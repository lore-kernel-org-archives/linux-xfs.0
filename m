Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76279192D84
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217003; cv=none; b=vGSKf8qfiImzELSaTNFy8IQPediBCRsiOYP+NPIuanur4gr2TF49Fq0BtwiTATyjaIcUb0sHHw2Bne1Vu8lMCEfyURHPrd3TvoIicUQtTwd7P4C2MpgDBzyPKZZ5CsfE5GWaflXE88BQSHcfqbVSp5SF07OvwFgWEFcRfQLx5hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217003; c=relaxed/simple;
	bh=VBV0OeWnSAgVSRJ0Avj0cKI4/5CmGndl7PeolvJjAyc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDlGnrF9t8CO5aBQR1/gCrCl2zoqfUjETZfiDrCixn29lM/GaMaNvC36UaAKWa8Aa8hcHiKQU/YFPw1olaLkkURxtmA3Okdq+d/XJ0+vkErJ13VcfguglYRi3RCUt+wi1yUZHCEvar+IP6q7zTg4mwwQJSMMDEiksVl9+hXqMSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mth2gorD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mth2gorD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCF6C4CECD;
	Tue, 29 Oct 2024 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730217003;
	bh=VBV0OeWnSAgVSRJ0Avj0cKI4/5CmGndl7PeolvJjAyc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mth2gorDB11/7H34gl5WlytUIwLeUX+sX13KKAIG8p++pJdqBBr/O2/3im+CyjDAY
	 j2Fk8D4Rgnc0bUcZlF42NCcSb8k4PwzGxVoFU1cCz01Rfj15Kbadqq/DsPG7Otsu5R
	 LMss5Yx8SIJTub4RIYM/aqHOuWuf6Aauo0NgN5ioh0kcUMSqdS3y2q3e6q2ylgKyXs
	 nvHFRkoTTN8pQJ4AkGFNZTzuuxzOXoFSTVQh4VmWGOdheHQR6enJwXa24WWnaHTQe2
	 H0RVf1dsNBjffaaCJgecDqmerBiU9WPZ+zKBGcGSOQUnww6RSbixdjR/6S38YMBJo/
	 7rR7HgWoK9sSQ==
Date: Tue, 29 Oct 2024 08:50:02 -0700
Subject: [PATCH 1/1] mkfs: add a config file for 6.12 LTS kernels
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673679.3129044.709345968312824752.stgit@frogsfrogsfrogs>
In-Reply-To: <173021673665.3129044.1694990541450985907.stgit@frogsfrogsfrogs>
References: <173021673665.3129044.1694990541450985907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We didn't add any new ondisk features in 2023, so the config file is the
same.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/Makefile      |    3 ++-
 mkfs/lts_6.12.conf |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.12.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index a6173083e4c2d4..754a17ea5137b7 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -16,7 +16,8 @@ CFGFILES = \
 	lts_5.10.conf \
 	lts_5.15.conf \
 	lts_6.1.conf \
-	lts_6.6.conf
+	lts_6.6.conf \
+	lts_6.12.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.12.conf b/mkfs/lts_6.12.conf
new file mode 100644
index 00000000000000..35b79082495d24
--- /dev/null
+++ b/mkfs/lts_6.12.conf
@@ -0,0 +1,19 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.12 LTS
+# kernel was released at the end of 2024.
+
+[metadata]
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+reflink=1
+rmapbt=1
+autofsck=0
+
+[inode]
+sparse=1
+nrext64=1
+exchange=0
+
+[naming]
+parent=0

