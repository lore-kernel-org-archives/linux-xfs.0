Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8IDR0UF048401 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 08:27:00 -0500
Message-ID: <505876E6.9040001@sgi.com>
Date: Tue, 18 Sep 2012 08:28:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: stop the sync worker before xfs_unmountfs
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com>
	<20120830223504.GE15292@dastard> <5040FF25.1010501@sgi.com>
	<20120901230824.GB6896@infradead.org>
	<20120912183347.GO3274@sgi.com> <20120912231406.GJ11511@dastard>
	<20120913164344.GV25175@sgi.com> <20120913211847.GS3274@sgi.com>
In-Reply-To: <20120913211847.GS3274@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 09/13/12 16:18, Ben Myers wrote:
> Cancel work of the xfs_sync_worker before teardown of the log in
> xfs_unmountfs.  This prevents occasional crashes on unmount like so:
...
> Signed-off-by: Ben Myers<bpm@sgi.com>
>
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c
> +++ xfs/fs/xfs/xfs_super.c
> @@ -919,6 +919,7 @@ xfs_fs_put_super(
>   	struct xfs_mount	*mp = XFS_M(sb);
>
>   	xfs_filestream_unmount(mp);
> +	cancel_delayed_work_sync(&mp->m_sync_work);
>   	xfs_unmountfs(mp);
>   	xfs_syncd_stop(mp);
>   	xfs_freesb(mp);
>


Tests successfully on all 3 of the machines that were crashing without 
the patch.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
