Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC5CC7F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 11:46:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9953530404E
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 09:46:25 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	pvjJOEjgyKwVzmbg for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 09:46:23 -0800 (PST)
Date: Mon, 21 Dec 2015 10:45:34 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 2/7] dax: support dirty DAX entries in radix tree
Message-ID: <20151221174534.GA4978@linux.intel.com>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-3-git-send-email-ross.zwisler@linux.intel.com>
	<20151221171512.GA7030@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151221171512.GA7030@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Mon, Dec 21, 2015 at 06:15:12PM +0100, Jan Kara wrote:
> On Fri 18-12-15 22:22:15, Ross Zwisler wrote:
> > Add support for tracking dirty DAX entries in the struct address_space
> > radix tree.  This tree is already used for dirty page writeback, and it
> > already supports the use of exceptional (non struct page*) entries.
> > 
> > In order to properly track dirty DAX pages we will insert new exceptional
> > entries into the radix tree that represent dirty DAX PTE or PMD pages.
> > These exceptional entries will also contain the writeback addresses for the
> > PTE or PMD faults that we can use at fsync/msync time.
> > 
> > There are currently two types of exceptional entries (shmem and shadow)
> > that can be placed into the radix tree, and this adds a third.  We rely on
> > the fact that only one type of exceptional entry can be found in a given
> > radix tree based on its usage.  This happens for free with DAX vs shmem but
> > we explicitly prevent shadow entries from being added to radix trees for
> > DAX mappings.
> > 
> > The only shadow entries that would be generated for DAX radix trees would
> > be to track zero page mappings that were created for holes.  These pages
> > would receive minimal benefit from having shadow entries, and the choice
> > to have only one type of exceptional entry in a given radix tree makes the
> > logic simpler both in clear_exceptional_entry() and in the rest of DAX.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> The patch looks good to me. Just one comment: When we have this exclusion
> between different types of exceptional entries, there is no real need to
> have separate counters of 'shadow' and 'dax' entries, is there? We can have
> one 'nrexceptional' counter and don't have to grow struct inode
> unnecessarily which would be really welcome since DAX isn't a mainstream
> feature. Could you please change the code? Thanks!

Sure, this sounds good.  Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
