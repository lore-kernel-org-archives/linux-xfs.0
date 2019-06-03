Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfFCMjP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jun 2019 08:39:15 -0400
Date: Mon, 3 Jun 2019 14:39:00 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: How to package e2scrub
Message-ID: <20190603123900.gzwwltgt2bj7gyfa@work>
References: <20190529120603.xuet53xgs6ahfvpl@work>
 <20190529182111.GA5220@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529182111.GA5220@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 29, 2019 at 11:21:11AM -0700, Darrick J. Wong wrote:
> On Wed, May 29, 2019 at 02:06:03PM +0200, Lukas Czerner wrote:
> > Hi guys,
> > 
> > I am about to release 1.45.2 for Fedora rawhide, but I was thinking
> > about how to package the e2scrub cron job/systemd service.
> 
> Funny, xfs has the same conundrum.  Adding Eric & xfs list to cc...
> 
> > I really do not like the idea of installing cron job and/or the service as
> > a part of regular e2fsprogs package. This can potentially really surprise
> > people in a bad way.
> >
> > Note that I've already heard some complaints from debian users about the
> > systemd service being installed on their system after the e2fsprogs
> > update.
> 
> Yeah, e2scrub is bitrotting rather faster than I had thought it
> would... but it's only available in Debian unstable.
> 
> > What I am going to do is to split the systemd service into a separate
> > package and I'd like to come to some agreement about the name of the
> > package so that we can have the same name across distributions (at least
> > Fedora/Debian/Suse).
> 
> Indeed.  Eric picked "xfsprogs-xfs_scrub" for Rawhide, though I find
> that name to be very clunky and would have preferred "xfs_scrub".
> 
> > I was thinking about e2scrub-service for systemd service or e2scrub-cron
> > for the cron job. What do you think ?
> 
> In /theory/ the cronjob support in e2scrub (and xfs_scrub) were designed
> to step out of the way if systemd is running, so at least in theory (on
> Debian anyway) the two can be in the same package with the end result
> being that e2scrub runs weekly in the background.  I've not tried in
> rhel/suse environments, however.
> 
> I also don't see the point of supporting cron *while* systemd is active.
> That increases the amount of corner-case testing we have to do, for
> little gain.  It's enough work to maintain the systemd-with-timers and
> sysvinit-with-cron scenarios.

Yeah, you're probably right. I just wanted to give people some options
if they do not want (for whatever reason) to use systemd. Container
environment might be a good example of that, but I am not at all sure
how well is lvm2 supported in containers.

> 
> If you're worried about the stability of systemd timer code, systemd's
> timer support has been stable enough to run e2scrub_all/xfs_scrub_all on
> my systems since late 2015, and I have no interest in supporting either
> on a pre-2016 distro.  Practically speaking, I guess that RHEL8, SLES16,
> and Ubuntu 20.04 will be the first LTS distros to support e2scrub at
> all.
> 
> (As for xfs_scrub, it'll barely achieve alpha status in Linux 5.2...)
> 
> > Also I decided not to package the cron job for now. But if I decide to
> > package it in the future I'd like to change the e2scrub cron
> > configuration so that it can run on the systems with systemd but make
> > the package conflict with the e2scrub-service so that users are free to
> > decide how they want to use it.
> 
> If you do end up creating two packages I'd name the systemd one
> e2scrub-systemd over e2scrub-service.

Ok, thanks for suggestion. Andreas was suggesting naming it as part of
e2fsprogs, that is - e2fsprogs-scrub but then it would be
e2fsprogs-scrub-systemd and that sounds a bit convoluted to me.

Thanks!
-Lukas

> 
> --D
> 
> > Thoughts ?
> > 
> > Thanks!
> > -Lukas
