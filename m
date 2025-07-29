Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555572882C3
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753786886; cv=none; b=aD8Q9iuaktlJSNplub0XpTiiTDwCrPtueYqkrB0abbURqrgzr1LM+zl0hA6kpModTdAuA3btc3QeMIYl9spkVlfBEoSMbGb1FmwYbsoZ+Ja2cVuAULtfuw0ma/cNkr5ewZnpy4cDWtn6x3ypHNB/R78628CLfZaOeBFRw6o2ZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753786886; c=relaxed/simple;
	bh=M4C9mRx9aUsFuTvMK09lioYc9TZ6UjANOHWpnVj/R9Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZeKdQo024Qx3Y+aRViKcWAWbPzLn9YSEf6uecNjSb/c2WVpiRfcmtLk/eN8dWfikI8WLPIPMguBTeFrUYGzwhScdo6ZcRegaAJRNcqfd77N/QJ03wanMsddfwDMwVrkzg1PlpRGJfpgB5psn72yKdiBM294dSwBclG8G4S4+tco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cl273Baz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cl273Baz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753786884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=So0AAPd1wRUvc21Guq0gQfnJ9II8dFSN8Y98fy5O3+4=;
	b=Cl273BaznhHuF5a+mgalj4knSOSycXvT5sQ4VOObcdp7IczWwZjhye1gbTXFZIV62NUTtG
	0BmKOTLQ8W7VeJnifZoc8qxohLx35PPyG4IAQD2QwGGglJeoKPsxyu26Nboc5qN+MladQt
	bGfeGfMjZpyyHepaiLvSfdrIKtRXHVw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-WSzW9xJkNe2I9aD_8FDC-A-1; Tue, 29 Jul 2025 07:01:18 -0400
X-MC-Unique: WSzW9xJkNe2I9aD_8FDC-A-1
X-Mimecast-MFC-AGG-ID: WSzW9xJkNe2I9aD_8FDC-A_1753786878
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-615145b0a00so1908984a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 04:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753786877; x=1754391677;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=So0AAPd1wRUvc21Guq0gQfnJ9II8dFSN8Y98fy5O3+4=;
        b=f74543u8qOC0cDcP4XsDZIyJnAcRrtSaleLZXwHccBLx52Z/CRkC99v0O/5qwNcBDV
         eLb5qFQPE6rEj2bKBuN6c6mSlyorlBi2wpIr1wJ77haHG1TbHFrlhTYx1/zTeiM4XDsu
         7ewY7fQ0h4xnzQ56xOCpmsd9IEW2icta1rOZg8S7a5B6i0Ff7KHJj4mrn1aJBTw+kuyT
         H/oBUHWko4sa8gLVOL4tZ4h5JRF/qDNjfxj++dSFrBREU/NKrUGCmC4VoCMEYWcOkiQa
         PGNhorB+AeTOk1zuY4bVL4ywomtDUGGLV89RQkVSyfa/p2PSeDuWjwaYYyP1NHU7Hrh3
         G2pQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlstATKrK/q1NyFpheW+/epgNP7zL7v3Sjy8XE7DuFQP2TArVA8SGY2CNtDwn32UIHCO+dr12KkDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRJxicxnga2Rdtd4nDpW2GGZmw1jrnc95tc4tvgxzoXSPx0Mjj
	0Y6PV1BffLsThToO3U0vIuKaTJie2+OBjOK1hz3EoqONfa521lJPOZmg3cMPqpstg6aQNJOhaTo
	mIWAe67FWXlZrld2yzpP4ZZi497ibZsHAU+ro2raU534sjgmFrnbTRHvixJYa
X-Gm-Gg: ASbGnctM0GsBR8J7gYRkGRhruyPIkS1PvfPljZRg/AJrqxP0X8ywAJPo3KqDIr/Vj4X
	HOvpuMDU1ifX93JBpHgJCxQRwJFgPaIF4P9MAR0HueyvYJ0xXzD+x5DrJ2ruo28V//KTwbfTlD8
	L1pSZ5LukB+7T5qxaUXQQE3M8PeY5r/e7LXfxpiokDn09T1MCuipafq4A22dQ/tPZIrUEt5FOPR
	zQvOhaScbLDje16lCq+vTn7v3fg7H1FKDP8Uqc4fUo9y+y8SEcSbQjR64IvQ2Uh/73U0qF2Kvtb
	sMMrpSbPlAEDvSb8exRHsGpifmdNC+nWBmk9FncgZXx0gg==
X-Received: by 2002:a05:6402:4412:b0:614:f5ae:61b8 with SMTP id 4fb4d7f45d1cf-614f5ae7748mr13464718a12.34.1753786877511;
        Tue, 29 Jul 2025 04:01:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEakdLJUx2nehTgX8ZDkDToqrT6AbOAQcPHQBUY7N+kToHIEXFYjthO1UEW+dYVztr4pP+dIQ==
X-Received: by 2002:a05:6402:4412:b0:614:f5ae:61b8 with SMTP id 4fb4d7f45d1cf-614f5ae7748mr13464676a12.34.1753786877010;
        Tue, 29 Jul 2025 04:01:17 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61563b3edd8sm1083884a12.47.2025.07.29.04.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:01:16 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 29 Jul 2025 13:00:36 +0200
Subject: [PATCH 2/3] xfs: allow setting xattrs on special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250729-xfs-xattrat-v1-2-7b392eee3587@kernel.org>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
In-Reply-To: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1495; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=ghW3o9D+GmsY48lL7mdinYhJBldhmXC3Xbwsy7mWVIE=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMjpW/nzvIW2zNO35/+4vXTdYg7ebHZpm8Sptd9PVp
 sZ3blwXPmd2lLIwiHExyIopsqyT1pqaVCSVf8SgRh5mDisTyBAGLk4BmEiOOCND6zYeufsqHmmy
 uhUTjtV95j329sJL2S9bPHLZFlTGS5WeZGQ4cX/FqnnuupselssIpP5OyyvmEbGdPWH3Vta3q9t
 WPE1gBQDH8kpb
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

XFS does't have extended attributes manipulation ioctls for special
files. Changing or reading file extended attributes is rejected for them
in xfs_fileattr_*et().

In XFS, this is necessary to work for project quota directories.
When project is set up, xfs_quota opens and calls FS_IOC_SETFSXATTR on
every inode in the directory. However, special files are skipped due to
open() returning a special inode for them. So, they don't even get to
this check.

The recently added file_getattr/file_setattr will call xfs_fileattr_*et,
on special files. This patch allows reading/changing extended file
attributes on special files.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fe1f74a3b6a3..f3c89172cc27 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -512,9 +512,6 @@ xfs_fileattr_get(
 {
 	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 
-	if (d_is_special(dentry))
-		return -ENOTTY;
-
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	xfs_fill_fsxattr(ip, XFS_DATA_FORK, fa);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -736,9 +733,6 @@ xfs_fileattr_set(
 
 	trace_xfs_ioctl_setattr(ip);
 
-	if (d_is_special(dentry))
-		return -ENOTTY;
-
 	if (!fa->fsx_valid) {
 		if (fa->flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL |
 				  FS_NOATIME_FL | FS_NODUMP_FL |

-- 
2.49.0

