Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A94C342510
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971300; cv=none; b=XolZTo1R/FNJFkfNDdZ9c1qUZ+kMEnUyR4K7XoJmemGNURnZgJ3tCg6H1BeGKdKn5xzpEf192Crs92F1DS6A6baoI+ff5b8M8f9oGiniHzMfQmtfCPGKIBHh0u46kjfcDyAq/1hllatuoB4yRcKmxsZ6jNQZ3XC1sSplpxY6a5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971300; c=relaxed/simple;
	bh=P8PyXBJvaLalNwdvqikarY/L2FfXg7GHP1atwhp5i/c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=loannlr9cYNnr7zBuMPy3dtk1AwJNbXQ3ZftxjD9rMR/4WgeaZCHlfg9frJEfEkiLZvdlZMQtnQnlwb77IiEI/8GyG2U8Xiy02myPlFQUOXS+C/bgB7oWNHCKtpt3mj5AT5E6N1eZ7B9117NaialDi6Vw9HjutTJ97sG8GI2bWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYRp40KH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYRp40KH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39B6C1F000FF;
	Mon, 21 Sep 2026 06:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971299;
	bh=Qz9tFGId0fjgEv1P+sx+L1Z/IfN6unwSTe2y0e4shw4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DYRp40KH0KZZRq2Jwf/6qbHmkss8ejBKp19zyWk7fe5V7/DyWFRO4FVVGJaZZPgTy
	 uD8KL6yPAReKnoimaQdVqxC1Fzpa+0y+h+QshH9LfHrcOmjzM/WZp8vf7ANoVoBtW4
	 eR3FJBe1aVuEFMbaK7Rdv5du05K8lwwVU+D3UkFE0Jw4oGUF862z46mWbi5IMKI2VR
	 F2OYeCI9t1WX60N1f1ypefm0zWYhfgi8zsXNicAZFRFTs7VBJhuEDa69ywaq9B9gHU
	 4YlQ7Az2ONbA7eISqmf7GUhfqab+rM2JExiqcdzjq/3mV6NHtzXx1c5QHBLW5NerCw
	 Bq2KNRonj1wGQ==
Date: Sun, 20 Sep 2026 23:14:58 -0700
Subject: [PATCH 2/2] mkfs: enable metadata directory trees by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996057932.169776.10273479283249698738.stgit@frogsfrogsfrogs>
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

Metadata directory trees were added to XFS in Linux 6.13 at the end of
2024.  It's now been two years and we haven't found any significant
problems, so enable it by default.  Sysadmins will now be able to have
persistent quota options instead of having to encode that in fstab.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |    6 +++++-
 mkfs/lts_7.3.conf      |    2 +-
 mkfs/xfs_mkfs.c        |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 927cd075bf8a5d..ed5b0b45149dd1 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -303,10 +303,14 @@ .SH OPTIONS
 .TP
 .BI metadir= value
 This option creates an internal directory tree to store filesystem metadata.
+The value is either 0 to disable the feature, or 1 to create the internal
+directory tree.
+If enabled, quota mount options are persisted across mounts without the need
+for respecifying them.
 .IP
 By default,
 .B mkfs.xfs
-will not enable this feature.
+will enable this feature.
 If the option
 .B \-m crc=0
 is used, the metadata directory feature is not supported and is disabled.
diff --git a/mkfs/lts_7.3.conf b/mkfs/lts_7.3.conf
index 16d1c40e8f8a88..13a2bd33c99068 100644
--- a/mkfs/lts_7.3.conf
+++ b/mkfs/lts_7.3.conf
@@ -9,7 +9,7 @@
 reflink=1
 inobtcount=1
 bigtime=1
-metadir=0
+metadir=1
 autofsck=repair
 
 [data]
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index aa87951db0d041..ffc4ab9746c80a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6147,6 +6147,7 @@ main(
 			.bigtime = true,
 			.nrext64 = true,
 			.exchrange = true,
+			.metadir = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

