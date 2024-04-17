Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D7213D53C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358386; cv=none; b=LVIDaGfz0pgnrwb9kZv7KcH78fhZkxvTFqH+2ahnPnfbE6dF53Cq2IkzO6Vl7k4MzrKhyzYuJRU61HWofkyw7R5ViGfU1ral4jtAZdZbBiENh7kh7s62SQ246Pf9XjaDPOQ9lXTVYqG1bwhWdUQe5izPiUs1u6jyeatJM8jYcvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358386; c=relaxed/simple;
	bh=QHbXu60hIYPcu2upLEJCNpbT4ZuJuUjUD2HLvj70emw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3yajnfStMDEc/azesdp42pSKeJ1GpfH7yktIfTF/Sz4g329q+1k6MDuGUCobTrYt3ltz3RQWChoSIdBX8bRLwo3rb16UobMhelXgrA2OyL1+YBGwOPyjUlbJUA294pZJM5/Ne0yRB5LNnQmKj7pE1kOizRfHZaebenR7vpqXiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hLC2oV5d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLC2oV5d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVo/jy69JZgmk6ipt44yooon16rXmwikx8HeguITUzo=;
	b=hLC2oV5dDY74t6GIkQtaFhwm+o7xTcUiIo8APx96iBATklSomG4EBf649kpnMNPR+IlWOL
	h/QU/V4qe9q9qVlat9lVmGPbYnzbyBGP82CAXeyMYsgnh161HWdpy1M2tZf9KCCyL7S26g
	lqUj+8Y8ry+N9sGHD/ZLkhIadWAbOkA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-ShBpjzFWP6qd7pTchlf9fQ-1; Wed, 17 Apr 2024 08:53:02 -0400
X-MC-Unique: ShBpjzFWP6qd7pTchlf9fQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-516d6407352so5280907e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358380; x=1713963180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yVo/jy69JZgmk6ipt44yooon16rXmwikx8HeguITUzo=;
        b=GE2Cmh4EJA3oURG/ipV1t9hg0VOEPggJT5PB+t2d2IVDAqxwkUjVRhqffFflaIahrK
         WBaFwYN0O9DX8LXOz4CyvWqIeiA5Wf4XRYDzaSOVyxT1w7O30qyb67Tls1/0AloiS71p
         FzAZKf2MhU5ZeKanCVyN0KtyIMnqrL5oDdX2xttdurmVBmPGq35LJuSnSyE8HgcaXsu/
         bK1gzTFTXNM6AnVANUD+YqNZpq+f63cD3B9o5n9roMh7mE/HkzN14lPOSWWnWM/M878u
         XHdJt3Tso5LbRDUnCtgddKxP1EUTcg7OUEtRbxGm+ZkjRJyBRxmzQhuOv/RRvrq+WIlt
         r/MQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+FKtHEx//BsHS+Ba1HA0JHvWmtUT3tolzmbcRzFxPlO9ErLXFchAw1YCWnnXPSCViXcTCmNDN+OvGKs0tqQMDgbi7zJIXOVXx
X-Gm-Message-State: AOJu0Yzym2p9aMxcAzepjqlGdTMclzDwixLebQzaMexaYXw+DNKqqE9Z
	nC+6wDZEnrkmg4jRP0011KuZwSBa/hsC7gTZrqWgwcF5BdRChmxVnNaNpDF1JkLc/GpTXAhZsxQ
	rSTH176lgGhBVMONoVZA4mO08wb6IwNWnWCTBg1+XWEl/sljUcVhO4JXr
X-Received: by 2002:a05:6512:1103:b0:519:3a8d:2ecb with SMTP id l3-20020a056512110300b005193a8d2ecbmr2554668lfg.5.1713358379610;
        Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXT44ukteBDsX7n+bqEUtNqS/qQTWUdPLqsaRmxP5LoZ/jQ4FqydUmt1/Koy2eD2eLvi7FFw==
X-Received: by 2002:a05:6512:1103:b0:519:3a8d:2ecb with SMTP id l3-20020a056512110300b005193a8d2ecbmr2554656lfg.5.1713358379140;
        Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id en8-20020a056402528800b0056e2432d10bsm7258169edb.70.2024.04.17.05.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:58 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3 3/4] xfs_scrub: don't call phase_end if phase_rusage was not initialized
Date: Wed, 17 Apr 2024 14:52:27 +0200
Message-ID: <20240417125227.916015-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417125227.916015-2-aalbersh@redhat.com>
References: <20240417125227.916015-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If unicrash_load() fails, all_pi can be used uninitialized in
phase_end(). Fix it by going to the unload: section if unicrash_load
fails and just go with unicrash_unload() (the is_service won't be
initialized here).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 scrub/xfs_scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d646ba..50565857ddd8 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -631,7 +631,7 @@ main(
 		fprintf(stderr,
 	_("%s: couldn't initialize Unicode library.\n"),
 				progname);
-		goto out;
+		goto out_unicrash;
 	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
@@ -828,6 +828,7 @@ out:
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+out_unicrash:
 	unicrash_unload();
 
 	/*
-- 
2.42.0

