Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F334626217B
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294845; cv=none; b=JjGFhfOZaBgKh0H/LyzoDPZtP6xERY1M9OaiZTApsznavcgil4K7BT0X5+RRv2N3wBYa+ehAX+4NS25RAGPKA1dHRe+nJdpJXjOyn5diWlsXSh5VcaRyuDEqw48Q0zFB04Q4hQSdg9dmb5xrIvcun97fzgfNoExPuGUPr7HGdro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294845; c=relaxed/simple;
	bh=H49YLUbW7vSKW1G2UCorfhqByLtpsDkossASa6BWJ1w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pzl/O+KfG8MUOGNvgyw05FhBrKmTIQ7fdvJadcd3ht/6enKGxqjZbdSK0cw6U7eqJ467Y8OBaGUF8H2egxoxH8O8SNbyNNaoAqi0xjAdFu0iFBxl34xVsOHpmfqT1+c+FdNlEbhQp5zopvsb2iockecMs2uInchEi+95okG4qa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuKdq608; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuKdq608"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cuQjbgVQzJ7hpIT9fb0pAtmNHkfL7cfg/oPTp1+oYwo=;
	b=iuKdq60848dzKUFCFCQVVwVcMKysvzl6kIdQrCvnwQdkveT03b5+UcRG83TRisdwz5rDCp
	BwSLa9FWReWGYMZvh6atRh/PetQB1K+r5Vpvzw/k7THoUYyVde2B6FU4RhbmuJxx7lStxq
	G/GA6WdcHu6X3YTw9jEnxcuBIrTR2sE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-m9fXxyS6OZWAp-c5eG4wBg-1; Tue, 11 Feb 2025 12:27:21 -0500
X-MC-Unique: m9fXxyS6OZWAp-c5eG4wBg-1
X-Mimecast-MFC-AGG-ID: m9fXxyS6OZWAp-c5eG4wBg
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5de3d2a3090so4972303a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294840; x=1739899640;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuQjbgVQzJ7hpIT9fb0pAtmNHkfL7cfg/oPTp1+oYwo=;
        b=uwg7bSyIBFeLlr3zGi04ZDcdBxMQ+angxRHogYOT1JS0fkfCizDKh58reKUe4s2SbR
         MQg++e1C4zJs6DUh+/hMy9LscPRxz2S0m1o6WJAoimdlY87K9mmoxYWj3Imt/NDoHkzC
         CbEOnhXumqvm5n/j5zNk1/INstCYiRYdBMb5wYM+D6uGAnp2R+ptdWvrEDFMgtHd4HHT
         jfBH8LSW4fC2XNlQI90Ri2pDQBoSGUHRKyYpjIAcjL1d5KWwymGHLgHWFAQVxbUw9Ntm
         IVGXYotvFU6T7N/+RBPVM/JEum9XHt9w1uczPWgKh+GNAcJWFjXCfo+BxNRXuvnstt1A
         r2NQ==
X-Gm-Message-State: AOJu0YwIPBb1jJtaN3jb7bZysESHWbioh+jev0NSXezeNRp/FNgCd/Wx
	V6M/1x3Q3EUGk7cUS6Tmlxuv49dSZTClI4UhrodcbCQ7ECMK9zbqRDbOercO138QWm9tzi1sFJ/
	E03Euroa7uOs+guKjzh8yhtlPnsQC8dOKcK/9+5mWKVc+CaaWbvCPeZGTd7oW8CgyNRk=
X-Gm-Gg: ASbGncvHa+Sqd6NgeN3/dtKPZxmn2zXT+sFb87gFopZGwem85DnLUu5iYWEYscxqg2W
	quJqYLWq9sCIXF5G33pKvPsjg8oa+AUKM/4Wxgnz1/ajM0hYSCc7xg8JDiFMcVhelGfmBx8uLwK
	L4poodY0gbwuBeeZgDEI7Nsh2LLcMj+9AcJUCtwfd++KuR0B12pOXk44rZMJdvKWfFtqcq5w835
	CQsZl34rlYcQfoD5i0CyukwCfGiUPj2rszLOBYr/dAUZmUGuHdvTUf1R9XkeHdwV7Dmbe4nDRtO
	qODI3oZUUCZuv7mEg5OMbjYuowwB/Ck=
X-Received: by 2002:a05:6402:4316:b0:5d0:cfdd:2ac1 with SMTP id 4fb4d7f45d1cf-5deadd7b874mr41458a12.6.1739294840029;
        Tue, 11 Feb 2025 09:27:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgf48K17nEnRITMbHTb+tO9MlnRC/f9W+RWURR3juc2Ij65VuSMhJdzWF4ocTWZefN6hsheA==
X-Received: by 2002:a05:6402:4316:b0:5d0:cfdd:2ac1 with SMTP id 4fb4d7f45d1cf-5deadd7b874mr41427a12.6.1739294839589;
        Tue, 11 Feb 2025 09:27:19 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:19 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:59 +0100
Subject: [PATCH v3 7/8] release.sh: use git-contributors to --cc
 contributors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-7-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=581; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=H49YLUbW7vSKW1G2UCorfhqByLtpsDkossASa6BWJ1w=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FDjZGJ61X3+yOpLlwpy+yVfOO1+euij258m2N
 czzDtWK3//QUcrCIMbFICumyLJOWmtqUpFU/hGDGnmYOaxMIEMYuDgFYCL+7Qy/2b4qnV3fVHjO
 zdv4RosR56+6JNeLJU7z7LnnLVTp933uyfDPzmTWh97Pu6sW7lC2uCzSO7/giMqPbsbaK3KVnxk
 LTex4AWlrSaU=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/release.sh b/release.sh
index a2afb98c2391c418a1b1d8537ea9f7a2f5138c1e..3d272aebdb1fe7a3b47689b9dc129a26d6a9eb20 100755
--- a/release.sh
+++ b/release.sh
@@ -132,6 +132,7 @@ mail_file=$(mktemp)
 if [ -n "$LAST_HEAD" ]; then
 	cat << EOF > $mail_file
 To: linux-xfs@vger.kernel.org
+Cc: $(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' ')
 Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released
 
 Hi folks,

-- 
2.47.2

