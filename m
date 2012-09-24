Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OCamZP142968 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 07:36:49 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	19dzcUfm9POlo3FV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 05:38:04 -0700 (PDT)
Received: by lbbgg6 with SMTP id gg6so1911822lbb.26
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 05:38:02 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/6] xfstest: add fio git submodule
In-Reply-To: <20120924113718.GK20960@dastard>
References: <a> <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
	<505FD0A9.3090601@redhat.com> <87lifzd9fl.fsf@openvz.org>
	<20120924113718.GK20960@dastard>
Date: Mon, 24 Sep 2012 16:38:00 +0400
Message-ID: <87txun1tqv.fsf@openvz.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Mon, 24 Sep 2012 21:37:18 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Sep 24, 2012 at 02:03:42PM +0400, Dmitry Monakhov wrote:
> > On Sun, 23 Sep 2012 22:16:57 -0500, Eric Sandeen <sandeen@redhat.com> wrote:
> > > On 9/23/12 2:24 PM, Dmitry Monakhov wrote:
> > > > FIO is very flexible io generator, i would call it IO swiss knife.
> > > > Currently we have tonnes of hardcoded application which reproduces
> > > > some predefined scenario. This approach has obvious dissadvantages
> > > > 1) Lack of flexability: once written it is hard to modify it in future
> > > > 2) Code base is large, many routines written again and again
> > > > 
> > > > At the same time add new fio based tast is just add simle INI file.
> > > > This greatly simplify code review. I do beleve that some day we will
> > > > replace most of hardcoded io binaries with fio.
> > > 
> > > The submodule approach is interesting, but I wonder - we have quite a few
> > > dependencies on other binaries already; what are the pros and cons of creating
> > > this as a git submodule vs. simply expecting fio to be installed on the
> > > system like any of the other dependencies we have today?
> > Pro:
> >  P1) allow to specify exact commit as a submodule HEAD this guarantee
> >      that we will have known version and functionality regardless to
> >      distribution package manager (which are known to be very conservative)
> 
> You haven't provided a method to do this in this patch. All
> you've provided is a submodule that tracks the fio tree head.
> All this needs to be properly documented in the README file, at
> minimum.
> 
> And conservative is good, too. I don't want tests to fail because of
> rapid changes in the fio tree causing regressions in fio itself. The
> tools that xfstests depends on need to be stable and relatively
> unchanging, because we're not testing them - we're testing the
> filesystem. The less the environemnt changes around the things we're
> actually supposed to be regression testing, the better.
Yes, but we do not have to advance submodule update unless we need it.
Project may goes forward but we still can use old commit if needed.
> 
> >  P2) Prevent duplicating of source code (fsstress.c/aio-stress.c and
> >      etc).  If some one want to add new feature to submodule he
> >      simply push it to official submodule repo and move submodule HEAD
> >      In that both parties(submodule maintainer and project maintainer)
> >      will benefit because new features will be available to every
> >      submodule user
> > Cons:
> >  C1) New dependencies
> >  C2) Learn people how to work with submodules
> > 
> > I'll not assume (C2) as a serious argument because this is just one more
> > git's command. For most users should just add new option to clone:
> > git clone --recursive git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> Doesn't work for me. I keep local mirrors of all git trees that I
> use regularly and update them by cron jobs so that I don't have to
> go to the internet for every local tree that I clone or update.
> 
> That's particularly important for me because I'm a *long* way from
> the US or Europe and cloning from scratch over the internet takes a
> long time and suck up a lot of bandwidth. I don't even allow my test
> machines to access the internet - they only know about the local
> network and mirrors. I'd have to overide the fio submodule URL in
> the xfstests repository on every test machine, and that gets messy
> in a hurry.
> 
> Also, we distribute xfstests as a tarball, and there has been talk of
> proper packaging (rpm/deb) as well. In those cases, the git
> submodule approach does not work as we have to depend on the distro
> supplied fio packages...
Yes, if this is mandatory. it makes packaging harder but not too
complex.
> 
> > (C1) Is not big deal in case of Fio because we already depends from
> > libaio.
> 
> There's also a fio version dependency. i.e. _require_fio has to
> detect whether the currently installed fio is of sufficiently recent
> version for the tests to run.
> 
> > (P2) Makes xfstest coverage larger because all new tests which use new 
> >      submodules functionality will start to work by default (today it
> >       silently ignored). As i already told fio is under rapid
> >      development Jens Axboe does very good job so (P2) really works for
> >      me, new features i need for xfstets was reviewed and accepted by Jens
> > http://git.kernel.dk/?p=fio.git;a=commit;h=8b28bd41375930664a0ff9ff9b101a88ac416ac5
> > http://git.kernel.dk/?p=fio.git;a=commit;h=9c25d2e3f498707c4fd5a4bb0adf9867ecb17768
> > http://git.kernel.dk/?p=fio.git;a=commit;h=e615ceafbe3962a35b7a7e06a0c8f4e2c0652c65
> 
> For me, that's not a "pro" - that's a "con" as i explained above.
> 
> > > (I package fio for Fedora, is it not commonly available on other
> > > distros?)
> 
> Available for Debian, which means all it's derivatives also have it.
> 
> In short, I'd prefer we continue to use package level dependencies
> detected through configure/_require_foo infrastructure than using
> source tree level dependencies. Package level dependencies are much,
> much easier to manage for most people and don't require everyone to
> have internet access on the machines that xfstests is being built
> on....
Ok i'll go back to _require_fio $VER approach, but it is reasonable to
add prep script which will fetch or install all necessary packages
so user can explicitly run it if internet is available.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
