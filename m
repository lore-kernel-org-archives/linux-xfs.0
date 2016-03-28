Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 099D77CA0
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 14:51:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C3F518F804C
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 12:51:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kEQycYyJxkjrm70U (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 12:51:45 -0700 (PDT)
Date: Mon, 28 Mar 2016 12:51:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't hand out pNFS layouts for reflink inodes
Message-ID: <20160328195140.GB5360@birch.djwong.org>
References: <1456936485-21940-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456936485-21940-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

[back to XFS after a few weeks' distractions]

On Wed, Mar 02, 2016 at 05:34:45PM +0100, Christoph Hellwig wrote:
> Although the protocol allows for it, the Linux NFS server code doesn't
> support reflink-like functionality yet.  It's been added to by TODO
> list..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_pnfs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index ade236e..9708fef 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -139,6 +139,13 @@ xfs_fs_map_blocks(
>  		return -ENXIO;
>  
>  	/*
> +	 * The pNFS block layout spec actually supports reflink like
> +	 * functionality, but the Linux pNFS server doesn't implement it yet.
> +	 */
> +	if (!xfs_is_reflink_inode(ip))
> +		return -ENXIO;

/me isn't familiar with pNFS, but doesn't this make it so that
xfs_fs_map_blocks /only/ works on reflinked files?  Maybe I'm misreading the
comment, but it sounds to me like Linux doesn't support reflinked files over
pNFS and therefore we want to disable this iomapping functionality any time we
find a reflinked file.

But maybe there's a subtlety here that I'm missing?

--D

> +
> +	/*
>  	 * Lock out any other I/O before we flush and invalidate the pagecache,
>  	 * and then hand out a layout to the remote system.  This is very
>  	 * similar to direct I/O, except that the synchronization is much more
> -- 
> 2.1.4
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
