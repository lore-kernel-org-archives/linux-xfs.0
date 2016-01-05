Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA6287F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 03:41:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85AAEAC007
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 01:41:02 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id brfsZKvUeuxGh0EK (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 01:40:55 -0800 (PST)
Date: Tue, 5 Jan 2016 10:41:01 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 2/7] dax: support dirty DAX entries in radix tree
Message-ID: <20160105094101.GB2724@quack.suse.cz>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Wed 23-12-15 12:39:15, Ross Zwisler wrote:
> Add support for tracking dirty DAX entries in the struct address_space
> radix tree.  This tree is already used for dirty page writeback, and it
> already supports the use of exceptional (non struct page*) entries.
> 
> In order to properly track dirty DAX pages we will insert new exceptional
> entries into the radix tree that represent dirty DAX PTE or PMD pages.
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

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
