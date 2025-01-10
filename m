Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1831AA1F6
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 11:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507121; cv=none; b=rZ1Og6Yys9Ocq6Xhzr7RZ1B9EfrCvKPAvzDfZ0k8nN2GrsRpoFeCJun0ZEYpuykNV51g2l/o0bdnLYE92pASddHkpfxzb6kjdvWRyrnYBdqgDQkLGc0doP6+Qw3JHONBXJZnuumaPo3nvWooGbOLej1OIDDputS1S4eqV7Z6eCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507121; c=relaxed/simple;
	bh=BMnh1HQJqdLKocGUzPUCuzENN56ETPQh0vOoIjoROYE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ircki9chLvWthaglW5if8BNEF02q10NssEGC7XkMtLVVLUjXKb+icO1eKsZItlpVDCbLg2nFPJ6PZBtk4xTil6rGw6qJ5C/9LKUI5xZYEGDlKT5cEKMtXaLeHEBUQf+gwMvGptosiLlqaojRrMpMQIeEN53SWWqPOZE+oa94Y1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YvhDJUH5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YvhDJUH5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736507119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5VzbmO6Aysb2ox4s+OKGgsrfEENFDF1jK5AzHQCArhw=;
	b=YvhDJUH57t9MZBfF+IZlGROhBWrj0jRYEHeTgKtvtENbmKTMklnDWie5kPBTzxIACthJvS
	nRClufQFFDis/aEQwK31ZgFYDKY1TipwFjDM5FepfXyqyw6yVWfUyh/YyLvxQD7V8Q3xw6
	j3LKlTnarP2eodqbFpAKG/BbMHPWzbY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-WWn5FbCPPKC8TV0isfwvvg-1; Fri, 10 Jan 2025 06:05:17 -0500
X-MC-Unique: WWn5FbCPPKC8TV0isfwvvg-1
X-Mimecast-MFC-AGG-ID: WWn5FbCPPKC8TV0isfwvvg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-436225d4389so13284335e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 03:05:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507116; x=1737111916;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5VzbmO6Aysb2ox4s+OKGgsrfEENFDF1jK5AzHQCArhw=;
        b=Jl6AnSXyOVVBZ7umSgzSnCsJfjJdPYyw/HdZ/F35zmaFq7f7XPgEeGUELJqxJ90avI
         qtCXC1TiVGyQutEeOjlo+z5eG/9eYquUN/aRIG9DBnsdEKHX9jas3tAodkuM0b1f2O5W
         isZZtUKtdJRM2GyNCHvj+s47hmyXebZBUYhqwmC/SwH4xe3/rP0Wzzd/w2ugpN+U8HnL
         9b+TzKgE00JzqhdM1DqK7VZMDMPoi49Dor7xpOQwy7mhOw9n6k7LE915P8B+47tsZYy6
         LmYDlGc3gSd5lVYPnLmcy6rOSPBrruZoGFUCAf/DQRmdXaVIPB2rHVkGPDXr+cQOqy0L
         JPKQ==
X-Gm-Message-State: AOJu0YxDFJ66WEsY+/R+utoj9CY88nTo1ngFIxrunZf60vCHYGhzV2oA
	EF5Qxx+Zmq3+ink9zEwooDEjkvdf/aECIsfWIbCyxQvEer/HhB/1erBNwHFUutng8E0/nDjPpfi
	fE+XRa2nkuqJlCY5NurmPqELnxVcYF9MPJlp4zYxlP4usySqiMgBfFNK2z/+HO8egtXZ2j0pZec
	LCjLlPxV8W3gfLWDZK1ztY/nirc237J4Ej7Kcd2LC1
X-Gm-Gg: ASbGncshHWHcBCpai/DmiboKgvxqh1L4rnefSQkU/p7myEMdRxwfrl03xcZldfIKy44
	iCFIvD4OrQwRp4UuRc4QiMhkUlDVkiOVkGavJVaqcrj0RrpLBmOk0nDsjffqC87f3da7ZjKVWjy
	hcI5wcsUll6hBcpNpP8d90nlmC08kLEbiwJeBtKdQlFJ7hXEuPP37ykqzNJWz/ElOQABVjXYsJk
	IcqkCB7Qdxawd0e2Ael5alSr5KlYfnZLGf8bRotn0VnCQv2V3kx8nUVzh42PjRIR+NEt76EXqSM
	c0U5wX8=
X-Received: by 2002:a05:600c:358a:b0:436:e69a:7341 with SMTP id 5b1f17b1804b1-436e9d686b2mr53017775e9.3.1736507116303;
        Fri, 10 Jan 2025 03:05:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPGe8bDSRnGBHB5QCvyExflNH+k8hKlljgJSk5QEhxdbUEepJG7Xe3xppU+Z+QAgaxzuS1VA==
X-Received: by 2002:a05:600c:358a:b0:436:e69a:7341 with SMTP id 5b1f17b1804b1-436e9d686b2mr53017355e9.3.1736507115855;
        Fri, 10 Jan 2025 03:05:15 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2ddcb5bsm84774835e9.23.2025.01.10.03.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:05:15 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/4] Update release.sh
Date: Fri, 10 Jan 2025 12:05:05 +0100
Message-Id: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOH+gGcC/x2MTQqAIBQGryJvnaD9UHSVaCH5VQ/CRCsC8e5Js
 5vFTKKIwIg0ikQBD0c+XRFdCVp24zZItsWpVnWrC/L21lyQAQdMhNQNVt0vSg2moxL5gJXffzj
 NOX+1NGlmYAAAAA==
X-Change-ID: 20241111-update-release-13ef17c008a5
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=898; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=BMnh1HQJqdLKocGUzPUCuzENN56ETPQh0vOoIjoROYE=;
 b=kA0DAAoWRqfqGKwz4QgByyZiAGeA/uuhM97G3gOc0cymlMJZbBbnOR3CGpuXt9XXuXY+S9TlW
 Ih1BAAWCgAdFiEErhsqlWJyGm/EMHwfRqfqGKwz4QgFAmeA/usACgkQRqfqGKwz4Qin9wEA1jL7
 9Ted7H7ZFVHb8giTyz7Kzv2CI6Gi9b0NWwO9SG4BAKm3RtNxrE2XA/DKjmiC9dsaWj692T1wK9v
 esbFf69wK
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
Andrey Albershteyn (4):
      release.sh: add signing and fix outdated commands
      release.sh: add --kup to upload release tarball to kernel.org
      release.sh: update version files make commit optional
      release.sh: generate ANNOUNCE email

 release.sh | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 148 insertions(+), 12 deletions(-)
---
base-commit: 67297671cbae3043e495312964470d31f4b9e5e7
change-id: 20241111-update-release-13ef17c008a5

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

