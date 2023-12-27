Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8767EE;
	Mon,  1 Jan 2024 00:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdxJ8rRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE98C433C8;
	Mon,  1 Jan 2024 00:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070758;
	bh=+bZjXIN47a46bHE9sLkDCYVh7WDa4PepmEvBYdmYx1o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BdxJ8rRe49ZltQGN2fcuc0X9CmfGsUpfydLvBSXivgNgamopraCnPkkp2gDfAfPvN
	 HC/YVrzcuDKEFWbMseCIDPQ+saRPycyyInaqQWwgzxE9r9H90ZgKTYgSV68CDZ/XGD
	 Z+BbJBQkiC6NpD27X0vqw6ccXnqq9dno6qacv8zRgWwdBdhJ4E+fdd9yDwvVfAIvsc
	 EyagdOcufngZ+8tpYVEK39afThB+G+X0SMo5JttzxzN1I759D7vqgKnpdRRmQO+bMr
	 pbUIrof+MZ9ITtvTqmYESKOOLuoIvzDc7BPLgPdr2JKK7HJ2HfFTKNyOLL6TTFkq2q
	 jZkPfDzbFu0sA==
Date: Sun, 31 Dec 2023 16:59:17 +9900
Subject: [PATCH 06/13] xfs: fix various problems with fsmap detecting the data
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031313.1826914.17634665414796550757.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

Various tests of realtime rmap functionality assumed that the data
device could be picked out from the GETFSMAP output by looking for
static fs metadata.  This is no longer true, since rtgroups have a
static superblock header at the start, so update these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/272 |    2 +-
 tests/xfs/276 |    2 +-
 tests/xfs/277 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index c68fa9d614..d5f3a74177 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -57,7 +57,7 @@ cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total c
 done
 
 echo "Check device field of FS metadata and regular file"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
diff --git a/tests/xfs/276 b/tests/xfs/276
index 8cc486752a..a05ca1961d 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -61,7 +61,7 @@ cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total c
 done
 
 echo "Check device field of FS metadata and realtime file"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*[[:space:]]*[0-9]*$" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" != "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
diff --git a/tests/xfs/277 b/tests/xfs/277
index 03208ef233..eff54a2a50 100755
--- a/tests/xfs/277
+++ b/tests/xfs/277
@@ -38,7 +38,7 @@ $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
 
 echo "Check device field of FS metadata and journalling log"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" = "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
 

