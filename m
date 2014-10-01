Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5DA17F6B
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 18:23:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8B208F8037
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:23:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ICznqigctrQ5bm0m for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 16:23:39 -0700 (PDT)
Date: Thu, 2 Oct 2014 09:23:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check for inode size overflow in xfs_new_eof()
Message-ID: <20141001232325.GF10298@dastard>
References: <1412104883-6151-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1412104883-6151-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 30, 2014 at 03:21:23PM -0400, Brian Foster wrote:
> If we write to the maximum file offset (2^63-2), XFS fails to log the
> inode size update when the page is flushed. For example:
> 
> $ xfs_io -fc "pwrite `echo "2^63-1-1" | bc` 1" /mnt/file
> wrote 1/1 bytes at offset 9223372036854775806
> 1.000000 bytes, 1 ops; 0.0000 sec (22.711 KiB/sec and 23255.8140 ops/sec)
> $ stat -c %s /mnt/file
> 9223372036854775807
> $ umount /mnt ; mount <dev> /mnt/
> $ stat -c %s /mnt/file
> 0
> 
> This occurs because XFS calculates the new file size as io_offset +
> io_size, I/O occurs in block sized requests, and the maximum supported
> file size is not block aligned. Therefore, a write to the max allowable
> offset on a 4k blocksize fs results in a write of size 4k to offset
> 2^63-4096 (e.g., equivalent to round_down(2^63-1, 4096), or IOW the
> offset of the block that contains the max file size). The offset plus
> size calculation (2^63 - 4096 + 4096 == 2^63) overflows the signed
> 64-bit variable which goes negative and causes the > comparison to the
> on-disk inode size to fail. This returns 0 from xfs_new_eof() and
> results in no change to the inode on-disk.
> 
> Update xfs_new_eof() to explicitly detect overflow of the local
> calculation and use the VFS inode size in this scenario. The VFS inode
> size is capped to the maximum and thus XFS writes the correct inode size
> to disk.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This was also discovered while playing around with xfs/071, though it
> doesn't cause a failure. FWIW, I started off fixing this by converting
> xfs_new_eof() to use xfs_ufsize_t. That worked, but this seemed more
> explicit.
> 
> Brian
> 
>  fs/xfs/xfs_inode.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c10e3fa..9af2882 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -102,7 +102,7 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
>  {
>  	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
>  
> -	if (new_size > i_size)
> +	if (new_size > i_size || new_size < 0)
>  		new_size = i_size;
>  	return new_size > ip->i_d.di_size ? new_size : 0;
>  }

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
