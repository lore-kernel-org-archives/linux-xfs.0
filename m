Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EDF2192FC
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 07:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746602985; cv=none; b=iCiCOIBz+wV9KFrfzThi56o4kS+JVkPAX+kI4ujgQIwqGaM5h2/kUwc+yHWQpzmyn6g/oEBxSer3W6BtrpbqFjA7aycq0n+FAYLrgvgV3Zhgvs3nB9nxLGwTZ17YVDYXyVKV7/z74vvQM/iRRWacg1J+u0wTJFw3TT14F1ZZVaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746602985; c=relaxed/simple;
	bh=PKYvn2JAsmfed3V+zJHCbP48UmEcoaXuDdT2AQZ4i0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dehqZDW2SRORFIrdBFGcwpYcXDX2ezZ/wlulgNhtB7Xh6BLmuXdnPS7MDUdAHdRWP05UdM98JiwLEZtst2toD98zIeblEbz9D7Jz+Aw2ZLa6XLRJtokiUzXhD3V7izYSGhnACyiUE8tCRg328MNqfnDxAALxD6hUeElZAPfwctA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lfFoogZe; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfFoogZe"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74019695377so5382121b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 00:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746602982; x=1747207782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M+rJLqioznTAHlMFfn4o9fzmjIZqO7LMXZl8iZuWdBQ=;
        b=lfFoogZeiRgMD5huxHfikjzijhcbFeXbhTdTPqrjngT5118SZ3LIuBvor5DJPnTj6J
         NV4XYp4VryJxw6n6FCQmjruwMOSK+7sudkQuPctGHVpVArFig1FvVcJOvAd9ijgIo0cS
         GG5bRZ7JLwO2NIDpiQshN3Ws8rxitLvVALTKc2AB/rb0PPRZr4iVIWuku+NZw0Zc6n05
         CeKLoDyFUAG858h1ZNbKy3tpMgQTKNHH+MzTYaTHORKrWjWfb29WZecYa1Luz0CTf6Ei
         TBoFfvJFFjwTBh2KLj1dW0Kn7g+MApIJugG7tCLIHxA/QqTEA4isxMPSwbzm2hT4pEaY
         eYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746602982; x=1747207782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+rJLqioznTAHlMFfn4o9fzmjIZqO7LMXZl8iZuWdBQ=;
        b=Lr/Csn9E9FWFWHTNwhTb1Udg0OaquRQs54x39CDn9enMru2+cubgfg1ODj07M3R3nf
         7VtLG0cYNRVytbTiodvj3dOwgBswGuugLGb6bwhEmDTh+CkBnbqTS95g12++cu8a013p
         5x87SsF8WxIcz7DMZk/5ESgF/MZJbP+3m/DprS9R4GjsMKo0DevsstGHAOL1sOriAgrP
         g1J9YqnfrfTNG7wMF0AsydECcpJ9DcEE3TfhVu1GfsXG7YSGodmskV36Djf8B5CsxGyS
         GgEYuWYV8T5yBsJD6fEOMB7I2U+UXS1XuNZ8n7TN7rBFVxSZHRHbzlIMnOfTEcj1Zxnb
         jLZA==
X-Gm-Message-State: AOJu0YxYkzi/7w4UttZFfUh5bmAeOV9Tg22KDO+59JVxgIdz/OuuOllU
	oN//QpA9G4o/QRbe9KhVQgYO94w3W2z/7OmIy8pKVBM5AEA3CBL6rnAhqQ==
X-Gm-Gg: ASbGnctZW8T95CIYHJ2Tm8wyjC/rdTnT6Uxxe3l3j77uQuxL6rwg4waBpu9XaB4KkYl
	SJLZWYyNKyVrDavhzZ/3BtThIDid7bshx835tZbpm1NzQDNVPByiOR+P9wvnUGl6SX1QNcRiD8f
	WQeKp0SGjaXA8YPnVRQwjVawe4Sg40F21WhwNW0KBwEGgCI0shESYtWloDaOVCGPQogHCpfjW7I
	XG2oAAdwVpdMDL2yDi+EaZtfiFbcEjX9BTLec3Gc6sDVNEOf+ukZdmv3omAG+BZS7MGjyG+8b65
	izP0UinBXbVb7TJ6a1mR2m4ZMv3tWXPLKjEykB/R6o3NC43Qjf83b4s93pT4TBvfVFFojclS8/y
	PpKKRKIndlNvIaQ7CtYmu2Hg=
X-Google-Smtp-Source: AGHT+IFjNnrzgJQEOQOvLh5/vB6wk9KtYcXohhYwwtLn7Nt4NJc7c+Egd963Tk28/z9/mr64ItINog==
X-Received: by 2002:a05:6a00:3485:b0:739:4723:c4d7 with SMTP id d2e1a72fcca58-7409cff0c67mr2980780b3a.22.1746602981932;
        Wed, 07 May 2025 00:29:41 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.205.34.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7a20bsm10768512b3a.10.2025.05.07.00.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 00:29:41 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	cem@kernel.org
Subject: [PATCH v4 1/1] xfs: Fail remount with noattr2 on a v5 with v4 enabled
Date: Wed,  7 May 2025 12:59:13 +0530
Message-ID: <9110d568dc6c9930e70967d702197a691aca74e7.1746600966.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1746600966.git.nirjhar.roy.lists@gmail.com>
References: <cover.1746600966.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bug: When we compile the kernel with CONFIG_XFS_SUPPORT_V4=y,
remount with "-o remount,noattr2" on a v5 XFS does not
fail explicitly.

Reproduction:
mkfs.xfs -f /dev/loop0
mount /dev/loop0 /mnt/scratch
mount -o remount,noattr2 /dev/loop0 /mnt/scratch

However, with CONFIG_XFS_SUPPORT_V4=n, the remount
correctly fails explicitly. This is because the way the
following 2 functions are defined:

static inline bool xfs_has_attr2 (struct xfs_mount *mp)
{
	return !IS_ENABLED(CONFIG_XFS_SUPPORT_V4) ||
		(mp->m_features & XFS_FEAT_ATTR2);
}
static inline bool xfs_has_noattr2 (const struct xfs_mount *mp)
{
	return mp->m_features & XFS_FEAT_NOATTR2;
}

xfs_has_attr2() returns true when CONFIG_XFS_SUPPORT_V4=n
and hence, the following if condition in
xfs_fs_validate_params() succeeds and returns -EINVAL:

/*
 * We have not read the superblock at this point, so only the attr2
 * mount option can set the attr2 feature by this stage.
 */

if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
	xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
	return -EINVAL;
}

With CONFIG_XFS_SUPPORT_V4=y, xfs_has_attr2() always return
false and hence no error is returned.

Fix: Check if the existing mount has crc enabled(i.e, of
type v5 and has attr2 enabled) and the
remount has noattr2, if yes, return -EINVAL.

I have tested xfs/{189,539} in fstests with v4
and v5 XFS with both CONFIG_XFS_SUPPORT_V4=y/n and
they both behave as expected.

This patch also fixes remount from noattr2 -> attr2 (on a v4 xfs).

Related discussion in [1]

[1] https://lore.kernel.org/all/Z65o6nWxT00MaUrW@dread.disaster.area/

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b2dd0c0bf509..58a0431ab52d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2114,6 +2114,21 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
+	/* attr2 -> noattr2 */
+	if (xfs_has_noattr2(new_mp)) {
+		if (xfs_has_crc(mp)) {
+			xfs_warn(mp,
+			"attr2 and noattr2 cannot both be specified.");
+			return -EINVAL;
+		}
+		mp->m_features &= ~XFS_FEAT_ATTR2;
+		mp->m_features |= XFS_FEAT_NOATTR2;
+	} else if (xfs_has_attr2(new_mp)) {
+		/* noattr2 -> attr2 */
+		mp->m_features &= ~XFS_FEAT_NOATTR2;
+		mp->m_features |= XFS_FEAT_ATTR2;
+	}
+
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
@@ -2126,6 +2141,17 @@ xfs_fs_reconfigure(
 		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
 	}
 
+	/*
+	 * Now that mp has been modified according to the remount options,
+	 * we do a final option validation with xfs_finish_flags()
+	 * just like it is done during mount. We cannot use
+	 * xfs_finish_flags()on new_mp as it contains only the user
+	 * given options.
+	 */
+	error = xfs_finish_flags(mp);
+	if (error)
+		return error;
+
 	/* ro -> rw */
 	if (xfs_is_readonly(mp) && !(flags & SB_RDONLY)) {
 		error = xfs_remount_rw(mp);
-- 
2.43.5

