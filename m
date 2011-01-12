Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C4DBGn137255 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 22:13:11 -0600
Subject: Re: [PATCH 01/12] xfs: prevent NMI timeouts in cmn_err
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294792553-8378-2-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-2-git-send-email-david@fromorbit.com>
Date: Tue, 11 Jan 2011 22:13:23 -0600
Message-ID: <1294805603.3115.127.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-01-12 at 11:35 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently have a global error message buffer in cmn_err that is
> protected by a spin lock that disables interrupts.  Recently there
> have been reports of NMI timeouts occurring when the console is
> being flooded by SCSI error reports due to cmn_err() getting stuck
> trying to print to the console while holding this lock (i.e. with
> interrupts disabled). The NMI watchdog is seeing this CPU as
> non-responding and so is triggering a panic.  While the trigger for
> the reported case is SCSI errors, pretty much anything that spams
> the kernel log could cause this to occur.
> 
> Realistically the only reason that we have the intemediate message
> buffer is to prepend the correct kernel log level prefix to the log
> message. The only reason we have the lock is to protect the global
> message buffer and the only reason the message buffer is global is
> to keep it off the stack. Hence if we can avoid needing a global
> message buffer we avoid needing the lock, and we can do this with a
> small amount of cleanup and some preprocessor tricks:
> 
> 	1. clean up xfs_cmn_err() panic mask functionality to avoid
> 	   needing debug code in xfs_cmn_err()
> 	2. remove the couple of "!" message prefixes that still exist that
> 	   the existing cmn_err() code steps over.
> 	3. redefine CE_* levels directly to KERN_*
> 	4. redefine cmn_err() and friends to use printk() directly
> 	   via variable argument length macros.
> 
> By doing this, we can completely remove the cmn_err() code and the
> lock that is causing the problems, and rely solely on printk()
> serialisation to ensure that we don't get garbled messages.
> 
> A series of followup patches is really needed to clean up all the
> cmn_err() calls and related messages properly, but that results in a
> series that is not easily back portable to enterprise kernels. Hence
> this initial fix is only to address the direct problem in the lowest
> impact way possible.

I had two trivial remarks but, well, what you have is just fine...

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sysctl.c |   23 ++++++++-
>  fs/xfs/support/debug.c        |  109 +++++++++++++++++++----------------------
>  fs/xfs/support/debug.h        |   25 ++++++---
>  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
