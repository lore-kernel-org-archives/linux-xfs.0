Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39759 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753112AbdLHWxY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Dec 2017 17:53:24 -0500
Date: Sat, 9 Dec 2017 09:52:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: fix exitcode handling (was Re: generic/399 and
 xfs_io pwrite command)
Message-ID: <20171208225253.GO4094@dastard>
References: <7235f31f-5427-ff12-11f9-cba98431e71c@tuxera.com>
 <20171204222842.GX4094@dastard>
 <35d2712c-b036-d017-2d42-f74bbc4444a9@tuxera.com>
 <20171205211850.GA5858@dastard>
 <20171206002638.GB5858@dastard>
 <20171207140519.GB3486@bfoster.bfoster>
 <20171207234631.GI5858@dastard>
 <20171208141506.GA55826@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208141506.GA55826@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Ari Sundholm <ari@tuxera.com>, fstests@vger.kernel.org, Emil Karlson <jkarlson@tuxera.com>, linux-xfs@vger.kernel.org

On Fri, Dec 08, 2017 at 09:15:06AM -0500, Brian Foster wrote:
> On Fri, Dec 08, 2017 at 10:46:31AM +1100, Dave Chinner wrote:
> > On Thu, Dec 07, 2017 at 09:05:20AM -0500, Brian Foster wrote:
> > > On Wed, Dec 06, 2017 at 11:26:38AM +1100, Dave Chinner wrote:
> > > > On Wed, Dec 06, 2017 at 08:18:50AM +1100, Dave Chinner wrote:
> > > > > On Tue, Dec 05, 2017 at 04:23:43PM +0200, Ari Sundholm wrote:
> > > > > > On 12/05/2017 12:28 AM, Dave Chinner wrote:
> > > > > > >On Thu, Nov 30, 2017 at 04:21:47PM +0200, Ari Sundholm wrote:
> > > ...
> > > > 
> > > > xfs_io: set exitcode on failure appropriately
> > > > 
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Many operations don't set the exitcode when they fail, resulting
> > > > in xfs_io exiting with a zero (no failure) exit code despite the
> > > > command failing and returning an error. Fix this.
> > > > 
> > > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > ...
> > > > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > > > index d1dfc5a5e33a..9b737eff4c02 100644
> > > > --- a/io/copy_file_range.c
> > > > +++ b/io/copy_file_range.c
> > > > @@ -92,6 +92,7 @@ copy_range_f(int argc, char **argv)
> > > >  	int ret;
> > > >  	int fd;
> > > >  
> > > > +	exitcode = 1;
> > > >  	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
> > > >  		switch (opt) {
> > > >  		case 's':
> > > > @@ -132,6 +133,8 @@ copy_range_f(int argc, char **argv)
> > > >  
> > > >  	ret = copy_file_range(fd, &src, &dst, len);
> > > >  	close(fd);
> > > > +	if (ret >= 0)
> > > > +		exitcode = 0;
> > > 
> > > I don't think it's appropriate to blindly overwrite the global exitcode
> > > value like this. What about the case where multiple commands are chained
> > > together? Should we expect an error code if any of the commands failed
> > > or only the last?
> > > 
> > > For example:
> > > 
> > >   xfs_io -c "pwrite ..." <file>
> > > 
> > > ... returns an error if the write fails, while:
> > > 
> > >   xfs_io -c "pwrite ..." -c "fadvise ..." <file>
> > > 
> > > ... would never so long as the fadvise succeeds.
> > 
> > Yup, I mentioned that this would be a problem on IRC. The patch fixes
> > the interactive and the single command cases, but won't work for
> > chained commands as you rightly point out.
> > 
> > To fix it properly, it's going to take a lot more than 15 minutes of
> > time. We're going to have to change how errors are returned to and
> > propagated through the libxcmd infrastruture, how we handle "fatal
> > error, don't continue" conditions through the libxcmd command loop,
> > etc. If we want to stop at the first error, then we've got to go
> > change all the return values from xfs_io commands to return non-zero
> > on error. We still have to set the exitcode as per this patch,
> > because the non-zero return value simply says "stop parsing input"
> > and doesn't affect the exit code of the program.
> > 
> > Given that xfs_quota, xfs_io, xfs_db, and xfs_spaceman all use the
> > same libxcmd infrastructure, we've got to make the changes
> > consistently across all of those utilities. This will require an
> > audit of all the commands first to determine if there's anything
> > special in any of those utilities, then changing all the code, then
> > testing all the CLI parsing still works correctly.  xfs_quota, as
> > usual, will be the problem child that causes us lots of pain here.
> > 
> > I'm not planning on doing all this in the near future, so I did the
> > next best thing that would only affect xfs_io behaviour. i.e.
> > directly manipulate the exitcode as many of the existing xfs_io
> > commands already do.
> > 
> 
> Sure, I don't dispute the broader work required to fix everything up
> properly and I don't take issue with modifying exitcode directly in
> principle. I just don't see how any of this necessitates breaking the
> chained command case for the those commands that we are trying to fix
> up, particularly when the problem seems easily avoidable. See below for
> a tweak to the fadvise example..

You're welcome to do this - I just threw out a quick patch that
makes the code *less broken* rather than perfect. exit codes for
chained commands are already somewhat broken, so what I did doesn't
make the state of affairs any worse.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
