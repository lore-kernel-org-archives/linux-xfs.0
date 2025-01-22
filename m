Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C1C1F1515
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558127; cv=none; b=PGZp75JCB6MEWKlNAFPDZsDJLV2ZaA+6r2BvS9Cc2PZDlKV1+DYIzt1vbW4A4CB6D7cC6pVfVJeTvB32B0nVOSvPuelOwiWeAC3WfFuNcdC3uB+kcSbithFFXeqI0byjb5cS2QrBRfJzYOKBem+ShfQEK0XG7cejoGQoZIrLXcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558127; c=relaxed/simple;
	bh=HEqEQmD45omW3DI5dTvUk9w2wn3duWh/w9BwEoGzopQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z1BKHJhDtpk3onh6A4C0+b1mrJid5FzUSescdSlOhVyYiPaNQUztNGYrMNC/qsf5WvI0AwlW4jmmjuGi4LG5/rp4XMEiMOQZBa3Rsid/iKC1yR99b4kg2l4itqHpPKt0bydlnGQdVow3RUEcsaLqbcwMRBQhU+ioObcDn3rtbNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQyWKm2Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQyWKm2Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hzyZbFQELoteQSqHRdF/WMG3hxyPVv5LapiuxLd4D2Y=;
	b=CQyWKm2YB1Ye8VW+tQ+HoqqGZmmVg6TjjKhr9dqYa+sfIjZr+4JUBwgFYZP1SGZspOauv1
	Wf9RW2t2noXeeKZda5miJyfNEb+LZDdFcTFwqay95URXn2SsomZEa/EWWc+Yy89tAccKmL
	zg9wXlkODWOKdD7YeZNmMBmxN+MKWVk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-uH9Hi5crMdmL1p64JMigZw-1; Wed, 22 Jan 2025 10:02:03 -0500
X-MC-Unique: uH9Hi5crMdmL1p64JMigZw-1
X-Mimecast-MFC-AGG-ID: uH9Hi5crMdmL1p64JMigZw
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aaf8396f65fso757079566b.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:02:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558122; x=1738162922;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzyZbFQELoteQSqHRdF/WMG3hxyPVv5LapiuxLd4D2Y=;
        b=bfm6P1kzcM7DhCeP0biS3sGoUJj9s4Z8gHGoWidk/OkYPeYgzx11YRbL77J/B2nKTz
         xZhgHWex37KlGP9r8YyUo6pe2Sdg84gp3WAgqNKlaJ5axcU1LyuA7DPpA3v2SDHK9ha+
         ML7GGC0j9/xUJLf5qRBrtCItp0pkVj7d+4WVLhWJetZAjeBXUniiP1iDfBBQNiqkVNqo
         FfegjZXY8AN7GidHu/t/gCxcXTXHPdBPdNKJfF/p/TdTs2PWisL3e8c9BjOGwTVD5gUB
         ub+VQxgTHQqbCJzzrj7GuiyuafeaTsGNA/oudFYnhnkqKUVaxxIWPtYRbGshUMpOTg+2
         qjNQ==
X-Gm-Message-State: AOJu0Yz9uozOs7CWgZqHN9PCFmDtZYiTDhYC7gDpexwrbKwZ0XT2EE2u
	FhkQonA31upw/l9ZVC1/k+CjUPHRRAD1f9ZRv6UviMpRlWcM51Uoen7U7da4fjr+5MubpiFeDd0
	JSq6bGvw0IDXP7aC6MqxEjfcPanJFe69tZewbqh03+raCZtkn+RF5SqrHRoBB0Mal
X-Gm-Gg: ASbGncsHmH3FPSYTlM5rKIKAEEgJpl0ujMbNv8TLmA4+xCt0g77RfKhtR5p/ZYPTlKB
	7KC1P3o5cWXNfojMoifvXuGAfVUrJElabIJfx6y+ScSbUQcEPFXDO2ecOKAUKH9CJMLWdHjnMV/
	q/Uo4K1AU0UuhNSqhR2vCFrbUkKunKeLLRvveXoJ9mQSV3717TxJ/qIH589vzmBonzgeTTbRnBL
	Yq1kIuIl0B90ottXlgBYZwLCVKC/KwVJZkdNec31r3G6KSNpndABiYBwO8m6Hbqp0lxbOnuJgXG
	SsJgeZH6nstL7FZwn7Se
X-Received: by 2002:a17:907:3e1d:b0:ab3:974:3d45 with SMTP id a640c23a62f3a-ab38b0a186cmr2395816666b.1.1737558121547;
        Wed, 22 Jan 2025 07:02:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFJCqTbZU5BkEys+7NeTdNhsU6226t68H0Yx2JxUFz1cbbcu3nZ035EyFlmWcO3+7PI09HUQ==
X-Received: by 2002:a17:907:3e1d:b0:ab3:974:3d45 with SMTP id a640c23a62f3a-ab38b0a186cmr2395808566b.1.1737558120946;
        Wed, 22 Jan 2025 07:02:00 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:32 +0100
Subject: [PATCH v2 6/7] git-contributors: make revspec required and shebang
 fix
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-6-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=HEqEQmD45omW3DI5dTvUk9w2wn3duWh/w9BwEoGzopQ=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBNotrWi5skTQdsnKmZalqbejl/mde/A5NN7gg
 Pgm3uLVe/07SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATGTDLUaG9+EeK4yP7dqu
 LXrw+4reeYLF51Jik3rX7k5Jbk7SiUiYyMiw5MF3vU45K5XYfTLrspy92svtprF5nJ2xqIHvdIN
 NbhITAPE0RRk=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Without default value script will show help instead of just hanging
waiting for input on stdin.

Shebang fix for system with different python location than the
/usr/bin one.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/git-contributors.py | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/git-contributors.py b/tools/git-contributors.py
index 83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286..628d6d0b4d8795e10b1317fa6fc91c6b98b21f3e 100755
--- a/tools/git-contributors.py
+++ b/tools/git-contributors.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 # List all contributors to a series of git commits.
 # Copyright(C) 2025 Oracle, All Rights Reserved.
@@ -71,8 +71,7 @@ class find_developers(object):
 
 def main():
     parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
-    parser.add_argument("revspec", nargs = '?', default = None, \
-            help = "git revisions to process.")
+    parser.add_argument("revspec", help = "git revisions to process.")
     parser.add_argument("--delimiter", type = str, default = '\n', \
             help = "Separate each email address with this string.")
     args = parser.parse_args()

-- 
2.47.0

