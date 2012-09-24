Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OA2V5q129001 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 05:02:31 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	pDL8Y5tV9YDVrITv (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 03:03:46 -0700 (PDT)
Received: by lbbgg6 with SMTP id gg6so1724518lbb.26
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 03:03:45 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/6] xfstest: add fio git submodule
In-Reply-To: <505FD0A9.3090601@redhat.com>
References: <a> <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
	<505FD0A9.3090601@redhat.com>
Date: Mon, 24 Sep 2012 14:03:42 +0400
Message-ID: <87lifzd9fl.fsf@openvz.org>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Sun, 23 Sep 2012 22:16:57 -0500, Eric Sandeen <sandeen@redhat.com> wrote:
> On 9/23/12 2:24 PM, Dmitry Monakhov wrote:
> > FIO is very flexible io generator, i would call it IO swiss knife.
> > Currently we have tonnes of hardcoded application which reproduces
> > some predefined scenario. This approach has obvious dissadvantages
> > 1) Lack of flexability: once written it is hard to modify it in future
> > 2) Code base is large, many routines written again and again
> > 
> > At the same time add new fio based tast is just add simle INI file.
> > This greatly simplify code review. I do beleve that some day we will
> > replace most of hardcoded io binaries with fio.
> 
> The submodule approach is interesting, but I wonder - we have quite a few
> dependencies on other binaries already; what are the pros and cons of creating
> this as a git submodule vs. simply expecting fio to be installed on the
> system like any of the other dependencies we have today?
Pro:
 P1) allow to specify exact commit as a submodule HEAD this guarantee
     that we will have known version and functionality regardless to
     distribution package manager (which are known to be very conservative)
 P2) Prevent duplicating of source code (fsstress.c/aio-stress.c and
     etc).  If some one want to add new feature to submodule he
     simply push it to official submodule repo and move submodule HEAD
     In that both parties(submodule maintainer and project maintainer)
     will benefit because new features will be available to every
     submodule user
Cons:
 C1) New dependencies
 C2) Learn people how to work with submodules

I'll not assume (C2) as a serious argument because this is just one more
git's command. For most users should just add new option to clone:
git clone --recursive git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

(C1) Is not big deal in case of Fio because we already depends from
libaio.

(P2) Makes xfstest coverage larger because all new tests which use new 
     submodules functionality will start to work by default (today it
      silently ignored). As i already told fio is under rapid
     development Jens Axboe does very good job so (P2) really works for
     me, new features i need for xfstets was reviewed and accepted by Jens
http://git.kernel.dk/?p=fio.git;a=commit;h=8b28bd41375930664a0ff9ff9b101a88ac416ac5
http://git.kernel.dk/?p=fio.git;a=commit;h=9c25d2e3f498707c4fd5a4bb0adf9867ecb17768
http://git.kernel.dk/?p=fio.git;a=commit;h=e615ceafbe3962a35b7a7e06a0c8f4e2c0652c65

> 
> (I package fio for Fedora, is it not commonly available on other
> distros?)
> 
> -Eric
> 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  .gitmodules                  |    3 +++
> >  common.config                |    3 +++
> >  src/Makefile                 |    8 +++++---
> >  src/aio-dio-regress/Makefile |    4 ++--
> >  src/fio                      |    1 +
> >  5 files changed, 14 insertions(+), 5 deletions(-)
> >  create mode 100644 .gitmodules
> >  create mode 160000 src/fio
> > 
> > diff --git a/.gitmodules b/.gitmodules
> > new file mode 100644
> > index 0000000..f0481ea
> > --- /dev/null
> > +++ b/.gitmodules
> > @@ -0,0 +1,3 @@
> > +[submodule "src/fio"]
> > +	path = src/fio
> > +	url = git://git.kernel.dk/fio.git
> > diff --git a/common.config b/common.config
> > index 7bed1c5..25cddb4 100644
> > --- a/common.config
> > +++ b/common.config
> > @@ -138,6 +138,9 @@ export DF_PROG="`set_prog_path df`"
> >  [ "$DF_PROG" = "" ] && _fatal "df not found"
> >  [ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T"
> >  
> > +export FIO_PROG="`set_prog_path $PWD/src/fio/fio`"
> > +[ "$FIO_PROG" = "" ] && _fatal "fio not found"
> > +
> >  export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
> >  export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
> >  export XFS_CHECK_PROG="`set_prog_path xfs_check`"
> > diff --git a/src/Makefile b/src/Makefile
> > index 67250ee..255bdd4 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -52,16 +52,18 @@ LLDLIBS += $(LIBGDBM)
> >  endif
> >  
> >  ifeq ($(HAVE_AIO), true)
> > -SUBDIRS += aio-dio-regress
> > +SUBDIRS += aio-dio-regress \
> > +		fio
> > +
> >  endif
> >  
> >  CFILES = $(TARGETS:=.c)
> >  LDIRT = $(TARGETS)
> >  
> >  
> > -default: depend $(TARGETS) $(SUBDIRS)
> > +default: .depend $(TARGETS) $(SUBDIRS)
> >  
> > -depend: .dep
> > +.depend: .dep
> >  
> >  include $(BUILDRULES)
> >  
> > diff --git a/src/aio-dio-regress/Makefile b/src/aio-dio-regress/Makefile
> > index 79dd55d..fcead9a 100644
> > --- a/src/aio-dio-regress/Makefile
> > +++ b/src/aio-dio-regress/Makefile
> > @@ -8,9 +8,9 @@ LDIRT = $(TARGETS)
> >  
> >  LLDLIBS = -laio -lpthread
> >  
> > -default: depend $(TARGETS)
> > +default: .depend $(TARGETS)
> >  
> > -depend: .dep
> > +.depend: .dep
> >  
> >  include $(BUILDRULES)
> >  
> > diff --git a/src/fio b/src/fio
> > new file mode 160000
> > index 0000000..e12d280
> > --- /dev/null
> > +++ b/src/fio
> > @@ -0,0 +1 @@
> > +Subproject commit e12d2800f811cb64d376cfdaed9a1257f3fa9c99
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
