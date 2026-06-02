Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69802E0B5C
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376363; cv=none; b=I6O0WKa/SWULF+bB8L+VDNmbPz+rw13XNewYAG7v+Usemk5ZQkS04zmQQTjB0W1jtH3SSXdiA+luonx6ZGlxbtc9gd8Rug7DfSi6DmqDCIOu29GJskQeWvJjG5zkcvZoES2MmYH1NP6J/lmyX7JTw4XflN8VI+9UIgCChMOFkHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376363; c=relaxed/simple;
	bh=B6zPgX7q0koZsQnPXWA5H0J1WGQPeYtVzzNW3k30iF4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGSbTwL9/SDAYIcyRmfqSQsMsTubIDsCTXsRSBBbm2CVuzBZC7HW5zeJOQ43IUx28wZGBD/LHFEyjkJ13ErhjpRdTicT0oeWKTscEfiHRvLhbt9GnokcnOMePd7IDQSJ0Fd/ezGuXDNE/rbBUGh59JbiG0hRrOKFnhupzSSxU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7CfF9eq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7CfF9eq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F3351F00893;
	Tue,  2 Jun 2026 04:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376362;
	bh=AzmwLo7SV3NB2TzsuP9vaanAfSISXusxKAEPDQ9yTOs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=M7CfF9eqiR+Vva/xoArQ7+pwd39TQkx4PHJ2ABtr+I9mhlW2o/6W0ZF3d9nqToyjE
	 VItMN8j+IFes/4xixkfcCp4r3b1H3xaMAzPBxpMD6iEMuAsvG0R/NSZ4lrCW5DtdJM
	 iRP6E321ga2Z+ZlNchIWlrHMMXHYJx26IIdXsJi1NGysVqiPYObseSqdLULTv1Szpr
	 mJ0TL1dy9XUx8T4+pojWMBk2ZWqhiElLDRp2rfSfeNJuXRmyMRrjEj+bXVurkEyMj4
	 EBTSe8513ct4VXSiUl+wgeFhsDKCGPkDnfTtHgvEm67CbbTpSkJiSUfpV4zLXi0mRh
	 sWPhyVW4A+xJg==
Date: Mon, 01 Jun 2026 21:59:21 -0700
Subject: [PATCH 5/7] xfs_healer: fix Makefile errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627135.588879.17876889855063986521.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex had a couple of complaints about the makefile -- mostly that it
never cleans up after xfs_healer_start; and that it should use LTINSTALL
to install libtool binaries.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/healer/Makefile b/healer/Makefile
index 1db2872617241b..49a48b52782e72 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -42,9 +42,12 @@ endif # HAVE_SYSTEMD
 
 ifeq ($(HAVE_HEALER_START_DEPS),yes)
 BUILD_TARGETS += xfs_healer_start
+LDIRT += xfs_healer_start xfs_healer_start.o
 SYSTEMD_SERVICES += xfs_healer_start.service
 endif # xfs_healer_start deps
 
+LDIRT += $(SYSTEMD_SERVICES)
+
 default: depend $(BUILD_TARGETS) $(SYSTEMD_SERVICES)
 
 xfs_healer_start: $(SUBDIRS) xfs_healer_start.o $(LTDEPENDENCIES)
@@ -62,7 +65,7 @@ install: $(INSTALL_HEALER)
 
 install-healer: default
 	$(INSTALL) -m 755 -d $(PKG_LIBEXEC_DIR)
-	$(INSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
+	$(LTINSTALL) -m 755 $(BUILD_TARGETS) $(PKG_LIBEXEC_DIR)
 
 install-systemd: default
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)

