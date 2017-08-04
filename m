Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33584 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:07 -0400
Subject: [PATCH 04/22] xfs_scrub: dispatch the various phases of the scrub
 program
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:01 -0700
Message-ID: <150180528117.18784.5739258011575292076.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create the dispatching routines that we'll use to call out to each
separate phase of the program.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    1 
 include/builddefs.in  |    1 
 m4/package_libcdev.m4 |   18 +++
 scrub/Makefile        |    4 +
 scrub/common.c        |   63 +++++++++++
 scrub/common.h        |    4 +
 scrub/scrub.c         |  271 +++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 362 insertions(+)


diff --git a/configure.ac b/configure.ac
index d5f072a..e7ea99e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -143,6 +143,7 @@ AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_HAVE_GETFSMAP
+AC_HAVE_MALLINFO
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index ec630bd..c178556 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -113,6 +113,7 @@ HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 HAVE_GETFSMAP = @have_getfsmap@
+HAVE_MALLINFO = @have_mallinfo@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index fa5b639..3ccdea5 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -297,3 +297,21 @@ AC_DEFUN([AC_HAVE_GETFSMAP],
        AC_MSG_RESULT(no))
     AC_SUBST(have_getfsmap)
   ])
+
+#
+# Check if we have a mallinfo libc call
+#
+AC_DEFUN([AC_HAVE_MALLINFO],
+  [ AC_MSG_CHECKING([for mallinfo ])
+    AC_TRY_COMPILE([
+#include <malloc.h>
+    ], [
+         struct mallinfo test;
+
+         test.arena = 0; test.hblkhd = 0; test.uordblks = 0; test.fordblks = 0;
+         test = mallinfo();
+    ], have_mallinfo=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_mallinfo)
+  ])
diff --git a/scrub/Makefile b/scrub/Makefile
index 90a1c47..6134fe9 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -27,6 +27,10 @@ LLDLIBS += $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
 LTDEPENDENCIES += $(LIBXCMD) $(LIBHANDLE)
 LLDFLAGS = -static
 
+ifeq ($(HAVE_MALLINFO),yes)
+LCFLAGS += -DHAVE_MALLINFO
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/scrub/common.c b/scrub/common.c
index 4e47332..86e92ed 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -168,3 +168,66 @@ do_error(char const *msg, ...)
 		abort();
 	exit(1);
 }
+
+double
+timeval_subtract(
+	struct timeval		*tv1,
+	struct timeval		*tv2)
+{
+	return ((tv1->tv_sec - tv2->tv_sec) +
+		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
+}
+
+/* Produce human readable disk space output. */
+double
+auto_space_units(
+	unsigned long long	bytes,
+	char			**units)
+{
+	if (debug > 1)
+		goto no_prefix;
+	if (bytes > (1ULL << 40)) {
+		*units = "TiB";
+		return (double)bytes / (1ULL << 40);
+	} else if (bytes > (1ULL << 30)) {
+		*units = "GiB";
+		return (double)bytes / (1ULL << 30);
+	} else if (bytes > (1ULL << 20)) {
+		*units = "MiB";
+		return (double)bytes / (1ULL << 20);
+	} else if (bytes > (1ULL << 10)) {
+		*units = "KiB";
+		return (double)bytes / (1ULL << 10);
+	}
+
+no_prefix:
+	*units = "B";
+	return bytes;
+}
+
+/* Produce human readable discrete number output. */
+double
+auto_units(
+	unsigned long long	number,
+	char			**units)
+{
+	if (debug > 1)
+		goto no_prefix;
+	if (number > 1000000000000ULL) {
+		*units = "T";
+		return number / 1000000000000.0;
+	} else if (number > 1000000000ULL) {
+		*units = "G";
+		return number / 1000000000.0;
+	} else if (number > 1000000ULL) {
+		*units = "M";
+		return number / 1000000.0;
+	} else if (number > 1000ULL) {
+		*units = "K";
+		return number / 1000.0;
+	}
+
+no_prefix:
+	*units = "";
+	return number;
+}
diff --git a/scrub/common.h b/scrub/common.h
index b601680..70a3b9d 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -56,4 +56,8 @@ debug_tweak_on(
 	return debug && getenv(name) != NULL;
 }
 
+double timeval_subtract(struct timeval *tv1, struct timeval *tv2);
+double auto_space_units(unsigned long long kilobytes, char **units);
+double auto_units(unsigned long long number, char **units);
+
 #endif /* XFS_SCRUB_COMMON_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 2b620bf..cb3d5f4 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -161,6 +161,265 @@ usage(void)
 	exit(16);
 }
 
+#ifndef RUSAGE_BOTH
+# define RUSAGE_BOTH		(-2)
+#endif
+
+/* Get resource usage for ourselves and all children. */
+static int
+scrub_getrusage(
+	struct rusage		*usage)
+{
+	struct rusage		cusage;
+	int			err;
+
+	err = getrusage(RUSAGE_BOTH, usage);
+	if (!err)
+		return err;
+
+	err = getrusage(RUSAGE_SELF, usage);
+	if (err)
+		return err;
+
+	err = getrusage(RUSAGE_CHILDREN, &cusage);
+	if (err)
+		return err;
+
+	usage->ru_minflt += cusage.ru_minflt;
+	usage->ru_majflt += cusage.ru_majflt;
+	usage->ru_nswap += cusage.ru_nswap;
+	usage->ru_inblock += cusage.ru_inblock;
+	usage->ru_oublock += cusage.ru_oublock;
+	usage->ru_msgsnd += cusage.ru_msgsnd;
+	usage->ru_msgrcv += cusage.ru_msgrcv;
+	usage->ru_nsignals += cusage.ru_nsignals;
+	usage->ru_nvcsw += cusage.ru_nvcsw;
+	usage->ru_nivcsw += cusage.ru_nivcsw;
+	return 0;
+}
+
+/*
+ * Scrub Phase Dispatch
+ *
+ * The operations of the scrub program are split up into several
+ * different phases.  Each phase builds upon the metadata checked in the
+ * previous phase, which is to say that we may skip phase (X + 1) if our
+ * scans in phase (X) reveal corruption.  A phase may be skipped
+ * entirely.
+ */
+
+/* Resource usage for each phase. */
+struct phase_rusage {
+	struct rusage		ruse;
+	struct timeval		time;
+	unsigned long long	verified_bytes;
+	void			*brk_start;
+	const char		*descr;
+};
+
+/* Operations for each phase. */
+#define DATASCAN_DUMMY_FN	((void *)1)
+#define REPAIR_DUMMY_FN		((void *)2)
+struct phase_ops {
+	char		*descr;
+	bool		(*fn)(struct scrub_ctx *);
+	bool		must_run;
+};
+
+/* Start tracking resource usage for a phase. */
+static bool
+phase_start(
+	struct phase_rusage	*pi,
+	unsigned int		phase,
+	const char		*descr)
+{
+	int			error;
+
+	error = scrub_getrusage(&pi->ruse);
+	if (error) {
+		perror(_("getrusage"));
+		return false;
+	}
+	pi->brk_start = sbrk(0);
+
+	error = gettimeofday(&pi->time, NULL);
+	if (error) {
+		perror(_("gettimeofday"));
+		return false;
+	}
+
+	pi->descr = descr;
+	if ((verbose || display_rusage) && descr) {
+		fprintf(stdout, _("Phase %u: %s\n"), phase, descr);
+		fflush(stdout);
+	}
+	return true;
+}
+
+/* Report usage stats. */
+static bool
+phase_end(
+	struct phase_rusage	*pi,
+	unsigned int		phase)
+{
+	struct rusage		ruse_now;
+#ifdef HAVE_MALLINFO
+	struct mallinfo		mall_now;
+#endif
+	struct timeval		time_now;
+	char			phasebuf[DESCR_BUFSZ];
+	double			dt;
+	long			in, out;
+	long			io;
+	double			i, o, t;
+	double			din, dout, dtot;
+	char			*iu, *ou, *tu, *dinu, *doutu, *dtotu;
+	int			error;
+
+	if (!display_rusage)
+		return true;
+
+	error = gettimeofday(&time_now, NULL);
+	if (error) {
+		perror(_("gettimeofday"));
+		return false;
+	}
+	dt = timeval_subtract(&time_now, &pi->time);
+
+	error = scrub_getrusage(&ruse_now);
+	if (error) {
+		perror(_("getrusage"));
+		return false;
+	}
+
+	if (phase)
+		snprintf(phasebuf, DESCR_BUFSZ, _("Phase %u: "), phase);
+	else
+		phasebuf[0] = 0;
+
+#define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
+#ifdef HAVE_MALLINFO
+
+	mall_now = mallinfo();
+	fprintf(stdout, _("%sMemory used: %luk/%luk (%luk/%luk), "),
+		phasebuf,
+		kbytes(mall_now.arena), kbytes(mall_now.hblkhd),
+		kbytes(mall_now.uordblks), kbytes(mall_now.fordblks));
+#else
+	fprintf(stdout, _("%sMemory used: %luk, "),
+		phasebuf,
+		(unsigned long) kbytes(((char *) sbrk(0)) -
+				       ((char *) pi->brk_start)));
+#endif
+#undef kbytes
+
+	fprintf(stdout, _("time: %5.2f/%5.2f/%5.2fs\n"),
+		timeval_subtract(&time_now, &pi->time),
+		timeval_subtract(&ruse_now.ru_utime, &pi->ruse.ru_utime),
+		timeval_subtract(&ruse_now.ru_stime, &pi->ruse.ru_stime));
+
+	/* I/O usage */
+	in =  (ruse_now.ru_inblock - pi->ruse.ru_inblock) << BBSHIFT;
+	out = (ruse_now.ru_oublock - pi->ruse.ru_oublock) << BBSHIFT;
+	io = in + out;
+	if (io) {
+		i = auto_space_units(in, &iu);
+		o = auto_space_units(out, &ou);
+		t = auto_space_units(io, &tu);
+		din = auto_space_units(in / dt, &dinu);
+		dout = auto_space_units(out / dt, &doutu);
+		dtot = auto_space_units(io / dt, &dtotu);
+		fprintf(stdout,
+_("%sI/O: %.1f%s in, %.1f%s out, %.1f%s tot\n"),
+			phasebuf, i, iu, o, ou, t, tu);
+		fprintf(stdout,
+_("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
+			phasebuf, din, dinu, dout, doutu, dtot, dtotu);
+	}
+	fflush(stdout);
+
+	return true;
+}
+
+/* Run all the phases of the scrubber. */
+static bool
+run_scrub_phases(
+	struct scrub_ctx	*ctx)
+{
+	struct phase_ops phases[] =
+	{
+		{
+			.descr = _("Find filesystem geometry."),
+			.must_run = true,
+		},
+		{
+			.descr = _("Check internal metadata."),
+		},
+		{
+			.descr = _("Scan all inodes."),
+		},
+		{
+			.descr = _("Defer filesystem repairs."),
+			.fn = REPAIR_DUMMY_FN,
+		},
+		{
+			.descr = _("Check directory tree."),
+		},
+		{
+			.descr = _("Verify data file integrity."),
+			.fn = DATASCAN_DUMMY_FN,
+		},
+		{
+			.descr = _("Check summary counters."),
+		},
+		{
+			NULL
+		},
+	};
+	struct phase_rusage	pi;
+	struct phase_ops	*sp;
+	bool			moveon = true;
+	unsigned int		debug_phase = 0;
+	unsigned int		phase;
+
+	if (debug && debug_tweak_on("XFS_SCRUB_PHASE"))
+		debug_phase = atoi(getenv("XFS_SCRUB_PHASE"));
+
+	/* Run all phases of the scrub tool. */
+	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
+		/* Skip certain phases unless they're turned on. */
+		if (sp->fn == REPAIR_DUMMY_FN ||
+		    sp->fn == DATASCAN_DUMMY_FN)
+			continue;
+
+		/* Allow debug users to force a particular phase. */
+		if (debug_phase && phase != debug_phase && !sp->must_run)
+			continue;
+
+		/* Run this phase. */
+		moveon = phase_start(&pi, phase, sp->descr);
+		if (!moveon)
+			break;
+		moveon = sp->fn(ctx);
+		if (!moveon) {
+			str_info(ctx, ctx->mntpoint,
+_("Scrub aborted after phase %d."),
+					phase);
+			break;
+		}
+		moveon = phase_end(&pi, phase);
+		if (!moveon)
+			break;
+
+		/* Too many errors? */
+		moveon = !xfs_scrub_excessive_errors(ctx);
+		if (!moveon)
+			break;
+	}
+
+	return moveon;
+}
+
 int
 main(
 	int			argc,
@@ -169,6 +428,7 @@ main(
 	int			c;
 	char			*mtab = NULL;
 	struct scrub_ctx	ctx = {0};
+	struct phase_rusage	all_pi;
 	unsigned long long	total_errors;
 	bool			moveon = true;
 	static bool		injected;
@@ -281,6 +541,11 @@ _("Only one of the options -n or -y may be specified.\n"));
 			mtab = _PATH_MOUNTED;
 	}
 
+	/* Initialize overall phase stats. */
+	moveon = phase_start(&all_pi, 0, NULL);
+	if (!moveon)
+		goto out;
+
 	/* How many CPUs? */
 	nproc = sysconf(_SC_NPROCESSORS_ONLN);
 	if (nproc < 0)
@@ -298,6 +563,11 @@ _("Only one of the options -n or -y may be specified.\n"));
 		injected = true;
 	}
 
+	/* Scrub a filesystem. */
+	moveon = run_scrub_phases(&ctx);
+	if (!moveon)
+		goto out;
+
 out:
 	if (xfs_scrub_excessive_errors(&ctx))
 		str_info(&ctx, ctx.mntpoint, _("Too many errors; aborting."));
@@ -328,6 +598,7 @@ _("%s: %llu warnings found.\n"),
 		ret |= 2;
 	if (ctx.runtime_errors)
 		ret |= 4;
+	phase_end(&all_pi, 0);
 
 	free(ctx.blkdev);
 	free(ctx.mntpoint);

