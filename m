Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B728863A9;
	Tue,  2 Jan 2024 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+cipgFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1134FC433C8;
	Tue,  2 Jan 2024 08:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704185079;
	bh=4BKJ2ZrfbeF8BnnDsZY9R37/ITrsMHAzMQCfYmSW2nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+cipgFqyadADxlMfzs26LLE8OxoFIPL2293NqEfpSeTEtkBPs8meIi8NfMG84GV4
	 6wXsxWlvuGb+doXwY6uv2YecHQzyhYuFaumgZ7Vwep6sWGwmAqLkZz7FOTv2/eueLL
	 JTGmAR/bt/BvsZ3Ai9qpYU9NBEpNNiUr1Uu9v/pkuQzatd1DtO8eOjgoCN6WzY3zm9
	 VSrksokVWwhv2ukI/oGYB7fry1L2YcdKn5yPira5rML/z/Vo821jTeAGcp4bhvqg/8
	 PbcjQouVH5amTnOaicqNfAT1F5/9AHijMOBAfjKhbYST3tJSX+b51BFGNuy0geg0ud
	 0OH1fsiV2zzfQ==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH 2/5] common/xfs: Add function to detect support for metadump v2
Date: Tue,  2 Jan 2024 14:13:49 +0530
Message-ID: <20240102084357.1199843-3-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240102084357.1199843-1-chandanbabu@kernel.org>
References: <20240102084357.1199843-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit defines a new function to help detect support for metadump v2.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 common/xfs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/xfs b/common/xfs
index 38094828..558a6bb5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -698,6 +698,14 @@ _xfs_mdrestore() {
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
+_scratch_metadump_v2_supported()
+{
+	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
+		grep -q "Metadump version to be used"
+
+	return $?
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {
-- 
2.43.0

