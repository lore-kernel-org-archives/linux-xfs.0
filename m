Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D40D7CA0
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 05:44:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 224B1304032
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 03:44:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id BHEkGdDLwAxvNMBS (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Mar 2016 03:44:20 -0700 (PDT)
Date: Fri, 25 Mar 2016 03:44:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
Message-ID: <20160325104418.GA10525@infradead.org>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Al Viro <viro@zeniv.linux.org.uk>

On Thu, Mar 24, 2016 at 05:17:29PM -0600, Vishal Verma wrote:
> @@ -72,16 +72,7 @@ xfs_zero_extent(
>  	struct xfs_mount *mp = ip->i_mount;
>  	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
>  	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
> -	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
>  
> -	if (IS_DAX(VFS_I(ip)))
> -		return dax_clear_sectors(xfs_find_bdev_for_inode(VFS_I(ip)),
> -				sector, size);
> -
> -	/*
> -	 * let the block layer decide on the fastest method of
> -	 * implementing the zeroing.
> -	 */
>  	return sb_issue_zeroout(mp->m_super, block, count_fsb, GFP_NOFS);

While not new: using sb_issue_zeroout in XFS is wrong as it doesn't
account for the RT device.  We need the xfs_find_bdev_for_inode and
call blkdev_issue_zeroout directly with the bdev it returned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
