Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B8C331EB0;
	Sat, 25 Jul 2026 07:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965189; cv=none; b=Rs2pagYI0BfyBuXcWj6yMnabzG9t7UPN72ISMzhdFpLjwmMdPf4F9emT4+JOo/dAMeeIXxDnAsuSV7Ctr1X14QqXEMJPAOtoE3LyAUzQ16ap3rVy1DhOTtMC8hNMFoSeYOotfSNBHki1BQmNkuIQerF5H4ytpYBFkknvAPkFj5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965189; c=relaxed/simple;
	bh=fw/nRl/y4mdFVVDi5bLGz78R8GMegVuj2iIDvwX1m30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJtnw7CoEPqJLX8FDw25hRfOwHrQMVE7971DFBRDCmOam24q4Lv1uGL5eLUz+l/fncyVBXM4Ghajl2xAK4MbGv6fjRkN6Gt9A0eukjB86mAXS6Tm5xHWDUa0tzHy9CQDIO2nY2eDajGabonRMAMxlLrMLZSLM2QSlEX2/RkW8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPaoRKB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPaoRKB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460AD1F000E9;
	Sat, 25 Jul 2026 07:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965188;
	bh=qa1sayaIQvzwoExpdR95uN90DWjqj0ydUFZDZMchGLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPaoRKB5mRsGUeO1YgS87w8dLD/3UFAfEQ+qSsf9LZYRfpN868YhWRSKU56SBFmCu
	 /Bxn36BQTuszrVJuFUN3rhh2a9WY8cy9SHAER62S3hPtLtqopIybYrkwyi5oIZn2Rp
	 HgomxRkJd6NslSKW7a+A9gjb4up7RagqMcX3YdXh2t8nVkkMMfQs2SjsG1Zx9KU+xp
	 laUZcSChf+wCEj3DvZMIUI4az/vITGVX9E+xamSYk/5gkAElz9uX4RWI/ukSR0PaDX
	 SxYDXXECamPrmK9/QT/cZpXvyn8BFDW/1Mu03vfv+aOjVvAVVFyR2Pl0lZoOzT5EkD
	 D7l2hRmQJPo6Q==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 06/13] fstests: add SEMANAGE_PROG
Date: Sat, 25 Jul 2026 15:39:03 +0800
Message-ID: <97b71706f0c127ec1bf4c73cd97e664fbeb03086.1784949155.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define `SEMANAGE_PROG` for an upcoming test case that uses `semanage(8)`.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/config b/common/config
index 5661fa0ec310..d760b796ce86 100644
--- a/common/config
+++ b/common/config
@@ -243,6 +243,7 @@ export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
 export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
+export SEMANAGE_PROG="$(type -P semanage)"
 
 # udev wait functions.
 #
-- 
2.43.0

