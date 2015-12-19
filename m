Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 521AF7F85
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 12:37:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E13B304032
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 10:37:49 -0800 (PST)
Received: from mail-yk0-f171.google.com (mail-yk0-f171.google.com
	[209.85.160.171]) by cuda.sgi.com with ESMTP id
	jsmvcTBJD6mJN7tW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 10:37:47 -0800 (PST)
Received: by mail-yk0-f171.google.com with SMTP id 140so93534406ykp.0
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 10:37:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450502540-8744-5-git-send-email-ross.zwisler@linux.intel.com>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-5-git-send-email-ross.zwisler@linux.intel.com>
Date: Sat, 19 Dec 2015 10:37:46 -0800
Message-ID: <CAPcyv4irspQEPVdYfLK+QfW4t-1_y1gFFVuBm00=i03PFQwEYw@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] dax: add support for fsync/sync
From: Dan Williams <dan.j.williams@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: X86 ML <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Dec 18, 2015 at 9:22 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> To properly handle fsync/msync in an efficient way DAX needs to track dirty
> pages so it is able to flush them durably to media on demand.
>
> The tracking of dirty pages is done via the radix tree in struct
> address_space.  This radix tree is already used by the page writeback
> infrastructure for tracking dirty pages associated with an open file, and
> it already has support for exceptional (non struct page*) entries.  We
> build upon these features to add exceptional entries to the radix tree for
> DAX dirty PMD or PTE pages at fault time.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
[..]
> +static void dax_writeback_one(struct address_space *mapping, pgoff_t index,
> +               void *entry)
> +{
> +       struct radix_tree_root *page_tree = &mapping->page_tree;
> +       int type = RADIX_DAX_TYPE(entry);
> +       struct radix_tree_node *node;
> +       void **slot;
> +
> +       if (type != RADIX_DAX_PTE && type != RADIX_DAX_PMD) {
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
> +
> +       spin_lock_irq(&mapping->tree_lock);
> +       /*
> +        * Regular page slots are stabilized by the page lock even
> +        * without the tree itself locked.  These unlocked entries
> +        * need verification under the tree lock.
> +        */
> +       if (!__radix_tree_lookup(page_tree, index, &node, &slot))
> +               goto unlock;
> +       if (*slot != entry)
> +               goto unlock;
> +
> +       /* another fsync thread may have already written back this entry */
> +       if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
> +               goto unlock;
> +
> +       radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
> +
> +       if (type == RADIX_DAX_PMD)
> +               wb_cache_pmem(RADIX_DAX_ADDR(entry), PMD_SIZE);
> +       else
> +               wb_cache_pmem(RADIX_DAX_ADDR(entry), PAGE_SIZE);

Hi Ross, I should have realized this sooner, but what guarantees that
the address returned by RADIX_DAX_ADDR(entry) is still valid at this
point?  I think we need to store the sector in the radix tree and then
perform a new dax_map_atomic() operation to either lookup a valid
address or fail the sync request.  Otherwise, if the device is gone
we'll crash, or write into some other random vmalloc address space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
