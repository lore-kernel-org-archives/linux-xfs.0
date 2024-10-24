Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDF3156F30
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 02:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738310; cv=none; b=K0Alfl37xrxsz0HeKm+I1psQ8aqoM96s+YFIwFExvHRDPOWPVUs4B0BjSUEGq+rPuy5T/eqDQ9BBPaDNwCZm1yDJrMXvhQxkEvbPVVh1JngCbeH4/gFcSZdodiTnnPKj08ogIsF3O6sd+yICDlGMOQow5UlAzHd6Z/pMXdZr0pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738310; c=relaxed/simple;
	bh=nyxaXjxibPLkxtfS15iO+RIFH200dLD8L047DHbKGE0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA7YfsjDaddptuVq+PU8Ig+glHXZBJHm8trJB7UIblUc8gxuirULC323NnkQ6qFx29MGz7Tq7Z0PN2wbKSxljAKz7VvhLRE4JDM1yg+6t2ZTwxDvNA9GxVtqUeVANaXziNNPVv8rYhPbBqvJK4fu3B8VSu6VlzTVBChVxujwFLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=J5fxeqxg; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="J5fxeqxg"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20c803787abso3551815ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 19:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729738307; x=1730343107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkRyxCjHYDM6g1n8M11Ib1ZjfR2KRFWOb8n4TyMPoGQ=;
        b=J5fxeqxgElpj6nXNjT1hKBK2ncpAA/azTj55TnTyd2HAMzaV6li+HeObG9pgILrREq
         R09RbMA7hvfuGWPAKhzvvnWJdqqYkbirdni5yvCYZ3/Dm3Hb9rGcM1SBqb1cdRX12a87
         mSLz7/UcEmFNNkA1/DbbOhDNxzghejrvFBYkIKWFRWdexOe4wdvR6C/EXVXB5ioyjGlK
         2ovmohMxqGZiaUylGx5YJNjTPlG5r6YDUL5j+buGK203SMNCTOpa/yxyhDS8vJqXskx/
         OlXcpohGC3icNOBXBxAIhSXu1lDTrTg/HXIzYkyByurk5dAgNLBoLCw4jdJ+xFLWsURc
         twVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729738307; x=1730343107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkRyxCjHYDM6g1n8M11Ib1ZjfR2KRFWOb8n4TyMPoGQ=;
        b=ggcoO3O45GwTmC1CjDyE8hWpaVcA+YjeaDh+sQ2II73LHSlTAMblnpxCcYkMiS7XW3
         CTjZuxm4+LvyZj1BmeLx1pCi821hun/hE5liWfujDJ9jX4ub8aoydvdCFEEjyS6hkUlq
         LBKrFrTP9Kt3VBzHz8xmcRbXrDoXY14h/iC33HZZz2YOPE7JrpQHQmZIboc6FPDi0DEn
         D17papgk/a53h+Bp6Q4WvKMo9VQqlZkBNUlaUFUPR89FwEvFYMsqb4s0NxhhqxdeqTSJ
         tZgXoy8J9n9u9IewESfXP1Sd2aMIcoa0vWBTjjZh4LEd/to5im0shO7QsLgFqZqlesJ2
         7mxg==
X-Gm-Message-State: AOJu0YxM1P/eswzvJoX5l+PteFFndCG2AOU99X8Tgddcyb41uQ2BY+Cj
	ei9Vz+A1fh/e5NmcaArj4Dggz90YFBsh2RDrD3ISvIICSFZQo1O9nvKFludGz7tJFX4AiF0jcJX
	2
X-Google-Smtp-Source: AGHT+IGdMgQwsXbKWAPTlElAjy5H6OV4BIorh3qmkYX0770YfkAwM/wyWHqqqwc0/qCmKh+qsgy8+g==
X-Received: by 2002:a17:903:1cf:b0:20c:ad30:c891 with SMTP id d9443c01a7336-20fb88f3190mr7005045ad.10.1729738307416;
        Wed, 23 Oct 2024 19:51:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0f3ff5sm63596405ad.280.2024.10.23.19.51.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 19:51:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1t3nwt-004xNv-2r
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1t3nwu-0000000H7zc-1T2r
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: sb_spino_align is not verified
Date: Thu, 24 Oct 2024 13:51:05 +1100
Message-ID: <20241024025142.4082218-4-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024025142.4082218-1-david@fromorbit.com>
References: <20241024025142.4082218-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

It's just read in from the superblock and used without doing any
validity checks at all on the value.

Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d95409f3cba6..0d181bc140f0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -398,6 +398,20 @@ xfs_validate_sb_common(
 					 sbp->sb_inoalignmt, align);
 				return -EINVAL;
 			}
+
+			if (!sbp->sb_spino_align ||
+			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+				xfs_warn(mp,
+				"Sparse inode alignment (%u) is invalid.",
+					sbp->sb_spino_align);
+				return -EINVAL;
+			}
+		} else if (sbp->sb_spino_align) {
+			xfs_warn(mp,
+				"Sparse inode alignment (%u) should be zero.",
+				sbp->sb_spino_align);
+			return -EINVAL;
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
-- 
2.45.2

