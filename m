Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB5B27F3F
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 10:42:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63042AC002
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 08:42:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fVSuM75zJIBihFat (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 08:42:33 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7DFgWbu006640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 11:42:32 -0400
Received: from laptop.bfoster (vpn-55-52.rdu2.redhat.com [10.10.55.52])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7DFgULb001792
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 11:42:31 -0400
Date: Wed, 13 Aug 2014 11:42:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: hole the inode lock across a full file collapse
Message-ID: <20140813154229.GB4426@laptop.bfoster>
References: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
	<1407523766-62233-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1407523766-62233-3-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On Fri, Aug 08, 2014 at 02:49:26PM -0400, Brian Foster wrote:
> A file collapse stress test workload reproduces collapse failures
> mid-operation due to changes in the inode fork extent count across
> extent shift cycles. xfs_collapse_file_space() currently calls
> xfs_bmap_shift_extents() to shift one extent at a time per transaction.
> The extent index is used to track the next extent to shift after each
> iteration.
> 
> A concurrent fsx and fsstress workload reproduces a scenario where the
> extent count changes during this sequence, causing the 'current_ext'
> index to become inaccurate and possibly skip shifting an extent. The
> likely result of this behavior is the subsequent shift attempt will not
> find a hole in the area of the skipped extent and fail, leaving the file
> in a partially collapsed state.
> 
> This occurs because the ilock is released and acquired across each
> transaction and each individual extent shift. Tracepoint output shows
> that once the ilock is released after an extent shift, a pending
> blocking writeback (e.g., sync) can acquire the lock and proceed before
> the next extent is shifted down. If the writeback converts part of a
> delayed allocation earlier in the file, for example, it can insert a new
> extent into the map. Tracing confirms a call to
> xfs_bmap_add_extent_delay_real() in this particular instance.
> 
> To prevent this scenario, hold the ilock across the entire extent shift
> loop in xfs_collapse_file_space().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2f1e30d..96eb97b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1474,6 +1474,8 @@ xfs_collapse_file_space(
>  	if (error)
>  		return error;
>  
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +

I realized this moves the lock outside of the xfs_trans_reserve(), thus
opening a potential deadlock scenario with regard to the log. I suppose
this might be harder to hit in real life than a sync() causing the
operation to fall over mid-sequence, so I'm still Ok with keeping this
unless anybody objects. That said, we might still have to do something
else here longer term... perhaps sync the whole file and revert to the
original locking, or retain this locking scheme and use a rolling
transaction. Anyways, food for thought..

Brian

>  	while (!error && !done) {
>  		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>  		/*
> @@ -1489,7 +1491,6 @@ xfs_collapse_file_space(
>  			break;
>  		}
>  
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
>  				ip->i_gdquot, ip->i_pdquot,
>  				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
> @@ -1517,9 +1518,9 @@ xfs_collapse_file_space(
>  			goto out;
>  
>  		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>  
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
>  out:
> -- 
> 1.8.3.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
