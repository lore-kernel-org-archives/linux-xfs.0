Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2869322DBD
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431566; cv=none; b=dIsxlxpT2wuzMKLCgtDHT6d66KEYMPQe6RFlgZ7+Dvy7Fg+C6w7ZJ6MKuVh9ekanCqAQZSl8a9e3/Lgb2jmzRfJpVU1vlPVkFtC2TigBxu6d7yAXNFrp1vfH7OE2ihPvojEMw+klpTw32a88mLNW4gvgaWTW2T7OD6W2loMjyAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431566; c=relaxed/simple;
	bh=O+3dGIR/1DtiE9KLcFUY0iaC5JbpkqVOUBN8aCmD/gU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 In-Reply-To:To:Cc; b=lzs+ybGGwnwGQsCWMs7fbj1wI556+C2nU6jdKMYw1nV9ET1FrL5WcnaVfKZCbYtQGbZjGETG5ZQJDdtitcDmuAOtLc9+lMJMcpfK0i0ovJZRAiC9fCKZZMSy79AQfvZVp8lSf68VeS79ZGAka2CxnOnVvW/WFunJ8HXyAcNBa84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lh8NLYba; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lh8NLYba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=z3WZwo/jaWWU1mgZkjIF7n9gEjSRZYhoi1CAELphjFM=;
	b=Lh8NLYbancC6Bz5pyrKA0k51uWf6Et1nz2VkB1sW1Y1m+IrjtAQRQYXICogrvsUd1ITL7U
	9gb0WUBKDO/OdlE8x1BhVXpzufaNYiPd2TPgX7rUQR2pKRNitMaPYnjdBrO+NtDwVpyaMu
	L3TW3b8T3/PCkuknSb5A5okR1pVsCDk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-5yRf215APbmjevs47URSvQ-1; Tue, 09 Sep 2025 11:26:02 -0400
X-MC-Unique: 5yRf215APbmjevs47URSvQ-1
X-Mimecast-MFC-AGG-ID: 5yRf215APbmjevs47URSvQ_1757431561
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e753e78902so380599f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431561; x=1758036361;
        h=cc:to:in-reply-to:content-transfer-encoding:mime-version:message-id
         :date:subject:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3WZwo/jaWWU1mgZkjIF7n9gEjSRZYhoi1CAELphjFM=;
        b=NzS0B+hR3S+ewqbv8FmkTNkokx2VXTqpZeI7D+1ah7U9p7DLpSryYuwL6bVHpG3cil
         NmrjSIgq/ffomFdFkXH5f879CgWKkydR9BoRr0L9O4a4kVI8yWy/iykQLraSsok592Rt
         8UynOIH8lyRG5sE4NSi4qf9ERfU621F7fIMM43W6SAeiMFm9xPaIiUv/rDwMUCQapSJk
         G7CbezumeZQDKrK+AeGfVvd6wGGsj+AonTEKfIeCV2BzkRBFGWWiO1wvvSDrT+zbExps
         tzE000AFTikBs5FXuLIOHy8Kh2XnuckErkzBQDpbuigsxGd5KRfNW+bPAHsZa0rMKrmo
         gbwA==
X-Forwarded-Encrypted: i=1; AJvYcCWcpAwaTd1elROT5U1qrdlEyPAfvYLX3UtTEpzhng0PpdMiWt9AAwcQtgwou+ZqOgjYBhBZN9Imrvg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk3S2bAnckcpNjreCmrdJmYizwfF0n1BVzoz+iDXf9x0w7+K8d
	B2YKfc1bIUt7hAYDF+d93O0vFVVEFRyJ647XXGCtun8W9qITGt+Lu1IsW0eXjshqARD7CKb+92e
	D0Ly7FDCLvKHWw3QNLgU2mbqvrtIzDHESVuk4Z95uOr/UillaPK/Bk7sukU/ln651sXlSXD9bkq
	0A5YJDmtAhvyOaRbELaSO+el9YpI0Ax7w7cEK4cdh28qTXysU=
X-Gm-Gg: ASbGncvmaV0OITDwatQONCrmx/EVKMFlMb+iT3Icc7ssCHvqCYcsw5TCOEgx620nJJ6
	ZX9YW2kntKKGGq9w0bxRyVoPuE2n1D8Lp8WW5reL1Y/e4qvjfUyrX3ZMoBKFQ1FSMxJfLoxrC6S
	9FrZxnj/C/9h/FHIIb7GKcWTOsPBqKTYHyibl2l2z0ld49SJZD7TdkT0uHHQEBknmI31TmV621C
	vHUn6kzZ8ufsJKekPd5VU+5LKCmvJD3GU76+ULfXZyVbhIhwVC5Lay79HimznSzyeBHJHCKmNig
	fFyQvNJrY347s2BcdiDM2y3da0s0ocr7qtDfq2U=
X-Received: by 2002:a05:600c:5304:b0:45d:e110:e690 with SMTP id 5b1f17b1804b1-45de110e75dmr90886485e9.14.1757431561056;
        Tue, 09 Sep 2025 08:26:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHS7BPzwjcjGF4v+qJMawvK/ZJPMgzEV0RZ5/MJh+kj7pnlazKDSanzwhxINAYPZk4x6NQDbg==
X-Received: by 2002:a05:600c:5304:b0:45d:e110:e690 with SMTP id 5b1f17b1804b1-45de110e75dmr90886185e9.14.1757431560561;
        Tue, 09 Sep 2025 08:26:00 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm348550005e9.21.2025.09.09.08.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:26:00 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v3 0/3] Test file_getattr and file_setattr syscalls
Date: Tue, 09 Sep 2025 17:25:55 +0200
Message-Id: <20250909-xattrat-syscall-v3-0-9ba483144789@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAANHwGgC/2WNywqDMBBFf0Vm3ZQ8qqZd9T+KixAnGioqkxAUy
 b83tcsuz4F77gEByWOAR3UAYfLBL3MBdanAjmYekPm+MEgua65EyzYTI5nIwh6smSaGqF2Nsm9
 QaCirldD57Sy+usKjD3Gh/TxI4mt/Lc31XysJxllj+N3enGqd4M830ozTdaEBupzzBwQlO/6vA
 AAA
X-Change-ID: 20250317-xattrat-syscall-ee8f5e2d6e18
In-Reply-To: <mqtzaalalgezpwfwmvrajiecz5y64mhs6h6pcghoq2hwkshcze@mxiscu7g7s32>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1889; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=O+3dGIR/1DtiE9KLcFUY0iaC5JbpkqVOUBN8aCmD/gU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMg64sxvuEhd8/7rz60KmDYvm2kxqMTSYyrLbeObKv
 qKIg59SFlzvKGVhEONikBVTZFknrTU1qUgq/4hBjTzMHFYmkCEMXJwCMBFZYUaGrcYLqrepHDvi
 8mtyyoqCqybJec0+YR+FE+/sWq2zevcvKYa/ostD5LyOn5VhP7pAO92vNbzFP4Hte+5MmWPzbE6
 7vtbiAAAGI0Y4
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add a test to check basic functionallity of file_getattr() and
file_setattr() syscalls. These syscalls are used to get/set filesystem
inode attributes (think of FS_IOC_SETFSXATTR ioctl()). The difference
from ioctl() is that these syscalls use *at() semantics and can be
called on any file without opening it, including special ones.

For XFS, with the use of these syscalls, xfs_quota now can
manipulate quota on special files such as sockets. Add a test to
check that special files are counted, which wasn't true before.

To: fstests@vger.kernel.org
Cc: zlang@redhat.com
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
Changes in v3:
- Fix tab vs spaces indents
- Update year in SPDX header
- Rename AC_HAVE_FILE_ATTR to AC_HAVE_FILE_GETATTR

Changes in v2:
- Improve help message for file_attr
- Refactor file_attr.c
- Drop _wants_*_commit
- Link to v1: https://lore.kernel.org/r/20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org

---
Andrey Albershteyn (3):
      file_attr: introduce program to set/get fsxattr
      generic: introduce test to test file_getattr/file_setattr syscalls
      xfs: test quota's project ID on special files

 .gitignore             |   1 +
 configure.ac           |   1 +
 include/builddefs.in   |   1 +
 m4/package_libcdev.m4  |  16 +++
 src/Makefile           |   5 +
 src/file_attr.c        | 274 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2000     | 109 ++++++++++++++++++++
 tests/generic/2000.out |  37 +++++++
 tests/xfs/2000         |  73 +++++++++++++
 tests/xfs/2000.out     |  15 +++
 10 files changed, 532 insertions(+)
---
base-commit: 3d57f543ae0c149eb460574dcfb8d688aeadbfff
change-id: 20250317-xattrat-syscall-ee8f5e2d6e18

Best regards,
--  
Andrey Albershteyn <aalbersh@kernel.org>

