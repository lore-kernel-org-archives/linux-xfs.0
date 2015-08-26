Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 190667F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 20:03:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D087C8F8049
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:03:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	14X6cSbcuJCS6TYf for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 18:03:13 -0700 (PDT)
Date: Wed, 26 Aug 2015 11:02:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] libxfs: clear buffer state flags in libxfs_getbuf
	and variants
Message-ID: <20150826010232.GT714@dastard>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003246.23973.12895.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826003246.23973.12895.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 25, 2015 at 05:32:46PM -0700, Darrick J. Wong wrote:
> When we're running xfs_repair with prefetch enabled, it's possible
> that repair will decide to clear an inode without examining all
> metadata blocks owned by that inode.  This leaves the unreferenced
> prefetched buffers marked UNCHECKED, which will cause a subsequent CRC
> error if the block is reallocated to a different structure and read
> more than once.  Typically this happens when a large directory is
> corrupted and lost+found has to grow to accomodate all the
> disconnected inodes.
> 
> In libxfs_getbuf*(), we're supposed to return an unused buffer which
> has a clean state.  Unfortunately, things like UNCHECKED can hang
> around to cause incorrect verifier errors later, so change those
> functions to launder the state bits clean.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/rdwr.c |   47 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 41 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 4f8212f..d28cea8 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -631,15 +631,39 @@ libxfs_getbuf_flags(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len,
>  	return __cache_lookup(&key, flags);
>  }
>  
> +/*
> + * Clean the buffer flags for libxfs_getbuf*(), which wants to return
> + * an unused buffer with clean state.  This prevents CRC errors on a
> + * re-read of a corrupt block that was prefetched and freed.  This
> + * can happen with a massively corrupt directory that is discarded,
> + * but whose blocks are then recycled into expanding lost+found.
> + *
> + * Note however that if the buffer's dirty (prefetch calls getbuf)
> + * we'll leave the state alone because we don't want to discard blocks
> + * that have been fixed.
> + */
> +static void
> +try_clean_buf(

Only thing I don't like about this patch is the name of this
function. It's really a "reset buffer state" function, so I think
that calling it something like reset_buf_state() would be more
appropriate.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
