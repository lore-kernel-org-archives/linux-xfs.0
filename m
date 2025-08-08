Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF982192D8A
	for <linux-xfs@vger.kernel.org>; Fri,  8 Aug 2025 19:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681539; cv=none; b=U7+3cuuzR8O6II6HUChyY/IyRLoEZB0886jhbW1yEmywHjTBIsLe8oTWJAcvFp+bmxmbwAsTqE9QqK5HYD7asiPGbPhhW1PRWVK7uWIerMgCqWkrz1+F9OD8g33USiyC1lffnfbf961lJ4UY572m63YIA3MU2wK0yG4uIBZO5Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681539; c=relaxed/simple;
	bh=e1W/HcruV/OHIdwnbStEI9Ov39lexljtbC+tMPtG4Sc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 In-Reply-To:To:Cc; b=GdbxO31+8jENocC5VMzpx/lx1jjGerlA08g1T9HolFBG4ZwjYbkWA/b4539T3fA/xjlyPNaasMjGMug36QmEOn8WODcD/2xqMqX9btLXyA2OVfQiib+R7giUWP6oAAGeUahsf2jIg5H9mE/Kpg2J3PcrLTGhN5flo8V2BlnUfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5ZWsozd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5ZWsozd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754681536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=SoUBKlNMzRCqR2PByufZ7Vaz72annPP0DWvMgm3RHPY=;
	b=h5ZWsozdEWBXYX2QTsq8oZsnsU2oGP/HCs63CfrtqAoQnXQwiVuy8wpOtRgkIPI1P3YQGf
	cuYij8hMjVn/crPdOstPi3Wpl4TBxtXUgEy7nO9p5XB90/D6Kt5FF8FEtbL+j/bSZl68J7
	PM08raUq4bPpkRDG4OUrpJgyg731ZM4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-drbRURskM-eDuxhXJ0xKqQ-1; Fri, 08 Aug 2025 15:32:15 -0400
X-MC-Unique: drbRURskM-eDuxhXJ0xKqQ-1
X-Mimecast-MFC-AGG-ID: drbRURskM-eDuxhXJ0xKqQ_1754681534
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d5f50a07so11969705e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Aug 2025 12:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681534; x=1755286334;
        h=cc:to:in-reply-to:content-transfer-encoding:mime-version:message-id
         :date:subject:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoUBKlNMzRCqR2PByufZ7Vaz72annPP0DWvMgm3RHPY=;
        b=snQmiTOh2Zjhz/3mR0hiDcsT8J4L9YlDmFwLBBHlDuhB9yQuINcoGn5/yilTOuOCJq
         8HkOB4Uc1Nb11STiNLBetqbm08TBWuqdsswoNVeqQiKv1U6K4590fPPz923yhMWP7cfJ
         SHtIkjjjY0I7PD7DV1bV0MV2p+U6Y2TVp2Lf6e3qJfg/2ptkrHSwR8wQDkI1PNIYVbHF
         XXg7fy5aRpc4JgHEzr9IKJMRXG14x8HFl/ie56hx1I9C+I+9HdE48swFXyay7q3rfZAX
         tMcHsAXVJrALbXkDuTyWl+Q6wXJ1riZm3lxjwmkWyY5lczVdcoZmRyQ8vgCNJ2RnEzYw
         jL7A==
X-Forwarded-Encrypted: i=1; AJvYcCWN4oBBoqoCUZdYork5PITmXg9b8yQlzFZwgdpSacMFVa+TQsvuj36OTpiFPHaEB+L7aXuS10WgeBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVGMDKyiit1HoRrP24ljKQb9qcVcOPDFDtr+wz9Mc7s8tq8LIO
	spappbRQBAdiG7BwuQ1wOxW1Xy6a4IkQhVwe8goGDBl6dvLs0zGfPDqc8Z/rXZl35GFadr4AEs7
	slZivhnMRZQ84SCSbhcQsvqYGUKLq//3ztr3AaYQlpuSB+FeXYV+Wel/WFhv8
X-Gm-Gg: ASbGncuL3ffYR9QNHkTGnFuaDpUWzrYxBOVQXSnUXAm0eqd8mAO+8CuVqh+/MJxL8W5
	jH9I84rGSfE1rTmZCR33ZztzTpz09B/g52Vcv6+p+7bMZRnrHMh1PaNtzX8zFZaLUMQegbt9fXO
	prtmZXkgfwT096BvB6Ufk95I6f2wKnE0Oys8Osc89B+Xnxyg2sjdCqB0FEvkD92y8OISYpJ4yII
	ZZS5Uthfw3tC0xyIN72UiXjbx22EcCCWQBmfRSHsfigfMBO7V/pxSFr5jJ3mYMUp80pMvqckfF+
	4fiG+WawX9nBQBHhv8jYcjb9v7v7b2j+XLZy2Xl9Su+lzg==
X-Received: by 2002:a05:600c:4fc5:b0:458:bd31:2c35 with SMTP id 5b1f17b1804b1-459f4fafcccmr33943065e9.25.1754681534127;
        Fri, 08 Aug 2025 12:32:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwYL9KJsxIX5x+DDFE5d8rhvfcgsu77l9lAsc4U6sL6PMjtSZsj4iEF5Qn2AGUfJmjvp/QNQ==
X-Received: by 2002:a05:600c:4fc5:b0:458:bd31:2c35 with SMTP id 5b1f17b1804b1-459f4fafcccmr33942925e9.25.1754681533755;
        Fri, 08 Aug 2025 12:32:13 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5869cccsm164906135e9.17.2025.08.08.12.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:32:13 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/3] Test file_getattr and file_setattr syscalls
Date: Fri, 08 Aug 2025 21:31:55 +0200
Message-Id: <20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKtQlmgC/x3MQQqAIBBG4avErBPSsKKrRAup3xqICkfCiO6et
 PwW7z0kCAyhvngo4GLhY8/QZUHT6vYFiudsMpWxVa1blVyMwUUlt0xu2xTQeQszN9Ad5eoM8Jz
 +4zC+7wdZaC0SYQAAAA==
X-Change-ID: 20250317-xattrat-syscall-ee8f5e2d6e18
In-Reply-To: <lgivc7qosvmmqzcq7fzhij74smpqlgnoosnbnooalulhv4spkj@fva6erttoa4d>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1556; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=e1W/HcruV/OHIdwnbStEI9Ov39lexljtbC+tMPtG4Sc=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMqYF7O0JaJV84xn7eAVr2uHzm1M9NxQxvJhrmfal/
 O+fjvyrx852lLIwiHExyIopsqyT1pqaVCSVf8SgRh5mDisTyBAGLk4BmMhFXob/Gcqfu7w0si8e
 7br0e6dLc8HGI9+LmY47Bu0/6XRGqc53KSNDs+L5bXsDFZse/ViWNPlG2spNm8peFq459FgwV8H
 K7zk/NwANSk1K
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
Andrey Albershteyn (3):
      file_attr: introduce program to set/get fsxattr
      generic: introduce test to test file_getattr/file_setattr syscalls
      xfs: test quota's project ID on special files

 .gitignore             |   1 +
 configure.ac           |   1 +
 include/builddefs.in   |   1 +
 m4/package_libcdev.m4  |  16 +++
 src/Makefile           |   5 +
 src/file_attr.c        | 277 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2000     | 113 ++++++++++++++++++++
 tests/generic/2000.out |  37 +++++++
 tests/xfs/2000         |  77 ++++++++++++++
 tests/xfs/2000.out     |  17 +++
 10 files changed, 545 insertions(+)
---
base-commit: 2cc8c822f864e272251460e05b0cba5bada0f9ee
change-id: 20250317-xattrat-syscall-ee8f5e2d6e18

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

