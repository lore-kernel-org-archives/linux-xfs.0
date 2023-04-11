Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A14C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 21:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjDKV6d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 17:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDKV6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 17:58:32 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F0D10EF
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 14:58:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id ke16so9195374plb.6
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 14:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681250310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QpXZE9ccwI65CeyT6Fuy2ByDl0Rn/e7Cup3+dDGnx7U=;
        b=BLTDZ8roFDjHbQixMs+lmq4CkLpaBQ1a3ORXiDIt+9IHrYVV0D561rJQF4pG+d6ohE
         tdv+lKKlAgCy/JKj9ojEyStDJz3vUQjGTUIzllVBIqSTa7+L8l66iRSRZqWwNwxKzh6w
         sXdnpKS7bJrXDbvSiwvsVbFSHeXMWDuIIYqJsJv+9lHtXps1PBZaaemX4sElz/QseE4v
         XE9mFssF9DgN/W29dFJLqFungN8S+NUpolB820n7GsYKr4R+PQ13eoPTMFUtzyVxqmCn
         Y2NcvOTFSntYfw6cI/m045r7CSJmKu2ohR6fB/14HZMKQGdPxwivZGVdllWAMnMJMGXM
         rC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681250310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QpXZE9ccwI65CeyT6Fuy2ByDl0Rn/e7Cup3+dDGnx7U=;
        b=e6jiqvdXBMFnPJz8EN7vDeqnq0jcqUfZ531LEw+PEbdnpvDemu2VjF4tFMKYWI+RNi
         QzqxvpIcu8DraVpy+9M8SA3Rg546SPJOxuaYC+sMOuRwYndEvDCM3XFUNdR47zPy2cT1
         LBBmtJDift1F9FK363eBmGYMLxHSZMb6VG3/sH23Hip8Pr+xM5lsMRaohIQDZb1pyiSY
         nRS+3UrD9eOiRFkT2qNBMv+IfAUCGFZ8NuxUko+ltrh7xGeOpDlXHvYzJvN7P2Zte6DC
         VPlbax89fWVRLM7A726jVONJnBrx3ZHuLUNUHVhDThPRIEHhnhPnWIwMa/JGh0OWmxWq
         BdSQ==
X-Gm-Message-State: AAQBX9eEVZIBGHbdysE4v51ANpvuKhf9hK2+cattAPdWgdS0CNOvny3F
        EdlpGtpARu1i8lImntRho1f5Tn8pYFIJRLKWdABEYLdS1G0=
X-Google-Smtp-Source: AKy350ZIDEZoOwbfM/7isCsZPkaTA2ScvRGLJngDYcucAf1FmXVbutalN5bPu731wRgAaynz8cvBWg==
X-Received: by 2002:a17:90b:1bcd:b0:23f:2955:aabe with SMTP id oa13-20020a17090b1bcd00b0023f2955aabemr16259283pjb.8.1681250309751;
        Tue, 11 Apr 2023 14:58:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id r21-20020a17090aa09500b00246774a9addsm51868pjp.48.2023.04.11.14.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 14:58:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmM0P-002FrW-Lq; Wed, 12 Apr 2023 07:58:25 +1000
Date:   Wed, 12 Apr 2023 07:58:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <20230411215825.GA3223426@dread.disaster.area>
References: <20230411010638.GF360889@frogsfrogsfrogs>
 <20230411032035.GZ3223426@dread.disaster.area>
 <20230411041858.GB360895@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411041858.GB360895@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2023 at 09:18:58PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 11, 2023 at 01:20:35PM +1000, Dave Chinner wrote:
> > On Mon, Apr 10, 2023 at 06:06:38PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > While fuzzing the data fork extent count on a btree-format directory
> > > with xfs/375, I observed the following (excerpted) splat:

....

> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 34de6e6898c4..5f96e7ce7b4a 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -1171,6 +1171,8 @@ xfs_iread_extents(
> > >  		goto out;
> > >  	}
> > >  	ASSERT(ir.loaded == xfs_iext_count(ifp));
> > > +	smp_mb();
> > > +	ifp->if_needextents = 0;
> > 
> > Hmmm - if this is to ensure that everything above is completed
> > before the clearing of this flag is visible everywhere else, then we
> > should be able to use load_acquire/store_release semantics? i.e. the
> > above is
> > 
> > 	smp_store_release(ifp->if_needextents, 0);
> > 
> > and we use
> > 
> > 	smp_load_acquire(ifp->if_needextents)
> > 
> > when we need to read the value to ensure that all the changes made
> > before the relevant stores are also visible?
> 
> I think we can; see below.
> 
> > >  	return 0;
> > >  out:
> > >  	xfs_iext_destroy(ifp);
> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > > index 6b21760184d9..eadae924dc42 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > > @@ -174,6 +174,8 @@ xfs_iformat_btree(
> > >  	int			level;
> > >  
> > >  	ifp = xfs_ifork_ptr(ip, whichfork);
> > > +	ifp->if_needextents = 1;
> > 
> > Hmmm - what's the guarantee that the reader will see ifp->if_format
> > set correctly if they if_needextents = 1?
> 
> At this point in the iget miss path, the only thread that can see the
> xfs_inode object is the one currently running the miss path.  I think
> the spin_lock call to add the inode to the radix tree is sufficient to
> guarantee that both if_format and if_needextents are set consistently
> when any other thread gains the ability to find the inode in the radix
> tree.
> 
> That said, smp_store_release/smp_load_acquire would make that more
> explicit.
> 
> How will we port this to userspace libxfs?

Add liburcu support. This brings across all the kernel side atomic
operations and memory model support, along with RCU. Basically, we
can then use the kernel side concurrency algorithms with almost no
change to the libxfs userspace at all...

See:

https://github.com/urcu/userspace-rcu/blob/master/include/urcu/arch/x86.h

Then we can just add two line wrappers that use cmm_rmb() and
cmm_wmb() to provide store_release/load_acquire semantics to the
required operations...

I've attached the bitrotted patch I have from the old xfs_buf port
to userspace I have sitting around. That series has other
libxfs implementations of various kernel concurrency APIs, too...

> > Wouldn't it be better to set this at the same time we set the
> > ifp->if_format value? We clear it unconditionally above in
> > xfs_iread_extents(), so why not set it unconditionally there, too,
> > before we start. i.e.
> > 
> > 	/*
> > 	 * Set the format before we set needsextents with release
> > 	 * semantics. This ensures that we can use acquire semantics
> > 	 * on needextents in xfs_need_iread_extents() and be
> > 	 * guaranteed to see a valid format value after that load.
> > 	 */
> > 	ifp->if_format = dip->di_format;
> > 	smp_store_release(ifp->if_needextents, 1);
> > 
> > That then means xfs_need_iread_extents() is guaranteed to see a
> > valid ifp->if_format if ifp->if_needextents is set if we do:
> 
> I think we should be smp_stor'ing needextents as appropriate for
> if_format, so that...
> 
> > /* returns true if the fork has extents but they are not read in yet. */
> > static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
> > {
> > 
> > 	/* see xfs_iread_extents() for needextents semantics */
> > 	return smp_load_acquire(ifp->if_needextents) &&
> > 			ifp->if_format == XFS_DINODE_FMT_BTREE;
> 
> ...then we don't need this FMT_BTREE check at all anymore.

Yup, as Christoph also pointed out. That definitely simplifies
things. :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfsprogs: introduce liburcu support

From: Dave Chinner <dchinner@redhat.com>

The upcoming buffer cache rework/kerenl sync-up requires atomic
variables. I could use C++11 atomics build into GCC, but they are a
pain to work with and shoe-horn into the kernel atomic variable API.

Much easier is to introduce a dependency on liburcu - the userspace
RCU library. This provides atomic variables that very closely match
the kernel atomic variable API, and it provides a very similar
memory model and memory barrier support to the kernel. And we get
RCU support that has an identical interface to the kernel and works
the same way.

Hence kernel code written with RCU algorithms and atomic variables
will just slot straight into the userspace xfsprogs code without us
having to think about whether the lockless algorithms will work in
userspace or not. This reduces glue and hoop jumping, and gets us
a step closer to having the entire userspace libxfs code MT safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 configure.ac               |  3 +++
 copy/Makefile              |  3 ++-
 copy/xfs_copy.c            |  3 +++
 db/Makefile                |  3 ++-
 debian/control             |  2 +-
 growfs/Makefile            |  3 ++-
 include/builddefs.in       |  4 +++-
 include/platform_defs.h.in |  1 +
 libfrog/workqueue.c        |  3 +++
 libxfs/init.c              |  3 +++
 libxfs/libxfs_priv.h       |  3 +--
 logprint/Makefile          |  3 ++-
 m4/Makefile                |  1 +
 m4/package_urcu.m4         | 22 ++++++++++++++++++++++
 mdrestore/Makefile         |  3 ++-
 mkfs/Makefile              |  2 +-
 repair/Makefile            |  2 +-
 repair/prefetch.c          |  9 +++++++--
 repair/progress.c          |  4 +++-
 scrub/Makefile             |  3 ++-
 scrub/progress.c           |  2 ++
 21 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5687174515d9..9725a4ff177a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,6 +154,9 @@ AC_PACKAGE_NEED_UUIDCOMPARE
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_NEED_URCU_H
+AC_PACKAGE_NEED_RCU_INIT
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
diff --git a/copy/Makefile b/copy/Makefile
index 449b235fad40..1b00cd0d5743 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_copy
 CFILES = xfs_copy.c
 HFILES = xfs_copy.h
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fc7d225fe6a2..f5eff96976d7 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -110,6 +110,7 @@ do_message(int flags, int code, const char *fmt, ...)
 		fprintf(stderr,
 			_("Aborting XFS copy -- logfile error -- reason: %s\n"),
 			strerror(errno));
+		rcu_unregister_thread();
 		pthread_exit(NULL);
 	}
 }
@@ -224,6 +225,7 @@ begin_reader(void *arg)
 {
 	thread_args	*args = arg;
 
+	rcu_register_thread();
 	for (;;) {
 		pthread_mutex_lock(&args->wait);
 		if (do_write(args, NULL))
@@ -243,6 +245,7 @@ handle_error:
 	if (--glob_masks.num_working == 0)
 		pthread_mutex_unlock(&mainwait);
 	pthread_mutex_unlock(&glob_masks.mutex);
+	rcu_unregister_thread();
 	pthread_exit(NULL);
 	return NULL;
 }
diff --git a/db/Makefile b/db/Makefile
index beafb1058269..5c017898289b 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -18,7 +18,8 @@ CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
diff --git a/debian/control b/debian/control
index e4ec897cc488..71c0816753b4 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
-Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
+Build-Depends: libinih-dev (>= 53), uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
diff --git a/growfs/Makefile b/growfs/Makefile
index a107d348ab6d..08601de77ab3 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_growfs
 
 CFILES = xfs_growfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
diff --git a/include/builddefs.in b/include/builddefs.in
index e8f447f92baf..78eddf4a9852 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -22,6 +22,7 @@ LDFLAGS =
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
+LIBURCU = @liburcu@
 LIBPTHREAD = @libpthread@
 LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
@@ -125,7 +126,8 @@ CROND_DIR = @crond_dir@
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
-PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
+# _LGPL_SOURCE is for liburcu to work correctly with GPL/LGPL programs
+PCFLAGS = -D_LGPL_SOURCE -D_GNU_SOURCE $(GCCFLAGS)
 ifeq ($(HAVE_UMODE_T),yes)
 PCFLAGS += -DHAVE_UMODE_T
 endif
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 539bdbecf6e0..7c6b3ada0bb4 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -23,6 +23,7 @@
 #include <limits.h>
 #include <stdbool.h>
 #include <libgen.h>
+#include <urcu.h>
 
 typedef struct filldir		filldir_t;
 
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 8c1a163e145f..702a53e2f3c0 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <errno.h>
 #include <assert.h>
+#include <urcu.h>
 #include "workqueue.h"
 
 /* Main processing thread */
@@ -24,6 +25,7 @@ workqueue_thread(void *arg)
 	 * Loop pulling work from the passed in work queue.
 	 * Check for notification to exit after every chunk of work.
 	 */
+	rcu_register_thread();
 	while (1) {
 		pthread_mutex_lock(&wq->lock);
 
@@ -60,6 +62,7 @@ workqueue_thread(void *arg)
 		(wi->function)(wi->queue, wi->index, wi->arg);
 		free(wi);
 	}
+	rcu_unregister_thread();
 
 	return NULL;
 }
diff --git a/libxfs/init.c b/libxfs/init.c
index 1ec837911df7..b06faf8acdde 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -310,6 +310,8 @@ libxfs_init(libxfs_init_t *a)
 	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
 
+	rcu_init();
+	rcu_register_thread();
 	radix_tree_init();
 
 	if (a->volname) {
@@ -1023,6 +1025,7 @@ libxfs_destroy(
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
 	leaked = destroy_zones();
+	rcu_unregister_thread();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
 		exit(1);
 }
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7181a8589312..db90e173f36e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -210,8 +210,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
-#define rcu_read_lock()		((void) 0)
-#define rcu_read_unlock()	((void) 0)
+
 /* Need to be able to handle this bare or in control flow */
 static inline bool WARN_ON(bool expr) {
 	return (expr);
diff --git a/logprint/Makefile b/logprint/Makefile
index 758504b39f0f..cdedbd0dbe82 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -12,7 +12,8 @@ CFILES = logprint.c \
 	 log_copy.c log_dump.c log_misc.c \
 	 log_print_all.c log_print_trans.c log_redo.c
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/m4/Makefile b/m4/Makefile
index c6c73dc9bbee..7312053039f4 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -24,6 +24,7 @@ LSRCFILES = \
 	package_services.m4 \
 	package_types.m4 \
 	package_icu.m4 \
+	package_urcu.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	multilib.m4 \
diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
new file mode 100644
index 000000000000..9b0dee35d9a1
--- /dev/null
+++ b/m4/package_urcu.m4
@@ -0,0 +1,22 @@
+AC_DEFUN([AC_PACKAGE_NEED_URCU_H],
+  [ AC_CHECK_HEADERS(urcu.h)
+    if test $ac_cv_header_urcu_h = no; then
+	AC_CHECK_HEADERS(urcu.h,, [
+	echo
+	echo 'FATAL ERROR: could not find a valid urcu header.'
+	exit 1])
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
+  [ AC_MSG_CHECKING([for liburcu])
+    AC_TRY_COMPILE([
+#define _GNU_SOURCE
+#include <urcu.h>
+    ], [
+	rcu_init();
+    ],	liburcu=-lurcu
+	AC_MSG_RESULT(yes),
+	AC_MSG_RESULT(no))
+    AC_SUBST(liburcu)
+  ])
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index d946955b0517..8f28ddab326b 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -8,7 +8,8 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_mdrestore
 CFILES = xfs_mdrestore.c
 
-LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
+LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/mkfs/Makefile b/mkfs/Makefile
index b8805f7e1ea1..811ba9dbe29b 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,7 +11,7 @@ HFILES =
 CFILES = proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
-	$(LIBUUID) $(LIBINIH)
+	$(LIBUUID) $(LIBINIH) $(LIBURCU)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/Makefile b/repair/Makefile
index 5f0764d1c3cd..47536ca1cc11 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -72,7 +72,7 @@ CFILES = \
 	xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
-	$(LIBPTHREAD) $(LIBBLKID)
+	$(LIBPTHREAD) $(LIBBLKID) $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 48affa1869f8..22a0c0c902d9 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -660,6 +660,7 @@ pf_io_worker(
 	if (buf == NULL)
 		return NULL;
 
+	rcu_register_thread();
 	pthread_mutex_lock(&args->lock);
 	while (!args->queuing_done || !btree_is_empty(args->io_queue)) {
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
@@ -682,6 +683,7 @@ pf_io_worker(
 	free(buf);
 
 	pftrace("finished prefetch I/O for AG %d", args->agno);
+	rcu_unregister_thread();
 
 	return NULL;
 }
@@ -726,6 +728,8 @@ pf_queuing_worker(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	unsigned long long	cluster_mask;
 
+	rcu_register_thread();
+
 	cluster_mask = (1ULL << igeo->inodes_per_cluster) - 1;
 
 	for (i = 0; i < PF_THREAD_COUNT; i++) {
@@ -739,7 +743,7 @@ pf_queuing_worker(
 			args->io_threads[i] = 0;
 			if (i == 0) {
 				pf_skip_prefetch_thread(args);
-				return NULL;
+				goto out;
 			}
 			/*
 			 * since we have at least one I/O thread, use them for
@@ -779,7 +783,6 @@ pf_queuing_worker(
 			 * Start processing as well, in case everything so
 			 * far was already prefetched and the queue is empty.
 			 */
-			
 			pf_start_io_workers(args);
 			pf_start_processing(args);
 			sem_wait(&args->ra_count);
@@ -841,6 +844,8 @@ pf_queuing_worker(
 	if (next_args)
 		pf_create_prefetch_thread(next_args);
 
+out:
+	rcu_unregister_thread();
 	return NULL;
 }
 
diff --git a/repair/progress.c b/repair/progress.c
index e5a9c1efa822..f6c4d988444e 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -182,6 +182,7 @@ progress_rpt_thread (void *p)
 		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
 
 	running = 1;
+	rcu_register_thread();
 
 	/*
 	 * Specify a repeating timer that fires each MSG_INTERVAL seconds.
@@ -286,7 +287,8 @@ progress_rpt_thread (void *p)
 		do_warn(_("cannot delete timer\n"));
 
 	free (msgbuf);
-	return (NULL);
+	rcu_unregister_thread();
+	return NULL;
 }
 
 int
diff --git a/scrub/Makefile b/scrub/Makefile
index 47c887eb79a1..849e3afd5af3 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -71,7 +71,8 @@ spacemap.c \
 vfs.c \
 xfs_scrub.c
 
-LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT)
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT) \
+	$(LIBURCU)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/scrub/progress.c b/scrub/progress.c
index 15247b7c6d1b..a3d096f98e2c 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -116,6 +116,7 @@ progress_report_thread(void *arg)
 	struct timespec		abstime;
 	int			ret;
 
+	rcu_register_thread();
 	pthread_mutex_lock(&pt.lock);
 	while (1) {
 		uint64_t	progress_val;
@@ -139,6 +140,7 @@ progress_report_thread(void *arg)
 			progress_report(progress_val);
 	}
 	pthread_mutex_unlock(&pt.lock);
+	rcu_unregister_thread();
 	return NULL;
 }
 
