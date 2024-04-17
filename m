Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD162D60C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358787; cv=none; b=U23vhP+dYefF/ua0g7f2HG3uLZa3R9dr9mAthkd9QlNO0PieKmNYEww6TkqZWgqjkWuOjBwadifArcNmOkuG3IAujNn+rQGKcnimPbzHrFTtaD6gVNvxd3ndugsPSNMmE4+grHtuXeHyBb0LLw+tojc4bKgGpvtipL1c6R+XXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358787; c=relaxed/simple;
	bh=XMQEaJCh4/8EJLUpPA6UOC29KXcVDWcqypRJmNuA/ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lYBN1DghMfjFbZL0wyNvS0GbUsFL5ZG35HF2b3wbeGZB4xtjGS86qlRCep37DDkTCMDsQb4KCNLRKhQQ6H7LX0Z54gxyH70EB2DzMy+ZKhHL9PuiHn2SDAmwIa+ygf7AxVL9aeikzaS+VcMNBmKlxL0RCTN3wIfP+KF+LP0xTjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhVASsP/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhVASsP/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Sm3Nbp7PsWvZfwvmMXdfPRzKVJgtt2QF7J7AuQo5ZGk=;
	b=IhVASsP/+AFiq8CHhuMWlifGG3Yu3QsxDhSLcdDdtiGa5BSFSxCxxInNs5z8cInzTFn1N2
	wPAd7s8JIma9aYVRpF/KzF/O3ApV7WdrxnH6eloEjpxrJGEBG1RADkzHmD3IXmvYZbJTnH
	+4IfBnH0M9pOWoHzlm+zwKZN4+2JvEA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-7-dS5PG8MR-eXW313uAjHg-1; Wed, 17 Apr 2024 08:59:42 -0400
X-MC-Unique: 7-dS5PG8MR-eXW313uAjHg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a51abd0d7c6so445915366b.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358781; x=1713963581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sm3Nbp7PsWvZfwvmMXdfPRzKVJgtt2QF7J7AuQo5ZGk=;
        b=k2a+EWhJZDOOqwu3KVQIBC47m2LfdllbBYSooaHLfycmf6v0h70nbaFfkzm636YQRM
         Tmx0nqUJ1YMFlAQkh1XuR09ktim+G/FUdye8ApuuTK+/0502TpzvYF2GqiNw2gzTefJ6
         nAf7bXcR0yV7T+iZBmVIaW9yajSRdmDSWI/nLIVob82zec6n7QY4R+A/ISisOQ8s0GsE
         2SMMIOkpBPtP5/wimb/TNzVh2QoEu85XVhsiNE4dRVAZP9sZw19OiSZ1qeL2ECvgXvt6
         Z4qNN5n+pCKxI7YdGf3jQF0M6HAgz6kwU985sUExn7M56WWNJ4VVFa4HVuk//fTrUEDd
         lOBw==
X-Forwarded-Encrypted: i=1; AJvYcCXcDXrCMRyTC42jLAX0UwZCLEwo2epX9V08lBgbO0ttXlFPduvqcu14kZxMNt5mnuVkna/ncFJkke2Z2xDkybaCEnPqglkcwpd4
X-Gm-Message-State: AOJu0Yx9AB6Rqt07hG3b87oFiFREl0ZiDOmlIkSrUAf1Be4B3V7DCVrM
	7VQyerL5bvr72h9XHE0kT/OQ43BeMGrTFDp5y0rsirSmYixYFIrMpYuVaguNqEPc7xiXCgwr7w7
	TjE//+EnEwLMsWRkMCtITnT8/aiXAeOh2qNqSWgZ48hm5tFL3UUl3XW+L
X-Received: by 2002:a17:907:9722:b0:a52:27cc:d03c with SMTP id jg34-20020a170907972200b00a5227ccd03cmr12655959ejc.45.1713358781192;
        Wed, 17 Apr 2024 05:59:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNxVF/b0mts9BU+RVxioBDV3knSmshRd7wyWKDZ+0sV/k+p2jU9yhN65VovWwwtywJGPqPCA==
X-Received: by 2002:a17:907:9722:b0:a52:27cc:d03c with SMTP id jg34-20020a170907972200b00a5227ccd03cmr12655930ejc.45.1713358780402;
        Wed, 17 Apr 2024 05:59:40 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id gc22-20020a170906c8d600b00a534000d525sm3330252ejb.158.2024.04.17.05.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:59:39 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 0/3] Refactoring and error handling from Coverity scan fixes
Date: Wed, 17 Apr 2024 14:59:34 +0200
Message-ID: <20240417125937.917910-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Just a few minor patches from feedback on coverity fixes.

v2:
- reduce unnecessary indentation in new flist_find_type() helper
- make new helper static
- add patch to handle strtol() errors
- set errno to zero to avoid catching random errnos

--
Andrey

Andrey Albershteyn (3):
  xfs_fsr: replace atoi() with strtol()
  xfs_db: add helper for flist_find_type for clearer field matching
  xfs_repair: catch strtol() errors

 db/flist.c          | 60 ++++++++++++++++++++++++++++-----------------
 fsr/xfs_fsr.c       | 26 +++++++++++++++++---
 repair/xfs_repair.c | 40 +++++++++++++++++++++++++++++-
 3 files changed, 100 insertions(+), 26 deletions(-)

-- 
2.42.0

