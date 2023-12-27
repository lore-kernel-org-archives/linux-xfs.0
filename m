Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2C44A04;
	Mon,  1 Jan 2024 00:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzqCBzqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF05C433C8;
	Mon,  1 Jan 2024 00:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070633;
	bh=XaVndy1OPIO5w1cmb6PN1D/P8heGFWib/A35S5NaWFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DzqCBzqqm6LhEG96o3hATWEXe6P9nAICBHtfy6vPZO7cbOObuI5CUj/aOEprULJH0
	 X7lsltnxu9F3Pk4wtCohDZOFpzPCIIo6PXdiCkIEp9tDzGMYzocyy8vUBEWpARNY0d
	 cg9wKiE+Dfhk/ZMkRcEf5+Hpts3Pc6TeboRhGbs+6ijYD/bZCyN95b4dGN8RcuXaJF
	 0WLmyPNuxmS+cI6/Ee6YddL+ulxRk6Tv2yNtRTiX4MzzWEwY339BOuhWulshJVf1cr
	 FLXXvY2huHqIRCacv1BOSKIuJenVWLG5sVSkICESi3jjU2dH7//NMZxJ8/gUqVXXyV
	 4tvCu4De1xxZg==
Date: Sun, 31 Dec 2023 16:57:12 +9900
Subject: [PATCH 17/17] common/fuzzy: adapt the scrub stress tests to support
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030561.1826350.9873455298200379629.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adapt the scrub stress testing framework to support checking realtime
group metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy  |   27 ++++++++++++++++++++++-----
 common/xfs    |    9 +++++++++
 tests/xfs/581 |    2 +-
 tests/xfs/720 |    2 +-
 tests/xfs/795 |    2 +-
 5 files changed, 34 insertions(+), 8 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index d504f0854e..2de06622e5 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -847,8 +847,10 @@ __stress_one_scrub_loop() {
 	local scrub_tgt="$3"
 	local scrub_startat="$4"
 	local start_agno="$5"
-	shift; shift; shift; shift; shift
+	local start_rgno="$6"
+	shift; shift; shift; shift; shift; shift
 	local agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local xfs_io_args=()
 	for arg in "$@"; do
@@ -861,6 +863,12 @@ __stress_one_scrub_loop() {
 				local ag_arg="$(echo "$arg" | sed -e "s|%agno%|$agno|g")"
 				xfs_io_args+=('-c' "$ag_arg")
 			done
+		elif echo "$arg" | grep -q -w '%rgno%'; then
+			# Substitute the rtgroup number
+			for ((rgno = start_rgno; rgno < rgcount; rgno++)); do
+				local rg_arg="$(echo "$arg" | sed -e "s|%rgno%|$rgno|g")"
+				xfs_io_args+=('-c' "$rg_arg")
+			done
 		else
 			xfs_io_args+=('-c' "$arg")
 		fi
@@ -1245,7 +1253,9 @@ _scratch_xfs_stress_scrub_cleanup() {
 __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
 	local start_agno="$2"
-	shift; shift
+	local start_rgno="$3"
+	shift; shift; shift
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local cooked_tgt="$scrub_tgt"
 	case "$scrub_tgt" in
@@ -1275,6 +1285,10 @@ __stress_scrub_check_commands() {
 			cooked_arg="$(echo "$cooked_arg" | sed -e 's/^repair/repair -R/g')"
 		fi
 		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/$start_agno/g")"
+		if echo "$cooked_arg" | grep -q -w '%rgno%'; then
+			test "$rgcount" -eq 0 && continue
+			cooked_arg="$(echo "$cooked_arg" | sed -e "s/%rgno%/$start_rgno/g")"
+		fi
 		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
 		echo $testio | grep -q "Unknown type" && \
 			_notrun "xfs_io scrub subcommand support is missing"
@@ -1300,6 +1314,7 @@ __stress_scrub_check_commands() {
 #	in a separate loop.  If zero -i options are specified, do not run.
 #	Callers must check each of these commands (via _require_xfs_io_command)
 #	before calling here.
+# -R	For %rgno% substitution, start with this rtgroup instead of rtgroup 0.
 # -r	Run fsstress for this amount of time, then remount the fs ro or rw.
 #	The default is to run fsstress continuously with no remount, unless
 #	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
@@ -1346,6 +1361,7 @@ _scratch_xfs_stress_scrub() {
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
 	local start_agno=0
+	local start_rgno=0
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -1353,12 +1369,13 @@ _scratch_xfs_stress_scrub() {
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "a:fi:r:s:S:t:w:x:X:" c; do
+	while getopts "a:fi:r:R:s:S:t:w:x:X:" c; do
 		case "$c" in
 			a) start_agno="$OPTARG";;
 			f) freeze=yes;;
 			i) io_args+=("$OPTARG");;
 			r) remount_period="$OPTARG";;
+			R) start_rgno="$OPTARG";;
 			s) one_scrub_args+=("$OPTARG");;
 			S) xfs_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
@@ -1369,7 +1386,7 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
-	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" \
+	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" "$start_rgno" \
 			"${one_scrub_args[@]}"
 
 	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
@@ -1425,7 +1442,7 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"$scrub_startat" "$start_agno" \
+				"$scrub_startat" "$start_agno" "$start_rgno" \
 				"${one_scrub_args[@]}" &
 	fi
 
diff --git a/common/xfs b/common/xfs
index 1ff81f4cc2..313b7045bd 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1584,6 +1584,15 @@ _xfs_mount_agcount()
 	$XFS_INFO_PROG "$1" | sed -n "s/^.*agcount=\([[:digit:]]*\).*/\1/p"
 }
 
+# Find rtgroup count of mounted filesystem
+_xfs_mount_rgcount()
+{
+	local rtgroups="$($XFS_INFO_PROG "$1" | grep rgcount= | sed -e 's/^.*rgcount=\([0-9]*\).*$/\1/g')"
+
+	test -z "$rtgroups" && rtgroups=0
+	echo "$rtgroups"
+}
+
 # Wipe the superblock of each XFS AGs
 _try_wipe_scratch_xfs()
 {
diff --git a/tests/xfs/581 b/tests/xfs/581
index 1d08bc7df3..353421130e 100755
--- a/tests/xfs/581
+++ b/tests/xfs/581
@@ -32,7 +32,7 @@ _require_xfs_stress_scrub
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" realtime
-_scratch_xfs_stress_scrub -s "scrub rtbitmap"
+_scratch_xfs_stress_scrub -s "scrub rtbitmap"  -s "scrub rgbitmap %rgno%"
 
 # success, all done
 echo Silence is golden
diff --git a/tests/xfs/720 b/tests/xfs/720
index 2b6406da6e..3242a19b02 100755
--- a/tests/xfs/720
+++ b/tests/xfs/720
@@ -39,7 +39,7 @@ alloc_unit=$(_get_file_block_size $SCRATCH_MNT)
 scratchfile=$SCRATCH_MNT/file
 touch $scratchfile
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-__stress_scrub_check_commands "$scratchfile" "" 'repair bmapbtd'
+__stress_scrub_check_commands "$scratchfile" "" "" 'repair bmapbtd'
 
 # Compute the number of extent records needed to guarantee btree format,
 # assuming 16 bytes for each ondisk extent record
diff --git a/tests/xfs/795 b/tests/xfs/795
index a381db320f..2ce2ec5365 100755
--- a/tests/xfs/795
+++ b/tests/xfs/795
@@ -39,7 +39,7 @@ scratchfile=$SCRATCH_MNT/file
 mkdir $scratchdir
 touch $scratchfile
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-__stress_scrub_check_commands "$scratchdir" "" 'repair directory'
+__stress_scrub_check_commands "$scratchdir" "" "" 'repair directory'
 
 # Create a 2-dirblock directory
 total_size=$((alloc_unit * 2))

