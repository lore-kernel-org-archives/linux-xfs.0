Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB538ECF
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558134; cv=none; b=WatycBoAKHaSlOaENwomtXbasln1DRX+76OF4AqThXheAM9fZcDdnQ0w0E5p0W9yC3kXRBU++xYNhGrKfxK8cG+Dz94QlqvkLHvyGBz4BZJigmBg2NA0xw8M+oDGiCnWt931zLC/aG3e7Y8EziMFPz3SaXe+SiBTEVftBBki3e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558134; c=relaxed/simple;
	bh=2sxhcyMnSiIx+CJFZDF/DmzAX1geMbKkWc+JqTxGVrg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=st7gvUu9w6z4h1NKA4TTAC0QnP2rRQ72j1HuFwNMQxskQc0QMlrRiNk01bGYmFRQ5hisdof0GI96XuNPR+AUilNDQRGztPV9RwbUT3keWH9GMwdKWjJFz/pdcenE5Ifxapz/O3028liHdkrAI7i5fHPUQud9S2apmILu2tBRpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9x7SBmS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9x7SBmS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0a4YT9SjnXltjIPrWVoporwRWJ9ewlhU6tvYFQMii9c=;
	b=F9x7SBmSwYM/LcCSEyZHivECtogRxh04DuWkowhFdFBB+imtNqQaMRs8LgWYuszgBoM12/
	Z4/cufl3mB57BhxpxWLBSZmd/L8gwmOyxN0SzBjpDWFuvB0Iy1cdm0ixSbfuGVuDg9KXto
	as1fJn/wsrr7cZqw+TNkFJw8P7UNB84=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-vdwfDgeLOLqZp5StOxJjVQ-1; Wed, 22 Jan 2025 10:02:08 -0500
X-MC-Unique: vdwfDgeLOLqZp5StOxJjVQ-1
X-Mimecast-MFC-AGG-ID: vdwfDgeLOLqZp5StOxJjVQ
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aafc90962ffso720967266b.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:02:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558126; x=1738162926;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0a4YT9SjnXltjIPrWVoporwRWJ9ewlhU6tvYFQMii9c=;
        b=Rn3eJcURyxrRDEHUhGC9QziD0SeSJqadCSKVj+FUr+pxMmTDIN3rlzHtqzNIrqnYF8
         rVmeUB8UGypEt4NaeZyxDzNjmdchHzL3w1XxfibBVqaD3Zmvxz/FEfRo3m331kCD0oh8
         P7uCZ4vm1RDEd+oT0mG72FThte9naMybg9prQ5Fsd42Hln4dmPRcjQjZiEA/nhlnfp4i
         Qem88JDryDWrOHKr3wDwfB0XSvAKx6iikCD7yO5X2qIuS18vMxEjXf3yrgI5tYNa3H5B
         m82nBx1l7NITXUdNolLKF7EwdaXV9kZh1LzEPQM7BBSj3DlDrcGK5rYOeYqr44WszSJ9
         +x9Q==
X-Gm-Message-State: AOJu0YxU3KFugVgm3R8GLJ1nwI/10Dv7y19gHJY6+25V2pyX6xkl3PKd
	kFFWZ8mv1PsV3IPdJE9ljxFXuDc6KG1V+M80z4wMIS2MVFLE7H/RrBt9Y5PvK1P/tIFwmjz/6Gw
	XOEypaOZY+mDjF3WsU1IpTiiyb2WiXKuVu0f6EN0FmGxEMUcyRJcF8fEiSBgL7QKB
X-Gm-Gg: ASbGncuREk2vd60xEocerC/hfrhHi3yiNQup5Z2qJuIUEp7FK9P2CpK+E0D9QpTwp7x
	ipvqgQBzyL+tn3UvBqrR2keoZlVBV8X56JM89iZlacUAKRf3JFTakFvrgQJ8Yj0CyPcb6JyjgzB
	JUVcHMM8CZ5IGtcJ3gikaBOihpulzwDBMzU7p0IgLotSceCvmrjGmKT4DPPMZhNGmhUH0nb6+Ff
	A8J3jucHqIenytZ4rXyp48d95mHJwLyFgiTeUia+8VmixZdVddXczDJrOePwhm0NKGKaPFx11HP
	ZKIKLB570P1Brzg06lVl
X-Received: by 2002:a17:907:60cd:b0:aa6:9461:a186 with SMTP id a640c23a62f3a-ab38b42f850mr2060402966b.46.1737558125147;
        Wed, 22 Jan 2025 07:02:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3iMmE8VvUViLaDpJ8hQPClZensjCC1A3OimEeE6l8JlvLavFQr0oKWJnqDmKLvO/jUtVD0g==
X-Received: by 2002:a17:907:60cd:b0:aa6:9461:a186 with SMTP id a640c23a62f3a-ab38b42f850mr2060377066b.46.1737558123059;
        Wed, 22 Jan 2025 07:02:03 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:02:01 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:33 +0100
Subject: [PATCH v2 7/7] release.sh: use git-contributors to --cc
 contributors
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-7-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=684; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=2sxhcyMnSiIx+CJFZDF/DmzAX1geMbKkWc+JqTxGVrg=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBK5WnvvlZnluVqpH/h3ju+yO/OJ3oj++E5Hj0
 vONXfS3aG1HKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAidzOYGS4fCLtjXpiVla1
 84KOnarLNb4JHj228PDu/vxudu43kXdOMfzTa+2Uu7y76Liec9zqI9Fnjk7csVpQpDRdYdrTG9P
 sFoQwAQCm9Uep
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/release.sh b/release.sh
index 723806beb05761da06d971460ee15c97d2d0d5b1..e5ae3a8f2f1c601c2e8803b9d899712b567fbbfe 100755
--- a/release.sh
+++ b/release.sh
@@ -166,5 +166,6 @@ echo "Done. Please remember to push out tags and the branch."
 printf "\tgit push origin v${version} master\n"
 if [ -n "$LAST_HEAD" ]; then
 	echo "Command to send ANNOUNCE email"
-	printf "\tneomutt -H $mail_file\n"
+	cc="$(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' -c ')"
+	printf "\tneomutt -H $mail_file -c $cc\n"
 fi

-- 
2.47.0

