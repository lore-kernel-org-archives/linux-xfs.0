Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41183 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbeERA35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 20:29:57 -0400
Received: by mail-pg0-f68.google.com with SMTP id w4-v6so2523185pgq.8
        for <linux-xfs@vger.kernel.org>; Thu, 17 May 2018 17:29:57 -0700 (PDT)
Date: Thu, 17 May 2018 17:29:53 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180518002953.GD24680@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <20180517205845.GV23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517205845.GV23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 02:31:21PM -0700, Darrick J. Wong wrote:
> On Thu, May 17, 2018 at 12:27:00PM -0700, Luis R. Rodriguez wrote:
> > You may want to stick to specific set of configuration options when
> > creating filesystems with mkfs.xfs -- sometimes due to pure technical
> > reasons, but some other times to ensure systems remain compatible as
> > new features are introduced with older kernels, or if you always want
> > to take advantage of some new feature which would otherwise typically
> > be disruptive.
> > 
> > This adds support for parsing a configuration file to override defaults
> > parameters to be used for mkfs.xfs.
> > 
> > We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> > different configuration files, if none is specified we look for the
> > default configuration file, /etc/mkfs.xfs.d/default. You can override
> > with -c.  For instance, if you specify:
> > 
> > 	mkfs.xfs -c experimental -f /dev/loop0
> > 
> > The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> > file. If you really need to override the full path of the configuration
> > file you may use the MKFS_XFS_CONFIG environment variable.
> > 
> > To verify what configuration file is used on a system use the typical:
> > 
> >   mkfs.xfs -N
> > 
> > There is only a subset of options allowed to be set on the configuration
> > file, and currently only 1 or 0 are acceptable values. The default
> > parameters you can override on a configuration file and their current
> > built-in default settings are:
> > 
> > [data]
> > noalign=0
> > 
> > [inode]
> > align=1
> > projid32bit=1
> > sparse=0
> > 
> > [log]
> > lazy-count=1
> > 
> > [metadata]
> > crc=1
> > finobt=1
> > rmapbt=0
> > reflink=0
> > 
> > [naming]
> > ftype=1
> > 
> > [rtdev]
> > noalign=0
> 
> Separate patch, but should there be a way to spit out the current mkfs
> settings as a config file?

Sure, I have that in my mind but definitely separate patch. As can be
seen, there are still quite a bit of minor things to wrap up. No point
in getting ahead of ourselves.

> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > ---
> >  include/builddefs.in   |   2 +
> >  man/man5/mkfs.xfs.d.5  | 121 ++++++++++
> >  man/man8/mkfs.xfs.8    |  26 +++
> >  mkfs/Makefile          |   2 +-
> >  mkfs/xfs_mkfs.c        |  47 +++-
> >  mkfs/xfs_mkfs_common.h |  12 +
> >  mkfs/xfs_mkfs_config.c | 591 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  mkfs/xfs_mkfs_config.h |  11 +
> >  8 files changed, 801 insertions(+), 11 deletions(-)
> >  create mode 100644 man/man5/mkfs.xfs.d.5
> >  create mode 100644 mkfs/xfs_mkfs_config.c
> >  create mode 100644 mkfs/xfs_mkfs_config.h
> > 
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 8aac06cf90dc..e1ee9f7ba086 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -62,6 +62,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
> >  PKG_INC_DIR	= @includedir@/xfs
> >  DK_INC_DIR	= @includedir@/disk
> >  PKG_MAN_DIR	= @mandir@
> > +PKG_ETC_DIR	= @sysconfdir@
> >  PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
> >  PKG_LOCALE_DIR	= @datadir@/locale
> >  
> > @@ -196,6 +197,7 @@ endif
> >  
> >  GCFLAGS = $(DEBUG) \
> >  	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
> > +	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
> >  	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
> >  
> >  ifeq ($(ENABLE_GETTEXT),yes)
> > diff --git a/man/man5/mkfs.xfs.d.5 b/man/man5/mkfs.xfs.d.5
> > new file mode 100644
> > index 000000000000..5424f730a2e5
> > --- /dev/null
> > +++ b/man/man5/mkfs.xfs.d.5
> > @@ -0,0 +1,121 @@
> > +.TH mkfs.xfs.d 5
> > +.SH NAME
> > +mkfs.xfs.d \- mkfs.xfs configuration directory
> > +.SH DESCRIPTION
> > +.B mkfs.xfs (8)
> > +uses a set of initial default parameters for configuration. These defaults
> > +are conservatively decided by the community as xfsprogs and features for XFS
> > +in the kernel advance. One can override these defaults on the
> 
> I'm not sure what the sentence "These defaults...in the kernel advance."
> means... is this close to what you meant?:
> 
> "The builtin mkfs defaults are decided by the XFS community.  New features
> are only enabled by default when the community consider it stable."

That reads much better. Amended.

> > +.B mkfs.xfs (8)
> > +command line, but there are cases where it is desirable for sensible defaults
> > +to always be specified by the system where
> 
> "...where it is desirable for the distro or the system administrator to
> establish their own supported defaults in a uniform manner." ?

Sure, I'll also add at the end:

"regardless of the version of mkfs.xfs used"

> > +.B mkfs.xfs (8)
> > +runs on. This may desirable for example on systems with old kernels where the
> > +built-in default parameters on
> > +.B mkfs.xfs (8)
> > +may not be able to create a filesystem which the old kernel supports and it
> 
> "...where the built-in default mkfs.xfs parameters create a filesystem
> that is not supported by the old kernel."
> 
> > +would be unclear what parameters are needed to produce a compatible filesystem.
> > +Overriding
> > +.B mkfs.xfs (8)
> > +built-in defaults may also be desirable if you have a series of systems with
> > +different kernels and want to be able to create filesystems which all systems
> > +are able to support properly.

I've moved this to another sentence as well then:

In such situations it would also be unclear what parameters are needed to        
produce a compatible filesystem, having a configuration file present ensures    
that if newer versions of                                                       
.B mkfs.xfs (8)                                                                 
are deployed, creating a filesystem will remain compatible.

> > +.PP
> > +The XFS configuration directory
> > +.B mkfs.xfs.d (5)
> > +can be used to define different configuration files which can be used to
> > +override the built-in default parameters by
> > +.B mkfs.xfs (8).
> > +Different configuration files are supported, the default
> > +configuration file,
> > +.I /etc/mkfs.xfs.d/default
> 
> The "/etc" part of the path should be sysconfdir and replaced by the
> build script to match whatever we're encoding into the mkfs.xfs binary.

Alrighty .. and all other "etc" references I take it.. sure.

> > +, will be looked for first and if present will be used to override
> > +.B mkfs.xfs (8)
> > +built-in default parameters. You can override the configuration file by
> > +specifying its name when using
> > +.B mkfs.xfs (8)
> > +by using the
> > +.B -c
> > +parameter. For example:
> > +.I mkfs.xfs -c experimental -f /dev/sda1
> > +will make
> > +.B mkfs.xfs (8)
> > +look for and use the configuration file
> > +.I /etc/mkfs.xfs.d/experimental
> > +to override
> > +.B mkfs.xfs (8)
> > +default parameters. If you need to override the full path for a configuration
> > +file you can use the
> > +.I MKFS_XFS_CONFIG
> > +environment variable prior to calling
> > +.B mkfs.xfs (8)
> > +to define the
> > +full path to the configuration file to be used.
> 
> Does the environment variable override -c, or the other way around?

The other way around.

Will continue the rest tomorrow.

  Luis
