Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D6224BBF8
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477762; cv=none; b=Nkx8Hj9GRupiwBZXM9q3ooWLy7sNFnJPE8agnoElYrqybt1zODcsqjMNvj0g6JkArvTSHwxFK+U1uHFLC8p7ftdN7rw5GUVBKPS2P4KJoKh/srFsefqn3hkCFSWMVeBu2IN9gaxyScwLPjT4nfbI9TrPrF1MBG+frpTN4LYajcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477762; c=relaxed/simple;
	bh=+8ZUUnTHj0UAHyv23Ypkef9XjZDXkrhzhtsOg6+B54Q=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=m27VEGIFdtL7zDUGPrX+RUSPlfkNcqeAdjtFycSb7PfqaA5cFj4Y7CCxUU9uF6rfr7xpSWGO+psTg1PtR8fL2lCo/nNRKz8XfwlqBrQEKY9bf2frcvM7Te8PCHMmmphM0aKpae9DgAViizAS+eZIAoAmUgerrtwqFJBORQnhLHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7sMnFNo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7sMnFNo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HpUGyQcNr5KLcCT+SN7xhRnUihI3Ng8u/7dj4WxuXAc=;
	b=H7sMnFNojJjTqNS6FiUG8i/56zmyxfV4mzrdxZaC7ImxGIyUJAJfN6tQxnDnm1BR2sl+bQ
	fdU8H4BDWyIOH3Z4qX+zFagJiu5qdX80K3PYcp2HDQeFnAaEdUSZApOfb5xzyHgGeUJUiB
	uWMScnme//WM6qF2Ngf0sbFVkdzSpG4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-G1dL396oNQK5K-6O2s0KVA-1; Thu, 13 Feb 2025 15:15:57 -0500
X-MC-Unique: G1dL396oNQK5K-6O2s0KVA-1
X-Mimecast-MFC-AGG-ID: G1dL396oNQK5K-6O2s0KVA
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43935e09897so10437365e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:15:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477756; x=1740082556;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HpUGyQcNr5KLcCT+SN7xhRnUihI3Ng8u/7dj4WxuXAc=;
        b=GPR6a3x/681/jRQRM/DKOc1csja0BvHaxexvcSiBuPV+tO5yvaclc2xVkJh5BEZrdP
         3gV5v2rXeZ2Pd7IBmydC+GEDnE/MgHRX/ALhjMXbkEG5jO7WfkCXgs/lJsNewIlq+g5i
         /9kAloEQmh7Ot9p2KdH9aLmO0d/AJFwF1I3Mc133VKeipq18IMI/do2JvXvL+Jf26EI3
         KJjXISknwX8B8xQOlQ9rfkz5750IgPdkFX6s8KUhW+wrExLuP2jZOwKWKfMcG8LVdI/w
         lqLw4oHBAdkdxSYoQqHPuDOGy5ivYOWeOSwxTdT7Xmu9mcIguHLvo4k+AlBEgzx/pJHZ
         Kaew==
X-Gm-Message-State: AOJu0YzwHPWm/w15sac63ggpJniP5mHi0qMivBW08YwJSo/g+rPkpBe7
	Q7XqGZ4w1+HliDJYJPVKK0CWW3sBSPX4pn1YBX95V5SqdF09wwjGFCMXNyzXvFbCTKRVDOW/5U1
	urMTWM6Rer42139/IZXaoc3Z3Wv4EmOpXTnH8F2m53G7ihBnVL/oYjxLCGNDrMZ4W
X-Gm-Gg: ASbGncuKfH9/xvADcvozROiDoevrEobdqoN6niFohNYcQR6UboMI0oJ1DLB7VrAc1Hj
	R3wzZt00MT80OgGQni5mWu2Yp28+NtGA2wbcA+TpliZofE0tim++CDLyBiu+QdWto358sT37hVP
	QoihUSMtoEL81kejYf8OrvQ3uhLPnjz3VlMEwld25/N81nuUtMikjZNObZn0kE3aqS9u7gITMzb
	4wnzBTye0kYJiErJ5WlvWwizwg5sClBrlTyrNVTUF5HAkxQpafCSFLe+AXBANZPT/ddzXlJqihs
	cr2KReilR4APQVs9/0d1ToO9+X/iAe4=
X-Received: by 2002:a05:600c:c14:b0:439:63cb:ff7e with SMTP id 5b1f17b1804b1-43963cc00d4mr49729305e9.10.1739477756417;
        Thu, 13 Feb 2025 12:15:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxv6wE8Wa9Sgw+sVCig5O6s91byhmisL2vuOtC0mI7snhtfa2JCCnjfUnZeW9xbnxkpLzWrg==
X-Received: by 2002:a05:600c:c14:b0:439:63cb:ff7e with SMTP id 5b1f17b1804b1-43963cc00d4mr49728925e9.10.1739477756019;
        Thu, 13 Feb 2025 12:15:56 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:15:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v4 00/10] Update release.sh
Date: Thu, 13 Feb 2025 21:14:22 +0100
Message-Id: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ5SrmcC/2XPTQ7CIBCG4asY1mJmhlKrK+9hXNAyVKJpDSjRN
 L27tBt/yu6b5HkTBhE5eI5ivxpE4OSj77s8ivVKNGfTtSy9zVsQUIH5ycfNmjvLwFc2kSUqdrh
 tACqjRUa3wM4/5+DxlPfZx3sfXnM/4XSdUhoQ4T+VUIIskQuoK+dq0xwuHDq+bvrQiqmV6MsTL
 TxlbwE17WytjNELrz6ell9JKvttXYFhTU2J7seP4/gGO/0kpy0BAAA=
X-Change-ID: 20241111-update-release-13ef17c008a5
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2137; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=+8ZUUnTHj0UAHyv23Ypkef9XjZDXkrhzhtsOg6+B54Q=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/XRWW3/HfNcKs69iO6reBO7r1VgWmTcxO0agT
 dqEX8A7eXFHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAicjvY2T48VZ+xwuJRrM3
 sjvO7lTYEHDVzEHxcImIhcMCSWXV2lPPGBnONH19Ij+lc/JywTNFP9uMd1ZtnLZByto1+/7dlv/
 nq9ZyAQDGcUf9
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
Changes in v4:
- Add a few from recently generated files to gitignore
- Drop Cc: trailers in libxfs-apply
- Better handling of trailers with multiple emails/hash marks/not quoted
  names
- Link to v3: https://lore.kernel.org/r/20250211-update-release-v3-0-7b80ae52c61f@kernel.org

Changes in v3:
- Add -f to generate for-next ANNOUNCE email
- Update for-next when new released is pushed
- Link to v2: https://lore.kernel.org/r/20250122-update-release-v2-0-d01529db3aa5@kernel.org

Changes in v2:
- Added git-contributors.py from Darrick
- A bit better/shorter commands for maintainer to run
- Link to v1: https://lore.kernel.org/r/20250110-update-release-v1-0-61e40b8ffbac@kernel.org

---
Andrey Albershteyn (10):
      release.sh: add signing and fix outdated commands
      release.sh: add --kup to upload release tarball to kernel.org
      release.sh: update version files make commit optional
      Add git-contributors script to notify about merges
      git-contributors: better handling of hash mark/multiple emails
      git-contributors: make revspec required and shebang fix
      release.sh: generate ANNOUNCE email
      release.sh: add -f to generate for-next update email
      libxfs-apply: drop Cc: to stable release list
      gitignore: ignore a few newly generated files

 .gitignore                |   2 +
 release.sh                | 185 +++++++++++++++++++++++++++++++++++++++++++---
 tools/git-contributors.py | 168 +++++++++++++++++++++++++++++++++++++++++
 tools/libxfs-apply        |   1 +
 4 files changed, 344 insertions(+), 12 deletions(-)
---
base-commit: eff7226942a59fc78e8ecd7577657c30ed0cf9a8
change-id: 20241111-update-release-13ef17c008a5

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

