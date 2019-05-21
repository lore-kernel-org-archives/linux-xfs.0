Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfEUQ6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 12:58:07 -0400
Date: Tue, 21 May 2019 09:58:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/12] libxfs: refactor online geometry queries
Message-ID: <20190521165801.GB5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839422001.68606.12869125311562128404.stgit@magnolia>
 <67eb11a7-d468-4b14-ab6d-714bd1de1f72@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67eb11a7-d468-4b14-ab6d-714bd1de1f72@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:38:56AM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
> > helper that we can use to standardize behaviors across mixed xfslibs
> > versions.  This is the prelude to introducing a new FSGEOMETRY version
> > in 5.2 and needing to fix the (relatively few) client programs.
> 
> Ok, helper is nice, but... libhandle?  I don't see how a geometry ioctl
> wrapper is related to libhandle.  Would this make more sense in libfrog/ ?

Secret goal here : I'd also like to convert xfsdump and xfstests to use
these helpers instead of forcing everyone to write their own graceful
degradation gluecode if they want to keep up with the new FSGEOMETRY
ioctl we're introducing in 5.2.

At the same time, putting it in libhandle means we need a better prefix
than xfs_ since that's for libxfs stuff.  Uh, maybe I'll redo this patch
with xfrog_ instead of xfs_ ?

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  Makefile            |    9 +++++----
> >  fsr/xfs_fsr.c       |   25 +++----------------------
> >  growfs/Makefile     |    5 +++--
> >  growfs/xfs_growfs.c |   24 ++++++++----------------
> >  include/linux.h     |    5 +++++
> >  io/bmap.c           |    2 +-
> >  io/fsmap.c          |    2 +-
> >  io/open.c           |    2 +-
> >  io/stat.c           |    4 ++--
> >  libhandle/Makefile  |    2 +-
> >  libhandle/ioctl.c   |   26 ++++++++++++++++++++++++++
> >  quota/Makefile      |    4 ++--
> >  quota/free.c        |    5 ++---
> >  repair/Makefile     |    6 +++---
> >  repair/xfs_repair.c |    4 ++--
> >  rtcp/Makefile       |    3 +++
> >  rtcp/xfs_rtcp.c     |    6 +++---
> >  scrub/phase1.c      |    2 +-
> >  spaceman/Makefile   |    4 ++--
> >  spaceman/file.c     |    2 +-
> >  spaceman/info.c     |   24 +++++++-----------------
> >  21 files changed, 82 insertions(+), 84 deletions(-)
> >  create mode 100644 libhandle/ioctl.c
> > 
> > 
> > diff --git a/Makefile b/Makefile
> > index 9204bed8..b72a9209 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -99,14 +99,15 @@ $(LIB_SUBDIRS) $(TOOL_SUBDIRS): include libfrog
> >  $(DLIB_SUBDIRS) $(TOOL_SUBDIRS): libxfs
> >  db logprint: libxlog
> >  fsr: libhandle
> > -growfs: libxcmd
> > +growfs: libxcmd libhandle
> >  io: libxcmd libhandle
> > -quota: libxcmd
> > -repair: libxlog libxcmd
> > +quota: libxcmd libhandle
> > +repair: libxlog libxcmd libhandle
> >  copy: libxlog
> >  mkfs: libxcmd
> > -spaceman: libxcmd
> > +spaceman: libxcmd libhandle
> >  scrub: libhandle libxcmd
> > +rtcp: libhandle
> >  
> >  ifeq ($(HAVE_BUILDDEFS), yes)
> >  include $(BUILDRULES)
> 
> ...
