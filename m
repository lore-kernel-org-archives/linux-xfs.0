Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB34b6w1061885 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 22:37:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 939671BF14B
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 20:38:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	wXxizzRzz70u7Hqv for <xfs@oss.sgi.com>;
	Thu, 02 Dec 2010 20:38:49 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48350448-1927428
	for <xfs@oss.sgi.com>; Fri, 03 Dec 2010 15:08:48 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1PONPy-00087q-VW
	for xfs@oss.sgi.com; Fri, 03 Dec 2010 15:38:47 +1100
Date: Fri, 3 Dec 2010 15:38:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent NMI timeouts in cmn_err
Message-ID: <20101203043846.GB23339@dastard>
References: <1291341315-31338-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291341315-31338-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, Dec 03, 2010 at 12:55:15PM +1100, Dave Chinner wrote:
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

FWIW, while these macros are the best way to make a simple backport
is possible, I just discovered that mainline has a %pV format
operator that allows an implementation like:

void
xfs_fs_cmn_err(
	const char              *lvl,
	struct xfs_mount        *mp,
	const char              *fmt,
	...)
{
	struct va_format        vaf;
	va_list                 args;

	va_start(args, fmt);
	vaf.fmt = fmt;
	vaf.va = &args;

	printk("%sFilesystem %s: %pV", lvl, mp->m_fsname, &vaf);
	va_end(args);

	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
}

Would this be a preferable method for replacing the existing
implementations, or are the macros good enough as the first step of
a mainline cleanup?

Cheers,,,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
