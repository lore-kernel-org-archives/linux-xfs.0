Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4320F33D1
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727865396; cv=none; b=uHW5/kdRwYVhsbqTmQvN2AOzVsmB/Pd6wyuprSCtjjcig/wDR9hJ9zQbDWHxxC1V6bVJ3bKBloGKq78mQahVk2qtkqgc4Lyw9xdrmUYZ0N8QLPVJhVgutzuq+M8uSZxUG9ICODUVO/KOeaqjUFpP3OHgzA8JfPAvw87Vfb8RUag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727865396; c=relaxed/simple;
	bh=8bbbNVFH8fseR42WXFZpKxt45Ex12IoB7jbtz6NdCIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5UvmMchaIZ/NHcv1W0PeijU5duU9Vgtj57Y2rKSh8E6awfp/NaWQC0XEJbbOQTNQBsWLp0mufJfZqYJnQQDYLiIQw6amyXpff0lcJI+EHhQ6f7yjLBkJz/RUYp/5zk2Jhy1qvRQTXvJ15R/SoCsTfURxEK+aiQZ2sIK5b8K+Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Npe/NmEs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Npe/NmEs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727865394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bJuvEJhIMeAQ+Uqh+fckDa2jBS95bRVN69kAwmnaUo=;
	b=Npe/NmEsqLae7bwAYOsmZ3LzhQ+OfCnH9Gzfa88xvFQzB1EZ4YOWnVJVjwKOuRxxwruBi7
	Wjl+93sWKWpzjn514iw8Xq22QFDHoJeuivPmDMAjiV01ua/8rzBOoExIhtQ/9xXrGO/yyP
	yLIubozgE2GWee3RF1tvv1iHU7hC844=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-zPQWBWcgM1KYtBgJhCO6Ug-1; Wed, 02 Oct 2024 06:36:32 -0400
X-MC-Unique: zPQWBWcgM1KYtBgJhCO6Ug-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8a7463c3d0so21192666b.2
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 03:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727865391; x=1728470191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bJuvEJhIMeAQ+Uqh+fckDa2jBS95bRVN69kAwmnaUo=;
        b=kfHPHw40YrDsc+nGKV+4JHxvuynIXxIEiq344GtMRnrdT4l+o99kF/HevwedQL5cNe
         GlgnbLATQOH9HHbGpBZuIyTFrxcuc4VxofZrc1qP8PBDgEk5+VwzuDwHT7sduSpBIKnq
         3py7iqtFebjNZEsk2GeFo73YQyAvqlJaaF1Sz4dOqAEuSDfBDkbdEkZnJWgJOwnSuO6a
         99sohkOSzFmL0AoSUKHrD9X9wyJte4e94lDTjHsT3+bh+3bqcAaAZ5lIDuDxnyhxjQ0N
         Bd+X34P5te9SBry8pl8Pow2UU8CeLu4GEjpmOlqEgafJ6+I6cco8Bv9B2BRaNVJbfKr8
         MqsQ==
X-Gm-Message-State: AOJu0YxmHNO1d4Hlt4jStdMrB43y3Tq2yu2ExMnFAF0yoq3KjIPMe//3
	upUo3RhwnoDZcFyV8wsppNmm4BgpqUFewE6pADhIwWX1U/qY0EF8C2gtf6HUlM7lT0NQ7F35PdU
	jg1lbedJ0kCsIDXM7TxSNfrVYNu5ytMTKZ9xjW0xRUU88RC7REsi4Dyr1y0aiBUSD5ONLo7COCD
	CuAsRkL709PMT9N1ZGLvNWg2alyHzyklYniz4fh85Z
X-Received: by 2002:a17:907:7f04:b0:a8d:4e13:55f9 with SMTP id a640c23a62f3a-a98f8245129mr235156266b.19.1727865390644;
        Wed, 02 Oct 2024 03:36:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj8UpI66Z/VKLDZ8AnoOHEcrlRMUvoZ2vC6daQbWi/1rJ0t1LPGRAfw6X2qhiCrgNu+7cMPQ==
X-Received: by 2002:a17:907:7f04:b0:a8d:4e13:55f9 with SMTP id a640c23a62f3a-a98f8245129mr235153366b.19.1727865390185;
        Wed, 02 Oct 2024 03:36:30 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2947e49sm845978266b.135.2024.10.02.03.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 03:36:29 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 1/2] xfsprogs: fix permissions on files installed by libtoolize
Date: Wed,  2 Oct 2024 12:36:23 +0200
Message-ID: <20241002103624.1323492-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20241002103624.1323492-1-aalbersh@redhat.com>
References: <20241002103624.1323492-1-aalbersh@redhat.com>
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

