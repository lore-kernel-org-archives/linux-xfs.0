Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 13:12:54 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7LCiaG026069
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 13:12:46 -0800
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <45787ED4.5070801@falconstor.com>
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com>
	 <457854CB.5030507@sandeen.net>  <45787ED4.5070801@falconstor.com>
Content-Type: text/plain
Date: Fri, 08 Dec 2006 08:11:46 +1100
Message-Id: <1165525906.30459.25.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Thu, 2006-12-07 at 15:51 -0500, Geir A. Myrestrand wrote:
> Eric Sandeen wrote:
> > Geir A. Myrestrand wrote:
> > 
> >> However, I run into issues with xfs_freeze as it often locks up when I 
> >> try to freeze a file system where there is I/O activity. Sometimes it 
> >> happen on the first xfs_freeze invocation to freeze the file system, 
> >> other times I have to unfreeze and then it happens on the second time I 
> >> freeze. xfs_freeze never returns when this happens.
> >>
> > 
> > Did you have this problem on the previous version?
> 
> I just tested with the old version, and I run into the same issue.
> 

Does it happen with mainline (current) kernels?  This is ringing some
distant bells, something to do with an atomic_inc being in the wrong
spot in [_]xfs_trans_alloc ... or maybe a wrong call to xfs_trans_alloc
instead of the '_' prefixed version - details are murky now though.  I
do remember fixing ... something in here, a few months back, that fix
may not be in Eric's codebase yet.

cheers.

-- 
Nathan
