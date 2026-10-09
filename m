Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D513CF698
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590023; cv=none; b=uXDWEyzFL9mXTYKJ9XWi+BJ/+65g/KOWwmjTDOe1Sddxk6FKIzgEOd2YPw41JtfTTG3MKYmDjk60ewPrCEz1ahDtds+xcURoESJ1sa10z+ip7MPWzAYOfFjbl8WXB+N/Mch4FOchXzUef8diqFWjvB3+UjV1NkMpqijfcKUUgfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590023; c=relaxed/simple;
	bh=cVEpg+naP2PGl/jKxkZgMwTOlscKZ9lmSl4eEsMhWvI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XW7jhGU7xbHPNMlPhh/0hPAekhY/TJCr1/G64UGEIFeP0HzBhhO/HuAz50b5VtIQQd5yNYAUSmfnEh6S1Je/6k7JKP6jU+jj/se6LvusXx54eTz1D/a1PJV0Mtb2RNe30vGAb9x7EnO17Wz/vZamD2B04No6NjFlPiLFlV8ICFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBbZPv3z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBbZPv3z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A21201F000FF;
	Fri,  9 Oct 2026 23:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791590022;
	bh=rpeAz0xUalI/p7LFQ3DYCkbcL5C+6TXBi8h3akm4Baw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NBbZPv3zE8JdUFqW9Kvd97G46vg6I/bNISzrugXENkRiOzufgHvX4uSTS5aC19xJt
	 Nf+Uf0PD8t3b57w0G5VPXchRRKf44XEZZXUyGRonz1wrFCzEW73253GtoZDMOn62ck
	 SDZqZbMGqtdYOic9lL0xWgHQ9ANZBX8tbGqCbzh8hF99XpKfv1MBIUflvt/xQvxPvO
	 jcD93vWEwYxTzKJzcAQ4eHttmcvlw+OGvL+OrKMlzh33JgswjrOnwB6uMPPJFeOPPj
	 u3rpG68wE3ZmzC+tnbEAwurag21hMA5qc/fR4JXUX88fn++NYfRaFy07f4rWDeAV11
	 rbzV7jaXTrFjQ==
Date: Fri, 09 Oct 2026 16:53:42 -0700
Subject: [PATCH 3/3] mkfs: enable metadata directory trees by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179158948337.3720929.9620901680652749422.stgit@frogsfrogsfrogs>
In-Reply-To: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
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
index 10fc00c2251b7c..3fc113a07a0c0c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6145,6 +6145,7 @@ main(
 			.bigtime = true,
 			.nrext64 = true,
 			.exchrange = true,
+			.metadir = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

