Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AA51F1515
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558109; cv=none; b=mbIqK2elSJuTskP4F6KvTUsnxHZpgT5DpNTsQOTbfWKFTSa0YRwKGAn2YUPHsiqYWUHIZpm+z4QvZpZzDbqJit/sJJDK/akGPH+tMPafUG6G2nminVjMZ+AqlZNfrDuLr2pkGeUn38e+cXN/lY/P1tvIBTWe8wL+qkgtDvogsr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558109; c=relaxed/simple;
	bh=IIdK1TL/2s9OOu6Dir6IQxUhQBIqGe/u1Wp0YleFEoU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HCAr01A14S40LdkBMy4pmZ4SS9yQzfdU7PDN2LyjAgiVLnnij+cKZaE1KGTsI6A+siDpapxhoOz2jwvnFqpQWfp5KdfCIRV31FH0wi/lWM7H6QZHfNbl9DB/wn6LzlspoA4MhRu1RW9noXDacyilro2fQsj0gg/kglmIzOmN4oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SShQKFhn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SShQKFhn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JMfqSSvKohOz9ERc1fVp0kOumElt3m5+Z2tMlC4jBss=;
	b=SShQKFhnPptNn5c7/yWfjpv2Jja0eiTUKp7D+2GLtW2gOrT/cA6p18huWA1HWxnOB/BKEh
	9aiAGNF8lmHI475yMle4v/v/cuTnFDWbI/K5G54+m3KkNMO2csEYcwQDMJ8ZiZaDIlA0qU
	uFFkYuzDKLxN2UFW7zIz96ov6R3+MpY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-IztUipviPOisTT1fYPdAwg-1; Wed, 22 Jan 2025 10:01:44 -0500
X-MC-Unique: IztUipviPOisTT1fYPdAwg-1
X-Mimecast-MFC-AGG-ID: IztUipviPOisTT1fYPdAwg
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa68b4b957fso802687366b.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:01:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558103; x=1738162903;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMfqSSvKohOz9ERc1fVp0kOumElt3m5+Z2tMlC4jBss=;
        b=a5A1Ogw7IpqztGrXot8BE+ObZRFeNRnar23bd699h5lbJd4Boq8kgzn6tO3lG4wyR4
         ooKPtP9Dphh3JFYZUy5faL5uWkFUxR0c5X63OpkOmVyuvyUQDsy+qwjqMYj68k/qJ8KB
         J2bKcXd8Mdfv7pN67s6nDbEx476r/J3HDMGTsg1JwgXkwlxrEaQ/QMnh3y/u4j753roz
         5BK+WoklXjrpBejJ8IrByaLsq6rwW/ph3o08ex+zefLybUsjAppuY9gHzzleZzYhdnJ6
         qJHt9wqqgu+ia+4rwW5sQs1m6kRgwj6UO1dgpqko8PPIHTiW4E18AOwmnzSu3IxdlQv6
         Go2Q==
X-Gm-Message-State: AOJu0YxJ9+tQKFEeb9doOMLhxb2gORqtHF0FAuX0WcSlrq+h+WEiI8DV
	WY5R2U9qnPvgc669xr5U2ZeVzLFakkGHfjNvI3TTRIBVL08dbOH6SlB3aPJNyAkcyajyLF2dETw
	4/BPVbUnaid2VHMjCUReIvEVjVTclWpeHfYrtR7GTvwpFsGUJYu1IK247
X-Gm-Gg: ASbGncvOMuxmEFGIJkhgHfSLF4Rn++uXCWOBCumFr4RTCihOwuc+hhyJ5CKR/dDXpL8
	vmXxxO+duJ1LpZMAl07yTmJE/upKbg8gjBChYGXsCkD2Adc370tJdY1P2mtKnopxGeezy3ORdfP
	KTuVsmIwIS3IzVTMQ4zKhR1B4on8R3X6FwzK89pD8HlbUdPVc5KjGkwqQZbU4Na1ZELkSyjuVsx
	Zug6h2CSD496GNCjv2Tu2K3agoocCTJWABVnTYrPqDhWsPovSf2Nyke8xVHt4dFhEYu+3jS7vI9
	YMNud80yRRkGN0RYJhL2
X-Received: by 2002:a17:907:72c6:b0:ab2:b84b:2dab with SMTP id a640c23a62f3a-ab38b163149mr2402482566b.30.1737558101585;
        Wed, 22 Jan 2025 07:01:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvp7o9fJr2pBWW79bERwzVOUdVYox4/a0kT3g5D7RxAr6wslhsMEsKrCgpotvh/gtyjqDfbw==
X-Received: by 2002:a17:907:72c6:b0:ab2:b84b:2dab with SMTP id a640c23a62f3a-ab38b163149mr2402450066b.30.1737558099276;
        Wed, 22 Jan 2025 07:01:39 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:38 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v2 0/7] Update release.sh
Date: Wed, 22 Jan 2025 16:01:26 +0100
Message-Id: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEYIkWcC/13MQQ6CQAyF4auQrh3TIihx5T0MiwHewEQCpINEQ
 7i7A0u7+5u8b6UA9Qh0T1ZSLD74cYiRnhKqOzu0ML6JTSmnmcQz76mxM4yihw0wcoGTW81c2Jz
 iaFI4/znAZxm782Ee9Xv4i+zfncpZhP+pRQybqyDjqnCusvXjBR3Qn0dtqdy27QeIjOhyrQAAA
 A==
X-Change-ID: 20241111-update-release-13ef17c008a5
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1357; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=IIdK1TL/2s9OOu6Dir6IQxUhQBIqGe/u1Wp0YleFEoU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBFYbvZrkL3r6nTrj6awfd1czc8QfXsE0Ie2Lk
 ohl384QFa+OUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE7m6hJFhkt2UroOihdWX
 jq6KiWrq63X/863Zs+TIsv/N68uvOgjKMDLMEoiz+ve27Kta6j5dqe8Lqp+FSXpEyP+a+U2vY/k
 ebn4+AF1BRfM=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

To: linux-xfs@vger.kernel.org

The release.sh seems to be last updated in 2015. Every one seems to have
their own script to release. This patchset updates release.sh to the do
the basic stuff as updating version files, committing them, creating
tag, creating release tarball, uploading tarball (optional).

-- 
Andrey

---
Changes in v2:
- Added git-contributors.py from Darrick
- A bit better/shorter commands for maintainer to run
- Link to v1: https://lore.kernel.org/r/20250110-update-release-v1-0-61e40b8ffbac@kernel.org

---
Andrey Albershteyn (7):
      release.sh: add signing and fix outdated commands
      release.sh: add --kup to upload release tarball to kernel.org
      release.sh: update version files make commit optional
      release.sh: generate ANNOUNCE email
      Add git-contributors script to notify about merges
      git-contributors: make revspec required and shebang fix
      release.sh: use git-contributors to --cc contributors

 release.sh                | 159 ++++++++++++++++++++++++++++++++++++++++++----
 tools/git-contributors.py |  93 +++++++++++++++++++++++++++
 2 files changed, 240 insertions(+), 12 deletions(-)
---
base-commit: 67297671cbae3043e495312964470d31f4b9e5e7
change-id: 20241111-update-release-13ef17c008a5

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

