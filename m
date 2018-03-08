Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14927 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751024AbeCHWgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 17:36:55 -0500
Date: Fri, 9 Mar 2018 09:36:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180308223652.GT18129@dastard>
References: <20180305150546.32191-1-jtulak@redhat.com>
 <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
 <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard>
 <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
 <20180308162838.GY18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308162838.GY18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Tulak <jtulak@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 08, 2018 at 08:28:38AM -0800, Darrick J. Wong wrote:
> On Thu, Mar 08, 2018 at 11:57:40AM +0100, Jan Tulak wrote:
> > On Tue, Mar 6, 2018 at 10:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Tue, Mar 06, 2018 at 12:51:18PM +0100, Jan Tulak wrote:
> > >> On Tue, Mar 6, 2018 at 12:33 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > >> > On 3/5/18 4:31 PM, Dave Chinner wrote:
> > >> >> On Mon, Mar 05, 2018 at 04:06:38PM -0600, Eric Sandeen wrote:
> > >> >>> As for running automatically and fix any problems, we may need to make
> > >> >>> a decision.  If it won't mount due to a log problem, do we automatically
> > >> >>> use -L or drop to a shell and punt to the admin?  (That's what we would
> > >> >>> do w/o any fsck -f invocation today...)
> > >> >>
> > >> >> Define the expected "forcefsck" semantics, and that will tell us
> > >> >> what we need to do. Is it automatic system recovery? What if the
> > >> >> root fs can't be mounted due to log replay problems?
> > >> >
> > >> > You're asking too much.  ;)  Semantics?  ;)  Best we can probably do
> > >> > is copy what e2fsck does - it tries to replay the log before running
> > >> > the actual fsck.  So ... what does e2fsck do if /it/ can't replay
> > >> > the log?
> > >>
> > >> As far as I can tell, in that case, e2fsck exit code indicates 4 -
> > >> File system errors left uncorrected, but I'm studying ext testing
> > >> tools and will try to verify it.
> > >> About the -L flag, I think it is a bad idea - we don't want anything
> > >> dangerous to happen here, so if it can't be fixed safely and in an
> > >> automated way, just bail out.
> > >> That being said, I added a log replay attempt in there (via mount/unmount).
> > >
> > > I really don't advise doing that for a forced filesystem check. If
> > > the log is corrupt, mounting it will trigger the problems we are
> > > trying to avoid/fix by running a forced filesystem check. As it is,
> > > we're probably being run in this mode because mounting has already
> > > failed and causing the system not to boot.
> > >
> > > What we need to do is list how the startup scripts work according to
> > > what error is returned, and then match the behaviour we want in a
> > > specific corruption case to the behaviour of a specific return
> > > value.
> > >
> > > i.e. if we have a dirty log, then really we need manual
> > > intervention. That means we need to return an error that will cause
> > > the startup script to stop and drop into an interactive shell for
> > > the admin to fix manually.
> > >
> > > This is what I mean by "define the expected forcefsck semantics" -
> > > describe the behaviour of the system in reponse to the errors we can
> > > return to it, and match them to the problem cases we need to resolve
> > > with fsck.xfs.
> > 
> > I tested it on Fedora 27. Exit codes 2 and 4 ("File system errors
> > corrected, system should be rebooted" and "File system errors left
> > uncorrected") drop the user into the emergency shell. Anything else
> > and the boot continues.
> 
> FWIW Debian seems to panic() if the exit code has (1 << 2) set, where
> "panic()" either drops to a shell if panic= is not given or actually
> reboots the machine if panic= is given.  All other cases proceed with
> boot, including 2 (errors fixed, reboot now).
> 
> That said, the installer seems to set up root xfs as pass 0 in fstab so
> fsck is not included in the initramfs at all.

Ok, so how do we deal with the "all distros are different, none
correctly follow documented fsck behaviour"?  It seems to me like we
need fsck to drop into an admin shell if anything goes wrong,
perhaps with the output saying what went wrong.

e.g. if we corrected errors and need a reboot, then we return 4 to
get the system to drop into a shell with this:

*** Errors corrected, You must reboot now! ***
#

If we had any other failure, then we drop to the shell with this:

*** Failed to repair filesystem. Manual correction required! ***
#

And only in the case that we have an unmounted, clean filesystem do
we continue to boot and mount the root filesystem?

> > This happens before root volume is mounted during the boot, so I
> > propose this behaviour for fsck.xfs:
> > - if the volume/device is mounted, exit with 16 - usage or syntax
> > error (just to be sure)

That's error 4 - requires manual intervention to repair.

> > - if the volume/device has a dirty log, exit with 4 - errors left
> > uncorrected (drop to the shell)

Yup.

> > - if we find no errors, exit with 0 - no errors

Yup, but only if the filesystem is not mounted, otherwise it's
"requires reboot" because repair with no errors still rewrites all
the per-ag metadata and so changes the on disk metadata layout.
Continuing at this point with a mounted filesystem is guaranteed to
corrupt the filesystem.

> > - if we find anything and xfs_repair ends successfully, exit with 1 -
> > errors corrected

Same as the above case - needs reboot.

> > - anything else and exit with 8 - operational error

I'd argue that's "errors uncorrected" (i.e. error 4) because it
requires manual intervention to determine what the error was and
resolve the situation.

> > And is there any other way how to get the "there were some errors, but
> > we corrected them" other than either 1) screenscrape xfs_repair or 2)
> > run xfs_repair twice, once with -n to detect and then without -n to
> > fix the found errors?
> 
> I wouldn't run it twice, repair can take quite a while to run.

Besides, we have to treat both cases the same because even if there
were no errors xfs_repair still modifies the metadata on disk....

> > I'm not aware of any script or tool that would refuse to work except
> > when started in a specific environment and noninteractively (doesn't
> > mean they don't exist, but it is not common). And because it seems
> > that fsck.xfs -f will do only what bare xfs_repair would do, no log
> > replay, nothing... then I really think that changing what the script
> > does (not just altering its output) based on environment tests is
> > unnecessary.

This isn't a technical issue - this is a behaviour management issue.
We want people to always run xfs_repair when there's a problem that
needs fixing, not fsck.xfs. fsck.xfs is for startup scripts only and
has very limited scope in what we allow it to do. xfs_repair is the
tool users should be running to fix their filesystems, not trying to
do it indirectly through startup script infrastructure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
