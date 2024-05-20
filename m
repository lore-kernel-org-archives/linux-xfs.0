Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CDE7C6C6
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223609; cv=none; b=CE/PEkLp3b9qvLLNRBg+NOQBuommvtNxKRGPN7VE4GwWmRYOLrPXyZFM0c4A25EoSfjA8OAJCmPLVU2QA34HMjIVlBmanBPGxpG1Zjqt/W7k1h5xVYPHLZ9dAhMdYN/CrbahF1JXbptzXtqAc+Kp1qKavW4z5fFkQWRkMrXbPBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223609; c=relaxed/simple;
	bh=mkrG/YG97IhZX08WJoTg8Am6V3go3zERxJGAAyANROM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k56vgdU+N1A+9pE10R7Po4XLILbHGLKf2Nar0p35ScvDc8dd9pEHRwV/bmqqoTEiKey9Y9pCRBYOLOYCGe8Fjk/UcVj0HBCCrUksSi1ih2NyVZnbhBfowWqXJI3MTCvtI//Cn0J+GJ01HUCHAVxGBZh43Isg+4M0m6nASnrb6hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfebAx+E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfebAx+E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716223606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jxKnHArgqISJftS4bn2IeTsfhFcMxrcBBKx2HU6xLc=;
	b=HfebAx+EVVc+PKOMWQGBLv5wvTmwNcRltS5oCjWXchRLyKWPjGuL1pIRiksp4kIu1c4ixV
	Y8SZn1/EbUeMErNv5ZnP9qhgDJg9AH/HxV2ZuftTVLRyaYw0SpuzW6G8kP6etptQ8GzR2f
	Nc0PfvWDvMjQFabElrupmJdpnvb+UXE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-ZmlfSnnAPOWLMj27yyZhhg-1; Mon, 20 May 2024 12:46:44 -0400
X-MC-Unique: ZmlfSnnAPOWLMj27yyZhhg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a59a0014904so685240766b.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 09:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716223603; x=1716828403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jxKnHArgqISJftS4bn2IeTsfhFcMxrcBBKx2HU6xLc=;
        b=CEB8f38nVMAGOzblUOQ0Q6YrP+Yvce6aPqya5UQXs5Ns4oOXldj95tHx/R8q5cwCcu
         ucH0XoJKHZ5dYoYbXHcf973Lo5h41o5l/So90ePqhw6iaEEaAEqsWVOkdp8Pu60Wt75F
         t8xz9DE40VZ0JTfnB7YAh4mMT4fnz8KkgmVhV2J0DPm4GO8vDK9ZZSaa1JpMj1bJEBqU
         AJ+EsT57tdqxKH2MnivGFIDff7jjOYX8NYhLUc3xjAa7zi0WhIlu3OVb5FCB079il7GF
         +D1fMFI3/tDwvly8JqIZ/YQILcJ8xhZU5RqBoppkAjNy3uO5hsz/s32rjiNCIrzdRaJ3
         8qjw==
X-Forwarded-Encrypted: i=1; AJvYcCUEzKdhdDipi4x5TeC5UvdIdybWQWv8xTZPDdE8v2Go/6GdkbtHYj/aETPaCEc3atlhUgWeKHOGVOwaAW1OllMfNacbGOZPMg4f
X-Gm-Message-State: AOJu0YwKhJSO7myoUjtZDWtFxTsK1f7QCBRaDYa59wWi73N0RQxWKCck
	fMuqoeRIgz5N3x1NiutxDUpTywPy5WUGrOWFJZgBN59G7VYYLRDBqdI/NLO/eDwKkaai1ymZ4bn
	fmrTsutkC800MBK/l5rQieDlWPy92vYzyx2krknqVsJO2/1MnQrBGt8Tm
X-Received: by 2002:a17:906:f6ca:b0:a59:a0ec:e02d with SMTP id a640c23a62f3a-a5a2d53b08emr1642865266b.8.1716223603388;
        Mon, 20 May 2024 09:46:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKsN1Ca9Oy+VPqruQtdHDZgorMnecfIWweVEvQxfx8HVKUScciqwN5lGVVPqB5e74kDInYWg==
X-Received: by 2002:a17:906:f6ca:b0:a59:a0ec:e02d with SMTP id a640c23a62f3a-a5a2d53b08emr1642863466b.8.1716223602811;
        Mon, 20 May 2024 09:46:42 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5df00490cfsm318872066b.159.2024.05.20.09.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 09:46:42 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2 3/4] xfs: allow setting xattrs on special files
Date: Mon, 20 May 2024 18:46:22 +0200
Message-ID: <20240520164624.665269-5-aalbersh@redhat.com>
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

As XFS didn't have ioctls for special files setting an inode
extended attributes was rejected for them in xfs_fileattr_set().
Same applies for reading.

With XFS's project quota directories this is necessary. When project
is setup, xfs_quota opens and calls FS_IOC_SETFSXATTR on every inode
in the directory. However, special files are skipped due to open()
returning a special inode for them. So, they don't even get to this
check.

The FS_IOC_FS[SET|GET]XATTRAT will call xfs_fileattr_set/get() on a
special file. Therefore, allow them to work on special inodes.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f0117188f302..adedfcd3fde5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -459,9 +459,6 @@ xfs_fileattr_get(
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
2.42.0

