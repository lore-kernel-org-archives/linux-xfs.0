Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A3219FC;
	Wed, 27 Mar 2024 02:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507417; cv=none; b=i/qC9lA9oCZR2knrcFD0ykxmF9vZb52QosujU8IL1NM41Cj0FT0a1D7BXjYdU2D7PV2EmINC3sHCI87gyN3M6viN+JU8Ax02QFFxk03HW45wr2bSsyHwuXdEWGGeQ85KIJKEA5SsNFSmZGQ3CV1UKvO1dIkCaZeODg8KRk9SMxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507417; c=relaxed/simple;
	bh=dbWgujssVHgH1plok4cUwbq4GEPCjRB748g910qdHQs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBocbH6pFjjpmlfXjTxA1MZGqPSPy4B8G5c3uWq7aTOkZA8chJ1S8G1FPIUShwzeuvqCjXGmztvB4E9yBM62KW4dmjFZJ/OrUvchHVcrfwbvONKLLUFp+cwTmsarp2qh976sWRQgrynCLuNwn2d3x44mp9fSk7qYTUDrk7TC0TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV7dsL5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV7dsL5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5D5C433C7;
	Wed, 27 Mar 2024 02:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711507416;
	bh=dbWgujssVHgH1plok4cUwbq4GEPCjRB748g910qdHQs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=YV7dsL5CAslSGAAqUB6FTbH1KjvnSgYHwCAidL7FWV2aU4GoMOn9Vtg8Hx9YmQUhV
	 D2UwRlfiMtSd9aRx6dO3I/671tlLn7BBfW5JvICGrqThGoqk6wrnMaEDzpW0BnVQf5
	 +6b2hiMAcpxWO9AKkHJuSnf1ONGy9tmUZo75hcWv4QcJfq4/hGJpp3j4pIPpbTI0Hv
	 RyBJcYIosR+1cOOxYzxDtQ998w3N8lhJxLlEg3fGEj8F/etCkMmSAXn13vef0ZeXiB
	 OMQlCo3LJZjaciVxwVeXK7Z4VBjr00CaYnbFK3IIg5eeFfPD8nrCLHkozT/YgHfaSp
	 vYMlI/woNBAjg==
Subject: [PATCH 3/4] generic/{166,167,333,334,671}: actually fill the
 filesystem with snapshots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Date: Tue, 26 Mar 2024 19:43:35 -0700
Message-ID: <171150741593.3286541.18115194618541313905.stgit@frogsfrogsfrogs>
In-Reply-To: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
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

XFS has this behavior in its reflink implementation where it returns
ENOSPC if one of the AGs that would be involved in the sharing operation
becomes more than 90% full.  As Kent Overstreet points out, that means
the snapshot creator shuts down when the filesystem is only about a
third full.  We could exercise the system harder by not *forcing*
reflink, which will actually fill the filesystem full.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/reflink    |    8 ++++++++
 tests/generic/166 |    2 +-
 tests/generic/167 |    2 +-
 tests/generic/333 |    2 +-
 tests/generic/334 |    2 +-
 tests/generic/671 |    2 +-
 6 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/common/reflink b/common/reflink
index 22adc4449b..8f30dc6784 100644
--- a/common/reflink
+++ b/common/reflink
@@ -226,6 +226,14 @@ _cp_reflink() {
 	cp --reflink=always -p -f "$file1" "$file2"
 }
 
+# Create file2 as a snapshot of file1 via cp and possibly reflink.
+_reflink_snapshot() {
+	file1="$1"
+	file2="$2"
+
+	cp --reflink=auto -p -f "$file1" "$file2"
+}
+
 # Reflink some file1 into file2
 _reflink() {
 	file1="$1"
diff --git a/tests/generic/166 b/tests/generic/166
index 0eb2ec9c3a..941b51b3f1 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -60,7 +60,7 @@ snappy() {
 			sleep 0.01
 			continue;
 		fi
-		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		out="$(_reflink_snapshot $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo "$out" | grep -q "No space left" && break
 		test -n "$out" && echo "$out"
diff --git a/tests/generic/167 b/tests/generic/167
index ae5fa5eb1c..3670940825 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -50,7 +50,7 @@ _scratch_cycle_mount
 snappy() {
 	n=0
 	while [ ! -e $finished_file ]; do
-		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		out="$(_reflink_snapshot $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo "$out" | grep -q "No space left" && break
 		test -n "$out" && echo "$out"
diff --git a/tests/generic/333 b/tests/generic/333
index bf1967ce29..19e69993a3 100755
--- a/tests/generic/333
+++ b/tests/generic/333
@@ -53,7 +53,7 @@ _scratch_cycle_mount
 snappy() {
 	n=0
 	while [ ! -e $finished_file ]; do
-		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		out="$(_reflink_snapshot $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo $out | grep -q "No space left" && break
 		test -n "$out" && echo $out
diff --git a/tests/generic/334 b/tests/generic/334
index b9c14b87ac..1e4d37b415 100755
--- a/tests/generic/334
+++ b/tests/generic/334
@@ -52,7 +52,7 @@ _scratch_cycle_mount
 snappy() {
 	n=0
 	while [ ! -e $finished_file ]; do
-		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		out="$(_reflink_snapshot $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo $out | grep -q "No space left" && break
 		test -n "$out" && echo $out
diff --git a/tests/generic/671 b/tests/generic/671
index b6cc0573f3..24ed24e213 100755
--- a/tests/generic/671
+++ b/tests/generic/671
@@ -41,7 +41,7 @@ _scratch_cycle_mount
 snappy() {
 	n=0
 	while [ ! -e $finished_file ]; do
-		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		out="$(_reflink_snapshot $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo "$out" | grep -q "No space left" && break
 		test -n "$out" && echo "$out"

