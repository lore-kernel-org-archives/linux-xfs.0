Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:27042 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751344AbdEVCH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2017 22:07:59 -0400
Date: Mon, 22 May 2017 12:07:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170522020746.GW17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard>
 <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org>
 <CAJCQCtRWyb-zMWJLoa1GK3PtVg2x=ySU2KiUZaGK4Lw1=t=sYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRWyb-zMWJLoa1GK3PtVg2x=ySU2KiUZaGK4Lw1=t=sYA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Fri, May 19, 2017 at 06:27:53PM -0600, Chris Murphy wrote:
> On Fri, May 19, 2017 at 3:00 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > Frankly, all you have to do is tweak the grub config file writer to
> > "fsfreeze -f /boot && fsfreeze -u /boot" after it writes the grub.cfg and
> > before it exits.  That's both grubby and grub-mkconfig.
> 
> I am willing to bet that their assumption has been, since ancient
> times, that PID 1 umounts the file system before reboot, thereby
> writing log contents to the file system. And it's not just these two
> programs, there's probably bunches of kernel updates that are done by
> myriad scripts that likewise assume on umount happening before reboot.

This is not relevant to the discussion, because sync(1) is
sufficient for those updates to be accessible after reboot because
the filesystem replays the log at mount time and the changes are not
accessed until the filesystem is mounted.

IOWs, the problem is purely a bootloader issue due to the fact it is
the only software on the system that directly accesses the
filesystem metadata prior to log recovery being performed at boot
time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
