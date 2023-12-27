Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26677ED;
	Mon,  1 Jan 2024 01:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWex3WLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF45AC433C7;
	Mon,  1 Jan 2024 01:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071039;
	bh=lp/ibTbu0SpCLYhexbJtamGg0MrqCgjKX1xNd3SAU68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mWex3WLZLL5UWZnffXVsPQXrDnw5NQ1OzZv0I+pVctglI8n7hqFXN9l0lOuLWQHhZ
	 H5A+vDgGxQeMum1YkZlblG2ucSRMjmpE2E/t8dR634oDbX3of2sH7iTzfWAbyZMfJw
	 5MWtZJpflEaplzUmthdK+XKLFPqZypb7xv/maXg/LQwOGBrfXrOh/x7+qanui53ymL
	 Yh7EJOcMFwYbcMpYJfVLj5BMfaVXwjZmdxlldtsMKnlMouB4C3IvUZBXcQLFZKrmfn
	 QKDqMsyKpwrzh9iNGUbpJnIjQYPP0wghn6wVdDpW7MH65ogE32RtLnGfujHWdxd+XV
	 fklNJRFrGE33w==
Date: Sun, 31 Dec 2023 17:03:59 +9900
Subject: [PATCH 1/1] xfs: baseline golden output for rt refcount btree fuzz
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032420.1827628.1074677672634826187.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032407.1827628.11076526403575631339.stgit@frogsfrogsfrogs>
References: <170405032407.1827628.11076526403575631339.stgit@frogsfrogsfrogs>
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

Record all the currently known failures of the xfs_scrub check and
repair code for the rt refcount btree fuzz tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1539.out |    6 ++++++
 tests/xfs/1540.out |    6 ++++++
 tests/xfs/1541.out |    6 ++++++
 tests/xfs/1542.out |   10 ++++++++++
 tests/xfs/1543.out |    2 ++
 tests/xfs/1544.out |   12 ++++++++++++
 tests/xfs/1545.out |   12 ++++++++++++
 7 files changed, 54 insertions(+)


diff --git a/tests/xfs/1539.out b/tests/xfs/1539.out
index aa3a963dc2..9f90912f2c 100644
--- a/tests/xfs/1539.out
+++ b/tests/xfs/1539.out
@@ -1,4 +1,10 @@
 QA output created by 1539
 Format and populate
 Fuzz rtrefcountbt recs
+numrecs = lastbit: offline scrub didn't fail.
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = firstbit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1540.out b/tests/xfs/1540.out
index 37f3311837..368dbace0f 100644
--- a/tests/xfs/1540.out
+++ b/tests/xfs/1540.out
@@ -1,4 +1,10 @@
 QA output created by 1540
 Format and populate
 Fuzz rtrefcountbt recs
+numrecs = lastbit: offline scrub didn't fail.
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = firstbit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1541.out b/tests/xfs/1541.out
index 35a9b73471..4af739233a 100644
--- a/tests/xfs/1541.out
+++ b/tests/xfs/1541.out
@@ -1,4 +1,10 @@
 QA output created by 1541
 Format and populate
 Fuzz rtrefcountbt recs
+numrecs = lastbit: offline scrub didn't fail.
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = firstbit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing rtrefcountbt recs
diff --git a/tests/xfs/1542.out b/tests/xfs/1542.out
index 55d820b4b1..d6acd5257c 100644
--- a/tests/xfs/1542.out
+++ b/tests/xfs/1542.out
@@ -1,4 +1,14 @@
 QA output created by 1542
 Format and populate
 Fuzz rtrefcountbt keyptrs
+u3.rtrefcbt.level = ones: mount failed (32).
+u3.rtrefcbt.level = firstbit: mount failed (32).
+u3.rtrefcbt.level = middlebit: mount failed (32).
+u3.rtrefcbt.level = add: mount failed (32).
+u3.rtrefcbt.level = sub: mount failed (32).
+u3.rtrefcbt.numrecs = ones: mount failed (32).
+u3.rtrefcbt.numrecs = firstbit: mount failed (32).
+u3.rtrefcbt.numrecs = middlebit: mount failed (32).
+u3.rtrefcbt.numrecs = add: mount failed (32).
+u3.rtrefcbt.numrecs = sub: mount failed (32).
 Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1543.out b/tests/xfs/1543.out
index e7afa10744..59eb5ad149 100644
--- a/tests/xfs/1543.out
+++ b/tests/xfs/1543.out
@@ -1,4 +1,6 @@
 QA output created by 1543
 Format and populate
 Fuzz rtrefcountbt keyptrs
+u3.rtrefcbt.keys[1].startblock = zeroes: offline scrub didn't fail.
+u3.rtrefcbt.keys[1].startblock = lastbit: offline scrub didn't fail.
 Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1544.out b/tests/xfs/1544.out
index b39532c160..717f901bb4 100644
--- a/tests/xfs/1544.out
+++ b/tests/xfs/1544.out
@@ -1,4 +1,16 @@
 QA output created by 1544
 Format and populate
 Fuzz rtrefcountbt keyptrs
+u3.rtrefcbt.level = ones: mount failed (32).
+u3.rtrefcbt.level = firstbit: mount failed (32).
+u3.rtrefcbt.level = middlebit: mount failed (32).
+u3.rtrefcbt.level = add: mount failed (32).
+u3.rtrefcbt.level = sub: mount failed (32).
+u3.rtrefcbt.numrecs = ones: mount failed (32).
+u3.rtrefcbt.numrecs = firstbit: mount failed (32).
+u3.rtrefcbt.numrecs = middlebit: mount failed (32).
+u3.rtrefcbt.numrecs = add: mount failed (32).
+u3.rtrefcbt.numrecs = sub: mount failed (32).
+u3.rtrefcbt.keys[1].startblock = zeroes: offline scrub didn't fail.
+u3.rtrefcbt.keys[1].startblock = lastbit: offline scrub didn't fail.
 Done fuzzing rtrefcountbt keyptrs
diff --git a/tests/xfs/1545.out b/tests/xfs/1545.out
index 982a0d64df..d279dc0db8 100644
--- a/tests/xfs/1545.out
+++ b/tests/xfs/1545.out
@@ -1,4 +1,16 @@
 QA output created by 1545
 Format and populate
 Fuzz rtrefcountbt keyptrs
+u3.rtrefcbt.level = ones: mount failed (32).
+u3.rtrefcbt.level = firstbit: mount failed (32).
+u3.rtrefcbt.level = middlebit: mount failed (32).
+u3.rtrefcbt.level = add: mount failed (32).
+u3.rtrefcbt.level = sub: mount failed (32).
+u3.rtrefcbt.numrecs = ones: mount failed (32).
+u3.rtrefcbt.numrecs = firstbit: mount failed (32).
+u3.rtrefcbt.numrecs = middlebit: mount failed (32).
+u3.rtrefcbt.numrecs = add: mount failed (32).
+u3.rtrefcbt.numrecs = sub: mount failed (32).
+u3.rtrefcbt.keys[1].startblock = zeroes: offline scrub didn't fail.
+u3.rtrefcbt.keys[1].startblock = lastbit: offline scrub didn't fail.
 Done fuzzing rtrefcountbt keyptrs

