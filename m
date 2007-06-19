Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 04:14:27 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JBEKdo003433
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 04:14:22 -0700
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Date: Tue, 19 Jun 2007 13:21:06 +0200
References: <46744065.6060605@dgreaves.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com>
In-Reply-To: <4677A0C7.4000306@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706191321.07278.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>

On Tuesday, 19 June 2007 11:24, David Greaves wrote:
> David Greaves wrote:
> > I'm going to have to do some more testing...
> done
> 
> 
> > David Chinner wrote:
> >> On Mon, Jun 18, 2007 at 08:49:34AM +0100, David Greaves wrote:
> >>> David Greaves wrote:
> >>> So doing:
> >>> xfs_freeze -f /scratch
> >>> sync
> >>> echo platform > /sys/power/disk
> >>> echo disk > /sys/power/state
> >>> # resume
> >>> xfs_freeze -u /scratch
> >>>
> >>> Works (for now - more usage testing tonight)
> >>
> >> Verrry interesting.
> > Good :)
> Now, not so good :)
> 
> 
> >> What you were seeing was an XFS shutdown occurring because the free space
> >> btree was corrupted. IOWs, the process of suspend/resume has resulted
> >> in either bad data being written to disk, the correct data not being
> >> written to disk or the cached block being corrupted in memory.
> > That's the kind of thing I was suspecting, yes.
> > 
> >> If you run xfs_check on the filesystem after it has shut down after a 
> >> resume,
> >> can you tell us if it reports on-disk corruption? Note: do not run 
> >> xfs_repair
> >> to check this - it does not check the free space btrees; instead it 
> >> simply
> >> rebuilds them from scratch. If xfs_check reports an error, then run 
> >> xfs_repair
> >> to fix it up.
> > OK, I can try this tonight...
> 
> 
> This is on 2.6.22-rc5

Is the Tejun's patch

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/30-block-always-requeue-nonfs-requests-at-the-front.patch

applied on top of that?

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
