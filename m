Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33A919ABD4
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 13:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727444643; cv=none; b=J/Da5UFtlaNbfw4bnyng+zjDEoUv3Ats6KKrhd9nYrK7IZiXPPu5xc1kbLlD0hU05vHrWSY7VgPsAyCTHObOiVBAfd6t/9ylm7B1fao3bELeX9/l1xP5LPj1qxTSewckURYsAHuxAHIp6PtPn2mWtK9vMRpvTFclU9/w7whtP4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727444643; c=relaxed/simple;
	bh=8bbbNVFH8fseR42WXFZpKxt45Ex12IoB7jbtz6NdCIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S692hsEcSdZafkulDpcVMAdZIVt3f8fVfIEqxDB5cnZUFVCvATpuZGq4Aob/p1uL5Vseqnyse/mezR8KtueBl8nEinqeIS6Nk/pDkvp5VY1Fb1Y8GYK4Xb1hRe5zR4UylgfWqTcLaHlSVsSmvvWpws/IjfYIdCaflVCxDl2vlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kiibbi5W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kiibbi5W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727444640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bJuvEJhIMeAQ+Uqh+fckDa2jBS95bRVN69kAwmnaUo=;
	b=Kiibbi5WWTxpadyYTrwPMu2heEuYdJJ1t4JAFQlnMYJ/UEnX6X2mVdLyUJssSdz9JqjULP
	V5Pgo2we9TSIQyijJfxu0MhtCkQxl73pTt4z0JB88/QVAEf1GLZvdRO3Zb48OWqFvTTfTs
	BtmzxIdqmlqV5LT98J4DlTxf8g0q3RI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-7J_rquuQP7WYOE-JP4D4Kg-1; Fri, 27 Sep 2024 09:43:59 -0400
X-MC-Unique: 7J_rquuQP7WYOE-JP4D4Kg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37ccbb420a9so1197597f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 06:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727444637; x=1728049437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bJuvEJhIMeAQ+Uqh+fckDa2jBS95bRVN69kAwmnaUo=;
        b=G7ZvAWCyxlAt7+xZOP4P17ln/tIy73xbkXFAbntFOhoaYLk9yDBPxFRboIdF5PjJIk
         qjJQmRY7+lXWZp20vkBofhE52ujSz5rG7Lo3P7sv4OXym524XHZL2Ivyw8EtLA+U9V5z
         HJ4WgQJdD8TCkoD2/Vn61fB0AkUuuO3YAWstHWO7ZDWmXsHmvetoNaR1rG8JofpGaNXa
         20ya+AKYnhXj2791lV+ESvrmkL9MZLP7xyeJ09lex6fL6Bz7+L9kPx6/zmxrzcnXqZaL
         VE8fd7TbNybpLNmnGlJVs0LzOVaxxgqFz6gk6tKowqAvIb/ov2zFNo0II7IEKjrD6SPp
         w3ZA==
X-Gm-Message-State: AOJu0YzWeZm7ztw2lzWzmzf09hrEWsVwq6HbXOGaQadS0mdoX3z1at0m
	+bzQY0aY6gaJRu9NZ1DVw3FiDKefdvVrgPgb0V13GtVmubBsQcp/2KsAGz3MC7/ZKJSnlnVdlk8
	78OvwUOaqYbPxisc6+NTtjIluvLdj9CwnBokaajFeR77a2wdzc3fIbfdfpWcc2ruDfdoEK20RYI
	cDXXIAAUrV7p0gwQDdwLVMpVdVagwIKLePXJhhuAOt
X-Received: by 2002:a5d:6448:0:b0:37c:d162:8295 with SMTP id ffacd0b85a97d-37cd5aafa24mr2180021f8f.29.1727444637519;
        Fri, 27 Sep 2024 06:43:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsjQRN8KR8jpVTvGJi+ZMPREdRrkNm5sxTRq2ab5FZ8E998G4hb/mbAAATNbAeI3PNOlF6kw==
X-Received: by 2002:a5d:6448:0:b0:37c:d162:8295 with SMTP id ffacd0b85a97d-37cd5aafa24mr2180000f8f.29.1727444637105;
        Fri, 27 Sep 2024 06:43:57 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd565dd86sm2572660f8f.27.2024.09.27.06.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 06:43:56 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 1/2] xfsprogs: fix permissions on files installed by libtoolize
Date: Fri, 27 Sep 2024 15:41:42 +0200
Message-ID: <20240927134142.200642-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20240927134142.200642-2-aalbersh@redhat.com>
References: <20240927134142.200642-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libtoolize installs some set of AUX files from its system package.
Not all distributions have the same permissions set on these files.
For example, read-only libtoolize system package will copy those
files without write permissions. This causes build to fail as next
line copies ./include/install-sh over ./install-sh which is not
writable.

Fix this by setting permission explicitly on files copied by
libtoolize.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 4e768526c6fe..11cace1112e6 100644
--- a/Makefile
+++ b/Makefile
@@ -109,6 +109,8 @@ endif
 
 configure: configure.ac
 	libtoolize -c -i -f
+	chmod 755 config.guess config.sub install-sh
+	chmod 644 ltmain.sh m4/{libtool,ltoptions,ltsugar,ltversion,lt~obsolete}.m4
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.44.1

