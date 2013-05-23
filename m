Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3310A7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 13:09:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1FB4D304032
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 11:09:36 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id 1A61jVMPtSTazdI4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 11:09:33 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 23 May 2013 12:09:32 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id BA4261FF0074
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 12:04:21 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r4NI9CAW118184 for <xfs@oss.sgi.com>; Thu, 23 May 2013 12:09:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r4NI98OZ031112
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 12:09:09 -0600
Subject: Re: deadlock with &log->l_cilp->xc_ctx_lock semaphone
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130522234129.GN29466@dastard>
References: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
	<20130522234129.GN29466@dastard>
Date: Thu, 23 May 2013 13:09:02 -0500
Message-ID: <1369332542.10223.5271.camel@chandra-dt.ibm.com>
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

Here it is:

May 23 10:48:52 test46 kernel: [   77.500728] XFS (sdh8): xlog_write: reservation summary:
May 23 10:48:52 test46 kernel: [   77.500728]   trans type  = QM_SBCHANGE (26)
May 23 10:48:52 test46 kernel: [   77.500728]   unit res    = 2740 bytes
May 23 10:48:52 test46 kernel: [   77.500728]   current res = -48 bytes
May 23 10:48:52 test46 kernel: [   77.500728]   total reg   = 0 bytes (o/flow = 0 bytes)
May 23 10:48:52 test46 kernel: [   77.500728]   ophdrs      = 0 (ophdr space = 0 bytes)
May 23 10:48:52 test46 kernel: [   77.500728]   ophdr + reg = 0 bytes
May 23 10:48:52 test46 kernel: [   77.500728]   num regions = 0
May 23 10:48:52 test46 kernel: [   77.500728]

Yes. I can readily reproduce the problem, but it is with my mangled up
patchsets :). There is a small change that makes this problem reproduce
consistently.
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

As I mentioned above, it may be a manipulation of my patch entanglement.

> the overrun. The fact this hang has been there since 2.6.35 tells
> you how rare transactions overruns are....
> 
> FWIW, the fix for the hang is to make xlog_print_tic_res() return an
> error and have the caller handle the shutdown.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
