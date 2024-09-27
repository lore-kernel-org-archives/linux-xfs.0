Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366A516E87D
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727454053; cv=none; b=PRhcGmPRJmSJY04wwEoo7LL+UMxLMZg4OOsKxG18SH2t8ddQu7v1YcIOYtXkad3SPlGhdlgnfNicCBduKgYP3HVZrXHHwRyYaeyBo0Ja6muiFoR7mpyaGXN+oixrXBMEUTD4wRCwVqJvWwHTs4M0WMjSS5AYwGpByFn0feehEYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727454053; c=relaxed/simple;
	bh=li8KTNOxmik3LBkm7+Pn2PAeZe0aJQ7lYsdvT4bGgJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPvjvXjPU9ambQKbRjihxxGdGinlXcqNhUJzYeqs29p+PxDcM2lRb1qUeRKqmxD5yns222baJC09TYAcKBFPYcU0FZW9qG5buHIynxt8A5vEiuCc3dj711CnHF2F7VJMotz7pUD4o2GJEcmCH9+x10cYAg7YIumoA0a145V4W6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DcJAQGuI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DcJAQGuI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727454051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NyE4yVVoPJL67rRMkyJhq1CZsbrT2fQEf/OZrkvabMs=;
	b=DcJAQGuIRqUD0hBVSLnhh1T2vJl/dPDxFtFf6ih00XDhPk0tI7xepq76p0PqaF3HdKywCZ
	QREBJ//gLWuMrmxhWyHnFbR85wIeOjSfvtW0Lsn7l5wa9n8mqf+42YEkPkNCJSvJcK+Xnf
	rgztfs080JAjpEKQ9Oug37v9Jakx6rA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-n852YM69MoGSUCq6v0-ohA-1; Fri, 27 Sep 2024 12:20:49 -0400
X-MC-Unique: n852YM69MoGSUCq6v0-ohA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cceb06940so14815765e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 09:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727454046; x=1728058846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NyE4yVVoPJL67rRMkyJhq1CZsbrT2fQEf/OZrkvabMs=;
        b=rkmdJaQglFqLmfeQnn/BRqrSFTtG7MkQxnda0kcnfeGL41ZfivIvte445E9NK6aKej
         0lNlQbzRILyoFNE0eJyLhxuqUKgJpCz653Xj22xtxQYZ+U9wD4U+mKGjMrklgWC/SC7S
         Cswdyd9qCsSwAmm3r4RaXm+UATMkBU0OYTumTEHUNqarxeRqJalbiXSZUg16K1jLeKRI
         t2C/Idvg0D7PDQ+SXM8OkJnp/NKBdB2kaVYXxZQiS13/UhJ4peQrhiRJNfkeIA3IWIQT
         k56ApUB3wXgQP2BeaXfoHlsIme77m5odhPF/xMGXBLzOBfZ/ukToPjqTSErVUlUsSUdh
         zf1g==
X-Gm-Message-State: AOJu0Yzc9xn5dSAbuWedZqaxf5Pa/RYmKt79V4nY11FShRkPXGUDqPFe
	KcKZBKb0ChY68V1ZLsrS7clW4zQ5jbIg0xKavfNSjcE23nje5gIhQfjPszs+sw/Oww5Yglj4qd/
	dN3f0mZXtnbJl9ar+r5/Y8htuvJ6cUPQH51a9QV5tnUf3epqdJhyjX6GsMIiQuR+hAQ9++9Eslk
	mz13N4rPahTpP9lvYgXoBf6yS5OWOvu94La9Qa1Fy0
X-Received: by 2002:a05:600c:3c94:b0:42c:bbd5:af70 with SMTP id 5b1f17b1804b1-42f5849109cmr29424885e9.30.1727454046521;
        Fri, 27 Sep 2024 09:20:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhlmNdYRRh/AfvfNMUk5Uhd/dMKbYdivlBq8UR769G5t3z8IfWfrwPbwVz1adzFo7YZ2vAhQ==
X-Received: by 2002:a05:600c:3c94:b0:42c:bbd5:af70 with SMTP id 5b1f17b1804b1-42f5849109cmr29424675e9.30.1727454046090;
        Fri, 27 Sep 2024 09:20:46 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57e2fe7dsm30650475e9.46.2024.09.27.09.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 09:20:45 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 2/2] xfsprogs: update gitignore
Date: Fri, 27 Sep 2024 18:20:40 +0200
Message-ID: <20240927162040.247308-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20240927162040.247308-1-aalbersh@redhat.com>
References: <20240927162040.247308-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building xfsprogs seems to produce many build artifacts which are
not tracked by git. Ignore them.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 .gitignore | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index fd131b6fde52..b80efa1758ee 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,7 @@
 /config.status
 /config.sub
 /configure
+/configure~
 
 # libtool
 /libtool
@@ -69,13 +70,16 @@ cscope.*
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
 /scrub/xfs_scrub
-/scrub/xfs_scrub@.service
 /scrub/xfs_scrub_all
-/scrub/xfs_scrub_all.cron
-/scrub/xfs_scrub_all.service
-/scrub/xfs_scrub_fail@.service
+/scrub/xfs_scrub_fail
+/scrub/*.cron
+/scrub/*.service
 
 # generated crc files
 /libfrog/crc32selftest
 /libfrog/crc32table.h
 /libfrog/gen_crc32table
+
+# docs
+/man/man8/mkfs.xfs.8
+/man/man8/xfs_scrub_all.8
-- 
2.44.1

