Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 326247F37
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2015 02:03:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2DCDAC003
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2015 00:03:26 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Dzctpf1D2IGVMiMe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Dec 2015 00:03:20 -0800 (PST)
Message-ID: <56838FA3.5030909@oracle.com>
Date: Wed, 30 Dec 2015 16:02:43 +0800
From: Bob Liu <bob.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/7] dax: support dirty DAX entries in radix tree
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Hi Ross,

On 12/24/2015 03:39 AM, Ross Zwisler wrote:
> Add support for tracking dirty DAX entries in the struct address_space
> radix tree.  This tree is already used for dirty page writeback, and it
> already supports the use of exceptional (non struct page*) entries.
> 
> In order to properly track dirty DAX pages we will insert new exceptional
> entries into the radix tree that represent dirty DAX PTE or PMD pages.

I may get it wrong, but there is "struct page" for persistent memory after
"[PATCH v4 00/18]get_user_pages() for dax pte and pmd mappings".
So why not just add "struct page" to radix tree directly just like normal page cache?

Then we don't need to deal with any exceptional entries and special writeback.

Thanks,
Bob

> These exceptional entries will also contain the writeback sectors for the
> PTE or PMD faults that we can use at fsync/msync time.
> 
> There are currently two types of exceptional entries (shmem and shadow)
> that can be placed into the radix tree, and this adds a third.  We rely on
> the fact that only one type of exceptional entry can be found in a given
> radix tree based on its usage.  This happens for free with DAX vs shmem but
> we explicitly prevent shadow entries from being added to radix trees for
> DAX mappings.
> 
> The only shadow entries that would be generated for DAX radix trees would
> be to track zero page mappings that were created for holes.  These pages
> would receive minimal benefit from having shadow entries, and the choice
> to have only one type of exceptional entry in a given radix tree makes the
> logic simpler both in clear_exceptional_entry() and in the rest of DAX.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/block_dev.c             |  2 +-
>  fs/inode.c                 |  2 +-
>  include/linux/dax.h        |  5 ++++
>  include/linux/fs.h         |  3 +-
>  include/linux/radix-tree.h |  9 ++++++
>  mm/filemap.c               | 17 ++++++++----
>  mm/truncate.c              | 69 ++++++++++++++++++++++++++--------------------
>  mm/vmscan.c                |  9 +++++-
>  mm/workingset.c            |  4 +--
>  9 files changed, 78 insertions(+), 42 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
