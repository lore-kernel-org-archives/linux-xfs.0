Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 486FF7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:39:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A26F304032
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:39:59 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id vobvtfH8IBro5mj1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:39:57 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id A312C20AB3
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:39:56 +0100 (CET)
Date: Tue, 12 Jan 2016 22:37:11 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 6/6] Add configure check for members of dirent for use in
	io/readdir.c
Message-ID: <20160112213711.GB10558@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200022.GG568@nyan> <20160112213006.GN10456@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112213006.GN10456@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Jan 12, 2016 at 09:00:22PM +0100, Felix Janda wrote:
> > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> > ---
> >  configure.ac         |  7 +++++++
> >  include/builddefs.in |  4 ++++
> >  io/Makefile          | 10 ++++++++++
> >  3 files changed, 21 insertions(+)
> > 
> > diff --git a/configure.ac b/configure.ac
> > index feee50a..3d6443a 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -135,5 +135,12 @@ AC_CHECK_SIZEOF([char *])
> >  AC_TYPE_UMODE_T
> >  AC_MANUAL_FORMAT
> >  
> > +AC_CHECK_MEMBERS([struct dirent.d_reclen],[],[],[[#include <dirent.h>]])
> > +AC_SUBST(ac_cv_member_struct_dirent_d_reclen)
> > +AC_CHECK_MEMBERS([struct dirent.d_off],[],[],[[#include <dirent.h>]])
> > +AC_SUBST(ac_cv_member_struct_dirent_d_off)
> > +AC_CHECK_MEMBERS([struct dirent.d_type],[],[],[[#include <dirent.h>]])
> > +AC_SUBST(ac_cv_member_struct_dirent_d_type)
> > +
> >  AC_CONFIG_FILES([include/builddefs])
> >  AC_OUTPUT
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index b5ce336..67d963c 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -109,6 +109,10 @@ HAVE_FLS = @have_fls@
> >  HAVE_FSETXATTR = @have_fsetxattr@
> >  HAVE_MREMAP = @have_mremap@
> >  
> > +HAVE_STRUCT_DIRENT_D_RECLEN = @ac_cv_member_struct_dirent_d_reclen@
> > +HAVE_STRUCT_DIRENT_D_OFF = @ac_cv_member_struct_dirent_d_off@
> > +HAVE_STRUCT_DIRENT_D_TYPE = @ac_cv_member_struct_dirent_d_type@
> > +
> >  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
> >  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> >  
> > diff --git a/io/Makefile b/io/Makefile
> > index 0b53f41..9574168 100644
> > --- a/io/Makefile
> > +++ b/io/Makefile
> > @@ -94,6 +94,16 @@ ifeq ($(HAVE_MREMAP),yes)
> >  LCFLAGS += -DHAVE_MREMAP
> >  endif
> >  
> > +ifeq ($(HAVE_STRUCT_DIRENT_D_RECLEN),yes)
> > +LCFLAGS += -D_DIRENT_HAVE_D_RECLEN
> > +endif
> 
> The C library should be defining these if those fields are
> supported, right?

It is strongly advised not to use these non-standard fields of dirent.
These macros are a feature of glibc. See also

https://seiscode.iris.washington.edu/issues/676

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
