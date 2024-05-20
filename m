Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7D7C6C6
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223611; cv=none; b=OsSwuexi6og+UT1gIGNJ1d2Jjxv+9E8SFghCWOHOoHnnbZ0R1Lf+7rC+LG5x9bYzgR8ufgVCadrm0VGTjNHGbAhM/oSXfMb/y2tbFFUgHarXOUj1uCNJv6vtwAowx323tqsAFwGNKsUVhX48WbZ6oAD1jN+A0ncLMSmdE7XYzsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223611; c=relaxed/simple;
	bh=vmQ2RZzOAXcMFnAqJwI9gEIKU5whTvVL+1HY9/asXoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOqr9OD0FCuAR+FDFY0SH3DVr5qbJsHDmDQrOJXf5NVhS6YSGmR4luvSjGkovor0RVd4AhnIIbmu9847xts8ryanwnNR1wfzpVZbsdAbNOJhImuMpyFo+DYX5/Sg8tidK99VOYKqrmlYs+3x9cKQRFvUbS27KGOs8u+HOAfWCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZwDXnjYP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwDXnjYP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716223607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ma2q0HaixXoqU+Yv1j7uLrxclgoa/BmHR6s9hlQtBag=;
	b=ZwDXnjYPtIjqzqum9d2oFscJZHXtygUDhNmKW5GROGLL3wakeS7Z6zqJBdbOpKXYGOtfXJ
	t7kHNuuHDYE891y5ZrLIzznRoMhQHGeRvZQlwCRi0xV2pZNiyF34eNh/jKdkuauSbEWBkA
	+/9NHwXnM8jmfHJgkjVSNFXc6T+iI2Q=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-j4oKqbX4OvCKb_aWNKqoYA-1; Mon, 20 May 2024 12:46:45 -0400
X-MC-Unique: j4oKqbX4OvCKb_aWNKqoYA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a59a17f35c8so732163966b.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 09:46:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716223604; x=1716828404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ma2q0HaixXoqU+Yv1j7uLrxclgoa/BmHR6s9hlQtBag=;
        b=tjiItgElgKP8GRMekBgVD9AHJuM/A6Y/ml7z057iWeYQsvZqAHdq7zFW2v1ojfTufC
         wW4EvH5Nfb203WFQCk+sUoVxb8kG8Z8sfddpUiAdXcpRIfLU3+BshK02kM7lKAX7SxZE
         61T9bmv5rBji1iYJDdVyrV2g3Cnlvn7Fr+II363v9RMlpzjm0rgayKyercKg8aw5icMP
         nmIAf5cGR0KPLy+Crvbm1WhExuEzjFdQT+GXACbigPXsAKHXOsdjen9q9CdoTCypWAxk
         59782mggturTewPuLBKBOPKeK8aMTpvy76jawG5VYS4/3NwRS3kbnqFH5JvKTYftGIru
         hW3g==
X-Forwarded-Encrypted: i=1; AJvYcCV5QgcTT6RHDulYNefz8bvaMFM9XtU6oqNZ4AQvM4A2ezWRU5Kfx3k+ionwc0gn7m4fuQ4wVVqUpph7oM++eyLBZ2DUGjIt/VJy
X-Gm-Message-State: AOJu0Yy2oihTN+AsKLesi58As2m8qbgtkP/QIS3Pq19jFS4yOTZ9vkCo
	lAevgjNWBa7wxpAKcEiaI+vQ2/lWPOyqv4NmuUNDxIsd8+2JOtb1EaHdu2WSPNotYpUQxaCowW+
	aALW8+HTclxTRr1xiyaYo0qleE99UMO/X3xb66tT2BxQqPpXy19qKnBcF
X-Received: by 2002:a17:906:6882:b0:a5a:76e2:c2a8 with SMTP id a640c23a62f3a-a5a76e2c306mr1371370766b.23.1716223604180;
        Mon, 20 May 2024 09:46:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQbzL2IUZ7TqGYW7K+SSSR6MaHYKue61QHFUN9QosNc5m8X+OJnkD30A35E9ai6IfJjIfNcw==
X-Received: by 2002:a17:906:6882:b0:a5a:76e2:c2a8 with SMTP id a640c23a62f3a-a5a76e2c306mr1371369166b.23.1716223603727;
        Mon, 20 May 2024 09:46:43 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5df00490cfsm318872066b.159.2024.05.20.09.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 09:46:43 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2 4/4] xfs: add fileattr_set/get for symlinks
Date: Mon, 20 May 2024 18:46:23 +0200
Message-ID: <20240520164624.665269-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240520164624.665269-2-aalbersh@redhat.com>
References: <20240520164624.665269-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As there are now FS_IOC_FS[GET|SET]XATTRAT ioctls, xfs_quota will
call them on special files. These new ioctls call
->xfs_fileattr_set/get. Symlink inodes don't have operations to
set extended attributes, so add ones used by other inodes. The
attribute value combinations are checked in fileattr_set_prepare().

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff222827e550..63f1a055a64a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1199,6 +1199,8 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.setattr		= xfs_vn_setattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
+	.fileattr_get		= xfs_fileattr_get,
+	.fileattr_set		= xfs_fileattr_set,
 };
 
 /* Figure out if this file actually supports DAX. */
-- 
2.42.0

