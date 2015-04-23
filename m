Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 300B529DFB
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 17:34:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 04A3F8F8052
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 15:34:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	r8bODmfkvIFddyAG for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 15:34:17 -0700 (PDT)
Date: Fri, 24 Apr 2015 08:32:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: always log the inode on unwritten extent
	conversion
Message-ID: <20150423223258.GL15810@dastard>
References: <1429807364-33943-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429807364-33943-1-git-send-email-bfoster@redhat.com>
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

On Thu, Apr 23, 2015 at 12:42:44PM -0400, Brian Foster wrote:
> The fsync() requirements for crash consistency on XFS are to flush file
> data and force any in-core inode updates to the log. We currently check
> whether the inode is pinned to identify whether the log needs to be
> forced, since a non-zero pin count generally represents an inode that
> has transactions awaiting a flush to the on-disk log.
> 
> This is not sufficient in all cases, however. Reports of xfstests test
> generic/311 failures on ppc64/s390x hosts have identified failures to
> fsync outstanding inode modifications due to the inode not being pinned
> at the time of the fsync. This occurs because certain bmap updates can
> complete by logging bmapbt buffers but without ever dirtying (and thus
> pinning) the core inode. The following is a specific incarnation of this
> problem:
> 
> $ mount $dev /mnt -o noatime,nobarrier
> $ for i in $(seq 0 2 31); do \
>         xfs_io -f -c "falloc $((i * 32768)) 32k" -c fsync /mnt/file; \
> 	done
> $ xfs_io -c "pwrite -S 0 80k 16k" -c fsync -c "pwrite 76k 4k" -c fsync /mnt/file; \
> 	hexdump /mnt/file; \
> 	./xfstests-dev/src/godown /mnt
> ...
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0013000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> *
> 0014000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 00f8000
> $ umount /mnt; mount ...
> $ hexdump /mnt/file
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 00f8000
> 
> In short, the unwritten extent conversion for the last write is lost
> despite the fact that an fsync executed before the filesystem was
> shutdown. Note that this is impossible to reproduce on v5 supers due to
> unconditional time callbacks for di_changecount and highly difficult to
> reproduce on CONFIG_HZ=1000 kernels due to those same callbacks
> frequently updating cmtime prior to the bmap update. CONFIG_HZ=100
> reduces timer granularity enough to increase the odds that time updates
> are skipped and allows this to reproduce within a handful of attempts.
> 
> To deal with this problem, make sure that the inode is logged in the
> unwritten extent conversion path. Fix up the logflags, if necessary,
> after the extent conversion to keep the extent update code consistent
> with the other extent update helpers. This fixup is not necessary for
> the other (hole, delay) extent helpers because they execute in the block
> allocation codepath, which already logs the inode for other reasons
> (e.g., for di_nblocks).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Log inode unconditionally on unwritten extent conversion and retain
>   the fsync pincount check.
> v1: http://oss.sgi.com/pipermail/xfs/2015-April/041468.html
> 
>  fs/xfs/libxfs/xfs_bmap.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aeffeaa..e74e42bf 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4417,6 +4417,21 @@ xfs_bmapi_convert_unwritten(
>  	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
>  			&bma->cur, mval, bma->firstblock, bma->flist,
>  			&tmp_logflags);
> +	/*
> +	 * Unwritten extent conversion might not have dirtied the inode
> +	 * depending on the extent state. Unlike block allocation (e.g.,
> +	 * di_nblocks), there may be no other reason to log the inode in the
> +	 * unwritten extent conversion path.
> +	 *
> +	 * We need to make sure the inode is dirty in the transaction for the
> +	 * sake of fsync(), which will not force the log for this transaction
> +	 * unless it sees the inode pinned. This can only happen for btree
> +	 * format inodes so use XFS_ILOG_CORE.
> +	 */
> +	if (!error && !tmp_logflags) {
> +		ASSERT(bma->cur);
> +		tmp_logflags |= XFS_ILOG_CORE;
> +	}
>  	bma->logflags |= tmp_logflags;
>  	if (error)
>  		return error;

I'd just do:

	bma->logflags |= tmp_logflags | XFS_ILOG_CORE;

Because it really doesn't matter if we log an unchanged inode core
or not - it's likely already in the CIL or AIL given we are doing
unwritten extent conversion, so it is unlikely to introduce
significant new overhead from doing this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
