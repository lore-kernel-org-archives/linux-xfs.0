Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA823NYi085277 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:03:23 -0600
Message-ID: <1320717802.3186.97.camel@doink>
Subject: Re: [PATCH v2 6/8] xfsdump: process thread exit status
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:03:22 -0600
In-Reply-To: <1320699511-12281-7-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-7-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-11-07 at 14:58 -0600, Bill Kendall wrote:
> When IRIX sprocs were in use, the main thread was notified of a thread
> exit just as if a child process exited -- it received SIGCHLD. The main
> thread would grab the pid and exit status, then call cldmgr_died() to
> inform it that the child was gone so the slot in the child array could
> be freed up for reuse.
> 
> This patch implements a similar mechanism for pthreads. The "c_busy"
> field in struct cld has been replaced with a "c_state" field that
> indicates whether the array slot is free (C_AVAIL), in use (C_ALIVE), or
> is waiting to be joined (C_EXITED). Additionally a "c_exit_code" field
> has been added to store the thread's exit value. Normally this is set
> when the thread entry function returns, but it is initialized to
> EXIT_INTERRUPT in case the thread is cancelled or calls pthread_exit()
> rather than returning (neither of which happens in the code today).
> 
> When the child thread starts, it registers a pthread cleanup handler
> which takes care of marking the child as C_EXITED and notifies the main
> thread that a child is gone. Doing this in a cleanup handler ensures
> that it's done regardless of how the thread exits. The main thread's
> loop is based around sigsuspsend(), so the notification is done by
> sending SIGUSR1. The main thread will then call cldmgr_join() to join
> all exited threads and obtain their exit status.
> 
> Additional changes:
> * cldmgr_findbypid() has been removed, it's no longer referenced.
> * stream_dead() no longer grabs the lock(), because it's called
>   only from cldmgr_join() which already holds the lock().
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.  Again, I've looked over this
pretty closely, but have not been as thorough
as I often am.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
