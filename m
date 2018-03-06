Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62446 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753656AbeCFVjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 16:39:20 -0500
Date: Wed, 7 Mar 2018 08:39:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Message-ID: <20180306213915.GJ18129@dastard>
References: <20180305150546.32191-1-jtulak@redhat.com>
 <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net>
 <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net>
 <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 06, 2018 at 12:51:18PM +0100, Jan Tulak wrote:
> On Tue, Mar 6, 2018 at 12:33 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > On 3/5/18 4:31 PM, Dave Chinner wrote:
> >> On Mon, Mar 05, 2018 at 04:06:38PM -0600, Eric Sandeen wrote:
> >>> As for running automatically and fix any problems, we may need to make
> >>> a decision.  If it won't mount due to a log problem, do we automatically
> >>> use -L or drop to a shell and punt to the admin?  (That's what we would
> >>> do w/o any fsck -f invocation today...)
> >>
> >> Define the expected "forcefsck" semantics, and that will tell us
> >> what we need to do. Is it automatic system recovery? What if the
> >> root fs can't be mounted due to log replay problems?
> >
> > You're asking too much.  ;)  Semantics?  ;)  Best we can probably do
> > is copy what e2fsck does - it tries to replay the log before running
> > the actual fsck.  So ... what does e2fsck do if /it/ can't replay
> > the log?
> 
> As far as I can tell, in that case, e2fsck exit code indicates 4 -
> File system errors left uncorrected, but I'm studying ext testing
> tools and will try to verify it.
> About the -L flag, I think it is a bad idea - we don't want anything
> dangerous to happen here, so if it can't be fixed safely and in an
> automated way, just bail out.
> That being said, I added a log replay attempt in there (via mount/unmount).

I really don't advise doing that for a forced filesystem check. If
the log is corrupt, mounting it will trigger the problems we are
trying to avoid/fix by running a forced filesystem check. As it is,
we're probably being run in this mode because mounting has already
failed and causing the system not to boot.

What we need to do is list how the startup scripts work according to
what error is returned, and then match the behaviour we want in a
specific corruption case to the behaviour of a specific return
value.

i.e. if we have a dirty log, then really we need manual
intervention. That means we need to return an error that will cause
the startup script to stop and drop into an interactive shell for
the admin to fix manually.

This is what I mean by "define the expected forcefsck semantics" -
describe the behaviour of the system in reponse to the errors we can
return to it, and match them to the problem cases we need to resolve
with fsck.xfs.

> >>>> I also wonder if we can limit this to just the boot infrastructure,
> >>>> because I really don't like the idea of users using fsck.xfs -f to
> >>>> repair damage filesystems because "that's what I do to repair ext4
> >>>> filesystems"....
> >>>
> >>> Depending on how this gets fleshed out, fsck.xfs -f isn't any different
> >>> than bare xfs_repair...  (Unless all of the above suggestions about dirty
> >>> logs get added, then it certainly is!)  So, yeah...
> >>>
> >>> How would you propose limiting it to the boot environment?
> >>
> >> I have no idea - this is all way outside my area of expertise...
> >
> > A halfway measure would be to test whether the script is interactive, perhaps?
> >
> > https://www.tldp.org/LDP/abs/html/intandnonint.html
> >
> > case $- in
> > *i*)    # interactive shell
> > ;;
> > *)      # non-interactive shell
> > ;;
> >
> 
> IMO, any such test would make fsck.xfs behave unpredictably for the
> user. If anyone wants to run fsck.xfs -f instead of xfs_repair, it is
> their choice.

We limit user choices all the time. Default values, config options,
tuning variables, etc, IOWs, it's our choice as developers to allow
users to do something or not.  And in this case, we made this choice
to limit what fsck.xfs could do a long time ago:

# man fsck.xfs
.....
	If you wish to check the consistency of an XFS filesystem,
	or repair a damaged or corrupt XFS filesystem, see
	xfs_repair(8).
.....
# fsck.xfs
If you wish to check the consistency of an XFS filesystem or
repair a damaged filesystem, see xfs_repair(8).
#


> We can print something "next time use xfs_repair
> directly" for an interactive session, but I don't like the idea of the
> script doing different things based on some (for the user) hidden
> variables.

What hidden variable are you talking about here? Having a script
determine behaviour based on whether it is in an interactive
sessions or not is a common thing to do. There's nothing tricky or
unusual about it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
