Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE5222584
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581451; cv=none; b=CCYBJKy1EetSr1P71AAcJJQYNFdfqbMATejrEQb3sGU4Ipkat1GX9H7GJZzWrDznk9wqYW+pkCm38ThKhm+lWsFwoQMZyNN8hrFoA6cwctkwFL1220dnp0Yj9Goj98/Vx18Mu6qmhCcImu+keRQ4FNWMlovx03U+BeF9tppKwiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581451; c=relaxed/simple;
	bh=sC0IW5rVyYUokgzzbprU8mVNVhPjl+mOlGj6L8j/o5c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NKcc+aQpgrlT+maeghMiQMtpLlBJ/mndy9BhK6V6jo4IljSEm6aA8fTWag6VBkp3WZjepf/MSDNH1ieOBQ2++Njja4zS/V5TAd1AhZfHLCWl077buYSCAmQBKVBDaGpBLvdURrHbiQ4HGIurvAW+MQLZOgkzBbshfcLHLWdSv8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R5LiNz+0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5LiNz+0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SfndJAO8PLvtVNa8QOrvmYKESgohX9Qf1wbrSRSSd/s=;
	b=R5LiNz+0o63/ca4C8rRYELX44q6w1sYbz65Joab2YUiACHL9GrE4CF2Ff8tNL2msF3TEff
	Oev5g/vEj2ONvg456tiQZWpVXkBktej0xRyo/XX3nWfR8wiIImOYWqK37wtf6E7YHBV7sU
	y3yNlh87XxvrEImpQGXa4OUl0BWJhUs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-VV5RxbjPPzuHBoEry0nFUg-1; Wed, 26 Feb 2025 09:50:46 -0500
X-MC-Unique: VV5RxbjPPzuHBoEry0nFUg-1
X-Mimecast-MFC-AGG-ID: VV5RxbjPPzuHBoEry0nFUg_1740581445
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-abbaa560224so683284766b.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581445; x=1741186245;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SfndJAO8PLvtVNa8QOrvmYKESgohX9Qf1wbrSRSSd/s=;
        b=WAq30TKs1oEFrhxaDiZ9acjetEcYvTaJ1JJ2Fo0uvW8sfu0F55QgQqnc7QiTUUS4if
         eX40Dkc95AUXnHX/Ro0aOt9zfziMP5L9BHebmXxKEwHNs9Y6GxgbGNwu1KHzSwnZNpGd
         viwN0uDBBWirDIkJJeRDRf7bjvwp6U2vl+ptD3U1wWQxihpdkeQosBi29he6LtfGOR1Q
         0eUkl/fJR4VG6pnp7nOrtNSSb4cqDJI0nUE+AyDHTxkFXOulkGMSKac57u5b0bDJrlXN
         j1BiSQ5g6EP1RVTzwNirWlmZeJ2HbV35/vAjyRTufbDd6JE8mraE8/fTcg5XfeJfQLWB
         bx2w==
X-Gm-Message-State: AOJu0YyrohMM/qSep53DvFDMLbFlHd+B+cg3MGj3PRNNjekR0a3HKZiL
	bYy7mbO1FClst1wWViJ0zkCtdrZ2C5XlfThDpu/VyD7liDA/lexHxJ5z3ayggudrn6iKniiTSBS
	KS5kDQ/jUb5CdjQ08Y8PB9Tx1ztil4fS5IYQ23Pbig7njLMGwV+VuIoKD
X-Gm-Gg: ASbGncsrwTPxGghW3BWd0Mlvockbhg0DKJIcf1CMzZzq5cHUN4zSh827mY1ok8W3pV2
	KnNxVGAPKM6pgsRMFfZDezdiJWcEgDD4Gs0DlpgukfxnvldtR1Ak3utdfLQa0myk05coHv/2A2w
	Sk2B0oeroI312e7HyBwZyIR3d2En7WcFOTnBCu9mwMIdPMb3JVLu1K+9DSqHIknjHQdLjbti7aX
	X9HzoWdpBtExAhaq3xKd/P7z8g67HtNKt4GZk7vqL3oxuJU51t/YqRMUMPUVT9I31wJLEsoLdFE
	Q6DUIbms/eFvDctr65J0CltNGkdU9GnkDNAdM84ohA==
X-Received: by 2002:a17:906:3282:b0:ab7:cb84:ecd6 with SMTP id a640c23a62f3a-abc0df5d6f5mr1868005166b.56.1740581445222;
        Wed, 26 Feb 2025 06:50:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkYC1RWuEEhSyW+AwOQcy7ItybvhNoeivQU6tJhpNFujQcQ3LPRaQxZDo7O0Ugovtu/VFeHQ==
X-Received: by 2002:a17:906:3282:b0:ab7:cb84:ecd6 with SMTP id a640c23a62f3a-abc0df5d6f5mr1868001966b.56.1740581444849;
        Wed, 26 Feb 2025 06:50:44 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:44 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v5 00/10] Update release.sh
Date: Wed, 26 Feb 2025 15:50:25 +0100
Message-Id: <20250226-update-release-v5-0-481914e40c36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADIqv2cC/2XPz24CIRDH8VcxnIuZGZaVeup7NB74Myip2TVgS
 Y3Zdy/rpVq4/Sb5fBPuonBOXMR+cxeZayppntrQbxvhT3Y6skyhbUFAA7Ynvy/BXllmPrMtLFF
 xxJ0HMFaLhi6ZY/p5BD8PbZ9Suc759uhXXK9rSgMi/E9VlCBH5AGcidFZ//HFeeLzds5HsbYqP
 XmizlPzAVDTe3DKWt159eep/0pVze+cAcua/Iix88OzV50fmvcwGqOscS6ML35Zll9UBJabbQE
 AAA==
X-Change-ID: 20241111-update-release-13ef17c008a5
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2612; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=sC0IW5rVyYUokgzzbprU8mVNVhPjl+mOlGj6L8j/o5c=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOYcWRjN9v7HphP9i9webP948mPuP79ok8bVsy
 /fXeuea7QzpKGVhEONikBVTZFknrTU1qUgq/4hBjTzMHFYmkCEMXJwCMJGNMxj+2Ui09F5ZXDOt
 7Pj+f4+DVyl++n/qxLs7K29p856+OvFOYgsjw8HCk44n3+4u7nsez7Ho1Nk3J88xb7rFrbtDrbp
 +k2zAZD4ACsRPBQ==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

To: linux-xfs@vger.kernel.org

The release.sh seems to be last updated in 2015. Every one seems to have
their own script to release. This patchset updates release.sh to do the
basic stuff as updating version files, committing them, creating tag,
creating release tarball, uploading tarball (optional), generate
for-next announce.

Just a few minor fixes from v4, see below.

-- 
Andrey

---
Changes in v5:
- Use --separator instead of --delimiter for git-contributors.py in
	release.sh: generate ANNOUNCE email
- Check return code of gpg --verify-signature in
	release.sh: add signing and fix outdated commands
- Add argument to $(basename) in help() in
	release.sh: add --kup to upload release tarball to kernel.org
- Link to v4: https://lore.kernel.org/r/20250213-update-release-v4-0-c06883a8bbd6@kernel.org

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
 release.sh                | 189 +++++++++++++++++++++++++++++++++++++++++++---
 tools/git-contributors.py | 168 +++++++++++++++++++++++++++++++++++++++++
 tools/libxfs-apply        |   1 +
 4 files changed, 348 insertions(+), 12 deletions(-)
---
base-commit: 4fd999332e19993fb7fd381f5fcd40ff943d98ac
change-id: 20241111-update-release-13ef17c008a5

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

