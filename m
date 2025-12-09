Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3104D2FF64E
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765296985; cv=none; b=Ci5cK761EpxW6UCOAaYllKpkiG1cU1qF27e1Fz3n2uhCFM4cIfO1PquU+odncSdYYHjuA5qxpS0b62vW4ambzbUtriSRgCCWB1H+8IWPscbZ7G195PusHY0i8/APltyPVts3h84BpGcW7gehu0drEiz+mHngFo0YHzWGNaaJMHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765296985; c=relaxed/simple;
	bh=JSFr4qRIUIyCn4+I5jSFX/W+MPsvk4/tKHZHrqEit8E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIvZdGCJjcSLEMI1ERr3c7yNebB4ETXjdJh/d1iHFVZBWRLM+JKJJeelltgo3+HyEchTmwaAETHH+NfsD3MNN2SZRjHPE7Kh9TgqTHpodLWFDkXU6M0xrvu+hG1kZAB53Olu3VLs+m2v3521TmFbQBFFpEnaNcYSPn5RdOQoCGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1/XF7T9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1/XF7T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A092C4CEF5;
	Tue,  9 Dec 2025 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765296984;
	bh=JSFr4qRIUIyCn4+I5jSFX/W+MPsvk4/tKHZHrqEit8E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t1/XF7T9RBOsNNxgLZIztYE7X6rS1W/E9XeDfK23Rp7JBae8xOUEAIcIGpfIYRkjH
	 QXeqgV6Ot0uotjULskYuskreIpdp++jaevuAd1XEG8tKlquOWQVadkWUpKE8HJ1bP6
	 jeubisjVzW2/qrTEu6MjgGWF9yhFt1GR4BIcoF8st3yI08SWGO29svNFINF4SOXoqr
	 K2o0hm7qfr90kFWgA7u37jsVGfBwSMuArAsdC30+vVyP7Y3fuMzxXFpIgKHD+RKeWZ
	 kcIgzFWPKDY5ybeRHoK4Shr6EASPjvf6ksLWlCA90G5/j8hwT4uw70AMejgaTRHbxZ
	 9aM2ZDId/s+Ug==
Date: Tue, 09 Dec 2025 08:16:24 -0800
Subject: [PATCH 2/2] mkfs: add 2025 LTS config file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176529676164.3974899.5005702998496231177.stgit@frogsfrogsfrogs>
In-Reply-To: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
References: <176529676119.3974899.4941979844964370861.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new configuration file with the defaults as of 6.18 LTS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.18.conf |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.18.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 04905bd5101ccb..fb1473324cde7c 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -18,7 +18,8 @@ CFGFILES = \
 	lts_5.15.conf \
 	lts_6.1.conf \
 	lts_6.6.conf \
-	lts_6.12.conf
+	lts_6.12.conf \
+	lts_6.18.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.18.conf b/mkfs/lts_6.18.conf
new file mode 100644
index 00000000000000..2dbec51e586fa1
--- /dev/null
+++ b/mkfs/lts_6.18.conf
@@ -0,0 +1,19 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.18 LTS
+# kernel was released at the end of 2025.
+
+[metadata]
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+metadir=0
+reflink=1
+rmapbt=1
+
+[inode]
+sparse=1
+nrext64=1
+exchange=1
+
+[naming]
+parent=1

