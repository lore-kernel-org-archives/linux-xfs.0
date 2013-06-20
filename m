Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 454A47F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 16:06:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5112AC001
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 14:06:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	YuYcuzq42UEIYU8j for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 14:06:12 -0700 (PDT)
Date: Fri, 21 Jun 2013 07:06:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with &log->l_cilp->xc_ctx_lock semaphone
Message-ID: <20130620210609.GR29376@dastard>
References: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
	<20130522234129.GN29466@dastard>
	<1371597515.22504.51.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371597515.22504.51.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Tue, Jun 18, 2013 at 06:18:35PM -0500, Chandra Seetharaman wrote:
> On Thu, 2013-05-23 at 09:41 +1000, Dave Chinner wrote:
> > On Wed, May 22, 2013 at 06:12:43PM -0500, Chandra Seetharaman wrote:
> > > Hello,
> > > 
> > > While testing and rearranging my pquota/gquota code, I stumbled on a
> > > xfs_shutdown() during a mount. But the mount just hung.
> > > 
> > > I debugged and found that it is in a code path where
> > > &log->l_cilp->xc_ctx_lock is first acquired in read mode and some levels
> > > down the same semaphore is being acquired in write mode causing a
> > > deadlock.
> > > 
> > > This is the stack:
> > > xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
> > >   xlog_print_tic_res
> > >     xfs_force_shutdown
> > >       xfs_log_force_umount
> > >         xlog_cil_force
> > >           xlog_cil_force_lsn
> > >             xlog_cil_push_foreground
> > >               xlog_cil_push - tries to acquire same semaphore in write mode
> > 
> > Which means you had a transaction reservation overrun. Is it
> > reproducable? iDo you have the output from xlog_print_tic_res()?
> > Because:
> > 
> > > xfs_trans_commit+0x79/0x270 [xfs]  
> > > xfs_qm_write_sb_changes+0x61/0x90 [xfs]
> > > xfs_qm_mount_quotas+0x82/0x180 [xfs]
> > > xfs_mountfs+0x5f6/0x6b0 [xfs]
> > 
> > This transaction only modifies the superblock, and it has a buffer
> > reservation for a superblock sized buffer, and hence should never
> > overrun.
> > 
> > IOWs, I'm ifar more concerned about the fact there was a
> > transaction overrun than they was a hang in the path that handles
> > the overrun. The fact this hang has been there since 2.6.35 tells
> > you how rare transactions overruns are....
> > 
> > FWIW, the fix for the hang is to make xlog_print_tic_res() return an
> > error and have the caller handle the shutdown.
> 
> Dave,
> 
> There are few ways this can be done, but each of them seem to change the
> code behavior. Wanted to get your opinion on which is the correct way.
> 
> (1) - don't shutdown in xlog_print_tic_res();
>     - upon return from xlog_print_tic_res(), do a up_read, and shutdown
>     - at the end of fucntion, up_read only if we haven't done it already
>   Behavior change: The protection offered by the semaphore is not 
>       available to the code block from shutdown to end of function

We don't want to do the rest of the work in the function if the
ticket check fails, so:

> (2) - don't shoudown in xlog_print_tic_res()
>     - upon return just set a flag
>     - at the end of function, after up_read, do shutdown
>   Behavior change: Shutdown is delayed to a later point.

A behaviour change is fine because we don't care about races here.

> I prefer (2) since (1) drops the protection. But, do not know the
> ramifications of delaying the shutdown. Can you comment ?

Basically, I think you can have xlog_print_tic_res() return
EFSCORRUPTED to the xfs_log_commit_cil(), then have it drop the
lock and return that error to xfs_trans_commit() immediately.

However, xfs_trans_commit() only catches the ENOMEM error, but that
was a temporary situation to handle the allocation error from
xfs_log_commit_cil() specially. Since we've removed the old old
logging code, this is the only error that can be returned so the
shutdown on error doesn't need to be specific to ENOMEM. hence if
you convert this to just a plain if (error) check, the shutdown will
happen from xfs_trans_commit() and the deadlock won't occur.

FWIW, to be on the safe side, I'd move the ticket check to after we
attach the busy extents to the CIL so that we can be certain that
the error path in xfs_trans_commit() does the right thing with them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
