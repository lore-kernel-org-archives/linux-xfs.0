Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF91531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479553; cv=none; b=H6grgp0CFtsvi7EKQYMxyD4LsFkr8PYhnV7lKKy4ng+HcxM9lceR+qpgTaTUDQ2kxBNoAof8R29Z1U6sMxtWY/SEE75GmmKfRJjtxNDPwDL+EORZ8guaHkJdJybS/3/QGSg/RW3DL8OgEHIo/pNqog8VjJuG8MQED5zZyCS7Cgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479553; c=relaxed/simple;
	bh=3zha2mVjvSiLONh9VkK94JPvtZiYkkS57TdNFCuYMSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8yO0lGetoWKc3nBJf5TbNHnZ/GPB7qk6ZF0jaFngG+SGAjRCfK5V9NeZotCKDS0FjqiZwDb5toZ6YaxNJhcQ8YIWWNntdi0Lhhy0JD9ul0Q9elMBYszFS01RyyRhEyqwuQSOPPY/Dax8XfVLeMxujDA9LGviiO/3qvYFvOzaXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fz/+a0DK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fz/+a0DK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5b8P8+8ryCRE/uHgy93N1n9HZ5fMNhiJhoyUXPFs1ls=;
	b=Fz/+a0DKnmxP/4P3KhFbTSXLozo+vI+WfGhNj+3obvv+HBhfiHw8oeEdaY1K8sssTTrjX+
	m/zUjipRkJFaOEAQmRC0oR9a5wC1hB97kCHh2N+cKzmxbXlNY0N4l5HYKPj4swZdbL+iUn
	UAfR29Qo2ixAPjAgZZ24Wrtn+CTD0gU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-lfaeC-BgOI2Ly0Fp3RlnAg-1; Sun, 29 Dec 2024 08:39:09 -0500
X-MC-Unique: lfaeC-BgOI2Ly0Fp3RlnAg-1
X-Mimecast-MFC-AGG-ID: lfaeC-BgOI2Ly0Fp3RlnAg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3862e986d17so3770799f8f.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479547; x=1736084347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5b8P8+8ryCRE/uHgy93N1n9HZ5fMNhiJhoyUXPFs1ls=;
        b=X5ApYSmj4aBImYmssjumqQuV/qh2an1Rqg22waADGeyBm3wRvwBbFm2M1/mGL6Pj+K
         QyQSxcFzBatSqT73G9UWgyhm09UEJ299QrlAHE9+oRbGP5qMQ3FWz84caPfL94UPd9Mh
         u7h7VAcS7ZS84EpnLEY01irJRh3d+WRBNZtIV67zN73mwpzfq/BsbCd9/wqkWY+y6gKu
         D1ZikxG6zS4DtQRqJq8DrhED4R6UOGgJ5aizj5I8FtsKyqwIo137f2MjVMYBI4x49CWG
         ov+jEGFBunI2/aOFpQ3BwDPos8EQmf80bbD5F4LX9m1+VRCyXjUy0EKviFORiEq7phvi
         SJvA==
X-Gm-Message-State: AOJu0Ywvp/3CKyWwgVv9gs8V2WPpNlpihc4XEJcMbK9FEvtDdhcol5MW
	igAB5SJZIGufzNGEfau9T/Id/yAy8bKIfb483yujnrKMvvmKmTwgXr6s30r/Rpi92tmoXHFDwqP
	j4iSkZBLy+WSBxSB3Sdg3ZqGtEgDrHTX0cSZKvaVkrVN5Q5bSLiIsRp4xFfL0yGnSPXFl0+NjfN
	e1v5MS5MAEhx1LjxOCaDZHJj7SBI2nL5uhfwIvL3sr
X-Gm-Gg: ASbGncvW8tctewKxprf3k+NjFGnJK5/Xb0PoBqSJ4YYk9sXZxxK10C1oGMOKHeoEYsu
	PJGBa+j5qWQHvVpv1b+GZ/AkFKok79oCt7yMPThlJ339S2GZY/XPj8fP/C1IxC9vGc91GNtOoDS
	p4mSN666uiOIc7dOPgYBXQdWweGR6LgLG/P2spdvHXKgxtG/YQqpDt1goRa7cArWMe0xnrtlf5l
	lg0AYILTIcc27NmPeJ/INfXTm+nLkVlUHatstoYMEOqs4ZvYZ8/ZRV85Su32XR4anAIm062Ky8Q
	wxpawlBahh4jUmc=
X-Received: by 2002:adf:9786:0:b0:38a:418e:bee with SMTP id ffacd0b85a97d-38a418e0e33mr9145568f8f.42.1735479547518;
        Sun, 29 Dec 2024 05:39:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXwrMBQvqmuujgBztiDukwzUFgvJPLJm4B5g363CKvis8dYYG6Wyt1ZxEqRLP2ZLVI/xcFGQ==
X-Received: by 2002:adf:9786:0:b0:38a:418e:bee with SMTP id ffacd0b85a97d-38a418e0e33mr9145556f8f.42.1735479547124;
        Sun, 29 Dec 2024 05:39:07 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:06 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 12/14] xfs: parse both remote attr name on-disk formats
Date: Sun, 29 Dec 2024 14:38:34 +0100
Message-ID: <20241229133836.1194272-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new format has ->crc[2] field. This field is overlapped with
anything what is before this remote attr name, for filesystems
without dxattr.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index bf0f73624446..4034530ad023 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -781,7 +781,13 @@ xfs_attr3_leaf_name_remote(
 		xfs_attr_leafblock_t	*leafp,
 		int			idx)
 {
-	return (xfs_attr_leaf_name_remote_t *)xfs_attr3_leaf_name(leafp, idx);
+	char *leaf = xfs_attr3_leaf_name(leafp, idx);
+	/* Overlap xfs_attr_leaf_name_remote_t with anything which is before.
+	 * The overlap is created by ->crc[2] and is not used for filesystem
+	 * without DXATTR. */
+	if (!xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_DXATTR))
+		return (xfs_attr_leaf_name_remote_t *)(leaf - 2*sizeof(__be32));
+	return (xfs_attr_leaf_name_remote_t *)leaf;
 }
 
 static inline xfs_attr_leaf_name_local_t *
-- 
2.47.0

