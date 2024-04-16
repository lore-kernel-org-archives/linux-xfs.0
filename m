Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7212AAF4
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270937; cv=none; b=cPbnqFe6Nw5MXZEmLa1FUcvXX4Y5X2L4bTdn5d6vnCvwEi/tCTWoK5bNif19HE3U5LSbnT8XY94lx6IWxkyXCk3s5A6orhAOhdM6yKOVClFs+TeenbL7kZ82ExdKJRy5o9aYkEmn0qBZB/eRTVhVDy+ZZPoAsn1+4FToZ9U2Y1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270937; c=relaxed/simple;
	bh=RR03LITUPqoryx1BJJZcJEW14NlEdQqVA4q/fuGQlYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX4VDLNRuA2WfaXdUd/+b4hC8wQ3Rh1L7qwoeWqBXBnT1v3gJ8BQZa48AoM+lyUmHeDpRaOcA8uhBnPnoFO1PfV5JEyYIHDqS+oAu4kJb0ECq7jj0QHCnKDFa3q6z9tVDZAgi7q2C0EySinyGenVEOowkwaXCpCURe9OBVE1zjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fJLBpTaF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJLBpTaF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713270934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJCBfl00jEWDyYXZKn1Yca77L4ubq0YMydHYXoka8VY=;
	b=fJLBpTaF310bUDnv7uMyGnlA9RQ9hloUewHPF1qBpWEGymdki6d7ZEyWE+DYIvRwFOecJG
	9wkBTcfSV4acDUNMjEzafNSSPtEbt1DDwwN9Fd4PRqTGoJGnPZv1IH+WuD41ZZCMRnXiv9
	iNuo/iQ6wMWwo/Q19tCAQYe203Zb5ro=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-xUcxVRlINHKgEDd1zSjWdg-1; Tue, 16 Apr 2024 08:35:33 -0400
X-MC-Unique: xUcxVRlINHKgEDd1zSjWdg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5685d83ec51so2314282a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270932; x=1713875732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJCBfl00jEWDyYXZKn1Yca77L4ubq0YMydHYXoka8VY=;
        b=AHZ5NOTppcTYJ7PT7CiNZ7bZGzWWuoc3aYRlCe3Je0WciiDPRoWG0xyL2d2I7k8B5j
         II5SmP/ZE9WLrbQe/tiXQ5UakOsWXZwHz71eeLnIgC4bK5g874dUMM+1M/FasCssZaRo
         n2Wq/w3dB23hoBcjMKccF/jmqTuvCHa2x5WnONervA1SKeQZ13jUodQvugPAFyBEpGVf
         vi9GofGj1o2Oct6X/ZVDViYN3ucBwINA+EYyydGSv+5Xt0FEolIs4Edn2IUcgb774zPC
         /5xsRok0J3/3UU0VE42rRWeIxMvgSBgzwvj83zDjh7Xc7FF5bW/IVGuzxD9L3oU+S2Ic
         095A==
X-Forwarded-Encrypted: i=1; AJvYcCUMmrgckJucTDumkN4MRgrTQMkA2bFOo6emJN7UHv/TENz7Vlzs7z9YvdWRpMHPJvpzM3G8tsItQSxXXOu4Gvp4HYOCcoGd3BEo
X-Gm-Message-State: AOJu0Ywr/dstByLtlQind+KRYpg4FcF+eQrWN8nDnlwy5bm+oE+0bmxd
	nRG9Xc3URWi8v4T+4WqBJ79sUZTHIMn8KBmuouiFrCxsFNTkIbgqZC7NBaNczR1DSFLBtgYmC2o
	HAd3SysCRftRfTSomQCYBJ9nCIsC0Y0jxECGgpfqRjg6W5q+Lui9CIFaLWx2EPcGG
X-Received: by 2002:a50:9317:0:b0:56e:2add:12eb with SMTP id m23-20020a509317000000b0056e2add12ebmr7790537eda.13.1713270931704;
        Tue, 16 Apr 2024 05:35:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUyiYrjOBWA5JG6Ijk/G+tI3FkGhxogFlaSY+e6FxKVkz022VmDooR9ixeYRLf3ieg8KitRA==
X-Received: by 2002:a50:9317:0:b0:56e:2add:12eb with SMTP id m23-20020a509317000000b0056e2add12ebmr7790519eda.13.1713270931219;
        Tue, 16 Apr 2024 05:35:31 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm465584edu.27.2024.04.16.05.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 05:35:30 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 3/5] xfs_io: init count to stop loop from execution
Date: Tue, 16 Apr 2024 14:34:25 +0200
Message-ID: <20240416123427.614899-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416123427.614899-1-aalbersh@redhat.com>
References: <20240416123427.614899-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

jdm_parentpaths() doesn't initialize count. If count happens to be
non-zero, following loop can result in access overflow.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 io/parent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/parent.c b/io/parent.c
index 8f63607ffec2..5750d98a3b75 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -112,7 +112,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
 	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
 {
 	int error, i;
-	__u32 count;
+	__u32 count = 0;
 	parent_t *entryp;
 
 	do {
-- 
2.42.0

