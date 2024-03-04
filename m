Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C377E105
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579559; cv=none; b=dIJBEeyEhEfjr9X+TkAlAvM+ph9I/t3S4SfCUceR35WKxV5l+a5ri+5/CjUzl7O9WSv+WvlqW+1dXSclTfAAMUC94ApEqllDHPlDtxNXpP2M6sPVXmyQuO4FbkWWYjlTB38aPE8znLRKOkBQ5swg61vtVDrUNc4r6EGpvhEOYqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579559; c=relaxed/simple;
	bh=Vv6pshJlKGTE98xSJNd6Xk8HKI+ZQ4JRPxzDEoR1Lmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw0YsDfU6QtyVEEtppzQY4wgLuF2ijTnRUd88SFK76Le02JchfZiIBJaRX3zm+MnH8bP0/jrW3+SgBQ8K6jYHuWDZHt/0eMnmqBwTeO9LvEMqtJjFMYjcU/+tlrb5QeQd+6Lf6m++stO47VW/rTYo2fZEqAPJpvh5+c7fmkhqXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XzW4L2+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzW4L2+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZV6cPRqKx5ix6M5gdtJYtyedkYWhw05+92IPp1Ctzuk=;
	b=XzW4L2+JTIf+Pffe8MwWmFgZyEdu6PvWTow+HgGdjsUta5DP15k17e362Oln+5lTquBEC5
	RSb/JhOLZVPfpHcmLteFXKu1z16B9NirY8Q4qLcvxoHtqqddUKGSRVfkBcJ4bexXjNV4Nv
	9k9kNsUcd5Q2jFO7eiEAoqmFAVBp6kA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-KLh0icTBNbCTwA6aptsglQ-1; Mon, 04 Mar 2024 14:12:35 -0500
X-MC-Unique: KLh0icTBNbCTwA6aptsglQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56698ef9362so2510771a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579554; x=1710184354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZV6cPRqKx5ix6M5gdtJYtyedkYWhw05+92IPp1Ctzuk=;
        b=or3fIOMzdfVAc6UEN54z8AaeukAR6EOFY2OlqsIrpzebrbmIN6XZPoIx3ryLaChZVi
         glESJ9VP8gnuwg0dkIS+KFbJ/K2I4T+eY8M50amjnGX/piCHpuLl7u1+PvuFYr9nsq7I
         rFc18S8lR3zGZI8EW63VY+Cn5D5JShL1kSlC1hxnSrm39Lm0GnmYB0fpsRDGCwJXc1Oi
         /W2m0n3dE6lI+rPHmYPN0CfvylqqgbMTQA8oMxEzj9IOrgchZAeBk5C4kCQmVA1SpNqj
         0kRCkkPZkvn29hdnr+V68ZJMl4f6RQrXorEV3/qPFYWb7ex3NKO6jhP0+zE4tmq1kWEB
         KNHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUogF3HNGjn/t+uxdDh9SoRdShhI7mYPBOBhTrL8HIRD9SJb56hB1pCZQ3qStodHdUra0/GHgkEss2g4sVXGfZgaopc97JVxTxy
X-Gm-Message-State: AOJu0YwEy7hjYclgVOzuUd8TWI7sUQqtVDshMRQN2KzA6vcS5NVeVsCT
	LAXT/BamA1Cq79qJGfipft59muP/l6gwlRLuRaeRPQfWj9LxwuJ6dB7M2iK4RMXF6+fIxaLIrQy
	70SRHK8xtw6z6IQkPYT8oC30LdcL5E0Asp78KvmyGu1mjZLq9W3ZM92o0
X-Received: by 2002:a17:906:a3cd:b0:a45:1f03:4f23 with SMTP id ca13-20020a170906a3cd00b00a451f034f23mr3215551ejb.52.1709579554820;
        Mon, 04 Mar 2024 11:12:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEr0NI1aFj9SyMPj6KLK6wqTh72eLYmQdqNJLscKrLdEp90sMnUKsBE06KkZVd9YcuteqLjDA==
X-Received: by 2002:a17:906:a3cd:b0:a45:1f03:4f23 with SMTP id ca13-20020a170906a3cd00b00a451f034f23mr3215547ejb.52.1709579554621;
        Mon, 04 Mar 2024 11:12:34 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:33 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 24/24] xfs: enable ro-compat fs-verity flag
Date: Mon,  4 Mar 2024 20:10:47 +0100
Message-ID: <20240304191046.157464-26-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
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
index 3ce2902101bc..be66f0ab20cb 100644
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

