Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C285A7ED;
	Mon,  1 Jan 2024 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xip2Mh0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884E7C433C7;
	Mon,  1 Jan 2024 01:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070883;
	bh=5FPdso9T4JvAZCVd+mOgv7MpFc0uDTLhqIb8eZdxn20=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xip2Mh0E5e/lbgDokOBhRrAT+8NV+UOtAePafA86jLj/PmsNDN7DGsYBfhaq3118N
	 xi0tfvvFN8t2Zca2EJZyT8T/MTLOgK+XXHCeOpZFo+VXWqco5daICLIZ6jKS4SidCb
	 VrYYAHnqa8nDwXMFHIHLbuRve07xl8Qv4qoo3M5AymzsIBchud13siy0OkTX2MfiPQ
	 iYTX0U6yvDSBFWj3z26Bxf/LkaR6zIWJOR/QrnxKqIp9bHstm7HQDxfi3bg9Ca8h1e
	 neBvKPQzs7DKza+h36r+5GHEDSU/VNc7GyzykZvYQToNO9igby2GTieFzNCRbg0Cz5
	 fuYBJbZmC0lvA==
Date: Sun, 31 Dec 2023 17:01:23 +9900
Subject: [PATCH 1/1] fuzzy: create known output for rt rmap btree fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031692.1827280.6296580347361583382.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031680.1827280.18087377382466462655.stgit@frogsfrogsfrogs>
References: <170405031680.1827280.18087377382466462655.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1528.out |   22 ++++++++
 tests/xfs/1529.out |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/406.out  |   22 ++++++++
 tests/xfs/408.out  |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/409.out  |   15 ++++++
 tests/xfs/481.out  |   22 ++++++++
 tests/xfs/482.out  |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 495 insertions(+)


diff --git a/tests/xfs/1528.out b/tests/xfs/1528.out
index b51b640c40..efa31b604e 100644
--- a/tests/xfs/1528.out
+++ b/tests/xfs/1528.out
@@ -1,4 +1,26 @@
 QA output created by 1528
 Format and populate
 Fuzz rtrmapbt recs
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = firstbit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+recs[2].blockcount = middlebit: offline scrub didn't fail.
+recs[2].blockcount = lastbit: offline scrub didn't fail.
+recs[2].blockcount = add: offline scrub didn't fail.
+recs[3].blockcount = middlebit: offline scrub didn't fail.
+recs[3].blockcount = add: offline scrub didn't fail.
+recs[4].blockcount = middlebit: offline scrub didn't fail.
+recs[4].blockcount = add: offline scrub didn't fail.
+recs[5].blockcount = middlebit: offline scrub didn't fail.
+recs[5].blockcount = add: offline scrub didn't fail.
+recs[6].blockcount = middlebit: offline scrub didn't fail.
+recs[6].blockcount = add: offline scrub didn't fail.
+recs[7].blockcount = middlebit: offline scrub didn't fail.
+recs[7].blockcount = add: offline scrub didn't fail.
+recs[8].blockcount = middlebit: offline scrub didn't fail.
+recs[8].blockcount = add: offline scrub didn't fail.
+recs[9].blockcount = middlebit: offline scrub didn't fail.
+recs[9].blockcount = add: offline scrub didn't fail.
 Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1529.out b/tests/xfs/1529.out
index 808fcc957f..0810094a43 100644
--- a/tests/xfs/1529.out
+++ b/tests/xfs/1529.out
@@ -1,4 +1,142 @@
 QA output created by 1529
 Format and populate
 Fuzz rtrmapbt keyptrs
+u3.rtrmapbt.keys[1].startblock = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[1] = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[2] = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[3] = firstbit: offline scrub didn't fail.
 Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/406.out b/tests/xfs/406.out
index 6615533e6c..e95ac52fed 100644
--- a/tests/xfs/406.out
+++ b/tests/xfs/406.out
@@ -1,4 +1,26 @@
 QA output created by 406
 Format and populate
 Fuzz rtrmapbt recs
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = firstbit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+recs[2].blockcount = middlebit: offline scrub didn't fail.
+recs[2].blockcount = lastbit: offline scrub didn't fail.
+recs[2].blockcount = add: offline scrub didn't fail.
+recs[3].blockcount = middlebit: offline scrub didn't fail.
+recs[3].blockcount = add: offline scrub didn't fail.
+recs[4].blockcount = middlebit: offline scrub didn't fail.
+recs[4].blockcount = add: offline scrub didn't fail.
+recs[5].blockcount = middlebit: offline scrub didn't fail.
+recs[5].blockcount = add: offline scrub didn't fail.
+recs[6].blockcount = middlebit: offline scrub didn't fail.
+recs[6].blockcount = add: offline scrub didn't fail.
+recs[7].blockcount = middlebit: offline scrub didn't fail.
+recs[7].blockcount = add: offline scrub didn't fail.
+recs[8].blockcount = middlebit: offline scrub didn't fail.
+recs[8].blockcount = add: offline scrub didn't fail.
+recs[9].blockcount = middlebit: offline scrub didn't fail.
+recs[9].blockcount = add: offline scrub didn't fail.
 Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/408.out b/tests/xfs/408.out
index c01b2e26ae..5626c59560 100644
--- a/tests/xfs/408.out
+++ b/tests/xfs/408.out
@@ -1,4 +1,142 @@
 QA output created by 408
 Format and populate
 Fuzz rtrmapbt keyptrs
+u3.rtrmapbt.keys[1].startblock = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[1] = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[2] = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[3] = firstbit: offline scrub didn't fail.
 Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/409.out b/tests/xfs/409.out
index 690ac99b10..3d0a67afa8 100644
--- a/tests/xfs/409.out
+++ b/tests/xfs/409.out
@@ -1,4 +1,19 @@
 QA output created by 409
 Format and populate
 Fuzz rtrmapbt keyptrs
+u3.rtrmapbt.level = ones: mount failed (32).
+u3.rtrmapbt.level = firstbit: mount failed (32).
+u3.rtrmapbt.level = middlebit: mount failed (32).
+u3.rtrmapbt.level = add: mount failed (32).
+u3.rtrmapbt.level = sub: mount failed (32).
+u3.rtrmapbt.numrecs = zeroes: online repair failed (1).
+u3.rtrmapbt.numrecs = zeroes: online re-scrub failed (5).
+u3.rtrmapbt.numrecs = zeroes: offline re-scrub failed (1).
+u3.rtrmapbt.numrecs = zeroes: online post-mod scrub failed (4).
+u3.rtrmapbt.numrecs = zeroes: offline post-mod scrub failed (1).
+u3.rtrmapbt.numrecs = ones: mount failed (32).
+u3.rtrmapbt.numrecs = firstbit: mount failed (32).
+u3.rtrmapbt.numrecs = middlebit: mount failed (32).
+u3.rtrmapbt.numrecs = add: mount failed (32).
+u3.rtrmapbt.numrecs = sub: mount failed (32).
 Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/481.out b/tests/xfs/481.out
index d570dc8f21..1e080de148 100644
--- a/tests/xfs/481.out
+++ b/tests/xfs/481.out
@@ -1,4 +1,26 @@
 QA output created by 481
 Format and populate
 Fuzz rtrmapbt recs
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = firstbit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+recs[2].blockcount = middlebit: offline scrub didn't fail.
+recs[2].blockcount = lastbit: offline scrub didn't fail.
+recs[2].blockcount = add: offline scrub didn't fail.
+recs[3].blockcount = middlebit: offline scrub didn't fail.
+recs[3].blockcount = add: offline scrub didn't fail.
+recs[4].blockcount = middlebit: offline scrub didn't fail.
+recs[4].blockcount = add: offline scrub didn't fail.
+recs[5].blockcount = middlebit: offline scrub didn't fail.
+recs[5].blockcount = add: offline scrub didn't fail.
+recs[6].blockcount = middlebit: offline scrub didn't fail.
+recs[6].blockcount = add: offline scrub didn't fail.
+recs[7].blockcount = middlebit: offline scrub didn't fail.
+recs[7].blockcount = add: offline scrub didn't fail.
+recs[8].blockcount = middlebit: offline scrub didn't fail.
+recs[8].blockcount = add: offline scrub didn't fail.
+recs[9].blockcount = middlebit: offline scrub didn't fail.
+recs[9].blockcount = add: offline scrub didn't fail.
 Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/482.out b/tests/xfs/482.out
index 6bdf7a9fc1..c945b7aaf8 100644
--- a/tests/xfs/482.out
+++ b/tests/xfs/482.out
@@ -1,4 +1,142 @@
 QA output created by 482
 Format and populate
 Fuzz rtrmapbt keyptrs
+u3.rtrmapbt.keys[1].startblock = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[1].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[2].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].startblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].owner_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = zeroes: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].offset_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].attrfork_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = ones: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = middlebit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = lastbit: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = add: offline scrub didn't fail.
+u3.rtrmapbt.keys[3].bmbtblock_hi = sub: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[1] = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[2] = firstbit: offline scrub didn't fail.
+u3.rtrmapbt.ptrs[3] = firstbit: offline scrub didn't fail.
 Done fuzzing rtrmapbt keyptrs

