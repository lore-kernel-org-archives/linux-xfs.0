Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214DD17B50A
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479611; cv=none; b=aKTajIDrGwIO+KyQP32FKatJ9X0pS55nxLEJ6UVdwITiL22MvnPK0QtO/PWxlCaaoTXIN5dnvydhLue32iCLF7VnpbqpD1wFzL7epOoSGMZKq+TuNkcu1hfzzUzIz/yiQiiwy0Jp0rHh44pf8HgxsK/mq3JsAnOmDXGK/bq5yrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479611; c=relaxed/simple;
	bh=iVAvD5S6+YCutnI9hQ8VPIEtzQUgRwMGkFQ+P22Z8a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5n40ZLYmeggCJYKXvWKQPnvicQRKTi3oVI65y5Qb3YTJXrHIfUOvvHY1k3uE+1lsXjjTyh1BRbux2sVAWbrrL2PkRaWonOu6AkH8gPVsZlINE6yaqPG81W9ku170QVIv2lqO3BWo+WZLpfAOSXtB8ayU5vSFDT+ezIOIlJBFXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vy/DTKPm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vy/DTKPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YElkSPrbhFHpSRjF4mCmp1Gp8kG42SIKQZMkph0MDjI=;
	b=Vy/DTKPmehaOujL6GCzGYJTqIpo/ANKeQLfTzOjqqO174Q2Vs6GXQ8Jj1Fvp8QEv+7q2ye
	1rGjEPdtTF/mOZ/JBt7cr/5IX3YHSnfjFHW7RDYDHYm0fhIXn+itkWOBJetiJ73VF/fUyw
	bkKmWYwZSqNFKk+cR6cF/xNPcM1pZ2c=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390--aWfsFsKOnKlSD_Fi9Q8VA-1; Sun, 29 Dec 2024 08:40:07 -0500
X-MC-Unique: -aWfsFsKOnKlSD_Fi9Q8VA-1
X-Mimecast-MFC-AGG-ID: -aWfsFsKOnKlSD_Fi9Q8VA
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aab9f30ac00so682893966b.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479606; x=1736084406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YElkSPrbhFHpSRjF4mCmp1Gp8kG42SIKQZMkph0MDjI=;
        b=IvbiOLQBTg6Pt9tondpHKogFR9ra1iiux0q8HcuOyXRAQNFBP7iNxHGAXoMrXTYHqG
         DdtW9fwVGKJYEKMzLIjbQVb+6yF5BYod7Lm6pm9fy23ycjo0Uj7FVVee4iKIj7BX6iJ8
         OI3a04aqW/ueQsLBBrI/IVc297EaLIjRYFmTRuvaJ57KEK9pJKTtyLWLMHndO9PPPDKi
         vtOUrILnLHJNpTVYaPNinZWh1J+y2YtPOAx0uj6ZeQLNdAsr9iyC6yfhxBpDYUeXwfmG
         0EPT3M2ZDLySEUd9DrEViLVyXYHXNNr6owEmM5M2wE2bP2FJfNGWCNjuMYj7UJgbQMan
         RLiw==
X-Gm-Message-State: AOJu0YzXCnyhWAyjbvi3/7AMI+UmsiTI57gfGV5KNQWbNNpz6XViW4Ea
	E0UuH/b7oXIaZuyO/RrpDW/8Y7ai8kEJDt8JBV3d2yUnBywTDE9TuuQZxu6Tk3vz/PQWDhsfl0H
	yP0bhE7qJXiR+dQr5QccFevqFBpDKA/kY543nAYOmJVZSI/YG/Jeusx4FXTJ2z/myWxhD38UvuM
	a04cgwLyRM6REFNI5LmLdwC78f+xvuUFuPIdpTToI4
X-Gm-Gg: ASbGncver8SV2iYuCYvyqQYoLMX8m7ZuAFzfiJUTKJJULk39mO759qIurpKm3+6bjTF
	qNJgI2L0hzKOC3RpV0mOiPe9EZ1zD//qHvIYddLeCQOcMZDu2PvfRYQmOvKc4ywXVNPNJZezR5w
	epZwQtiVExHMRA3fRZw9jkeqh1CKSus4XOC+Hra1Jm05tLfuFo16s8ujwCdp9WcAPYDUsJzHprH
	B1XRGx15GQNKLQZYrjSRMsfsqSaXm1IMtroRA6wbudZNOXQIpmVieo5m0rZ2JyIejDXgdqf3s68
	+NZ4d1O+dDO1ZG8=
X-Received: by 2002:a17:907:94c6:b0:aa6:79fa:b47d with SMTP id a640c23a62f3a-aac2703375bmr2936803466b.1.1735479606090;
        Sun, 29 Dec 2024 05:40:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE78NsMqEWexSxeC+63+yl7zVA9oxry3VtbaABTlYThWwLJjvBcHh9EwOIiyUvq8LI7f0YceQ==
X-Received: by 2002:a17:907:94c6:b0:aa6:79fa:b47d with SMTP id a640c23a62f3a-aac2703375bmr2936800966b.1.1735479605618;
        Sun, 29 Dec 2024 05:40:05 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:05 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 15/24] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Sun, 29 Dec 2024 14:39:18 +0100
Message-ID: <20241229133927.1194609-16-aalbersh@kernel.org>
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

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix typo in subject]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 47203b8923aa..d653ae6b1636 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1258,6 +1258,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.47.0

