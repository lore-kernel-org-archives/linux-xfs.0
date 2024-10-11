Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7390C2ED;
	Fri, 11 Oct 2024 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610735; cv=none; b=KQmYCn1WOHIilWxNmbyP28s8lU2lj0aB90LDRg+NhrMuA15UBartYR2CxKFe1lv8XR61X94iC3yKmEqssa2emd1iF7+vVBXUa6xcPnu+fwrXlxxujLxqXw2sqbKIz6L/wUjHKmY41jtU5YBTCNmyQDQ+UZdbGrllkxAbkKNeits=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610735; c=relaxed/simple;
	bh=pjs3VXMwd5WdEc7oXC3aEGDxKinjiU6VcMtm+NtAzhU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VzPYRU0ST8vKeXw/WwuBv4lOXdrd2iZMDZAlDP77yV2L5dWAa3rxzDvO7ps9VUHO80GdJZ1IpE2oQHj3c4XcwClUwN/Mmoh8uL+ViS7S1AEKMuxNYr92H2fUeAtwYXCDX9UVJhe2TwhClJZHtZhELkzo91IaV/2GEW9oRafp7oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJLIyij6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJLIyij6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E600C4CEC5;
	Fri, 11 Oct 2024 01:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610734;
	bh=pjs3VXMwd5WdEc7oXC3aEGDxKinjiU6VcMtm+NtAzhU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VJLIyij6jWagAFK84n+SrhX9m1LjoFbJYJULbOoTEsOWdFGZDGOqYvlbfJ5V7atKH
	 rYYiUl1lgQUWt/yIdLaENyc7sZ1UjvzNehUg+ROs6zvIKQSTbu5AMUqe+tQCyeJNkN
	 xiDIKD0ti3uloVkizEVwFX74NtkGct14Iy869RWLBpJO77ncZL/FG1M9e8ae/TAU7/
	 pWL3FWK0QhSjr/rDXfdXDcnTW+MKc4PFw+ilp4FAZ2l4jNpfBWmPaWuFa8G+S/v/Op
	 KiqbpTvD9iJCScswt1Zq+L1diVS+obh86y5xPQ1TvnYITpGckz/trQUjlZMuUGiHup
	 1w2BBzElCaXsA==
Date: Thu, 10 Oct 2024 18:38:53 -0700
Subject: [PATCH 03/11] xfs/{030,033,178}: forcibly disable metadata directory
 trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658043.4187056.14504092342033103535.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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

The golden output for thests tests encode the xfs_repair output when we
fuzz various parts of the filesystem.  With metadata directory trees
enabled, however, the golden output changes dramatically to reflect
reconstruction of the metadata directory tree.

To avoid regressions, add a helper to force metadata directories off via
MKFS_OPTIONS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   13 +++++++++++++
 tests/xfs/030 |    1 +
 tests/xfs/033 |    1 +
 tests/xfs/178 |    1 +
 4 files changed, 16 insertions(+)


diff --git a/common/xfs b/common/xfs
index ae32710072671e..20217ea7365a4d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1887,3 +1887,16 @@ _scratch_xfs_find_metafile()
 	echo "inode $sb_field"
 	return 0
 }
+
+# Force metadata directories off.
+_scratch_xfs_force_no_metadir()
+{
+	if echo "$MKFS_OPTIONS" | grep -q 'metadir='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/metadir=[0-9]*/metadir=0/g' -e 's/metadir\([, ]\)/metadir=0\1/g')"
+		return
+	fi
+
+	if grep -q 'metadir=' $MKFS_XFS_PROG; then
+		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
+	fi
+}
diff --git a/tests/xfs/030 b/tests/xfs/030
index 7ce5ffce38693c..22fbdb2fdbc999 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -48,6 +48,7 @@ _check_ag()
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 DSIZE="-dsize=100m,agcount=6"
 
diff --git a/tests/xfs/033 b/tests/xfs/033
index d7b02a9c51b3f0..e0b0dd58212d61 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -51,6 +51,7 @@ _filter_bad_ids()
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 # devzero blows away 512byte blocks, so make 512byte inodes (at least)
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
diff --git a/tests/xfs/178 b/tests/xfs/178
index a22e626706ec49..0cc0e3f5bb88b4 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -50,6 +50,7 @@ _dd_repair_check()
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
+_scratch_xfs_force_no_metadir
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 
 # By executing the followint tmp file, will get on the mkfs options stored in

