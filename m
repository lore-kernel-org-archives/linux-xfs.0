Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85DC97F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 07:32:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0303EAC001
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 05:32:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GBChXwXPS5G35Mhj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 05:31:56 -0700 (PDT)
Date: Fri, 4 Jul 2014 08:40:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140704124049.GB12151@bfoster.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
	<20140704000426.GX4453@dastard>
	<alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>
	<20140704014008.GI9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140704014008.GI9508@dastard>
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
Cc: "Carlos E. R." <carlos.e.r@opensuse.org>, XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 04, 2014 at 11:40:08AM +1000, Dave Chinner wrote:
> On Fri, Jul 04, 2014 at 03:29:31AM +0200, Carlos E. R. wrote:
> > On Friday, 2014-07-04 at 10:04 +1000, Dave Chinner wrote:
> > >On Fri, Jul 04, 2014 at 01:34:52AM +0200, Carlos E. R. wrote:
> > >>Ok, true, there is no formal "Oops".
> > >>
> > >>But no, the system does not remains fine, I had to hit the hardware
> > >>reset or power off button to get out.
> > >
> > >That usually only happens when the root filesystem is shut down and
> > >you can't access any of the binaries needed to run the system. Is
> > >the filesystem that is shutting down the root?
> > 
> > No, it is not. Root is separate and using ext4. The problematic one
> > is /home.
> > 
> > 
> > What I did, as far I remember, was, when I noticed that home had
> > failed and was read only, to switch to runlevel 1, umount /home
> > (killing the apps that were still using it), then tried to mount it
> > again to replay the log, prior to using xfs-repair on it. Mount
> > hung. ctrl-alt-supr failed, or appeared to fail. So reset button...
> 
> That's a completely different issue to having a shutdown filesystem
> hang your system. That's a mount problem, and likely a known issue.
> You need to be specific when describing a problem, otherwise we
> waste time going down the wrong paths.
> 
> > >>No, the on disk filesystem is not healthy. If I continue using it,
> > >>after reboot and using "xfs_repair" several times, it fails again
> > >>within a day.
> > >
> > >After at least one hibernation and thaw cycle, right?
> > 
> > Yes. 3, I think.
> 
> Then hibernation has caused the corruption. It may take some time
> for the corruption to be detected, but there isn't any doubt in my
> mind that hibernation is the cause of your problems.
> 
> So, until we have kernel fixes, you'd do best to turn off
> hibernation. If you can't live with leaving your machine powered up
> or switching it off, then use suspend-to-ram rather than
> suspend-to-disk to avoid the problematic snapshot/restore
> situation....
> 

FWIW, I ran through a bunch of hibernation tests yesterday and couldn't
seem to reproduce anything interesting. I ran a preallocating workload
while constantly hibernating and waking a vm. I also tried using a hack
to avoid the eofblocks trim on release to make the test more effective,
and another to invoke the hibernation from the eofblocks background
scanner to "improve" the chances of conflict. I also ran a truncate test
to stress xfs_itruncate_extents() during hibernation cycles (there's
actually an instance of this in Carlos' reported output that doesn't
seem to involve a workqueue, attributed to thunderbird iirc) and ran
these similar tests going back to v3.11.0 as well as the latest
3.16.0-rc2.

None of this really means anything outside of there isn't quite enough
information to reproduce. It looks simple enough to enable freezing on
the eofblocks (or other xfs) workqueues by setting a flag, so we could
go and do that, but that still isn't definite. E.g., that thunderbird
truncate instance of failure stands out a bit to me.

Carlos,

You've indicated in your previous replies that you have reproduced this
repeatedly or more easily after you hit the problem and before you run a
reformat and restore sequence, enough to give you the impression at
least that the reformat is necessary. If you have the time, could you
run some of your typical activities through some hibernation cycles in
an attempt to narrow down what might contribute to this? E.g., perhaps
this only occurs with thunderbird or some other particular application
running, etc. If you have the ability to try a more recent kernel for a
period of time, that could be interesting as well.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
