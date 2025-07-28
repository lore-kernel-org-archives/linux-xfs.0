Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2068527F003
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734699; cv=none; b=sTdDmZBehycVFNZRVkaRb6PNql2BqBPbdZMl3NQapTnTgwBNHE0wWkUhfaJX0oCS2682dAlTYEDglAULYrntfj9N+O06apG2jF8Qa9Dkc6zesd+lIkZtsqXWiGFQ5C2GITQfqZ+dE1pcQ9dsyJimCtrxHjjjE8ZOOq2//1GMGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734699; c=relaxed/simple;
	bh=FmQY0utR3EJKnbdnl2kWXdJsHs06S3lSSo5C32WL97Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=DJUb0iraGfrpRrAu3faICSN28819UtcRC9xBBHbxxLWtFuZ/N4sOahOGrR/BBZ373wV/noKs6v0NEXKKebVeXNmnZhvo8GviEUuMYFmOBzODmwaaZGWBlEJxywWaVYDaj4j87OGMwo+uZC/IMi9CFD8+1vlyhpQTz0dZ5g+ui1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCHfXx4O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCHfXx4O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJrJhTiKWZWizCb5vgJDR1e4Y3d90lblUc5COXR2wnU=;
	b=NCHfXx4OLcDwdk3WPc1Uz8UNMwQBuESdvj1USyC2mE+4tUmkPQmXNmqNypLhUaSEbBQ/gG
	i3L+dTbgMVbuOlF7M2nlt2wOGG0XCwt4UL/duEmMaaXh30raa1pO9On5mNwbYlgvC3g4Pp
	X8XtaGyJtuC/hO8aN2yHgrlD177dQ6I=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-RJmC42efNfmaCJvPJ_ilcg-1; Mon, 28 Jul 2025 16:31:34 -0400
X-MC-Unique: RJmC42efNfmaCJvPJ_ilcg-1
X-Mimecast-MFC-AGG-ID: RJmC42efNfmaCJvPJ_ilcg_1753734693
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6149374a4c8so226411a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734693; x=1754339493;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJrJhTiKWZWizCb5vgJDR1e4Y3d90lblUc5COXR2wnU=;
        b=CzL074Iu5TSTeOACkBoNx82deSRshLnRro9oT4YGpstq7o3xz2YwOJXU3fD9LFReAd
         NVd1Kdprd7AP53DnphcBYzGdKqMkETUFriXIvKO2x0qp/HMgz42+hlUa6tL+6ad+08Zm
         t1PQ++XcQYQy/C+iMtA2S5R/LQ6/zAdMRkYXDPq7AJ/wq3HAavpHvPxu3xkr9hXHAgX2
         H4xN2ueXOvCQf9lWZyXBOgxKLUBiyYdc4SmFPBeDlLlEwo1lshduyde+GKjdncJZ5VYQ
         z7PUuTstLBrUQiamfERzuZTB10pj0vjdKApYDvedmGvTy2aij8F0lrc2bqQCVTiz96B/
         aQRw==
X-Forwarded-Encrypted: i=1; AJvYcCWZEfnNVfCp1ff4MqlvBYulXoeNu2tO3LaBUTm2q2Y9Tp9qz1To8I+8qWB76RmzWa0zHCq2MhMnirg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7kdnu2WzqS5YgJConEAR15sgo1+c+d673amC9tETiqEsdi1+r
	psWFQvWwW42Ye9g4Tpul0+VvNCfvvPL0z/CTJPgMHytIpkw/33GyoLVLeGpqkS5pj3fKZXRP9uj
	7O4ScnYaDVwu1OJG8O5A4okSbjllWjKp/eadvl+4/r1MQxsFTbu+4yX1x/YWe
X-Gm-Gg: ASbGncsXY/M0S3SzhkrSHYYT4xLN2bs+qG2vrpB49jiQmhJpNxnb5ZFkOFxawGZVS9/
	nUHPSwbNz8ag2WbOL/NT4A3tlEzSAQxXXNdpEnVS+0WiDD0e+7oIuvYU2cF3DCSuN76hY96qBwn
	x9f8l43vVAh3JjvN3oAbyJTqb7s7r27Vv/H+yEtyRj7Rm25U4vGoeIVDa4eYfWfHWctk5pB01b6
	zDiG2Iiv6Z1473V8IBpwbdnG2XI+zNj1xEb5W1Fatq1KC+wdWJFBg8H6q2pVbsZNkj+5tjBnl44
	CW1z506ROiqw9PHzYVxo63CC19WnJfv/yvv9gIZQAFfeOg==
X-Received: by 2002:a05:6402:26d2:b0:607:35d:9fb4 with SMTP id 4fb4d7f45d1cf-61564414146mr767659a12.15.1753734693254;
        Mon, 28 Jul 2025 13:31:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEA5UBDZv2tek/WX1R6Rvm8MNzw4SMmyDGLfo9kmuBsv5oxLO/xwY0iTeJo5s1xCMBhuaSJhg==
X-Received: by 2002:a05:6402:26d2:b0:607:35d:9fb4 with SMTP id 4fb4d7f45d1cf-61564414146mr767638a12.15.1753734692828;
        Mon, 28 Jul 2025 13:31:32 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:31 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:16 +0200
Subject: [PATCH RFC 12/29] fsverity: expose merkle tree geometry to callers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-12-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2959; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=hpvpUPXPy1PD+AbFvGEt6YZjB0rOC9HnWhC0HEKd4jM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSeh1ljJs/hUucvPQjYw7y/pYvD9w7BOeNivVZ
 W1r1cRtoUs7SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATGT1CkaGWffPnqz4d8dV
 vzNez2FCk5DZrOt6922Dg3I6piqL/onkYvhfF7HsvMK6c2w3+ENMc8pjl1TlKaw89TilxlL+d1G
 wEhsjAHAWRkA=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Create a function that will return selected information about the
geometry of the merkle tree.  Online fsck for XFS will need this piece
to perform basic checks of the merkle tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/verity/open.c         | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h | 11 +++++++++++
 2 files changed, 48 insertions(+)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index fdeb95eca3af..de1d0bd6e703 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -407,6 +407,43 @@ void __fsverity_cleanup_inode(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(__fsverity_cleanup_inode);
 
+/**
+ * fsverity_merkle_tree_geometry() - return Merkle tree geometry
+ * @inode: the inode to query
+ * @block_size: will be set to the log2 of the size of a merkle tree block
+ * @block_size: will be set to the size of a merkle tree block, in bytes
+ * @tree_size: will be set to the size of the merkle tree, in bytes
+ *
+ * Callers are not required to have opened the file.
+ *
+ * Return: 0 for success, -ENODATA if verity is not enabled, or any of the
+ * error codes that can result from loading verity information while opening a
+ * file.
+ */
+int fsverity_merkle_tree_geometry(struct inode *inode, u8 *log_blocksize,
+				  unsigned int *block_size, u64 *tree_size)
+{
+	struct fsverity_info *vi;
+	int error;
+
+	if (!IS_VERITY(inode))
+		return -ENODATA;
+
+	error = ensure_verity_info(inode);
+	if (error)
+		return error;
+
+	vi = inode->i_verity_info;
+	if (log_blocksize)
+		*log_blocksize = vi->tree_params.log_blocksize;
+	if (block_size)
+		*block_size = vi->tree_params.block_size;
+	if (tree_size)
+		*tree_size = vi->tree_params.tree_size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsverity_merkle_tree_geometry);
+
 void __init fsverity_init_info_cache(void)
 {
 	fsverity_info_cachep = KMEM_CACHE_USERCOPY(
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 8155407a7e4c..f10e9493ffa7 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -166,6 +166,9 @@ int __fsverity_file_open(struct inode *inode, struct file *filp);
 int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void __fsverity_cleanup_inode(struct inode *inode);
 
+int fsverity_merkle_tree_geometry(struct inode *inode, u8 *log_blocksize,
+				  unsigned int *block_size, u64 *tree_size);
+
 /**
  * fsverity_cleanup_inode() - free the inode's verity info, if present
  * @inode: an inode being evicted
@@ -250,6 +253,14 @@ static inline void fsverity_cleanup_inode(struct inode *inode)
 {
 }
 
+static inline int fsverity_merkle_tree_geometry(struct inode *inode,
+						u8 *log_blocksize,
+						unsigned int *block_size,
+						u64 *tree_size)
+{
+	return -EOPNOTSUPP;
+}
+
 /* read_metadata.c */
 
 static inline int fsverity_ioctl_read_metadata(struct file *filp,

-- 
2.50.0

