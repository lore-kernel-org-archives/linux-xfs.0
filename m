Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B3117F4E
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 17:22:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC901AC002
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 15:22:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ec26SV8nl3YPIyXz for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 15:22:13 -0700 (PDT)
Date: Tue, 16 Jun 2015 08:21:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix remote symlinks on V5/CRC filesystems
Message-ID: <20150615222157.GD10224@dastard>
References: <557F4E1E.8000505@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <557F4E1E.8000505@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 15, 2015 at 05:13:50PM -0500, Eric Sandeen wrote:
> If we create a CRC filesystem, mount it, and create a symlink with
> a path long enough that it can't live in the inode, we get a very
> strange result upon remount:
> 
> # ls -l mnt
> total 4
> lrwxrwxrwx. 1 root root 929 Jun 15 16:58 link -> XSLM
> 
> XSLM is the V5 symlink block header magic (which happens to be
> followed by a NUL, so the string looks terminated).
> 
> xfs_readlink_bmap() advanced cur_chunk by the size of the header
> for CRC filesystems, but never actually used that pointer; it
> kept reading from bp->b_addr, which is the start of the block,
> rather than the start of the symlink data after the header.
> 
> Looks like this problem goes back to v3.10.
> 
> Fixing this gets us reading the proper link target, again.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 3df411e..40c0765 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -104,7 +104,7 @@ xfs_readlink_bmap(
>  			cur_chunk += sizeof(struct xfs_dsymlink_hdr);
>  		}
>  
> -		memcpy(link + offset, bp->b_addr, byte_cnt);
> +		memcpy(link + offset, cur_chunk, byte_cnt);
>  
>  		pathlen -= byte_cnt;
>  		offset += byte_cnt;

Looks like the correct fix, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

However, it raises a more disturbing question: how did we not trip
over this until now? I though we had long symlink test coverage in
xfstests but clearly we haven't - do you have a test that closes
this verification hole?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
