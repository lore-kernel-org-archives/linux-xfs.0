Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31078342510
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971285; cv=none; b=HjqJcIsFJbhyy6e0WzVdS6DxUkM1GtF5Lgma+ihK5uNgyVpZSQuezqiwH0l5/rimdXr3AVe+jCcrpT4eQVtzEUvJ+422Br0KwNIFPU3ksCQs/Uwc+b1Inop0Ez+uyJz0EE24b2hkH3+TUeEqri1FcPsbsxq5CfSOaMOrdPkdAzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971285; c=relaxed/simple;
	bh=bvrlGLzj7ykiWZqDO4F49CeMBiz4ksPzUzK6NhZTnG8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJ8XbYdoOWp5/rR/rh9zjy2/9tP9Uq+bij2wkSnbodL6e4UhRxIf+o7flL8i7ys551+JLT9PJGMrNlTaIyhdio07iGlqPCBpm7zEDkK1Wv/RKyf8Mr3zONQSPCSDLcIsl4r1IIL9IGHT2ASjCDKHhDRowZqKTPCzbySS5SYfIcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILVQd/4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILVQd/4E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 92D761F000FF;
	Mon, 21 Sep 2026 06:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971283;
	bh=PyY+nHH4hm5+FNc0ctBgdgE9x20Fgdob8xI1aR4yDTA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ILVQd/4Eq2ahwe1raJQnh1avDjquHbYtFACPmFNDcA4ho/aIC+UtCtak0v6yAMvs1
	 h55QsFZVH2FgYcp94tWcKiawzeWhonhAvMrJK+OLiSVw5EkEg5tma4y4Www2dBUL/D
	 gkNmlwnVmAXk4TJG4IKNVGFzkJkUAex7NUVvfYd6RiDs//HqRwqE6uwNBi3GAsjbId
	 HpgnRXxbadbP8xDW8iVSB+jhDgXrIjspmpvnNGiLdWfCC+jQ3Rr0+zikgfCclGVUMx
	 ukP8/F1P9wL94CGQTuxGVvvB8gI7dWvb0D3c3pgNYWUYVFra+wCdSXd2sLqby//qng
	 Y7b5u/njFGBKg==
Date: Sun, 20 Sep 2026 23:14:43 -0700
Subject: [PATCH 1/2] mkfs: add config file for the 2026 LTS kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996057914.169776.676694849229728136.stgit@frogsfrogsfrogs>
In-Reply-To: <178996057889.169776.13298686198868661581.stgit@frogsfrogsfrogs>
References: <178996057889.169776.13298686198868661581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a config file for 7.3 since it'll be the LTS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/Makefile     |    3 ++-
 mkfs/lts_7.3.conf |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_7.3.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 16793bdb1e03e3..b2d99e620c78c4 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -19,7 +19,8 @@ CFGFILES = \
 	lts_6.1.conf \
 	lts_6.6.conf \
 	lts_6.12.conf \
-	lts_6.18.conf
+	lts_6.18.conf \
+	lts_7.3.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_7.3.conf b/mkfs/lts_7.3.conf
new file mode 100644
index 00000000000000..16d1c40e8f8a88
--- /dev/null
+++ b/mkfs/lts_7.3.conf
@@ -0,0 +1,29 @@
+# V5 features that were the mkfs defaults when the upstream Linux 7.3 LTS
+# kernel was released at the end of 2026.
+[block]
+
+[metadata]
+crc=1
+finobt=1
+rmapbt=1
+reflink=1
+inobtcount=1
+bigtime=1
+metadir=0
+autofsck=repair
+
+[data]
+
+[inode]
+sparse=1
+nrext64=1
+exchange=1
+
+[log]
+
+[naming]
+parent=1
+ftype=1
+version=2
+
+[realtime]

