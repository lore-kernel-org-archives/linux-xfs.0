Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9CD158A23
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 22:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108709; cv=none; b=ZQTE+1hAi9D2+vAx0HcekvwLataxfOgHgEVhpkdVaNTDdzl0kYvWuJusxkEnQWAdjhMTjh50yhtufp34TQ/rC6KQ47wwT11DS9gAm9VZ2MuplVk9+Fn3DwECdd7jrNJE3ibjp5LE0uWFYm3dmOoj1oBVi3v/+HOxp97o9VPXLSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108709; c=relaxed/simple;
	bh=MXGI6VSicE7T1E5OFuCt+Nzid2HwkQZkw9zAa+dbyuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CA7qwZMZk/dEgVGjrBtZ6hs3RyGWJ3CP1dfxtM9Kjbm2sLiGmzB67neBGFdt2J3ocpIHh3pvL+k9Ra1DmuJ2PtgZF3HqM0LDrK/loU/75VWUlaRy7XKlZHFZS6MrnDfTOtiWXA+5E+JMSlgBEbzzmLFONmEepYuvVH+hk4QYoUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SuQWUGy8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SuQWUGy8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717108706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y9yoRh/CbOZhOF9//6QOC3/DejT7jfzGC4yRF+VkFoI=;
	b=SuQWUGy8e1Stx3cAhwWmrYGI+WJdoLw1Gs5ICG3Q8AW+IqRb3AePMJLvTPUbclo/RAR3od
	fCOA6V8uLZZhhBdTA8KvJZ2LXM2NhwVXTS2Ggz2GweWX9K//zUqVdOO2Kf7x+Ff2YWmO50
	jjblPzyeuiQ+UZtATkgdjoh+sa9W08o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-jvp_8ojCOIGQxf4sg596jg-1; Thu, 30 May 2024 18:38:25 -0400
X-MC-Unique: jvp_8ojCOIGQxf4sg596jg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42128f7b5fbso8543925e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 15:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108701; x=1717713501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y9yoRh/CbOZhOF9//6QOC3/DejT7jfzGC4yRF+VkFoI=;
        b=tolHWEQkRbpOy93Fb1ysB5M63g1NCBaqnALK/9veArmCDIzdZXtGFXs//PC/zXEe/H
         o8D8hEIsqIMSvhHgTOP7DRRlUs1sRjw6X7P3tRjFla1T6pGz00QHkUjGP45QNRb57WtQ
         d3i5rm2tA8BENjG0RK+fAX4tJNP5NjT/oOOjcu3cblMtm+NTQZtDs5v5dguo6syHH0AU
         eDT6NgMj/edywjEcPb7MB3nld0BsX4tDLuSXecjGdRG3MvKzPkKd0IEaRd8K0Bgsjm0Z
         ydh+NEBnruLwsrFTqjYQgZnZ16FVyvR3mSMlKTEgHVtndwrNYqM6OURM8vYlKeYibKTO
         v68g==
X-Gm-Message-State: AOJu0YxRB8jUGrY4OFJPaDPCMJJCu4l4kzeKt7QMB0lCDKFkKmQRU3Xu
	grHU3SP3u5BCpYPQNVaZA68+H1U3wjc3vUZKN/+hHYBtKPJn4EbmEPaDl7AfG8ZTvsucPGN53Lv
	hH777LLVt++wUfhPYTqayKdZUa6npauONc/6XOhqQhVE09TnvmRE+W7PGC/ZnD0YM5YwlvIlo06
	CVqB91QBMnFp9fsURYjQ+dWBgNBV3IpWwMXlfMwdHM
X-Received: by 2002:a05:600c:5026:b0:421:15f:186a with SMTP id 5b1f17b1804b1-4212e0bfe7amr860725e9.39.1717108701221;
        Thu, 30 May 2024 15:38:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXkggyoIepmAQh6rnpdCJ1MvcISHrZyhGF1zLm9Dn0b95pUjahjZyz+SVRAMwxjkqTfYWyQQ==
X-Received: by 2002:a05:600c:5026:b0:421:15f:186a with SMTP id 5b1f17b1804b1-4212e0bfe7amr860605e9.39.1717108700771;
        Thu, 30 May 2024 15:38:20 -0700 (PDT)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42127062149sm36053675e9.14.2024.05.30.15.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 15:38:20 -0700 (PDT)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@redhat.com
Subject: [PATCH 0/2] xfsprogs: Fix some issues found by checker
Date: Fri, 31 May 2024 00:38:17 +0200
Message-ID: <20240530223819.135697-1-preichl@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both issues have been found by Red Hat's covscan checker.

Pavel Reichl (2):
  xfs_db: Fix uninicialized error variable
  xfs_io: Fix do not loop through uninitialized var

 db/hash.c   | 2 +-
 io/parent.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.45.1

