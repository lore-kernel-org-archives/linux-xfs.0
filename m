Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E19331DD82
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968573; cv=none; b=QC+2TiZBDimJVRsW9eECMGGpkpNEqFjcrmIRpAm/YSjFnWfPXqyn+Xxu0VsYKZaNIPw6HJEN7NQUU4ZZCLqVAdGcCrkbJvZ7072Pj56VTmaak9ZZlwAEEdjUBoFUknroGUVN3wrBa8aH6fV5RwnLqC/PuUxNILuv65RlWKbO5fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968573; c=relaxed/simple;
	bh=yGp/NxJkcclLX/oxsMmnaFG7uXGzDm3sgbQh2bb8Y2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJltdfS8Gp2AKhDWyiRvlS6mZSOPSbk7UUQQdO7tqI7lQZRukz4KAKWeryMZhqWg57ISCS9jUtOiCooSqrtsjg/Tff6yzNce25QT8TN7tmhkqEtk6PjPVSjIqroKX4LTOEgJ3Hl8p8gYoTwg7S9aF5PeyLs5nEBQIzE+JdGY/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B142qzqn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B142qzqn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760968571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=joqZRkk4+TwVEW9KnzmZmcPW11H9Yujd1P1x2lAPzHE=;
	b=B142qzqnFab8Md2AYk9GWT8tezKHUQUnxMl8axWMN2gQTiVS+KO5cgTDw6comhivXZLk46
	EfHtWnIwcExDleUoWP/YhyaPSBrulWOxjKlpajIYhHqRCWxCUp6KOhT1rU8K9Wv4xy1W3Q
	s1MVz1BvcBVodPUKyGwhznz46bVIKHc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325--yQGqARiMliRt5RemKRCNg-1; Mon, 20 Oct 2025 09:56:04 -0400
X-MC-Unique: -yQGqARiMliRt5RemKRCNg-1
X-Mimecast-MFC-AGG-ID: -yQGqARiMliRt5RemKRCNg_1760968560
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-472ce95ed1dso9569315e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 06:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968559; x=1761573359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joqZRkk4+TwVEW9KnzmZmcPW11H9Yujd1P1x2lAPzHE=;
        b=fWeuy3pV2UKtz74YG7ykCpv1Ao14eIIykrZWfN5sZCltNxatonyo8Qhhs2EN80B8s+
         c8KjWk49LblHCRX8ApPES9JPj1RTQTAxn9UuC4svVR0sB/b56RqtKts9jMbAStyC190H
         fMu1EsYqN7+iwaZz6xORLs4NA19ED8KWmob4JmQWhPKBitR0pXQwWhc8S+gGETjRJai9
         EE3Dq95nTDOq+Py5AxGB5LnxCIoJH/cdd9Mb/oxt5/jxja8wHpYyx3WIcDkYbpayxTu8
         GyPc2psX+5W4nOVeJy7Dpi5MXNINGgzhWx7Wt/a15s3bUplQGn9C9Bi5QlOA2om3awoq
         Wvyg==
X-Gm-Message-State: AOJu0YxcnyQWzI8VEYzWbD8yLk/FzZFTk8kBN7cxYyuzQbnOErCI1Azc
	OFKWyFxEiee+JOLjspncd1ERISMH6miQjP1/8Jl77SfaaihLVZL2S7rqiwKKrSZxus1+o370qzU
	Y+lgOaYf95bqLYfDB8l7xRjPEEBuc3D8MkruQhT7VvKTsfJc8R2BLBtG4auk2V9rhcAIGErMG9V
	0S42eBaT+LtXuF0CzeiPXBXV6N2+ECbkN3AJEJEaRpeDdb
X-Gm-Gg: ASbGncvaEph3UNVaPm/GpeEnvx/vZBG5AzS6EickPhyz6y4POaCnQKleOj42XmjPmss
	p26wYwplSNcsfNZg8HS4IKfjg7MrsEl2aZ1iWVIcSJrrX9VYhxtkdyKLwtYotk3uW055lc+pPSQ
	XlipJTgZhy5GiLhfrnLMNzqRMuxdApXi18JnaBmGBIR26M9pTiU4sqsrVhPGZ8q/MTYNji4W2qT
	iK2laG8O6aN+uWVBqR/JMV7/czRlrb+fnQVbcTkVD3ly2U/g/OOZ0h/BeoZWd2c/Hj+pdBmTkOv
	IOojRvUIr+ay/ql8bdRd7wvYag/SgtyrfTidmvOSbu9b6CrOjzAUGcJyEAIz1CE705fF70HOaLO
	Z/CXz6Jq3dnBkH0kzs+54HLTiR+zgVidMBA==
X-Received: by 2002:a05:6000:2889:b0:428:3e6b:8deb with SMTP id ffacd0b85a97d-4283e6b8e84mr5337675f8f.61.1760968559260;
        Mon, 20 Oct 2025 06:55:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERmRBSiPso4Fx/JyEpbSHJUDtjom7V3U8lKN/pPy8a4YxPD063xQIzuzCItfdNELs2meiroA==
X-Received: by 2002:a05:6000:2889:b0:428:3e6b:8deb with SMTP id ffacd0b85a97d-4283e6b8e84mr5337639f8f.61.1760968558643;
        Mon, 20 Oct 2025 06:55:58 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b55sm151404645e9.6.2025.10.20.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 06:55:58 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: djwong@kernel.org,
	zlang@redhat.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 1/3] common/filter: add missing file attribute
Date: Mon, 20 Oct 2025 15:55:28 +0200
Message-ID: <20251020135530.1391193-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251020135530.1391193-1-aalbersh@kernel.org>
References: <20251020135530.1391193-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add n (nosymlinks) char according to xfsprogs io/attr.c

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 common/filter | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/filter b/common/filter
index c3a751dd0c39..28048b4b601b 100644
--- a/common/filter
+++ b/common/filter
@@ -692,7 +692,7 @@ _filter_sysfs_error()
 _filter_file_attributes()
 {
 	if [[ $1 == ~* ]]; then
-		regex=$(echo "[aAcCdDeEfFijmNpPsrStTuxVX]" | tr -d "$1")
+		regex=$(echo "[aAcCdDeEfFijmnNpPrsStTuVxX]" | tr -d "$1")
 	else
 		regex="$1"
 	fi
-- 
2.50.1

