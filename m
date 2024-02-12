Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1F44596E
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757230; cv=none; b=mKWeu/ou87WWTJpJYR+BFR5mx+MtT6AjRtY70j+KgCGyRzBFplkdl5HdxeFox+A/JSVtww/FFHZuNxoYwLe3LDH8ULf1YaH6MNmrY9xUxRUnC+6/yITfHbwGOtwk7q+GL0Qf7VexJypYfFsVl/gc2klRi/46POvNWBOwoe94pK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757230; c=relaxed/simple;
	bh=YOeOw6KtPMpEfhCDXm/Z9NhM8n2QAyzwIfav1+RaVLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TIpV1YobEdzuSJzqdT4qJGqZTrV7sOkhEp2Dps8etFvOTW96s5vixDhwyJVRe7xllGrRTaqr7BuINRrfagOG5oLjyWM+q/Gp2z8J3RxcwmYAQBfu2Y58c4mutwQqqlRpTNnV60DB2S4yPpTnpnwhuDCUVN8Haw1qRfUnm13elbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HeVzG6ZD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HeVzG6ZD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9e7oB1ZKkqE1/ExZ0FRyhaGlyLumWOw/BjQhwlJ8uVw=;
	b=HeVzG6ZD6r+QZkdyxX79L+niT9h9AzMpxFsnRAtYz3BfdDFrCTlBSz4FdLsL27nk0QWmga
	Apm96JyJjnMKoeMISolI4vqsaW0LxUnVZMjuvC2B07AQreZ+qOo4niAl0P+fVYKjh3+EGJ
	D1j0MpJTjv/beZDxn8U2D0fT5cN9i4k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-K1sCvspyMreRic8bScy19A-1; Mon, 12 Feb 2024 12:00:26 -0500
X-MC-Unique: K1sCvspyMreRic8bScy19A-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5605a2937d4so2492632a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757225; x=1708362025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9e7oB1ZKkqE1/ExZ0FRyhaGlyLumWOw/BjQhwlJ8uVw=;
        b=Rda4Y5yjm8/qCFJQktXtrBzjywUNMH90GZpCmn/xEyc5KsssCcc3ipAbUb9su51Vis
         AJ5JVyTC4Cgtg+12XJMAIfZXSXhNrfd7VKiBZ2A6rBDH40Q1gPz9Uw56C+o7OEZ6+gzd
         RwK8W150u8Hn549sOU1CngU0mv8BBpA/6UKnP9p0zOooE23rDOk4pOW4Sby4s6RNMwB+
         agnunpHD0UC7W9YCHgSldBHNeKNdW03+63Ocow9BdFQkPcMllE5SMJibPONNHjJ9Yhkv
         BRbsDO36n5ebm52wVA8fbsNkLJjUdX55N85Wp80BDTtkln8nN81fr3HcDw73Xwmplu1e
         S4kA==
X-Gm-Message-State: AOJu0YyfAQV/P0BEDWew+VXvV7wD1IZ8KCJQmJhUNYneRgjE74S+wEEB
	b9LfWAk2bT6fjHaIYbv/EFjr1uIv6V9zrodb7So05XPwEyzogvGnHvc3ZeGtzuAI7DYNNHXPHlL
	kf/LJoYvxTwaYZceXy7EEWCyveD7tuMFd5sZKEtlnmdtn8TMSwC2opImP
X-Received: by 2002:a05:6402:b86:b0:561:8bc4:b05f with SMTP id cf6-20020a0564020b8600b005618bc4b05fmr3774681edb.0.1707757225308;
        Mon, 12 Feb 2024 09:00:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFvE/KNVEA8sjxOeGFkeZw+80fBpxWhXZhf/YA0PJnuhaTIDH6fJT1TzvZ1+/5L6O1QV86bRA==
X-Received: by 2002:a05:6402:b86:b0:561:8bc4:b05f with SMTP id cf6-20020a0564020b8600b005618bc4b05fmr3774674edb.0.1707757225103;
        Mon, 12 Feb 2024 09:00:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUxhzEnZsbrIW5ntwlAso9rR1RXR6wMwsKLEZAURItKAlHxOTZpXXk//KErSQyBEO5t4xpAXZ0vDqA8X2RcFIRn9WnYwXDIqu0P7/Uu3jI+3Xltem4uDRgS1XTxukmgySaw5GZN7IDa1Vy6tlSgmkVRkyb2IOkF9bpHxYkammVkHBpqRcckWFuXKg8cP+kXzYsWYvz3HRagDyByWyBO6s3AHde6Xr/froZ0
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:24 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 25/25] xfs: enable ro-compat fs-verity flag
Date: Mon, 12 Feb 2024 17:58:22 +0100
Message-Id: <20240212165821.1901300-26-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ea78b595aa97..0cb5bf9142b7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -355,10 +355,11 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.42.0

