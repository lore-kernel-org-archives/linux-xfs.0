Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685C1E1A2A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 10:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727865397; cv=none; b=qmW0LoDTR1Fbrss1T1MceALZ63G/dOvqngcISuDKT9OMpmUByZyw7r+yY6jND6NYV8IbBKfgdNK/YQOj0TXbRNFRdRLYszCkj2EI6EHZLt51QX4J9Fun5CpavXijrcPSkpTef3tDikshotLEOWPrf1GdjHCLb/hqJfeXPcg9y2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727865397; c=relaxed/simple;
	bh=eG0KQvoM7y1pxEH3tY9COEgkX58ijR/F54KjSJ7Wb1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RJT6OcLn61oFnwv3eHzlTdLehl4AI9atNfmBdLncv6yIvp0/LAKCy0NZuJFbFk+9ONmB3DtyDQfkvBcofxDeGvTIrXwJpXRkbLVw+/IBRVBsL98XIQDJ2kHRc/5kbLE6kU5AgzeJsT2BGVtmUQ9gqyJWwChRBTr0jZTivDgb4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W5JmZvXb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W5JmZvXb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727865394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1m7SmbPKkua6yIw368aBzj2311UHwcxeq9ZW6UxUgYU=;
	b=W5JmZvXbnaatAjLsgdUZk9lK+nQfUi+jP1juNF3aIhAneox+VB8oevZtMtj9tQRTTdhPLA
	UXXIpNSitZLD54W7LRZo7ywahqyqeLo3s19IR+97nuALNVkSzXtr/UUq3QCEa6ftyTPKIG
	vpJ4ILEMqbTZN8YrEKFFymAxt0YphsI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-SzCmoq07Mpu1XQIvWhzL3w-1; Wed, 02 Oct 2024 06:36:31 -0400
X-MC-Unique: SzCmoq07Mpu1XQIvWhzL3w-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a8d10954458so504267566b.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 03:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727865390; x=1728470190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1m7SmbPKkua6yIw368aBzj2311UHwcxeq9ZW6UxUgYU=;
        b=gEja0A9u+UTSJoIi6QGHdyk5Cdkr8XSCZo44smBv0g6ujVHW+aIyz66ki24TW5Zbj+
         gd5M9PXHtREKbC4MxMOP+EEZ6NWFoEXgP+49FQqYinP1IgZ79StBXIP/x6LkLzronoXD
         /u7xgDN8Ruh/YvAv45hQQbyeeWELrr8NhJ4ElqXDvVgMTJ1pdHhk8D50jMyUR+K43KET
         C6LX4TpZW2/FMwfapQUxIvoMkOgMdW4KZgD1m2GHLKMnXd6C6OBUdg2MCk0iPXmpY9Gx
         xOjvuBiDdwX3GZ7O9ae+xQdaj0Dr+f/5pk93MYg3K767NacvQLPz9mrSGn9fVUAm6JYe
         TKkw==
X-Gm-Message-State: AOJu0YwACfptS+KWxnw0+sjfDjdW62o3SUApZu8QLBVYOGHwjU4m7He+
	LRqtTqYNUwDbVtckCgdW3Vtt6C2l1mRF1k+Vx5vL3dzY3Wn8qcbQxQa9WFwOZyXfksg6/5DzVtC
	laZXZ49Vx2N0CoUp5LzmqoxA6S+EwOUXh8yAXdm5rhYifn3C1BDPg84uzF+yKbbmHwYr6xIu0Ks
	EkO5+VbJvwjeefbViIUIk9EAqkW0sxOqBsq8LLxrCR
X-Received: by 2002:a17:907:96a3:b0:a8a:7062:23ef with SMTP id a640c23a62f3a-a98f8263330mr239195466b.32.1727865390174;
        Wed, 02 Oct 2024 03:36:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvxc3kKpK1TauLVw1zckmNzE3Hll2DM2UWRDtvVUAWMnZpK0MakwrLmJgrr/CCNtLEhWj6CA==
X-Received: by 2002:a17:907:96a3:b0:a8a:7062:23ef with SMTP id a640c23a62f3a-a98f8263330mr239192966b.32.1727865389721;
        Wed, 02 Oct 2024 03:36:29 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2947e49sm845978266b.135.2024.10.02.03.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 03:36:29 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 0/2] Minor fixes for xfsprogs
Date: Wed,  2 Oct 2024 12:36:22 +0200
Message-ID: <20241002103624.1323492-1-aalbersh@redhat.com>
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

v3:
- Use wildcard or backup files
v2:
- Use wildcard for scrub systemd/cron files

Andrey Albershteyn (2):
  xfsprogs: fix permissions on files installed by libtoolize
  xfsprogs: update gitignore

 .gitignore | 12 ++++++++----
 Makefile   |  2 ++
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.44.1

