Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 22:58:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m325w6RR002075
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 22:58:08 -0700
Date: Wed, 2 Apr 2008 15:58:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Serious XFS crash
Message-ID: <20080402055831.GG103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home> <20080325233611.GW103491721@sgi.com> <20080401140035.46470306@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080401140035.46470306@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Apr 01, 2008 at 02:00:35PM +0200, Emmanuel Florac wrote:
> Le Wed, 26 Mar 2008 10:36:11 +1100 vous écriviez:
> 
> > What sector size is being used for the XFS filesystem? If it's
> > not the same as teh filesystem block size, then XFS can't have done
> > this itself because the offset that this garbage starts at would
> > not be block aligned.....
> 
> I've gone thru the logs. This machine had a serious XFS crash on march
> 6 due to bad blocks (failed drive in the RAID-5). Is it possible that
> the March 19 XFS crash is related to this, i. e. after running
> xfs_repair on march 6 it remained some on-disk garbage that provoked a
> new crash a couple of weeks later?
> 
> Here is the march 6 crash :
> 
> Mar  6 10:42:46 system3 kernel:  [xfs_alloc_read_agf+244/432]
> xfs_alloc_read_agf+0xf4/0x1b0 Mar  6 10:42:46 system3 kernel:
> [xfs_alloc_fix_freelist+1000/1120] xfs_alloc_fix_freelist+0x3e8/0x460
> Mar  6 10:42:46 system3 last message repeated 2 times Mar  6 10:42:46
> system3 kernel:  [_xfs_trans_commit+489/928]
....

The log is rather garbled - can you repost? Also, XFS usually outputs
an error message before the stack trace; can you make sure you
paste that as well (if it exists)?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
