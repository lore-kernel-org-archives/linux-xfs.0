Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A3EF29DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 18:41:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47AA5304053
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:41:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZMAmRv4QzKIFTLF5 for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 16:41:48 -0700 (PDT)
Date: Thu, 23 May 2013 09:41:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with &log->l_cilp->xc_ctx_lock semaphone
Message-ID: <20130522234129.GN29466@dastard>
References: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
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

On Wed, May 22, 2013 at 06:12:43PM -0500, Chandra Seetharaman wrote:
> Hello,
> 
> While testing and rearranging my pquota/gquota code, I stumbled on a
> xfs_shutdown() during a mount. But the mount just hung.
> 
> I debugged and found that it is in a code path where
> &log->l_cilp->xc_ctx_lock is first acquired in read mode and some levels
> down the same semaphore is being acquired in write mode causing a
> deadlock.
> 
> This is the stack:
> xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
>   xlog_print_tic_res
>     xfs_force_shutdown
>       xfs_log_force_umount
>         xlog_cil_force
>           xlog_cil_force_lsn
>             xlog_cil_push_foreground
>               xlog_cil_push - tries to acquire same semaphore in write mode

Which means you had a transaction reservation overrun. Is it
reproducable? iDo you have the output from xlog_print_tic_res()?
Because:

> xfs_trans_commit+0x79/0x270 [xfs]  
> xfs_qm_write_sb_changes+0x61/0x90 [xfs]
> xfs_qm_mount_quotas+0x82/0x180 [xfs]
> xfs_mountfs+0x5f6/0x6b0 [xfs]

This transaction only modifies the superblock, and it has a buffer
reservation for a superblock sized buffer, and hence should never
overrun.

IOWs, I'm ifar more concerned about the fact there was a
transaction overrun than they was a hang in the path that handles
the overrun. The fact this hang has been there since 2.6.35 tells
you how rare transactions overruns are....

FWIW, the fix for the hang is to make xlog_print_tic_res() return an
error and have the caller handle the shutdown.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
