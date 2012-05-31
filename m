Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VGNSZS050352 for <xfs@oss.sgi.com>; Thu, 31 May 2012 11:23:28 -0500
Message-ID: <4FC79AFD.4080103@sgi.com>
Date: Thu, 31 May 2012 11:23:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
	<20120525204536.GA4721@sgi.com>
In-Reply-To: <20120525204536.GA4721@sgi.com>
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

On 05/25/12 15:45, Ben Myers wrote:

> xfs:  shutdown xfs_sync_worker before the log
>
> Revert commit 1307bbd, which uses the s_umount semaphore to provide
> exclusion between xfs_sync_worker and unmount, in favor of shutting down
> the sync worker before freeing the log in xfs_log_unmount.  This is a
> cleaner way of resolving the race between xfs_sync_worker and unmount
> than using s_umount.
>
> Index: xfs/fs/xfs/xfs_log.c

Waiting for the worker to end before destroying the AIL looks like a
better solution.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
