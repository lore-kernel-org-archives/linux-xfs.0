Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDFC2F8BEE
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 22:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765321140; cv=none; b=mdorE8Mno7uBJQflIP/kkZbeGVnTZoCBn6QOrnS7/1Uw7MEjdUG8xzMNC7Oi3vC1PofhEnbU0AQSLgEwNG2/LufYdRlMQxatLYRWcVGg/jAGCjJTpHxxWHDggSeTsR5BzV1kqCCx2jUGM5Vtid4Rxu50C/xOOZvmwcddfQ3ui6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765321140; c=relaxed/simple;
	bh=sFVdAkgFOINhzK560Out4EbgCov5DZCMN4hZSisa95Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lBT6V3/JST7PchFKD10cYTipsmdoDhLXjpxfkvV/TwtVFC8FitUmmbKvbJkbuyiIIBNWN2g8ckFrJRgIwT/evTcQg/tbwVvbjDSkcgMyb2YoRQufEryBjv/l+QvoOmSgtu6Wudhw/ZXWXe4CbBhmzw/+5wL3/TRcQBJtXhzF+QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdxKXdW5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sfnRJay7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdxKXdW5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sfnRJay7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765321138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sx2N030kHDU3OMlQAIVaDUGrGe8VrOBIheVyKBS03xQ=;
	b=CdxKXdW5gDQVAi5nnsTMliZi4gQMkh+2dN1CKiwDkELyylJg3NMA6wZQVLqCeMY8bskwYO
	InoU0dfY9sYNFUGozm85gfh5a6PT0BTjptOsAErNrOS/VETms3YZFzsfdm8dDeTVL1T2zO
	qeV7juzPznJMAH6T/gu0LT5twe6qax0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-ZCF1acqUO22-YVtZ1UHNoQ-1; Tue, 09 Dec 2025 17:58:56 -0500
X-MC-Unique: ZCF1acqUO22-YVtZ1UHNoQ-1
X-Mimecast-MFC-AGG-ID: ZCF1acqUO22-YVtZ1UHNoQ_1765321135
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso39306895e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 14:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765321135; x=1765925935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sx2N030kHDU3OMlQAIVaDUGrGe8VrOBIheVyKBS03xQ=;
        b=sfnRJay7Cihy0V/2R7l6ArlRCKipta9eQI7JO59nCqWkfNp992KA0WGm7rZCO8cIx5
         U//fwVvft3qmV9vJ1SMEOFzNAGJ9LcZ1YlKny+B6ZhGCHNnd6xZAGD1GWJKOuOw5CB4F
         aatRfYXEbdH2x0Fe7F1Q8uDIPozlxohsJA8TsWL4Jmhwv9iY+TAJW0wJyREZm0IAQwHf
         7Rac4ugMxyVa969WV3ovtbVOcL2xBzq9GsA28/xOh3yKb7Abkj8NsBXmsLxHOHuMBMrO
         7+Sr1bmRLFeXRgtrsYQ125LoDNGG/k2I/jPHPmQPKpG1nb53HApzKZNkl68O3+q3dgac
         lGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765321135; x=1765925935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sx2N030kHDU3OMlQAIVaDUGrGe8VrOBIheVyKBS03xQ=;
        b=pcVgU8HVqhHGKxBKPes3XNPWHcNN3gJsw+VXYhYpREGNd7d+zV3unJvLcv2lw709mg
         o3lpIyJL1+TqJgMBJavDSZBXJzHbz8RmMORdGkIOFldQ4D1NV4eX1fYrQ7Nl8JC2SLMi
         3XNrXagNSY4Mp2DQ6phJD9bEA0IEiBhPi/sxAh94K96DYNWuwRr0HBSD8FZcFL3FiMC3
         uzzm/W7MtxsfaxyWIYZZzIleC22iY/7Hqa7TMmRn4N34vk5FUQXFjBm/U1W9q81cHbDt
         QnNEhaTAyZjaDmGr76atiAN7zHqMcB7ZzhY5kajUR2LAVIXbfFTTLCfwc7NGrBD0s7gk
         qCSg==
X-Gm-Message-State: AOJu0YwEj1GxYv2jGptPAoTaseT3iHJ0jLwRnOfC5b5QddLM2JschEgP
	C7zO68CohFtwCvoPc0Nywpmx+wb6GYBLXl72eJnbzkJipEFqnygsKCoGSM+s2ryP+Lx/kb+IN/L
	CuT8CiK7MUnX/4IiAj+QbDaecQy5gFsDlwnvHihnTd8faNW1e+1yjADKxPYoqUwox9ZHu+tLSXh
	dd7kBbfXgqBgehl9rd+EmWH7+91ofvTP7iI6XDkSd5/7c4
X-Gm-Gg: ASbGncutqvmOqA6B1MTFuLi0SpuRnkacL6rLuJzW8VhbKnrvsh1viheIt1t39EmOKH8
	5iQDEC/2S1ayOfyyF/NjX3eLjbUFieXAPwqEj/7PdyqZzyQOMVL+NtRA36f8RzHp+F/Dx0kYjoJ
	EOG/nmDBQeaVhIwNnUoGJh8iZ1jAS1jnWuUpKjtPYuQYwaJfPVABPQPoWN7F+atafQIRgQYAaGl
	4z9kOkGN7nGe7xx6baiaPHU/eJFlcytk9O/igt8BbpS1DtcANMTdXhqE7UWdVP9XSrfaUi/SsUB
	mVfRx0/f01YpIsO+ovkFBKk2FbhNpSneDBlMlNRga7efQT2pdwSNweyYxX9TF+SteYSfjx/7ucQ
	tjHuysHYMSjCxuQitFzo77fi9CUBl8zF26sglTf8aJKq3VIw=
X-Received: by 2002:a05:600c:b85:b0:477:abea:9028 with SMTP id 5b1f17b1804b1-47a8376e3c3mr3833255e9.6.1765321134845;
        Tue, 09 Dec 2025 14:58:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgACqwu12HVyVQL7/vLC000z365P1m3zXNRJvxuudFHdeJ0m2Cwpd0xQjFFuE18f+whO93Lg==
X-Received: by 2002:a05:600c:b85:b0:477:abea:9028 with SMTP id 5b1f17b1804b1-47a8376e3c3mr3833165e9.6.1765321134445;
        Tue, 09 Dec 2025 14:58:54 -0800 (PST)
Received: from fedora.redhat.com (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d353f8bsm34575522f8f.43.2025.12.09.14.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 14:58:53 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	chandanbabu@kernel.org,
	aalbersh@redhat.com
Subject: [PATCH v2 0/1] mdrestore: fix restore_v2() superblock length check
Date: Tue,  9 Dec 2025 23:58:51 +0100
Message-ID: <20251209225852.1536714-1-preichl@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

On s390x (big-endian), running xfstests -g metadump currently fails
6 out of 9 tests. The failure is triggered by the superblock
extent-length validation in restore_v2(). The code rejects
xme_len == 1, but a length of 1 is the correct and expected value,
since the superblock fits within a single 512-byte sector.

On big-endian systems, this length decodes to 1 and the check aborts
the restore. On little-endian systems, the same on-disk bytes are
interpreted as 16777216, so the faulty logic never triggers there.

The patch removes the incorrect rejection of a valid extent length of
1 and applies proper logic so that the superblock extent length is
validated consistently across all architectures.

The outline of the fix was discussed with Chandan (thanks).

v2:
- xme.xme_len is an ondisk value so use be32_to_cpu() instead of
  cpu_to_be32()

Pavel Reichl (1):
  mdrestore: fix restore_v2() superblock length check

 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.52.0

