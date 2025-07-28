Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CFC284B41
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734711; cv=none; b=g9IP5CkZ2RrrbyWzSktjZD0rleiQvKgaN6YL/tiV+IZrCpH0e2cp7s5R09atV/8TEeqEmfgz3HD+21ix7eWNURxY5QtYcmcoJMQ9hs42XPtPHrOT1IuwUiZRbnr2mdXHO2cZmm774BxmIWeHeHlPKe5JFohiMm52AisfVbYcuMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734711; c=relaxed/simple;
	bh=oXrYk89O0Um5P8PkyP0aN/fzstJe93VqP0YI02ddnhE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C+yW8svcS+V+ZyDqi7q+KHE2sTdg23DZdpBaZjw/w4tHrZw8Ef0IC/M2LC0i/4PNCd26IiJZ2VZeNc3ONnpEEAgbjQZTnP767S25wpwZ7H70uz+jfJ5T/3xppJZknNjA1SUUOknkV/V1VD6s5UbP/vrRbBRz3JrFx94BjHzo8kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ibNambPz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ibNambPz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/UHpX8nvBBvaUQO36ZKMY1wOJRmJ65rli9NZbFUt5AA=;
	b=ibNambPz6wnC6b4JeteKRCrARHbA+U4nAcAMNJPUceXru41mSC2Cde5KKJbNLtS+5LzXJO
	Mwq54/aEdZOep1+TDVJQwJckiM91Wm1jsCHN6aEQjS07oYDzpcN7ooCh4L2vjWz14s4pVM
	icmosm9LdQpGy21vzUWMAYz5VhArzCQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-208RyCSbPIyfcE9fq3WNJw-1; Mon, 28 Jul 2025 16:31:46 -0400
X-MC-Unique: 208RyCSbPIyfcE9fq3WNJw-1
X-Mimecast-MFC-AGG-ID: 208RyCSbPIyfcE9fq3WNJw_1753734705
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-61525af8a0bso1925099a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734705; x=1754339505;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UHpX8nvBBvaUQO36ZKMY1wOJRmJ65rli9NZbFUt5AA=;
        b=BwU2av6Lz+y/J1r/2vS3JjIPf3kuvCgdUG3VPzd/4oLVBXIkyUF3pDUIKP+kPCALrI
         M5qzk7d3K0Nd5RmdJ1TUW35AyjD/Dy2LXlu+/EXA0V8WMC80EKOEbGJZhQJuu3hBItLc
         QiZeoyTogA5a48m3GhHZARwit0nAcD4GAauQfUryXn2FedaE5KmYW84Oa9k4adrkJqDP
         Qdgi70DoUZc6HoFYZm53DbwROsJWsynXIkoXT4pvRcF7Myw/N3MM0aCCqtKtBu8ZpFm+
         Xg9Z1HrdjNyEQOx3PzmcObFvBS1i9p8HKhGZea9uSOcEIpzVu+j/BSejT87IuZrcYJSF
         kljg==
X-Forwarded-Encrypted: i=1; AJvYcCXMsPeshsnxSCMRVDKpjsBRh5Moto6fvhSG3UZn957xx2VrWmEBdvIxxQqfQX1CvHPCwAtqswoYs7s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzora/pTcZKlkqCPG3QuwwEOwG/1mJUt+7rHuM5bOZBXX1++HBs
	322QenTfMGuSCWmNYiwSETTqp/IOzEF+AxAlHsay0KL2/B6VJdaPuy8zBfF9f91HDUheT89+8vz
	anrol1V4a2MQs93yrRGBPNVgq3g10S3ySL6OhCeVJaVSwBFOWyNqjJPR+F8OY
X-Gm-Gg: ASbGncsQNQ0OLJb8fc1SiWZ4MdAB7m8oZxVmDK5N6goCbanCVPei/fTn/QtUeGZjsfK
	YaCBT6R4sv6dgOc+Puk1zGZQlVmZxGybbLlmT6IUPq0ckaOvq0uFlE/PX6+T7s7g2u2iaWmp6xZ
	UIGWhzrF1FkknuAmMjItlt2ipKvuPoqqzPIB2ffyvlXGF2sx6KkqtOHxSkatngEeYjbPi9LgP0I
	77gEwlZOC4IyO8vzXXhcbRgmdnQjQVhiddUSp2f77yvPLleXyENP3mK3r1UBIIcM4OZ6wlJu7qQ
	/NCUt+VrkWnm50cHRt8JDQw+M64B4u4SFGHTQI1t6gcubA==
X-Received: by 2002:a05:6402:1ec5:b0:612:a77e:1843 with SMTP id 4fb4d7f45d1cf-614f1bd4bc1mr12230475a12.5.1753734705273;
        Mon, 28 Jul 2025 13:31:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoDTzvEORt+zYj5p5DTj1JYCh8sm3pEhkMIx1xgTWgVgB7tdbLlFlIksa68FpKbUDf1D8onw==
X-Received: by 2002:a05:6402:1ec5:b0:612:a77e:1843 with SMTP id 4fb4d7f45d1cf-614f1bd4bc1mr12230456a12.5.1753734704844;
        Mon, 28 Jul 2025 13:31:44 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:42 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:27 +0200
Subject: [PATCH RFC 23/29] xfs: add fs-verity ioctls
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-23-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1235; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=1zT9nrTCecXTInwM9izpme0zk/YxcLuwcyE7K7v4l/w=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSUgKGS+eNzO21U7T/oLpxbM/FOT+TbixuChou
 0JdzLdShpMdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJlLey/A/ecr87Tt4lXv3
 TFp3aaKx/Mw/YmbHXa3ZXkxgr4ngmW6oxchwVew9d6SIbvOkjAPRH83lblz88svzXlqExAw+WSa
 H+Yo8AM5/RB4=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

[djwong: remove unnecessary casting]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d250f7f74e3b..589c36ee4e7f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1428,6 +1429,21 @@ xfs_file_ioctl(
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
2.50.0

