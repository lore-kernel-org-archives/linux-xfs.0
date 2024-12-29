Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3661802DD
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479615; cv=none; b=RGKQ14usZhnlNuizEfhdSMHmfuSkxqBfoaP2q6cYh72Cs48Jtkx7lKoI6Jo6lE84a0DE0S7BI1v0do5hc+KxMDNNON2Dy73eCnUqap7LSw+4UI+3rUBHyCulcBn5Sd1jRd4zdHgOi3R2eYMVsVwDoHOv6EMEtFbyaFQsJtpKlvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479615; c=relaxed/simple;
	bh=k0IYQJKTdGPCEUVgwekBfv9miGMMNGcBQ3ZUmc2oHnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaB84HNkLpdN/r+oHiSrIDfwTbF4gIOnUEULZGA+aPAfNKWVDVycA6XyR36CGOkTxpZCYtoJCi2N0RyqyZ636V2wYSZp0ESpaHRIIXPHVlZTf6ey/I/jtsQ7yXaxDOKFCmb6Iu+JKnQCY3RPFdNTS5LE7ayBKm2aPGkvVijdNcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MOIS3q/q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MOIS3q/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IXYZ9D7xkG1mJFs0k/2a3I9IVQy9Tfy5TMzEFr6Qfm4=;
	b=MOIS3q/qgSd4Y8E24SCogMqS+dtH0qoVSuV6cOZWiAW/MBPsdhUKmwS5KLKRZb85qbHEC1
	CIGawvfTlfchSGUA9D6Rvjfq0bdzRY2whbI9mw6qFN+IzH5Qka4gBAyKo15MVtGVrrk51s
	FgNIPiQu1HBqBqXSX/YFEz676bp520o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-hHY_Zy7fMdiuXr5PpzgB7g-1; Sun, 29 Dec 2024 08:40:12 -0500
X-MC-Unique: hHY_Zy7fMdiuXr5PpzgB7g-1
X-Mimecast-MFC-AGG-ID: hHY_Zy7fMdiuXr5PpzgB7g
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa6a7bea04cso243785566b.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479610; x=1736084410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXYZ9D7xkG1mJFs0k/2a3I9IVQy9Tfy5TMzEFr6Qfm4=;
        b=b7G4bmxuSgNosU54uFujCa5C0VyYqxrRR5hwTYUZJzXbRcT9iJYT1wUQpPLONfzNys
         YXs+PYjXV5ZRg0wC7y0rRfPvKMwo48796hjJRG9GlVpaxlSVSnKsLgpRkcRi9dbdMVB7
         fbxS8fb1hNeEAUT8JqgZy0khVULZfJ069ygRMZrOvDMfB7GcbgPprXSNFxpo901jr/y+
         MhFBJCV5UidrKSqCeEIQAeIi+ANY2v+JxWUs25zWYXaDtrChQ/DIsS2Q9IlWYyEyG354
         Bnq362GlZEO5OsAFjiZA8JBIEYa21UlDLjSxleVHSszBI5vaIhrBh/24PIjjNUCrLy3e
         3QkA==
X-Gm-Message-State: AOJu0Yz+m9j33wX3TrHyfDDg/4EalWBgyo+gqRhBHf3qiPxoijsY+rtF
	sybW+WQ8Spx8/tVTBl8NsxoncTYjWa3vxBD9AxcZVqQksO7wPyu+KSHz3/z2BUL17Z1I9AEpXYW
	7gUQOnazjY7AZZ0X2ndP5zTel19Zc2QRitGwLuyO0pnL7ulebIqvRLFNJes7FJCACli0VK4yhOY
	E3PQ5eGDkDDJ0iP820AtyOBquLBxKMqijvY/dn5Fm3
X-Gm-Gg: ASbGncuiCFZ83bMz4tsWwXF037pKduoo3PwuV0FWVcHGZFYTvOp3j9sPkN92tUjXzlX
	kl/ddpclv5eCM1Os4x4RWXvpIZwcKi/fOM9K6DsdTUJbsLpAFbxmvNh9jKcvLitpjFrbln0z3N1
	HwwaFioFSCmaFFK3OgsefjnpNR2+sqidxLbKTk3WIH1OI/mNaCtLaV2ywo19tyYoSmlVmS/c5pt
	orZSSquy7Xh2Gs4Sdf4c7HzieM9YZj1SaZiioeXfsfyVT5rSlR5ORZ9irhugmf/1Xse9vmHvdJl
	mmPTwqiqEZx41NA=
X-Received: by 2002:a17:907:9812:b0:aa6:738c:2ddc with SMTP id a640c23a62f3a-aac2d4472bamr3192135166b.4.1735479610574;
        Sun, 29 Dec 2024 05:40:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeHX+ULyROg8ApWhEsAdG9LyJnC36OcQG57fxX/wMBQREBoHdtFiMAG+zklVDsz3G1zEylqw==
X-Received: by 2002:a17:907:9812:b0:aa6:738c:2ddc with SMTP id a640c23a62f3a-aac2d4472bamr3192132766b.4.1735479610185;
        Sun, 29 Dec 2024 05:40:10 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:09 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 20/24] xfs: add fs-verity ioctls
Date: Sun, 29 Dec 2024 14:39:23 +0100
Message-ID: <20241229133927.1194609-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: remove unnecessary casting]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0789c18aaa18..e62260a77b75 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1410,6 +1411,21 @@ xfs_file_ioctl(
 	case XFS_IOC_COMMIT_RANGE:
 		return xfs_ioc_commit_range(filp, arg);
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.47.0

