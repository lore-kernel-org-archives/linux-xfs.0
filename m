Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58902 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932084AbeCEWbv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 17:31:51 -0500
Date: Tue, 6 Mar 2018 09:31:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180305223148.GG18129@dastard>
References: <20180305150546.32191-1-jtulak@redhat.com>
 <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Mar 05, 2018 at 04:06:38PM -0600, Eric Sandeen wrote:
> On 3/5/18 3:56 PM, Dave Chinner wrote:
> > On Mon, Mar 05, 2018 at 04:05:46PM +0100, Jan Tulak wrote:
> >> The fsck.xfs script did nothing, because xfs doesn't need a fsck to be
> >> run on every unclean shutdown. However, sometimes it may happen that the
> >> root filesystem really requires the usage of xfs_repair and then it is a
> >> hassle. This patch makes the situation a bit easier by detecting forced
> >> checks (/forcefsck or fsck.mode=force), so user can require the repair,
> >> without the repair being run all the time.
> >>
> >> (Thanks Eric for suggesting this.)
> >>
> >> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > 
> > Ok, so I can see why support for this is probably neecssary, I have
> > a few reservations about the implementation....
> > 
> >> ---
> >>  fsck/xfs_fsck.sh | 14 ++++++++++++--
> >>  1 file changed, 12 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> >> index e52969e4..71bfa2e1 100755
> >> --- a/fsck/xfs_fsck.sh
> >> +++ b/fsck/xfs_fsck.sh
> >> @@ -4,10 +4,12 @@
> >>  #
> >>  
> >>  AUTO=false
> >> -while getopts ":aApy" c
> >> +FORCE=false
> >> +while getopts ":aApyf" c
> >>  do
> >>  	case $c in
> >>  	a|A|p|y)	AUTO=true;;
> >> +	f)      	FORCE=true;;
> >>  	esac
> >>  done
> >>  eval DEV=\${$#}
> >> @@ -15,10 +17,18 @@ if [ ! -e $DEV ]; then
> >>  	echo "$0: $DEV does not exist"
> >>  	exit 8
> >>  fi
> >> +
> >> +# The flag -f is added by systemd/init scripts when /forcefsck file is present
> >> +# or fsck.mode=force is used during boot; an unclean shutdown won't trigger
> >> +# this check, user has to explicitly require a forced fsck.
> >> +if $FORCE; then
> >> +	xfs_repair $DEV
> >> +	exit $?
> >> +fi
> > 
> > This needs to check that the xfs_repair binary is present in the
> > environment that is running fsck. If this is checking the root fs
> > from the initramfs, then distros are going to need to package
> > xfs_repair into their initramfs build scripts...
> 
> Fedora and RHEL does, FWIW.  Can others check?  What does Debian do?

No idea. I've never needed to peel an initramfs to check what is
inside.

Ah, debian has a tool for that (lsinitramfs)....

$ lsinitramfs /boot/initrd.img-4.15.0-1-amd64  |grep xfs
lib/modules/4.13.0-1-amd64/kernel/fs/xfs
lib/modules/4.13.0-1-amd64/kernel/fs/xfs/xfs.ko
sbin/fsck.xfs
$

Nope, xfs_repair is not packaged in the debian initramfs. And, well,
on a more recently installed machine:

$ lsinitramfs /boot/initrd.img-4.15.0-rc8-amd64  |grep xfs
lib/modules/4.15.0-rc8-amd64/kernel/fs/xfs
lib/modules/4.15.0-rc8-amd64/kernel/fs/xfs/xfs.ko
$

fsck.xfs isn't even in the built initramfs for a machine running
only XFS filesystems....

> > Also, if the log is dirty, xfs_repair won't run. If the filesystem
> > is already mounted read-only, xfs_repair won't run. So if we're
> > forcing a boot time check, we want it to run unconditionally and fix
> > any problems found automatically, right?
> 
> Yep, I'm curious if this was tested - I played with something like this
> a while ago but didn't take notes.  ;)
> 
> As for running automatically and fix any problems, we may need to make
> a decision.  If it won't mount due to a log problem, do we automatically
> use -L or drop to a shell and punt to the admin?  (That's what we would
> do w/o any fsck -f invocation today...)

Define the expected "forcefsck" semantics, and that will tell us
what we need to do. Is it automatic system recovery? What if the
root fs can't be mounted due to log replay problems?

> > I also wonder if we can limit this to just the boot infrastructure,
> > because I really don't like the idea of users using fsck.xfs -f to
> > repair damage filesystems because "that's what I do to repair ext4
> > filesystems"....
> 
> Depending on how this gets fleshed out, fsck.xfs -f isn't any different
> than bare xfs_repair...  (Unless all of the above suggestions about dirty
> logs get added, then it certainly is!)  So, yeah...
> 
> How would you propose limiting it to the boot environment? 

I have no idea - this is all way outside my area of expertise...

> I wondered
> about the script itself checking for /forcefsck or the boot parameters,
> but at least the boot params probably last for the duration of the uptime.
> And re-coding / re-implementing the systemd checks in our own script
> probably is a bad idea, so forget I suggested it ...

But, yeah, we don't want to have to do that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
