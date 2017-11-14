Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44365 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756128AbdKNUTT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 15:19:19 -0500
Date: Tue, 14 Nov 2017 21:19:15 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Message-ID: <20171114201915.GI729@wotan.suse.de>
References: <20171113103139.GA18936@yu-chen.sh.intel.com>
 <20171113201414.GD16026@wotan.suse.de>
 <CAPcyv4hbHpoMe20Sjpq4Qov6TKx9A+t6Y9GJ68PT2tsY3Jh7kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hbHpoMe20Sjpq4Qov6TKx9A+t6Y9GJ68PT2tsY3Jh7kA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org, Thorsten Leemhuis <linux@leemhuis.info>, oleg.b.antonyan@gmail.com, Oliver Neukum <oneukum@suse.com>

On Mon, Nov 13, 2017 at 12:37:00PM -0800, Dan Williams wrote:
> On Mon, Nov 13, 2017 at 12:14 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Mon, Nov 13, 2017 at 06:31:39PM +0800, Yu Chen wrote:
> >> The xfs-buf/dm-1 should be freezed according to
> >> commit 8018ec083c72 ("xfs: mark all internal workqueues
> >> as freezable"), thus a easier way might be have to revert
> >> commit 18f1df4e00ce ("xfs: Make xfsaild freezeable
> >> again") for now, after this reverting the xfsaild/dm-1
> >> becomes non-freezable again, thus pm does not see this
> >> thread - unless we find a graceful way to treat xfsaild/dm-1
> >> as 'frozen' if it is waiting for an already 'frozen' task,
> >> or if the filesystem freeze is added in.
> >>
> >> Any comments would be much appreciated.
> >
> > Reverting 18f1df4e00ce ("xfs: Make xfsaild freezeable again")
> > would break the proper form of the kthread for it to be freezable.
> > This "form" is not defined formally, and sadly its just a form
> > learned throughout years over different kthreads in the kernel.
> 
> If the behavior breaks then the "form" is broken.

People have been arguing this for a long time, as such a long term objective is
to do away with kthread freezing all together. That's easier said than done.
It will require some more work though, so a tiny initial first goal will be to
do fs freezing prior to suspend/hibernate. For discussions on the challenges on
removing kthread frerezing, you can refer to the discussion of the last 2
patches in my series.

> > I'm also not convinced all our hibernation / suspend woes would be fixed by
> > reverting this commit, its why I worked instead on formalizing a proper freeze
> > / thaw, which a lot of filesystems already implement prior to system
> > hibernation / suspend / resume [0].
> >
> > I'll be respinning this series without the last patch, provided I'm able to
> > ensure I don't need the ext[234] hack I did in that thread. Can you test the
> > first 3 patches *only* on that series and seeing if that helps on your XFS
> > front as well?
> 
> Those do not seem suitable for a  -stable backport.

Agreed. But fortunately filesystem freeze support has been in place for XFS
since v2.6.29 via commit c4be0c1dc4cdc ("filesystem freeze: add error handling
of write_super_lockfs/unlockfs") and likewise for a few other filesystems.
Prior to this commit freeze_fs() was write_super_lockfs() and returned
void, likewise unfreeze_fs() was unlockfs() and also returned void, after
the commit both could return an error. So one option for stable kernels
is to see if you can devise a userspace hook pre suspend or hiberanate
to issue the freeze fs yourself, and back:

/usr/sbin/xfs_freeze /mount-point
/usr/sbin/xfs_freeze -u /mount-point

In systemd-isneyverse, as per systemd-suspend.service(8), this *could* be
something like stashing the following script the systemd-suspend.service(8)
special path, for instance my systemd-suspend.service(8) on openSUSE
is /usr/lib/systemd/system-sleep/ however on Debian this is
   /lib/systemd/system-sleep/

So say you stash a fs.sleep script[0] there, first verify:

systemctl status systemd-suspend.service

You can then debug this while suspending with:

journalctl -f -u systemd-suspend

This is not enough though, one would also have to suspend processes
mucking with XFS filesystems, and unfortunately there isn't much of
graceful way to do this from userspace I think that I could come up
with except using SIGSTOP, and using lsofs on the mount point...

This seems to work on both my OpenSUSE and Debian systems, except the user
experience may not be as ideal, and this is precisely why having the kernel do
this work is much better long term.

#!/bin/bash

set -e

XFS_FREEZE="/usr/sbin/xfs_freeze"
PROC_MOUNTS="/proc/mounts"
SUSPEND_SIGNAL="SIGSTOP"

error_quit()
{
	echo "$1" >&2
	exit 1
}

check-system()
{
	[ -r "${PROC_MOUNTS}" ] || error_quit "ERROR: cannot find or read ${PROC_MOUNTS}"
	[ -x "${XFS_FREEZE}" ] || error_quit "ERROR: cannot find or execute ${XFS_FREEZE}"
}

run-fs-freeze()
{
	local i FSTYPE MNT ROOTDEV ARGS

	while read ROOTDEV MNT FSTYPE ARGS; do
	    [ "$ROOTDEV" = "rootfs" ] && continue
	    [ "$MNT" = "/" ] && continue

	    case $FSTYPE in
	    xfs)
		echo "  Trying to freeze userspace processes on '$FSTYPE' mounted on ${MNT}... "
		for i in $(lsof +D $MNT -t 2>/dev/null); do kill -$SUSPEND_SIGNAL $i; done
		echo -n "  Trying to freeze fstype '$FSTYPE' mounted on ${MNT}... "
		$XFS_FREEZE -f $MNT
		echo "OK!"
		;;
	    *)
		;;
	    esac

	done < $PROC_MOUNTS
}

run-fs-unfreeze()
{
	local i FSTYPE MNT ROOTDEV ARGS

	while read ROOTDEV MNT FSTYPE ARGS; do
	    [ "$ROOTDEV" = "rootfs" ] && continue
	    [ "$MNT" = "/" ] && continue

	    case $FSTYPE in
	    xfs)
		echo "  Trying to unfreeze userspace processes on '$FSTYPE' mounted on ${MNT}... "
		for i in $(lsof +D $MNT -t 2>/dev/null); do kill -SIGCONT $i; done
		echo -n "  Trying to unfreeze fstype '$FSTYPE' mounted on ${MNT}... "
		$XFS_FREEZE -u $MNT
		echo "OK!"
		;;
	    *)
		;;
	    esac

	done < $PROC_MOUNTS
}

check-system

if [ "$2" = suspend ]; then
	echo "INFO: running $0 for $2"
else
	echo "INFO: running $0 for $2"
fi

if [ "$1" = pre ] ; then
	run-fs-freeze
fi
if [ "$1" = post ] ; then
	run-fs-unfreeze
fi

> We can always
> follow on with these patches once -stable and mainline are back to
> their baseline behavior.

Reverting 18f1df4e00ce ("xfs: Make xfsaild freezeable again") cannot
be defined as "going back to baseline behavior" given it also implies
we'd be resurfacing the issue Hendrik reported last year in February,
that of suspend failures due to xfsaild blocking the freezer to
settle down:

    Jan 17 19:59:56 linux-6380 kernel: PM: Syncing filesystems ... done.
    Jan 17 19:59:56 linux-6380 kernel: PM: Preparing system for sleep (mem)
    Jan 17 19:59:56 linux-6380 kernel: Freezing user space processes ... (elapsed 0.001 seconds) done.
    Jan 17 19:59:56 linux-6380 kernel: Freezing remaining freezable tasks ...
    Jan 17 19:59:56 linux-6380 kernel: Freezing of tasks failed after 20.002 seconds (1 tasks refusing to freeze, wq_busy=0):
    Jan 17 19:59:56 linux-6380 kernel: xfsaild/dm-5    S 00000000     0  1293      2 0x00000080
    Jan 17 19:59:56 linux-6380 kernel:  f0ef5f00 00000046 00000200 00000000 ffff9022 c02d3800 00000000 00000032
    Jan 17 19:59:56 linux-6380 kernel:  ee0b2400 00000032 f71e0d00 f36fabc0 f0ef2d00 f0ef6000 f0ef2d00 f12f90c0
    Jan 17 19:59:56 linux-6380 kernel:  f0ef5f0c c0844e44 00000000 f0ef5f6c f811e0be 00000000 00000000 f0ef2d00
    Jan 17 19:59:56 linux-6380 kernel: Call Trace:
    Jan 17 19:59:56 linux-6380 kernel:  [<c0844e44>] schedule+0x34/0x90
    Jan 17 19:59:56 linux-6380 kernel:  [<f811e0be>] xfsaild+0x5de/0x600 [xfs]
    Jan 17 19:59:56 linux-6380 kernel:  [<c0286cbb>] kthread+0x9b/0xb0
    Jan 17 19:59:56 linux-6380 kernel:  [<c0848a79>] ret_from_kernel_thread+0x21/0x38

As noted on the commit log of Michal's patch, the issue had been there for quite
some time, its just commit 24ba16bb3d4 ("xfs: clear PF_NOFREEZE for xfsaild
kthread") made the issue visible.

This is another way to say suspend has been busted on XFS for a very long time,
but I would not blame XFS -- this is a kernel issue to get proper filesystem
suspend working right, and the way we currently deal with kthreads is just
a sloppy goo mess which has created this situation.

  Luis
