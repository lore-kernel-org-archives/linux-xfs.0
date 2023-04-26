Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B85C77B7F
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Apr 2023 00:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbjDZAOj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Apr 2023 20:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjDZAOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2023 20:14:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652228A73;
        Tue, 25 Apr 2023 17:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAD6360C2B;
        Wed, 26 Apr 2023 00:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527BFC433D2;
        Wed, 26 Apr 2023 00:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682468075;
        bh=xWc7uWYVrYC0yA1/ZMUmMB36dhWBiGBNFdvpHcuqyCw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZEHNFeBEMrISi35LeBx5SWkymXiyFlQISrMwf6pzjjTxWnYRiSe9sTFbRLjZhxcNk
         9JdSwJEIrxpikJohxDl5pHeF/JLw+uvA+2gdxbe2jgj3KZVuyD2V6V+ZXzFoFK2Orp
         ro0X8PLwlYdFZBheB0ce3vXL+l4yIHqTd/IIV3JSxsd16LsMHh1S5wKqihUYyB87J7
         v3rzDVUZhxXZAew0FPbtWKZke70jFNOetsbnr8FEH7Tq66xoklISGBhOUzsyr2s1Y0
         s9Kx5E89yfZrANe1E3byndLi6icr6qVgk0JFGtUPIMErv7/F0zclGZNNE+60X/CjoO
         Vh2OpSUbk1SkA==
Subject: [PATCH 3/4] misc: add duration for long soak tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Apr 2023 17:14:34 -0700
Message-ID: <168246807490.732186.2632021184514655054.stgit@frogsfrogsfrogs>
In-Reply-To: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
References: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that test runners can schedule long soak stress test programs
for an exact number of seconds by setting the SOAK_DURATION config
variable.  Change the definition of the 'soak' test to specify that
these tests can be controlled via SOAK_DURATION.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 README                |    5 +++
 check                 |   12 ++++++++
 common/config         |    2 +
 common/fuzzy          |    7 ++++
 common/report         |    1 +
 doc/group-names.txt   |    3 +-
 ltp/fsstress.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++--
 ltp/fsx.c             |   50 +++++++++++++++++++++++++++++++
 src/soak_duration.awk |   23 ++++++++++++++
 tests/generic/476     |    7 +++-
 tests/generic/521     |    1 +
 tests/generic/522     |    1 +
 tests/generic/642     |    1 +
 13 files changed, 183 insertions(+), 8 deletions(-)
 create mode 100644 src/soak_duration.awk


diff --git a/README b/README
index 030b47d92a..fd3b123633 100644
--- a/README
+++ b/README
@@ -255,6 +255,11 @@ Test control:
    load applied to the system during a test by the specified multiple.
  - Set TIME_FACTOR to a nonzero positive integer to increase the amount of
    time that a test runs by the specified multiple.
+ - For tests that are a member of the "soak" group, setting SOAK_DURATION
+   allows the test runner to specify exactly how long the test should continue
+   running.  This setting overrides TIME_FACTOR.  Floating point numbers are
+   allowed, and the unit suffixes m(inutes), h(ours), d(ays), and w(eeks) are
+   supported.
 
 Misc:
  - If you wish to disable UDF verification test set the environment variable
diff --git a/check b/check
index 1a58a2b269..3aee66f08a 100755
--- a/check
+++ b/check
@@ -366,6 +366,18 @@ if ! . ./common/rc; then
 	exit 1
 fi
 
+# If the test config specified a soak test duration, see if there are any
+# unit suffixes that need converting to an integer seconds count.
+if [ -n "$SOAK_DURATION" ]; then
+	SOAK_DURATION="$(echo "$SOAK_DURATION" | \
+		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
+		$AWK_PROG -f $here/src/soak_duration.awk)"
+	if [ $? -ne 0 ]; then
+		status=1
+		exit 1
+	fi
+fi
+
 if [ -n "$subdir_xfile" ]; then
 	for d in $SRC_GROUPS $FSTYP; do
 		[ -f $SRC_DIR/$d/$subdir_xfile ] || continue
diff --git a/common/config b/common/config
index 6c8cb3a5ba..3878e28efa 100644
--- a/common/config
+++ b/common/config
@@ -57,11 +57,13 @@ export SOAK_PROC=3             # -p option to fsstress
 export SOAK_STRESS=10000       # -n option to fsstress
 export SOAK_PASSES=-1          # count of repetitions of fsstress (while soaking)
 export EMAIL=root@localhost    # where auto-qa will send its status messages
+
 export HOST_OPTIONS=${HOST_OPTIONS:=local.config}
 export CHECK_OPTIONS=${CHECK_OPTIONS:="-g auto"}
 export BENCH_PASSES=${BENCH_PASSES:=5}
 export TIME_FACTOR=${TIME_FACTOR:=1}
 export LOAD_FACTOR=${LOAD_FACTOR:=1}
+export SOAK_DURATION=${SOAK_DURATION:=}
 export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
 
 # some constants for overlayfs setup
diff --git a/common/fuzzy b/common/fuzzy
index 961bedc717..4365e7343e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1351,7 +1351,12 @@ _scratch_xfs_stress_scrub() {
 	fi
 
 	local start="$(date +%s)"
-	local end="$((start + (30 * TIME_FACTOR) ))"
+	local end
+	if [ -n "$SOAK_DURATION" ]; then
+		end="$((start + SOAK_DURATION))"
+	else
+		end="$((start + (30 * TIME_FACTOR) ))"
+	fi
 	local scrub_startat="$((start + scrub_delay))"
 	test "$scrub_startat" -gt "$((end - 10))" &&
 		scrub_startat="$((end - 10))"
diff --git a/common/report b/common/report
index be930e0b06..9bfa09ecce 100644
--- a/common/report
+++ b/common/report
@@ -67,6 +67,7 @@ __generate_report_vars() {
 	REPORT_VARS["CPUS"]="$(getconf _NPROCESSORS_ONLN 2>/dev/null)"
 	REPORT_VARS["MEM_KB"]="$(grep MemTotal: /proc/meminfo | awk '{print $2}')"
 	REPORT_VARS["SWAP_KB"]="$(grep SwapTotal: /proc/meminfo | awk '{print $2}')"
+	test -n "$SOAK_DURATION" && REPORT_VARS["SOAK_DURATION"]="$SOAK_DURATION"
 
 	test -e /sys/devices/system/node/possible && \
 		REPORT_VARS["NUMA_NODES"]="$(cat /sys/devices/system/node/possible 2>/dev/null)"
diff --git a/doc/group-names.txt b/doc/group-names.txt
index a0ae6965a8..5fd8fe6773 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -118,7 +118,8 @@ send			btrfs send/receive
 shrinkfs		decreasing the size of a filesystem
 shutdown		FS_IOC_SHUTDOWN ioctl
 snapshot		btrfs snapshots
-soak			long running soak tests of any kind
+soak			long running soak tests whose runtime can be controlled
+                        directly by setting the SOAK_DURATION variable
 spaceman		xfs_spaceman functional tests
 splice			splice system call
 stress			fsstress filesystem exerciser
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index e60f2da929..6641a525fe 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -386,6 +386,8 @@ char		*execute_cmd = NULL;
 int		execute_freq = 1;
 struct print_string	flag_str = {0};
 
+struct timespec deadline = { 0 };
+
 void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
 int	attr_list_path(pathname_t *, char *, const int);
@@ -459,6 +461,34 @@ void sg_handler(int signum)
 	}
 }
 
+bool
+keep_looping(int i, int loops)
+{
+	int ret;
+
+	if (deadline.tv_nsec) {
+		struct timespec now;
+
+		ret = clock_gettime(CLOCK_MONOTONIC, &now);
+		if (ret) {
+			perror("CLOCK_MONOTONIC");
+			return false;
+		}
+
+		return now.tv_sec <= deadline.tv_sec;
+	}
+
+	if (!loops)
+		return true;
+
+	return i < loops;
+}
+
+static struct option longopts[] = {
+	{"duration", optional_argument, 0, 256},
+	{ }
+};
+
 int main(int argc, char **argv)
 {
 	char		buf[10];
@@ -478,13 +508,14 @@ int main(int argc, char **argv)
 	struct sigaction action;
 	int		loops = 1;
 	const char	*allopts = "cd:e:f:i:l:m:M:n:o:p:rRs:S:vVwx:X:zH";
+	long long	duration;
 
 	errrange = errtag = 0;
 	umask(0);
 	nops = sizeof(ops) / sizeof(ops[0]);
 	ops_end = &ops[nops];
 	myprog = argv[0];
-	while ((c = getopt(argc, argv, allopts)) != -1) {
+	while ((c = getopt_long(argc, argv, allopts, longopts, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			cleanup = 1;
@@ -579,6 +610,26 @@ int main(int argc, char **argv)
 		case 'X':
 			execute_freq = strtoul(optarg, NULL, 0);
 			break;
+		case 256:  /* --duration */
+			if (!optarg) {
+				fprintf(stderr, "Specify time with --duration=\n");
+				exit(87);
+			}
+			duration = strtoll(optarg, NULL, 0);
+			if (duration < 1) {
+				fprintf(stderr, "%lld: invalid duration\n", duration);
+				exit(88);
+			}
+
+			i = clock_gettime(CLOCK_MONOTONIC, &deadline);
+			if (i) {
+				perror("CLOCK_MONOTONIC");
+				exit(89);
+			}
+
+			deadline.tv_sec += duration;
+			deadline.tv_nsec = 1;
+			break;
 		case '?':
 			fprintf(stderr, "%s - invalid parameters\n",
 				myprog);
@@ -721,7 +772,7 @@ int main(int argc, char **argv)
 				}
 			}
 #endif
-			for (i = 0; !loops || (i < loops); i++)
+			for (i = 0; keep_looping(i, loops); i++)
 				doproc();
 #ifdef AIO
 			if(io_destroy(io_ctx) != 0) {
@@ -1121,6 +1172,26 @@ dirid_to_fent(int dirid)
 	return NULL;
 }
 
+bool
+keep_running(opnum_t opno, opnum_t operations)
+{
+	int ret;
+
+	if (deadline.tv_nsec) {
+		struct timespec now;
+
+		ret = clock_gettime(CLOCK_MONOTONIC, &now);
+		if (ret) {
+			perror("CLOCK_MONOTONIC");
+			return false;
+		}
+
+		return now.tv_sec <= deadline.tv_sec;
+	}
+
+	return opno < operations;
+}
+
 void
 doproc(void)
 {
@@ -1149,7 +1220,7 @@ doproc(void)
 	srandom(seed);
 	if (namerand)
 		namerand = random();
-	for (opno = 0; opno < operations; opno++) {
+	for (opno = 0; keep_running(opno, operations); opno++) {
 		if (execute_cmd && opno && opno % dividend == 0) {
 			if (verbose)
 				printf("%lld: execute command %s\n", opno,
@@ -1935,6 +2006,7 @@ usage(void)
 	printf("   -V               specifies verifiable logging mode (omitting inode numbers)\n");
 	printf("   -X ncmd          number of calls to the -x command (default 1)\n");
 	printf("   -H               prints usage and exits\n");
+	printf("   --duration=s     ignore any -n setting and run for this many seconds\n");
 }
 
 void
diff --git a/ltp/fsx.c b/ltp/fsx.c
index ee4b8fe45d..c76b06ca76 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -193,6 +193,8 @@ int fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
 #define fsxread(a,b,c,d)	fsx_rw(READ, a,b,c,d)
 #define fsxwrite(a,b,c,d)	fsx_rw(WRITE, a,b,c,d)
 
+struct timespec deadline;
+
 const char *replayops = NULL;
 const char *recordops = NULL;
 FILE *	fsxlogf = NULL;
@@ -2457,6 +2459,7 @@ usage(void)
         -Z: O_DIRECT (use -R, -W, -r and -w too)\n\
 	--replay-ops opsfile: replay ops from recorded .fsxops file\n\
 	--record-ops[=opsfile]: dump ops file also on success. optionally specify ops file name\n\
+	--duration=seconds: ignore any -N setting and run for this many seconds\n\
 	fname: this filename is REQUIRED (no default)\n");
 	exit(90);
 }
@@ -2739,9 +2742,33 @@ __test_fallocate(int mode, const char *mode_str)
 #endif
 }
 
+bool
+keep_running(void)
+{
+	int ret;
+
+	if (deadline.tv_nsec) {
+		struct timespec now;
+
+		ret = clock_gettime(CLOCK_MONOTONIC, &now);
+		if (ret) {
+			perror("CLOCK_MONOTONIC");
+			return false;
+		}
+
+		return now.tv_sec <= deadline.tv_sec;
+	}
+
+	if (numops == -1)
+		return true;
+
+	return numops-- != 0;
+}
+
 static struct option longopts[] = {
 	{"replay-ops", required_argument, 0, 256},
 	{"record-ops", optional_argument, 0, 255},
+	{"duration", optional_argument, 0, 254},
 	{ }
 };
 
@@ -2753,6 +2780,7 @@ main(int argc, char **argv)
 	char logfile[PATH_MAX];
 	struct stat statbuf;
 	int o_flags = O_RDWR|O_CREAT|O_TRUNC;
+	long long duration;
 
 	logfile[0] = 0;
 	dname[0] = 0;
@@ -2950,6 +2978,26 @@ main(int argc, char **argv)
 			o_direct = O_DIRECT;
 			o_flags |= O_DIRECT;
 			break;
+		case 254:  /* --duration */
+			if (!optarg) {
+				fprintf(stderr, "Specify time with --duration=\n");
+				exit(87);
+			}
+			duration = strtoll(optarg, NULL, 0);
+			if (duration < 1) {
+				fprintf(stderr, "%lld: invalid duration\n", duration);
+				exit(88);
+			}
+
+			i = clock_gettime(CLOCK_MONOTONIC, &deadline);
+			if (i) {
+				perror("CLOCK_MONOTONIC");
+				exit(89);
+			}
+
+			deadline.tv_sec += duration;
+			deadline.tv_nsec = 1;
+			break;
 		case 255:  /* --record-ops */
 			if (optarg)
 				snprintf(opsfile, sizeof(opsfile), "%s", optarg);
@@ -3145,7 +3193,7 @@ main(int argc, char **argv)
 	if (xchg_range_calls)
 		xchg_range_calls = test_xchg_range();
 
-	while (numops == -1 || numops--)
+	while (keep_running())
 		if (!test())
 			break;
 
diff --git a/src/soak_duration.awk b/src/soak_duration.awk
new file mode 100644
index 0000000000..6c38d09b39
--- /dev/null
+++ b/src/soak_duration.awk
@@ -0,0 +1,23 @@
+#!/usr/bin/awk
+#
+# Convert time interval specifications with suffixes to an integer number of
+# seconds.
+{
+	nr = $1;
+	if ($2 == "" || $2 ~ /s/)	# seconds
+		;
+	else if ($2 ~ /m/)		# minutes
+		nr *= 60;
+	else if ($2 ~ /h/)		# hours
+		nr *= 3600;
+	else if ($2 ~ /d/)		# days
+		nr *= 86400;
+	else if ($2 ~ /w/)		# weeks
+		nr *= 604800;
+	else {
+		printf("%s: unknown suffix\n", $2);
+		exit 1;
+	}
+
+	printf("%d\n", nr);
+}
diff --git a/tests/generic/476 b/tests/generic/476
index 62908654ad..8e93b73457 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -8,7 +8,7 @@
 # bugs in the write path.
 #
 . ./common/preamble
-_begin_fstest auto rw long_rw stress
+_begin_fstest auto rw long_rw stress soak
 
 # Override the default cleanup function.
 _cleanup()
@@ -33,7 +33,10 @@ _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
 nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
-$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
+fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
+test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
+
+$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/generic/521 b/tests/generic/521
index cde9d44775..22dd31a8ec 100755
--- a/tests/generic/521
+++ b/tests/generic/521
@@ -35,6 +35,7 @@ fsx_args+=(-r $min_dio_sz)
 fsx_args+=(-t $min_dio_sz)
 fsx_args+=(-w $min_dio_sz)
 fsx_args+=(-Z)
+test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
 
 run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
 
diff --git a/tests/generic/522 b/tests/generic/522
index ae84fe04bb..f0cbcb245c 100755
--- a/tests/generic/522
+++ b/tests/generic/522
@@ -29,6 +29,7 @@ fsx_args+=(-N $nr_ops)
 fsx_args+=(-p $((nr_ops / 100)))
 fsx_args+=(-o $op_sz)
 fsx_args+=(-l $file_sz)
+test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
 
 run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
 
diff --git a/tests/generic/642 b/tests/generic/642
index c0e274d843..eba90903a3 100755
--- a/tests/generic/642
+++ b/tests/generic/642
@@ -49,6 +49,7 @@ for verb in attr_remove removefattr; do
 done
 args+=('-f' "setfattr=20")
 args+=('-f' "attr_set=60")	# sets larger xattrs
+test -n "$DURATION" && args+=(--duration="$DURATION")
 
 $FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
 

