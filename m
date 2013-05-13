Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 607947F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 19:46:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27286304039
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 17:46:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2PpJXrAEdcGvDzjl for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 17:46:00 -0700 (PDT)
Date: Mon, 13 May 2013 10:45:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
Message-ID: <20130513004559.GK32675@dastard>
References: <518B08D9.1060906@gmail.com> <20130509031646.GN24635@dastard>
	<20130509072045.GO24635@dastard> <518C54AA.7070908@gmail.com>
	<20130510021942.GP23072@dastard>
	<CAJzLF9kmBuQ5+-7NbzPqjUxG5yUELxCxjhh=3NiTFD0dNh-UXQ@mail.gmail.com>
	<20130511011732.GC32675@dastard> <518DCDB1.30408@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518DCDB1.30408@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, May 11, 2013 at 12:48:49AM -0400, Michael L. Semon wrote:
> On 05/10/2013 09:17 PM, Dave Chinner wrote:
> >On Fri, May 10, 2013 at 03:07:19PM -0400, Michael L. Semon wrote:
> >>On Thu, May 9, 2013 at 10:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>On Thu, May 09, 2013 at 10:00:10PM -0400, Michael L. Semon wrote:
> 
> >>Thanks for looking at it.  There are going to be plenty of false
> >>positives out there.  Is there a pecking order of what works best?  As
> >>in...
> >>
> >>* IRQ (IRQs-off?) checking: worth reporting...?
> >>* sleep inside atomic sections: fascinating, but almost anything can trigger it
> >>* multiple-CPU deadlock detection: can only speculate on a uniprocessor system
> >>* circular dependency checking: YMMV
> >>* reclaim-fs checking: which I knew how much developers need to
> >>conform to reclaim-fs, or what it is
> >
> >If there's XFS in the trace, then just post them. We try to fix
> >false positives (as well as real bugs) so lockdep reporting gets more
> >accurate and less noisy over time.
> >
> >Cheers,
> >
> >Dave.
> >
> 
> Feel free to ignore and flame them as well.  I'm going to make
> another attempt to triage my eldest Pentium 4, and there's a high
> chance that you'll have to reply, "Despite the xfs_* functions, that
> looks like a DRM issue.  Go bug those guys."
> 
> Thanks!
> 
> Michael
> 
> During generic/249 (lucky, first test out)...
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.9.0+ #2 Not tainted
> -------------------------------------------------------
> xfs_io/1181 is trying to acquire lock:
>  (sb_writers#3){.+.+.+}, at: [<c10f01be>]
> generic_file_splice_write+0x7e/0x1b0
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock){++++++}, at: [<c11dca9a>] xfs_ilock+0xea/0x190

Known issue. Needs VFS level changes to be fixed. I've posted
patches several times to linux-fsdevel over the past 2 years to fix
it, but I'm still waiting for them to be picked up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
