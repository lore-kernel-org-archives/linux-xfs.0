Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30B526BD8E
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294838; cv=none; b=SNBzI3uLL7DKFosh4XK+cd5E9OU4l1fVuI44w0/QySSmEkkyM0bY1Y7bP8foHfhIU7doDSUsfBddnJZDqWNg5YWCxiZ8DI5en/gIaT/dYM3INqkschPLZdydk6edUgRl9Cx5xm3IF7rPTUQTaxJfxcBs4FIl+ZL8mObGnSLrPi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294838; c=relaxed/simple;
	bh=JdICo3FU4n7AxoMKz8FpQt6tgcx19rANS1PzqxJtCG8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EIwttQBv2Onzgh2LcXTAvRjDKabGPDCbUFkaFSNXca9cN6P7+8q8d+7p/BWxLDeyxoioXaepQ2xEUXmB9zFXdoWppEm1bbW7kLrw+o2PaRUfGmast2BJVykvmpdSHCLb2CFIFa1fywmNhmuuiYebdF1h81T5uu5Nmp2mKENruxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BA/ZQdei; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BA/ZQdei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZTg6vqBxY5SLFjpZxOY79RYbqcJZKX2I9h77BSXG+2o=;
	b=BA/ZQdeimc7nAKbZQamMFF5jCL+II36mLG0I6+2veQsL9v1P86QE6q3FdvCeHdcbNdVQzO
	bhI+WvmjCenecwz8fUfWJTEieGKZMoQ4FjgSl5y9dTJ5TBvfpzivUVQprkblmq4E3RlNaM
	3DNuaRCisScpR1SAA/CM1lCnxnJV1Io=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-dkgPc5F3OY-w8XG4Lc25_Q-1; Tue, 11 Feb 2025 12:27:14 -0500
X-MC-Unique: dkgPc5F3OY-w8XG4Lc25_Q-1
X-Mimecast-MFC-AGG-ID: dkgPc5F3OY-w8XG4Lc25_Q_1739294833
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5de909cf05dso1880717a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294833; x=1739899633;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZTg6vqBxY5SLFjpZxOY79RYbqcJZKX2I9h77BSXG+2o=;
        b=MRbSqnGSM4OJL1zQkL1oDcotdLfM6eLHQSmRA8Q/pQT7x27dxaeV+0urvtRdLw0ofz
         B7rXuuuJamYcG+utQoZD+ms59IUxkXQB+uoC1oPHpScP1jcy/Z7zFB1uf0ae32lCD48N
         iYMnI2NKJpITIAgdo27n5OfRcDAvD4YRHVS1f3sVszV4u9crwJqjwtadFt3sDu2l6yq+
         l34znV98Pyw1/bvW+/lBqCVJcDcNN3+S+qLmR9Fiv+zmmeubMAzDt58sDSo/jT5jE7Be
         cf0ZYeUsJpWz4IDMxC7WhHPP8kxm6bjwaQCJA8iy++eeahbLmgmxmYH6m+mm9uKoMIPO
         jgpg==
X-Gm-Message-State: AOJu0YyprjeTmonHkGm+7+6eOQOCFz5ic8YpNs/O7BuUUoiXrNEfhkRD
	i/+N/sqojl5ruLX/sMjmJZJH2Aw6apQ/VfAGyGRMGr7wRohG/l8jeXzlphmQgLS9BAgoeaFxuvD
	RMnuyhqmgKpRfhonukj4p8fTQBHNAc4JEH1u+N3ac/cmFDqxHY6pzTybt
X-Gm-Gg: ASbGncsVsARv4VhtGl8JIE8f6no95d+d941LCx7/Gs12TeuNnfVOD0wNHGg7xq2BOu7
	6zoZWtxp4AVA+GVJE/U57qjdDEnNCWLIOpJT//thXv2sAbSQt/v2pwOoOOFS/JefST3WlaEvFcR
	HIxLcST18WKgvzJmyA+WpBnT8080Be96G/XWspPaR55HA8MAoUa35i1j7spxMlKJ8cN6N4QXbE8
	uJePgsBxLQo7fUiqO+nVEw1PDTzAb2ANLnmHbcmlWElS432TvFcjG/+iQ2Dlnnt6GlGHBgjX/J9
	uvM8KQ2iK0/ANvKj6YP+AmNAavE/IRs=
X-Received: by 2002:a05:6402:34c7:b0:5dc:1f35:56a with SMTP id 4fb4d7f45d1cf-5deadd7b8demr29589a12.5.1739294833446;
        Tue, 11 Feb 2025 09:27:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGL258JX6KsT42fsD45DGtDxNrGcRBwsvZcOoTujgKxn8D2qPfLCokknBWp9szF1VXJdlDqDg==
X-Received: by 2002:a05:6402:34c7:b0:5dc:1f35:56a with SMTP id 4fb4d7f45d1cf-5deadd7b8demr29577a12.5.1739294833082;
        Tue, 11 Feb 2025 09:27:13 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:12 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v3 0/8] Update release.sh
Date: Tue, 11 Feb 2025 18:26:52 +0100
Message-Id: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFyIq2cC/2WMyw6CMBBFf4V0bc1MoYqu/A/jotApNBIgU2w0h
 H+3sPJxd+cm58wiEHsK4pzNgin64Ic+Qb7LRN2aviHpbWKhQBWYJh+jNRNJpo5MIIk5OTzWAKX
 RIkkjk/PPLXi9JW59mAZ+bf2I67umNCDCbyqiBHlAKqAqnatMfbkT99TtB27E2orqw1fqz1fJt
 4BanWyVG6O//GVZ3vtT3qntAAAA
X-Change-ID: 20241111-update-release-13ef17c008a5
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1643; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=JdICo3FU4n7AxoMKz8FpQt6tgcx19rANS1PzqxJtCG8=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld35M88e++ahUzzDIvt14O/tT98prcxdGV8hufpw
 LSpD2Zujp7dUcrCIMbFICumyLJOWmtqUpFU/hGDGnmYOaxMIEMYuDgFYCLG0Qx/xePP78i78Cpj
 c35k0b568UaJ2vsKx5c861414dSMFIsDiQz/bCyPpHf2X7twpdqpJ3LeXGeJxZfd4nar/78tFnC
 zOCSDEwAV7EzH
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

To: linux-xfs@vger.kernel.org

The release.sh seems to be last updated in 2015. Every one seems to have
their own script to release. This patchset updates release.sh to do the
basic stuff as updating version files, committing them, creating tag,
creating release tarball, uploading tarball (optional), generate
for-next announce.

-- 
Andrey

---
Changes in v3:
- Add -f to generate for-next ANNOUNCE email
- Update for-next when new released is pushed
- Link to v2: https://lore.kernel.org/r/20250122-update-release-v2-0-d01529db3aa5@kernel.org

Changes in v2:
- Added git-contributors.py from Darrick
- A bit better/shorter commands for maintainer to run
- Link to v1: https://lore.kernel.org/r/20250110-update-release-v1-0-61e40b8ffbac@kernel.org

---
Andrey Albershteyn (8):
      release.sh: add signing and fix outdated commands
      release.sh: add --kup to upload release tarball to kernel.org
      release.sh: update version files make commit optional
      release.sh: generate ANNOUNCE email
      Add git-contributors script to notify about merges
      git-contributors: make revspec required and shebang fix
      release.sh: use git-contributors to --cc contributors
      release.sh: add -f to generate for-next update email

 release.sh                | 185 +++++++++++++++++++++++++++++++++++++++++++---
 tools/git-contributors.py |  93 +++++++++++++++++++++++
 2 files changed, 266 insertions(+), 12 deletions(-)
---
base-commit: eff7226942a59fc78e8ecd7577657c30ed0cf9a8
change-id: 20241111-update-release-13ef17c008a5

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

