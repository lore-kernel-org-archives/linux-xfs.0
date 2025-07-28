Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE00280CD5
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734705; cv=none; b=BOo4AMAXlUA4h0gTW49q4/AmtqRebLg4d0C1D0rbqeT/i6UoF61LTi6VsQ7K5uHUitzaPspCg8FfsYRfhrHNSaBHspJH5BvkCV4cnW4O1D4fpB4YTptWGrFAVFe2nomcRkpV0V0wW4zp6k4l+tzF8cHvpNM2fcQr4OpxvWP7ziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734705; c=relaxed/simple;
	bh=p+EivlFaBaFeoVDU7+pqeo9nmnJY3StP+2lRZQjS180=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NCNMLZf/A4gVCZwVQUa12RlnYODWRtyiH2udbyV9FFW4QIGsMDkrI+UVJF8AU97WDY2KNr2vgvDq+2nMbg9fr1eNZfgxkUNG9kS1ikco39HXMpuT/fs6vt0ZFX6StoBT1TEYncngvQWR2xSmC3TSPIM6LlFo1/nugdcv2eQLnkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3TXAJVJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3TXAJVJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cahKNglI9xSwz5JIoCWs8VJvuAgbLUt85ayzIAcfs2M=;
	b=A3TXAJVJTWMtxJLeX4ZUM5ZcWVBIUD2sZh2896Yrrfq01b5LIeVfGWUAkmOvEhTW2Zm6DD
	iz0fTqSADuv4WwJE3wgY6ItLYmDSdDorC+HepbI4qZvoXQ/A3pUzw1DP050XtXy2Rr2Dqz
	HxbJJ65TWaXybvbZ6D3Y5v6kBkHnU4Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-8XDIV55sPaWwneNILsQMiQ-1; Mon, 28 Jul 2025 16:31:38 -0400
X-MC-Unique: 8XDIV55sPaWwneNILsQMiQ-1
X-Mimecast-MFC-AGG-ID: 8XDIV55sPaWwneNILsQMiQ_1753734697
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6069f1c97b3so3632371a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734697; x=1754339497;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cahKNglI9xSwz5JIoCWs8VJvuAgbLUt85ayzIAcfs2M=;
        b=ivcnOcGrN3QzslGhVahV9uBiHnKrKrwx8Y+bK9uLCzOnEc4//KpLsROkP4SbYhxKJc
         W1Kox9uBEqD3cFH1R/3CBKBlpoP12K4vo19l8nDyejIK+dt3QFxNpJWtKIV7viWINc7B
         FVx65JpG/OhhLs9Y1DiTe/xKxwOy/zZOIx6+F8jRrtZOKDchnuwv1zeGU48l+63J0Q/k
         +4IgQwQIXYoaV46tivDRnN3DJIWhV/s7m6q67iArnqqUSoLL7nAOw04XV8QDsSkA5+4/
         SO+j3yLVfYPJOfiIQ9dFhikMqs06l6Hecxt7LbyOgYMzwCBND0QVl2KGNIykLwXQOgsH
         KIvw==
X-Forwarded-Encrypted: i=1; AJvYcCUmjKqqA6x4tEBIwKPvGx7zls1muAxsUvLzn4JeFzcXi+G4m5a6Y8QllM39OA4oeFDDVHj9LCT8k1s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1vS4ndVFVHA45ISHpCtBg/ZH4e0PY6+IoSvi537m0eFtLOvGz
	GNpAendqM157ewf3NnDNWPUAjIlphH9Cb+MgbhGe8mZ2ECPp59qx4L7TsOMRSODpYUX3q23g5vS
	caqsTxkPTZKAxJtDQ+GUaMimUTjk5KBki4Up5BAZ5+W8cpEfFAcpn9NBiwrq6
X-Gm-Gg: ASbGnctf/nI4Dgb/qfxoTy6cdzbweOqmKNH5cMv15NjrjxZL+cAYlllrAy17kYqF0Pa
	Z0eFgexl47X2m5Wc5pbiTek56c+LK69kRK4gFOWcSqdru0b3ArzYWC9Swkgej5nIcQEQ5osNsAe
	0zxMzIXuTBFlnFzGduzV7TF5p00sNSCy5dyVC6ZqDBPDoixasiT3P9Dya8OdgFaZ0sVfJSGTkB6
	QeXhozxV0LfVrUrtcCzc3EOecyqkzZuaGYvUwaXNCvlUJidoz7raZuUo0v14vLc3zzuDwz42bw3
	L4FukBjGFoZ9sjQ8/LgDERlA45OXjF4E2mscCF/p5/GRog==
X-Received: by 2002:a50:9f2e:0:b0:615:6481:d1c with SMTP id 4fb4d7f45d1cf-61564810e79mr504150a12.1.1753734697380;
        Mon, 28 Jul 2025 13:31:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzcmjWUM4tpi80MrHyBmhwXTxuNdy0MV8CXOsbdaPmmd16rtBJCPyF/DGt45rhwcV1lVFnbg==
X-Received: by 2002:a50:9f2e:0:b0:615:6481:d1c with SMTP id 4fb4d7f45d1cf-61564810e79mr504126a12.1.1753734696666;
        Mon, 28 Jul 2025 13:31:36 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:36 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:20 +0200
Subject: [PATCH RFC 16/29] xfs: add inode on-disk VERITY flag
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-16-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3261; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=m7e3KU80TSoaoTV8cWB70CeLe0cQoiE7sYhyjk6qxk4=;
 b=kA0DAAoWRqfqGKwz4QgByyZiAGiH3hij/Y25S7p2LNAHxqYA/QuCWy9VGJpoqHH8+zE+gnFnf
 oh1BAAWCgAdFiEErhsqlWJyGm/EMHwfRqfqGKwz4QgFAmiH3hgACgkQRqfqGKwz4Qi7xQEAyOzq
 0tVpBYOt/aywWjtRFn5RiSek4KaoiY46bdpFz5MA/3rcD3MFLx77GDXprkoxi/dGg4SpG2nIt0A
 pYl3R+JUB
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

Add flag to mark inodes which have fs-verity enabled on them (i.e.
descriptor exist and tree is built).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     | 7 ++++++-
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 ++++++++
 fs/xfs/libxfs/xfs_inode_util.c | 2 ++
 fs/xfs/xfs_iops.c              | 2 ++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3a8c43541dd9..1cd9106d852b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1231,16 +1231,21 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DIFLAG2_METADATA_BIT	5
 
+/* inodes sealed with fs-verity */
+#define XFS_DIFLAG2_VERITY_BIT		6
+
 #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
 #define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
+#define XFS_DIFLAG2_VERITY	(1ULL << XFS_DIFLAG2_VERITY_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA | \
+	 XFS_DIFLAG2_VERITY)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index aa13fc00afd7..33a71f85f596 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -756,6 +756,14 @@ xfs_dinode_verify(
 	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
+	/* only regular files can have fsverity */
+	if (flags2 & XFS_DIFLAG2_VERITY) {
+		if (!xfs_has_verity(mp))
+			return __this_address;
+		if ((mode & S_IFMT) != S_IFREG)
+			return __this_address;
+	}
+
 	if (xfs_has_zoned(mp) &&
 	    dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP)) {
 		if (be32_to_cpu(dip->di_used_blocks) > mp->m_sb.sb_rgextents)
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 48fe49a5f050..8589ec44feda 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -126,6 +126,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8cddbb7c149b..83d31802f943 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1393,6 +1393,8 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by

-- 
2.50.0

