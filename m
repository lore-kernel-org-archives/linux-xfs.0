Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0015535B
	for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2024 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728043036; cv=none; b=lapOma0pSpmKqphFK5FhzUdtp3hEiZxnVskxrx6L4D7BFByPG3fw+BsX2Th2sbFlOKjdeh7L6iG9i5JhldfbCxBqgaPo/14hk9Bfrp0Rqim066jCdKNABoJWu3Zi8ERkZC9ZS5MODQQmdh6vTG80qwMCa0uP1m/NVsvLsXArn0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728043036; c=relaxed/simple;
	bh=SsLg5q61aqjWYFoNqlNNYenaAxw/Ja50R7MaDDjZRp4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CMM1va5PkZ92SzPMltNhSUfQpWMKf2QCSFMKi1Jn+ZReEI0V2o6PsFRmhbpi66ExvXwbwXEZ4Cdpnok3rUvpAmEm5TevZ/1CCc/kVlBg/9NuErFXUfgoK2uN5pTd8vT+epFujOPbHuND09KbNzgz2RmMi1oSiBs4ZA+3HsevmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjKU11PB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjKU11PB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728043033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tTT5SzdIVWnhouuIl0n2MCwUbHCUNiyKRAsM1DK6Mic=;
	b=KjKU11PBVsn/6rPtOPYuJTej3b9GYGjmweEO41A8T8pSakB7i7yzB5sWrXpPtWJD3yKMQ2
	LOMrX7F5YuqgcF4SLHvD2Z+JkNRAZAVBoeegi3DP3zl6pS30WG8ZCwhlTB49xRrWK3tnCz
	p1SHJiY/lkCp74ELa4xBkkAnzPfhOPU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-Rt2nSqIIPw6H7xkJ8C3JlA-1; Fri, 04 Oct 2024 07:57:12 -0400
X-MC-Unique: Rt2nSqIIPw6H7xkJ8C3JlA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8a80667ad8so178231566b.2
        for <linux-xfs@vger.kernel.org>; Fri, 04 Oct 2024 04:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728043030; x=1728647830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tTT5SzdIVWnhouuIl0n2MCwUbHCUNiyKRAsM1DK6Mic=;
        b=APsZBM10CqAVIZHA3VqJsJ4bN3jWWmvwDi63g03ZHikL3r6A3MzKy6D4zku1sy/Cgc
         DIklgfgGGfRMg3QIZPl8LQTaW/npV0eRCZRTIvO7bFrFY9UvZi04bxL69VP2Mk8QgMXx
         DiPbcTXxg1ruuxWp9LrbQUf0pyLbayju/o/nkS7z5b2ujMw8vIEyU+o51mFATvk1Dy/2
         zGFuiMS0zok6o/XuJ9vic7TKxoh+pjqOjhGQSS9TwbU59DTj3juO6GH9fbX+fPTjQnLt
         72xkgya3ba9wRzL37+e2Q5vIbUwg9T7t/uoK3PP7S7ZhKZDMEYX/A26oe596Us8KWofQ
         CJaQ==
X-Gm-Message-State: AOJu0Yy8gfK6/dVY09BYif8CQ2EU922HdM4m7BhoCis+KUOlmyBbnBqj
	sOmXh5irbvaPoC9ARbMmH5SXximsEYeW8nbVboR5olE9wGcohL0en1ftJOAssOSP/4CiHpL+rLA
	gU4DVMysCIkA5/ZXO4I+h5TxOFdC23qkKBpX3hOdolQnFMbAFlh6dicUxjzF3TwlI7IugFtNAR1
	nvgn48ieP9aVXznB8ac+7iWtORBHzDg4Y8NCZFRe39
X-Received: by 2002:a17:907:e8e:b0:a86:851e:3a2b with SMTP id a640c23a62f3a-a991bd79ff2mr240859966b.29.1728043030568;
        Fri, 04 Oct 2024 04:57:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgoOcVYVf3fkiUc2++f+/4uaRCcIMYvQUt9UNBk3wgBNCwVaYXhjytjcVbgQKfoYg00k0BSQ==
X-Received: by 2002:a17:907:e8e:b0:a86:851e:3a2b with SMTP id a640c23a62f3a-a991bd79ff2mr240858066b.29.1728043030148;
        Fri, 04 Oct 2024 04:57:10 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99102a64a5sm216734566b.76.2024.10.04.04.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 04:57:09 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 0/2] Minor fixes for xfsprogs
Date: Fri,  4 Oct 2024 13:57:02 +0200
Message-ID: <20241004115704.2105777-1-aalbersh@redhat.com>
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

v4:
- Explicitly list m4/ files instead of shell globbing
v3:
- Use wildcard or backup files
v2:
- Use wildcard for scrub systemd/cron files

Andrey Albershteyn (2):
  xfsprogs: fix permissions on files installed by libtoolize
  xfsprogs: update gitignore

 .gitignore | 12 ++++++++----
 Makefile   |  3 +++
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.44.1

