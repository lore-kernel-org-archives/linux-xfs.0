Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6AEC329E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 18:19:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59865304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:19:10 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id VA7kNbtekHJR0OgM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 16:19:09 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 18 Jun 2013 19:19:09 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id CDF5E6E803F
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 19:19:02 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5INIaNc333552 for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 19:18:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r5INIapZ017360 for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 20:18:36 -0300
Subject: Re: deadlock with &log->l_cilp->xc_ctx_lock semaphone
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130522234129.GN29466@dastard>
References: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
	<20130522234129.GN29466@dastard>
Date: Tue, 18 Jun 2013 18:18:35 -0500
Message-ID: <1371597515.22504.51.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, 2013-05-23 at 09:41 +1000, Dave Chinner wrote:
> On Wed, May 22, 2013 at 06:12:43PM -0500, Chandra Seetharaman wrote:
> > Hello,
> > 
> > While testing and rearranging my pquota/gquota code, I stumbled on a
> > xfs_shutdown() during a mount. But the mount just hung.
> > 
> > I debugged and found that it is in a code path where
> > &log->l_cilp->xc_ctx_lock is first acquired in read mode and some levels
> > down the same semaphore is being acquired in write mode causing a
> > deadlock.
> > 
> > This is the stack:
> > xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
> >   xlog_print_tic_res
> >     xfs_force_shutdown
> >       xfs_log_force_umount
> >         xlog_cil_force
> >           xlog_cil_force_lsn
> >             xlog_cil_push_foreground
> >               xlog_cil_push - tries to acquire same semaphore in write mode
> 
> Which means you had a transaction reservation overrun. Is it
> reproducable? iDo you have the output from xlog_print_tic_res()?
> Because:
> 
> > xfs_trans_commit+0x79/0x270 [xfs]  
> > xfs_qm_write_sb_changes+0x61/0x90 [xfs]
> > xfs_qm_mount_quotas+0x82/0x180 [xfs]
> > xfs_mountfs+0x5f6/0x6b0 [xfs]
> 
> This transaction only modifies the superblock, and it has a buffer
> reservation for a superblock sized buffer, and hence should never
> overrun.
> 
> IOWs, I'm ifar more concerned about the fact there was a
> transaction overrun than they was a hang in the path that handles
> the overrun. The fact this hang has been there since 2.6.35 tells
> you how rare transactions overruns are....
> 
> FWIW, the fix for the hang is to make xlog_print_tic_res() return an
> error and have the caller handle the shutdown.

Dave,

There are few ways this can be done, but each of them seem to change the
code behavior. Wanted to get your opinion on which is the correct way.

(1) - don't shutdown in xlog_print_tic_res();
    - upon return from xlog_print_tic_res(), do a up_read, and shutdown
    - at the end of fucntion, up_read only if we haven't done it already
  Behavior change: The protection offered by the semaphore is not 
      available to the code block from shutdown to end of function
(2) - don't shoudown in xlog_print_tic_res()
    - upon return just set a flag
    - at the end of function, after up_read, do shutdown
  Behavior change: Shutdown is delayed to a later point.

I prefer (2) since (1) drops the protection. But, do not know the
ramifications of delaying the shutdown. Can you comment ?

Regards,

Chandra
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
