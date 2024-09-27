Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB988142621
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727454052; cv=none; b=fKm5P5csi1+gaswwAwHD5+1ylIdfOlXfNZVoBahQoAFmEBBZ/A1uAa+QRx6jNDblMLEu3G5eNoEscDOxdMAtjZP+oIey1jx1xEOBS3sS9Gp9W74pb+sC8c4MEWyOt1NUePoNBMd0y22wYtx2xCJxmz8c00zXig8mnRuIv9eQ9Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727454052; c=relaxed/simple;
	bh=nXGEO1LNYuPtWHM7ZnHzkiUlJN3ZWDkvXrAmhvUQxaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mt9C94i3A5v1uoaxBE8HbQGPaQ2GnTWo/1LHWj970jRDwveSLAOEPUFHwKJRPq87BGCykTa1CDHPtOFU08nYDruRw7BplITMAQh8FCB6O1xsU4zkavVAUcWqNY3lnRkv8c9THbeGnTZN8r3zAzAa3O6ySbTcsU/MTjd02fw9FwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Esq71kqB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Esq71kqB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727454049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RJ9VUuoJHd4aThqsUc+FJlHnTQFs6glW9GXXaFFLlTg=;
	b=Esq71kqBe7UEUxfkjgB82GOoO/bUv3Wn9YpnScu9B55pHbwPeQOpppWYQZD5Xrd5gUDj3D
	HRMZlPoMY230n0Ma+XI6SEQRHRhffmTuayuG1/D52CnliU9eCopRl3OvbK2FTDfd8/6bdZ
	wx1ruRAMt0iJGdMG436QZKeXE1EwtSg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-U-RKASfYPPWaLA4Ld9PBUA-1; Fri, 27 Sep 2024 12:20:47 -0400
X-MC-Unique: U-RKASfYPPWaLA4Ld9PBUA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb6ed7f9dso22681375e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 09:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727454045; x=1728058845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJ9VUuoJHd4aThqsUc+FJlHnTQFs6glW9GXXaFFLlTg=;
        b=prmhrvTDhKWbIL7trbBX/XZ2cRTs74S45G/mEvN9XfIknSC+tSMckHavyQbLLX/5TN
         d2bk22FVxhQO8wqvhAAfGwBX2FqYCJN+nmOtbzrP0xe6ybazvnlwf/p27tdLchEJylKC
         lg88BC3615u5dqPjMWZkk34gawxAj1sgVp6TuRTsmHRs663L0MMnhfCCQ48IiG9ubJAx
         79/gDZ4TH+2PLa0PWPq8zmKGuUAiRxOV+rqrYYjoMKhFhEfNe+Kd5oMmWs/r265NHHGi
         nvQv5+fL5aPzDT2sXfBcXGvi7GcHC1CweCe2XRV+ktG5lc8r+LdgWVe00LtOo3oE5/et
         vatw==
X-Gm-Message-State: AOJu0YxZ5CVYS5224nvLpHA5VLmBccDyoVUfeUbREu2PVnSs2WrCYUEA
	0lAnKBi9/ceAHZ3bGE+CcfQl87WB6n4HuvSLgu9KtnDpsfDnOEVF0nI2HgPIaDnqwOHbQGu0dF3
	rV9lJHlTg5mEb2LM2wskQNcEVYQkaUYE1q4PvcPaHQ52p+FgrFYTGIBpz5Ip/rjM6kIGrLuf3jU
	eJZIFgPLCjNPb6DtXX5E0b2JSK/3aK3Egef11SamZh
X-Received: by 2002:a05:600c:1d20:b0:42c:ba83:3f00 with SMTP id 5b1f17b1804b1-42f5840e1efmr37815305e9.1.1727454045564;
        Fri, 27 Sep 2024 09:20:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzNxRCqMvhL0Kc+nomLVc71AKpylNO42FV9v2lFIAbD/45g8z0DLewHYgaIqEOHlZzQ7rQuA==
X-Received: by 2002:a05:600c:1d20:b0:42c:ba83:3f00 with SMTP id 5b1f17b1804b1-42f5840e1efmr37814875e9.1.1727454045152;
        Fri, 27 Sep 2024 09:20:45 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57e2fe7dsm30650475e9.46.2024.09.27.09.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 09:20:44 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 0/2] Minor fixes for xfsprogs
Date: Fri, 27 Sep 2024 18:20:38 +0200
Message-ID: <20240927162040.247308-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

These two patches are fix for building xfsprogs in immutable distros
and update to .gitignore.

Andrey Albershteyn (2):
  xfsprogs: fix permissions on files installed by libtoolize
  xfsprogs: update gitignore

 .gitignore | 12 ++++++++----
 Makefile   |  2 ++
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.44.1

