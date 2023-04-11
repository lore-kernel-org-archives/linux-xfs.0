Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F82BC77B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDKSOB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjDKSOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:14:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB13310DF;
        Tue, 11 Apr 2023 11:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66FFC62042;
        Tue, 11 Apr 2023 18:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A2DC433EF;
        Tue, 11 Apr 2023 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681236838;
        bh=eW/UEk4k+q6PVtPHGGWy4RlyWvC/CsQTrE3pdYTqcz0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nb7XpJL90gG8oYLfItvXhL3WgjzK9I/10pTeIQZ9x311tdaf2WiJFfqLR8Zk1lw0p
         ZQ2NBGNDVA8lC6Anr7riMM5kvNymFkPeQWaYotFtORXaLDkqY2XCNptC6kWM6gN8jb
         KM4FeolRt4m0Ej9fnvwOecYAHQcgO4qO4QTtSLSVZJ8/LA3wCcOmWkWiEcZR2lwaoc
         6EuE4gnCi/zPZXWfiGZcbO69OrKIQddZaa1Bqo6/D4vLhs0vVDpjW9rlGOx4Qb59Ko
         1IEx+aFY6RdqUAy2x4ElK/q8Tc07gUOwcWCuTnz1THuZ6Uejtt75BxUeNOAYt4tx1C
         Fsi+9DHQimrHg==
Subject: [PATCH 2/3] misc: add duration for long soak tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Apr 2023 11:13:58 -0700
Message-ID: <168123683823.4086541.4438928240640523731.stgit@frogsfrogsfrogs>
In-Reply-To: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that test runners can schedule long soak stress test programs
for an exact number of seconds by setting the STRESS_DURATION config
variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check                 |   14 +++++++++
 common/config         |    7 ++++
 common/fuzzy          |    7 ++++
 common/report         |    1 +
 ltp/fsstress.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++--
 ltp/fsx.c             |   50 +++++++++++++++++++++++++++++++
 src/soak_duration.awk |   23 ++++++++++++++
 tests/generic/476     |    5 +++
 tests/generic/521     |    1 +
 tests/generic/522     |    1 +
 tests/generic/642     |    1 +
 11 files changed, 182 insertions(+), 6 deletions(-)
 create mode 100644 src/soak_duration.awk


diff --git a/check b/check
index 1a58a2b269..b065277287 100755
--- a/check
+++ b/check
@@ -366,6 +366,20 @@ if ! . ./common/rc; then
 	exit 1
 fi
 
+# If the test config specified a soak test duration, see if there are any
+# unit suffixes that need converting to an integer seconds count.
+if [ -n "$SOAK_DURATION" ]; then
+	SOAK_DURATION="$(echo "$SOAK_DURATION" | \
+		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
+		$AWK_PROG -f $here/src/soak_duration.awk)"
+	if [ $? -ne 0 ]; then
+		echo "$SOAK_DURATION"
+		status=1
+		exit 1
+	fi
+	export SOAK_DURATION
+fi
+
 if [ -n "$subdir_xfile" ]; then
 	for d in $SRC_GROUPS $FSTYP; do
 		[ -f $SRC_DIR/$d/$subdir_xfile ] || continue
diff --git a/common/config b/common/config
index 6c8cb3a5ba..fdd0aadbeb 100644
--- a/common/config
+++ b/common/config
@@ -57,6 +57,13 @@ export SOAK_PROC=3             # -p option to fsstress
 export SOAK_STRESS=10000       # -n option to fsstress
 export SOAK_PASSES=-1          # count of repetitions of fsstress (while soaking)
 export EMAIL=root@localhost    # where auto-qa will send its status messages
+
+# For certain tests that run in tight loops, setting this variable allows the
+# test runner to specify exactly how long the test should continue looping.
+# This is independent of TIME_FACTOR.  Floating point numbers are allowed, and
+# the unit suffixes m(inutes), h(ours), d(ays), and w(eeks) are supported.
+export SOAK_DURATION=${SOAK_DURATION:=}
+
 export HOST_OPTIONS=${HOST_OPTIONS:=local.config}
 export CHECK_OPTIONS=${CHECK_OPTIONS:="-g auto"}
 export BENCH_PASSES=${BENCH_PASSES:=5}
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
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index e60f2da929..0dc6545448 100644
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
+	printf("   --duration=s     run for this many seconds\n");
 }
 
 void
diff --git a/ltp/fsx.c b/ltp/fsx.c
index ee4b8fe45d..761d5e467f 100644
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
+	--duration=seconds: run for this many seconds\n\
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
index edb0be7b50..a162cda6b1 100755
--- a/tests/generic/476
+++ b/tests/generic/476
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
 

