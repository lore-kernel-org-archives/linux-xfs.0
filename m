Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD29074431
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710436244; cv=none; b=MyJ0ySh777hK9VyJ+26r9+OsG0O8wQ7x+7XXypgc+OH6Une/mdZufbskdA9nI1XiqrCKWPmBhxzhZke8kgspcCcUtAgb1lQ6P6RqzSD0iwv4c3wpZtnpAaH8vJktKSScbPjZYLn8BzsetWBewnIKfUDqk8MywGkvcOKuG8Obc/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710436244; c=relaxed/simple;
	bh=TyItB/hAYM3pBtSHA6TUbqO5G1iY4oZ8BvSG7S1PdMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uhdA1cKBjdevgofkPnjM4V58j09lgqVwgodDvt6x/zzHctNu1qEJbxtv1OM63bNltivALhtmthtQ+magxJkRmcbBhrOmkcpunH/NQflw+EYbEuglslQwIs1mDuRy+Bkgc5Gi8bTwFMXRZ1vSECTA0QFUWHWq+aHZqn1kBHvfXQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3Yz10Ej; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3Yz10Ej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710436241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nglP/KsI47mDuSUjIPZ3C/44ECCEYoTczUhHN4ODHLg=;
	b=I3Yz10Ejt3mosv5EphVxxz4VCL1ZW3fRGzvPI1r/3sftkIPWgy/6OQRDCDCWXKnmSmrkus
	K9f14Zt7X6F0uFXOvHBME3DY7TZXYfrumOkGsJP8MCbc/OZkIsTFQC3FzFA6SZsXTGG+6V
	h1sTie+pSiAfC2XGLkaN9uxh3sfqqWc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-hspDlBahPryeu9EJIOTH3w-1; Thu, 14 Mar 2024 13:10:34 -0400
X-MC-Unique: hspDlBahPryeu9EJIOTH3w-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a4679ce1706so31545766b.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 10:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710436233; x=1711041033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nglP/KsI47mDuSUjIPZ3C/44ECCEYoTczUhHN4ODHLg=;
        b=GkUUHJkVEAo0i2hJobWOA03zSUkF/SY3PR1hpMnrYeAjO3seRlh0wW/0DjviFia1BE
         V8o2drNTXvmv2NwXgtHnQDFNWqMFLK904BDH6Lsycdifj8/BmhcQy5sHs9Pe6fcp153/
         Y4Douu81aKZRwj6imfQaSpoqEm6kTioJc4pmo5sPgPaCRI59vvHJeBBaaO5JpVq3qPvR
         LvKnCWdTye67fzksEaEYmnROrB+w1rZlLOYuCW/m7fndaUKBa2OZNlboV2ZpFhf0qAjP
         7ZtXCt5xMiEIo5V3jNqJbLmEXVW7KFo3oW76AxC84ayKlEceaLuE55RTQ7JzDLztqQl0
         FIiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3FHA8cRfnxdA6zlOrgfLWfXJSrbplz7iLLuu0SHCMS8St0JYywI1zIOkllGXh/Dx5C9QOT9tKKJDTZL9jil0Lv5HfD/4IdMKD
X-Gm-Message-State: AOJu0YxvCvvFkO6YCvwX4BZ3vcm3Mstoal92tZFm3JwINZSkX9njHTK8
	N2V8oBWG7zpNT2GiN4qHAYdgsVe6V/NVfkyyLWjP5sUC329XHTRf3BnJFyQ0epMK8yW0T7sb8D3
	qbd5RlCn067ryULpMQg0PcxntPsunxnhY/LM8Ur7NV+qg6rojIJWDzut+
X-Received: by 2002:a17:906:6858:b0:a46:5f1d:f357 with SMTP id a24-20020a170906685800b00a465f1df357mr299968ejs.10.1710436233426;
        Thu, 14 Mar 2024 10:10:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvPIcNkko9NH8iuSw0lecUD6Jh90LB+MmU7nCy0xCAvv6LMzlZ3Px9WFVsLc0xgJZghD3x5A==
X-Received: by 2002:a17:906:6858:b0:a46:5f1d:f357 with SMTP id a24-20020a170906685800b00a465f1df357mr299935ejs.10.1710436232695;
        Thu, 14 Mar 2024 10:10:32 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id v19-20020a1709060b5300b00a466715aec4sm885899ejg.96.2024.03.14.10.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 10:10:32 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: david@fromorbit.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2] xfs: allow cross-linking special files without project quota
Date: Thu, 14 Mar 2024 18:07:02 +0100
Message-ID: <20240314170700.352845-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's an issue that if special files is created before quota
project is enabled, then it's not possible to link this file. This
works fine for normal files. This happens because xfs_quota skips
special files (no ioctls to set necessary flags). The check for
having the same project ID for source and destination then fails as
source file doesn't have any ID.

mkfs.xfs -f /dev/sda
mount -o prjquota /dev/sda /mnt/test

mkdir /mnt/test/foo
mkfifo /mnt/test/foo/fifo1

xfs_quota -xc "project -sp /mnt/test/foo 9" /mnt/test
> Setting up project 9 (path /mnt/test/foo)...
> xfs_quota: skipping special file /mnt/test/foo/fifo1
> Processed 1 (/etc/projects and cmdline) paths for project 9 with recursion depth infinite (-1).

ln /mnt/test/foo/fifo1 /mnt/test/foo/fifo1_link
> ln: failed to create hard link '/mnt/test/testdir/fifo1_link' => '/mnt/test/testdir/fifo1': Invalid cross-device link

mkfifo /mnt/test/foo/fifo2
ln /mnt/test/foo/fifo2 /mnt/test/foo/fifo2_link

Fix this by allowing linking of special files to the project quota
if special files doesn't have any ID set (ID = 0).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1fd94958aa97..b7be19be0132 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1240,8 +1240,19 @@ xfs_link(
 	 */
 	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     tdp->i_projid != sip->i_projid)) {
-		error = -EXDEV;
-		goto error_return;
+		/*
+		 * Project quota setup skips special files which can
+		 * leave inodes in a PROJINHERIT directory without a
+		 * project ID set. We need to allow links to be made
+		 * to these "project-less" inodes because userspace
+		 * expects them to succeed after project ID setup,
+		 * but everything else should be rejected.
+		 */
+		if (!special_file(VFS_I(sip)->i_mode) ||
+		    sip->i_projid != 0) {
+			error = -EXDEV;
+			goto error_return;
+		}
 	}
 
 	if (!resblks) {
-- 
2.42.0

