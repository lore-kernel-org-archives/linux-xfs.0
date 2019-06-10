Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbfFJREl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:04:41 -0400
Date: Mon, 10 Jun 2019 10:04:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190610170434.GJ1871505@magnolia>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
 <20190610160616.GE1688126@magnolia>
 <CAOQ4uxiQsOTFO5f_aQWrmbSgSGuOy2wHoJbQAdWHrA1s-pZoHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiQsOTFO5f_aQWrmbSgSGuOy2wHoJbQAdWHrA1s-pZoHQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 10, 2019 at 07:54:52PM +0300, Amir Goldstein wrote:
> On Mon, Jun 10, 2019 at 7:06 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Mon, Jun 10, 2019 at 09:31:31AM -0400, Theodore Ts'o wrote:
> > > On Mon, Jun 10, 2019 at 09:37:32AM +0300, Amir Goldstein wrote:
> > > >
> > > >Why do you think thhis is xfs_io fall back and not kernel fall back to
> > > >do_splice_direct()? Anyway, both cases allow read from swapfile
> > > >on upstream.
> > >
> > > Ah, I had assumed this was changed that was made because if you are
> > > implementing copy_file_range in terms of some kind of reflink-like
> > > mechanism, it becomes super-messy since you know have to break tons
> > > and tons of COW sharing each time the kernel swaps to the swap file.
> > >
> > > I didn't think we had (or maybe we did, and I missed it) a discussion
> > > about whether reading from a swap file should be prohibited.
> > > Personally, I think it's security theatre, and not worth the
> > > effort/overhead, but whatever.... my main complaint was with the
> > > unnecessary test failures with upstream kernels.
> > >
> > > > Trying to understand the desired flow of tests and fixes.
> > > > I agree that generic/554 failure may be a test/interface bug that
> > > > we should fix in a way that current upstream passes the test for
> > > > ext4. Unless there is objection, I will send a patch to fix the test
> > > > to only test copy *to* swapfile.
> > > >
> > > > generic/553, OTOH, is expected to fail on upstream kernel.
> > > > Are you leaving 553 in appliance build in anticipation to upstream fix?
> > > > I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> > > > posted and plan to push to upstream/stable sooner than VFS patches.
> > >
> > > So I find it kind of annoying when tests land before the fixes do
> > > upstream.  I still have this in my global_exclude file:
> >
> > Yeah, it's awkward for VFS fixes because on the one hand we don't want
> > to have multiyear regressions like generic/484, but OTOH stuffing tests
> > in before code goes upstream enables broader testing by the other fs
> > maintainers.
> 
> And to prove this point, Ted pointed out a test bug in 554, which also
> affects the kernel and man pages fixes, so it was really worth it ;-)

:D

> >
> > In any case, the fixes are in the copy-range-fixes branch which I'm
> > finally publishing...
> >
> > > # The proposed fix for generic/484, "locks: change POSIX lock
> > > # ownership on execve when files_struct is displaced" would break NFS
> > > # Jeff Layton and Eric Biederman have some ideas for how to address it
> > > # but fixing it is non-trivial
> >
> > Also, uh, can we remove this from the auto and quick groups for now?
> >
> 
> I am not opposed to removing these test from auto,quick, although removing
> from quick is a bit shady. I would like to mark them explicitly with group
> known_issues, so that users can run ./check -g quick -x known_issues.
> BTW, overlay/061 is also a known_issue that is going to be hard to fix.
> 
> But anyway, neither 553 nor 554 fall into that category.

Sorry, I was unclear -- I was asking to remove g/484 from auto/quick.

--D

> Thanks,
> Amir.
