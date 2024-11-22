Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E0B22339;
	Fri, 22 Nov 2024 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294431; cv=none; b=LKDBjtKn+mLWVU886aLb0+qxvrXkwnFKejpjD77A8TZgmxYoQOxix9GTsz96WwO8ZDuGwFdw7dc4M1gfuQzcB4ZMN6qZTZBVYW6ey5WUcMDez7nyBu0MyzIkpUyZuIx3Esh+xxwGVrHh8mVLeH6JJ7CzdcxnuFFYJ0RPBka4hmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294431; c=relaxed/simple;
	bh=FqXto+XvEKJb19Mg6eHjG09gKuWcl9gRB9HoBxKkqIQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OD/6Uca01TmURQv50fz2ifFAkOCqND2yVorzDp3YQ+5NhSFxOi/XKMa3Xz6HuASw/94NDyUCeX14EpaWcViz4Fv33GAyLrRs0nsJd5wjVyJEaepi9MoEy+l++SIrBV1Mu0YQCgG3ntqCRhizyUyHa3Kn/Rp3vVEuy0K/67RBncI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlQ7JRQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlQ7JRQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B5DC4CECE;
	Fri, 22 Nov 2024 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294431;
	bh=FqXto+XvEKJb19Mg6eHjG09gKuWcl9gRB9HoBxKkqIQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OlQ7JRQieuj8nz+x+UIjZ0HGKLF4HcAYqC/+didKK/siPz/iqMRqsWcr7QrDC3mCf
	 p5XHtxlKfAoVTxOfUohQh4w5+plrWKNRDXIulde78kedPTMzdvv43OosAbUoHH8zRn
	 MdCFPAQ92jnW3yUAQD04xI9fbT7pgYjpi2GvBYeV8Ys2nn0imN2r9w+9ro5HwOkv8k
	 lk4LvDxssjyXFR8acaiukbpIISZ93qHTwBH4gtBnlekpSYxgVSzWqMp793QhA/wwMV
	 LJHnOLlnw99yffREzkQB/Vshyy+nLhBv+/EFNSICUQ1vHMsaOH8Jkbgmdp7YIPWAHJ
	 PleEXG9h/yzvA==
Date: Fri, 22 Nov 2024 08:53:50 -0800
Subject: [PATCH 13/17] generic/251: constrain runtime via time/load/soak
 factors
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420209.358248.6636819948700619006.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On my test fleet, this test can run for well in excess of 20 minutes:

   613 generic/251
   616 generic/251
   624 generic/251
   630 generic/251
   634 generic/251
   652 generic/251
   675 generic/251
   749 generic/251
   777 generic/251
   808 generic/251
   832 generic/251
   946 generic/251
  1082 generic/251
  1221 generic/251
  1241 generic/251
  1254 generic/251
  1305 generic/251
  1366 generic/251
  1646 generic/251
  1936 generic/251
  1952 generic/251
  2358 generic/251
  4359 generic/251
  5325 generic/251
 34046 generic/251

because it hardcodes 20 threads and 10 copies.  It's not great to have a
test that results in a significant fraction of the total test runtime.
Fix the looping and load on this test to use LOAD and TIME_FACTOR to
scale up its operations, along with the usual SOAK_DURATION override.
That brings the default runtime down to less than a minute.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/251 |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index d59e91c3e0a33a..b4ddda10cef403 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -15,7 +15,6 @@ _begin_fstest ioctl trim auto
 tmp=`mktemp -d`
 trap "_cleanup; exit \$status" 0 1 3
 trap "_destroy; exit \$status" 2 15
-chpid=0
 mypid=$$
 
 # Import common functions.
@@ -151,29 +150,28 @@ function check_sums() {
 
 function run_process() {
 	local p=$1
-	repeat=10
+	if [ -n "$SOAK_DURATION" ]; then
+		local duration="$SOAK_DURATION"
+	else
+		local duration="$((30 * TIME_FACTOR))"
+	fi
+	local stopat="$(( $(date +%s) + duration))"
 
-	sleep $((5*$p))s &
-	export chpid=$! && wait $chpid &> /dev/null
-	chpid=0
-
-	while [ $repeat -gt 0 ]; do
+	sleep $((5*$p))s
 
+	while [ "$(date +%s)" -lt "$stopat" ]; do
 		# Remove old directories.
 		rm -rf $SCRATCH_MNT/$p
-		export chpid=$! && wait $chpid &> /dev/null
 
 		# Copy content -> partition.
 		mkdir $SCRATCH_MNT/$p
 		cp -axT $content/ $SCRATCH_MNT/$p/
-		export chpid=$! && wait $chpid &> /dev/null
 
 		check_sums
-		repeat=$(( $repeat - 1 ))
 	done
 }
 
-nproc=20
+nproc=$((4 * LOAD_FACTOR))
 
 # Copy $here to the scratch fs and make coipes of the replica.  The fstests
 # output (and hence $seqres.full) could be in $here, so we need to snapshot
@@ -194,11 +192,9 @@ pids=""
 echo run > $tmp.fstrim_loop
 fstrim_loop &
 fstrim_pid=$!
-p=1
-while [ $p -le $nproc ]; do
+for ((p = 1; p < nproc; p++)); do
 	run_process $p &
 	pids="$pids $!"
-	p=$(($p+1))
 done
 echo "done."
 

