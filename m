Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041D4158858
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479619; cv=none; b=sYgWBw9wrlBqhD+Xqu4tpddnX5YJQAc3t/Lw3zcg4iDf0P44J1z7BeAHeW50sGIChN5gZA4TYqdKrxEc6Pd8PMf4nAINlgm3qKDTG5ETLyJzevX9O4462/liyli4HGM0CKuipP2uU396ZlhkHk4gcDRX7eMDJAgqfioUj7wyau8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479619; c=relaxed/simple;
	bh=YoRoL1TBFcrSncyWJhCTPMkMdg0wun7X0lTpOFQqTrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ij5J3KY634EUlPx904F4TUehoz6OF8QDFpzF7pT5bDnDR5D4kP3bcPejQqHBo4/GftMfbyJci4oR1qo/tESvE90XRa/eiqHf1wgLgDYh57b5P+DCBLlUZxFzcXUyMzojkQg4r4Magw5AXVA7202CL75Uk2s6lTU0NeTr8wK8H/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nl7Ztbtm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nl7Ztbtm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=taqbHKqNQ1u6e8lcdtpbfFyqmFmBX0Dm3LL6BLSroSQ=;
	b=Nl7ZtbtmT8kCuXLXdhnt1t20DXHT0UMKxjfVi1/HIxjVLUIBRcIezMeoySIFmoWZpF4xO/
	qHPnM57RL/WINY3n704PDg3Ni5Ma4sDm83aWkULNheMsoiracYFN5Utm/hUeBbTIxjAjKo
	h5/uRmSGdrRt3BfGULx7rIEKiNPdUzQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-WNJQDV5TPfmK_CDmEzlZnA-1; Sun, 29 Dec 2024 08:40:15 -0500
X-MC-Unique: WNJQDV5TPfmK_CDmEzlZnA-1
X-Mimecast-MFC-AGG-ID: WNJQDV5TPfmK_CDmEzlZnA
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa680e17f6dso627508666b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479614; x=1736084414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=taqbHKqNQ1u6e8lcdtpbfFyqmFmBX0Dm3LL6BLSroSQ=;
        b=HdM9iqQrx3G0a1DAPDVOeUq99CjT1Co1cWFo54o9DcGIXtIZq+B74ONc2vLEXzO/pu
         pC+lixU/q8tnL3ETO4ZRrJn+TO15gvWWdabFodoF/Zxe/tqmHEGrl12xzPUtzWQSCD+Y
         w1aDyyxJYCLzTonekY6NIQGGKw/H2wbRODnW+2bu8kpRMlH8c2YBsNgbAl9fwYgTEKe1
         vTYJ9kSPZ6SIYzobCrJHPDhsfd6YjTigkk0FHRhTpQk5TweX3+dBEpMoH9ONbnpMIibb
         Iydd3JmH2+6LH3DGzjWfXFE8y4qlKtHD6d6k3e0pL6b0G9o18bxZYvsVVmmcUQDvpEa5
         N6Xw==
X-Gm-Message-State: AOJu0YyenGG5IIx4ugQQVmOsgcCoueNM5K15rDsccig7Y2NkgMw2yW7C
	LZ8uu45Nlt7IeyAisbXA10AAIEoggTDCqbzWv01txaBCCi0h+wRtDHtJWOEXYQ7dy1ND6J8CRaq
	Ig3s9FqH+YNkAs8LRivBbWfA9KYEQqbxZIPrV/u7ZRZfXjzaA4W8xB22MZbe5WpTSjmdh4rF6b6
	UcdYgad+2KycS3J8mNrhDIKHZ1/F7RDRo1YRO0Ch+r
X-Gm-Gg: ASbGnctHc6AKSw34k4kRas1noXNMiCjgR/KqsyinDKPzdnVWV6UaZD+It5XbJ4iHlO1
	FLi4oo9nVnUv0ykMNGY3sg5fWrciCopb8sCmc0z/ggqLyNkaqsHLx5HDzAq3H1U4BjNeaC5ykkQ
	q4Ce9PkEOtpZznG68qgcWLkn//JbnkOM9aE+HkgX2Gyw3J1r1LxYLKWjHFXFvA41A5ODbmqinYO
	tmXPvJeYz11c5Yv+HRqJtBi994lLAEGIPvNR08Kgbe/OAw/6umvss5DU3lFemOyw7nPAXVJOT+V
	o4eblqf37jGsWaE=
X-Received: by 2002:a05:6402:1590:b0:5d0:d818:559d with SMTP id 4fb4d7f45d1cf-5d81dda6576mr79196111a12.11.1735479614439;
        Sun, 29 Dec 2024 05:40:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZaSB1sdlMJNh7UtmLHUBWOFvkI0R3B2hLOii6h/vXB1iFeL49kZCoKJdUgMolq1KMTBJc3g==
X-Received: by 2002:a05:6402:1590:b0:5d0:d818:559d with SMTP id 4fb4d7f45d1cf-5d81dda6576mr79196057a12.11.1735479614109;
        Sun, 29 Dec 2024 05:40:14 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:13 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 24/24] xfs: enable ro-compat fs-verity flag
Date: Sun, 29 Dec 2024 14:39:27 +0100
Message-ID: <20241229133927.1194609-25-aalbersh@kernel.org>
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

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index df84c275837d..6eb10300ff31 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -374,10 +374,11 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT	| \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT	| \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK	| \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT	| \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.47.0

