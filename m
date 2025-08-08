Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C88F1F237A
	for <linux-xfs@vger.kernel.org>; Fri,  8 Aug 2025 19:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681426; cv=none; b=Nds/N/roiRuWP+rSGai04b2cN4YdqIqd1USvV8eNZ4aqxEr2J5qhHC6ZxX9CdVcWRLQLZ3PbzukCOwn1l0r35iGtgpS8FaG43i1w8u5SVKWenfoeiQAWP5PuX+6pCCvOB6jCXVYKYwsLopVhF2HGNccTGcIzMslmBTHdEHyqkfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681426; c=relaxed/simple;
	bh=RoO+eToTLoP7DJCluxCUMFB3uHhVkxLfxlwTTYnRp1I=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 In-Reply-To:To:Cc; b=DNyBFqrpk9K5BClul8OMdWqKyyfH9dAFG7gxV5ahU1qZtBYB4XIpLVkMnnSWwGdUUiu4aOCNxk3r9ihGGlQM8z7wc+FvjZBh9IWedV2t8iQBFEukPE3fTx39eJVLc4KZ6Q3xaqB8T1Vw2cPRrTG2i+vSvY/4vwhXI+2uz0QMc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJ9Qc+FC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ9Qc+FC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754681423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=Pbtv+XyTsq/xa+ZE8T4GUjr3UVdr93V/ZFjsmaMOOqw=;
	b=aJ9Qc+FCRGiK434d5I+utwY+vGJD8GaDMm7B9dNsdL9BnSiN+Ts2axeQBj2Rxlw/0y1K1H
	5k7rd4gM1PUmUD7NrC4iMlKhc5wr7f5fctKf5O1sWjbmyDkNwGR8m3Qi8FrbT6niupsF03
	xy9dN2/uikEK0uPwn7X0/zxe/3Lazkg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-2jXHjUsZNq2hwhB18MZK4Q-1; Fri, 08 Aug 2025 15:30:21 -0400
X-MC-Unique: 2jXHjUsZNq2hwhB18MZK4Q-1
X-Mimecast-MFC-AGG-ID: 2jXHjUsZNq2hwhB18MZK4Q_1754681420
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459e0f54c88so13415965e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 08 Aug 2025 12:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681420; x=1755286220;
        h=cc:to:in-reply-to:content-transfer-encoding:mime-version:message-id
         :date:subject:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pbtv+XyTsq/xa+ZE8T4GUjr3UVdr93V/ZFjsmaMOOqw=;
        b=o/py8oImk7cybo+g8ljlH2Zm8IKBc4890xpbCTMRAtyjTVBFN0CmY1gVYKmODVuoa7
         CO4KdysdqkH9HUfcDk/OApxYvhwKIroyLyrMn4eEr0dscjDkbmn/GR9CIeZpJW525V9P
         +qNTCePjr6CllTPRjkLUDhDiScXNKxSqXvxoCaXX5NZJNV1fEdjhKwexypwvJEout3CS
         sx4KsFgL11y/ZLONYizSRd1KorihJBgPro3dHO3jv58APr+ZrLa/RuTi5b6XRhKS2E6r
         UId7E4ZLy6/55lI9+QBV4JJm4WgvzB1+Ev+7yWz2JUNfV9soVHI3JsC+9Qnb/CaLyNmV
         exEw==
X-Forwarded-Encrypted: i=1; AJvYcCUE1tYmDrSSBNMTBjVczGKIfLZgqnWZWZJDfjxc0MDtLSOBiTtTowfsTZKn2yO6vY8aUKvWuRK4sGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi+/t2UtzZmpJalxpsoE5qch0/ejhKnLJTDtOG/i1J2sVa++QR
	gpaZQvHlTeG2weOTRnvpVxqbMMoMrOPGa2h7/5gnQjl/zbvjuLX5Svy1hSoE4IcdNQjUi/BtR3P
	9g4ADlTghibkedYcG7ChONHt1929w1wK5T5jysf/wRuXsLI2D/VWyz0ZxoWDe
X-Gm-Gg: ASbGncuI3SdY0Qbvl6Dy+WjqRQtWdy3LF3wuuGMYHHEag2PXZ+NhL5i4JCE6eWxsejT
	jQF140anmtda8kEnACOyeeWPiSzRF/67mFpSgEEfV4gGksTs0pWsrUksbsYGr0EHRWOkiro/k4F
	MAouPF0Sy6BikP6PqnMOr8Y/xv4FzhvTgCC0SAC83fA46j/kf+Ephmus3+3UuzSOQhlZytw+rqY
	voNfVjDgrfdsAZTxPb4n7AAqFzTnEPYeeQL5x1LQMaCWH+tQ1U92GlgyogX15kuTtAI3+OGFvEf
	qklFJqFYuiXuUXucZL/38fuT6SO4qVZbldRVMC+rKF3Owg==
X-Received: by 2002:a05:600c:1c2a:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-459f51fc4ebmr35049805e9.12.1754681420482;
        Fri, 08 Aug 2025 12:30:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFp1IuzzdXOGE03zxoG8JUn7495zov2w9mOX8h5r+eV4QvNjeTn8aXSO+ujUQzn2AbrHIOH7A==
X-Received: by 2002:a05:600c:1c2a:b0:456:1281:f8dd with SMTP id 5b1f17b1804b1-459f51fc4ebmr35049555e9.12.1754681420032;
        Fri, 08 Aug 2025 12:30:20 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm8925162f8f.69.2025.08.08.12.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:30:19 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/4] xfsprogs: utilize file_getattr() and file_setattr()
Date: Fri, 08 Aug 2025 21:30:15 +0200
Message-Id: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEdQlmgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDY0Nz3YrEkpKixBLd4sri5MScHF0LY8u0JKOkJINkM2MloK6CotS0zAq
 widGxtbUAb1OEPGEAAAA=
X-Change-ID: 20250317-xattrat-syscall-839fb2bb0c63
In-Reply-To: <lgivc7qosvmmqzcq7fzhij74smpqlgnoosnbnooalulhv4spkj@fva6erttoa4d>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1394; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=RoO+eToTLoP7DJCluxCUMFB3uHhVkxLfxlwTTYnRp1I=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMqYFeOdU5PYahrBaXWLy32+37p6o+XWXXww5HDeeF
 7pc6rKR1uooZWEQ42KQFVNkWSetNTWpSCr/iEGNPMwcViaQIQxcnAIwEe+JDP/Tnux9mqu1xG8K
 5+FFB5UTL7ZsLZvvk+o7MyChoSLwZlQzI8Msxaeyvb8zOFbNjrmUXepz8peK07LnoQ1bHr1kEum
 J5GQBAAllRVo=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Hi all,

This patchset updates libfrog, xfs_db, xfs_quota to use recently
introduced syscalls file_getattr()/file_setattr().

I haven't replaced all the calls to ioctls() with a syscalls, just a few
places where syscalls are necessary. If there's more places it would be
suitable to update, let me know.

Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

---
Andrey Albershteyn (4):
      libfrog: add wrappers for file_getattr/file_setattr syscalls
      xfs_quota: utilize file_setattr to set prjid on special files
      xfs_io: make ls/chattr work with special files
      xfs_db: use file_setattr to copy attributes on special files with rdump

 configure.ac          |   1 +
 db/rdump.c            |  24 +++++++--
 include/builddefs.in  |   5 ++
 include/linux.h       |  20 +++++++
 io/attr.c             | 130 ++++++++++++++++++++++++++-------------------
 libfrog/Makefile      |   2 +
 libfrog/file_attr.c   | 105 ++++++++++++++++++++++++++++++++++++
 libfrog/file_attr.h   |  35 ++++++++++++
 m4/package_libcdev.m4 |  19 +++++++
 quota/project.c       | 144 ++++++++++++++++++++++++++------------------------
 10 files changed, 357 insertions(+), 128 deletions(-)
---
base-commit: d0884c436c82dddbf5f5ef57acfbf784ff7f7832
change-id: 20250317-xattrat-syscall-839fb2bb0c63

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

