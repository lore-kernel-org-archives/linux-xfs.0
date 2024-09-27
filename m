Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEFC19AA5D
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727444644; cv=none; b=joK9JOSOQNcZCZZspddzI9K+d4du17+yq82Ji8PVIBz/tCXj0j90ygYYvErMqkn9a7xv9WhfU1PcfpG3fGcHUsz49Z3PEdfFAsZNnqd3e1cGE5fzSup2Z86Vum8RWoHR8PytzOec4gJ058L6orDA4FirMPg8Ce6RhohrYROBJQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727444644; c=relaxed/simple;
	bh=fqdNEHePZ6SAACCqsTrIv5lcjtc39RJSLmkbDYY7VwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrbVgEkmOhrgD7eC1GPbvKo0sf0Eg3FzVmtxUM9nM0FVSXZU1UNDbn8hwerNgIn8Dd770rVv642t8HKvUnK5GARxFy4C3DVlgm1k4VzvzkF5bFXSIbkfrYmPxKhpBbUo0aVVibkuPeDD+g9QjornIo7uBOPTNEceF5wybqAwBAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQr+9eY+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQr+9eY+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727444641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAw8NtSb0SUb5g1rfftVVA95hGv0O5xfO3JOVSb5CXc=;
	b=EQr+9eY+d4+NFX+SbvUkTljuaAmFtGTg8cm+mG6k7vXTImbzGHp+e6Q/DMvpkaXEBVYsB6
	xUF8pHEziZ67yLK8BkYbgRyaOvWGMrDlEkoV/vB9Vc6oothdlBY43jB0NbIjNe8/xpigYt
	0i9Uqd9FpyEKYyHaIa+rXjqG58urL08=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-LiLl3wEmNMShFv9sd-XDsg-1; Fri, 27 Sep 2024 09:44:00 -0400
X-MC-Unique: LiLl3wEmNMShFv9sd-XDsg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37cc63b1ec3so1173838f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 06:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727444638; x=1728049438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAw8NtSb0SUb5g1rfftVVA95hGv0O5xfO3JOVSb5CXc=;
        b=aiqDBYQrqqbR1j4JsNNe6+l0agLRKU5gqoHjCUB5iPELyGamvtH0Sic1RkqOzUroyD
         tasZOvPeaydEKbo3b9qeEfx3SLc5t1G0+6fQbLmtLty37dNBHdDv1VpJrq0qbbiw9lWf
         shNR2dwhZX0dtRFTp4RW2C0KvUiLeEwuOFBqoqizpGorIfMTrJn2ZE5PfPCAgTHu/NnM
         o5oxq10O8ct0jfHR+jIlVr31zlBunZJZ6WlBw6dvrt4Hbq07E2Xd4frEgnRu78snusJH
         ECjsiQjXIOD9SZ2e7w0SaTDqITZuuIsyjjgwCLFDT/zRB8DmYr4Hy6Geven4YHU5Ytrb
         Djhg==
X-Gm-Message-State: AOJu0Ywsc39NsavTGDUPHjqSMJmn3gYVBTH5dJUgFDnFiXtNVPtB2nv9
	9en/FvtfsKXKoSVVJU4EEDPzZYy5vh1QUra2OY9rIY5lVo7gdQJZ7QFR80rW2JWeAUK5f+o63cr
	wwSWwDT/2l4UKG1Vlc30aWcZZD+YdvRkOAs71kRTfgEBCOMlAQP2l5aUGXrMOGe8bJLtU5fQMS0
	msEe4MZST143C8iZwh4LT3avB2H6ZKVa4FfxhtAhNC
X-Received: by 2002:a5d:480e:0:b0:37c:cd8a:50e2 with SMTP id ffacd0b85a97d-37cd5aaf995mr2101627f8f.33.1727444638338;
        Fri, 27 Sep 2024 06:43:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaMSzJnFpi4pQgR7q8hg336mEtDgmrHFQuodZiAbtU8s4P2AY7yY7KlqS8pGJFmkxhX5RjjA==
X-Received: by 2002:a5d:480e:0:b0:37c:cd8a:50e2 with SMTP id ffacd0b85a97d-37cd5aaf995mr2101612f8f.33.1727444637953;
        Fri, 27 Sep 2024 06:43:57 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd565dd86sm2572660f8f.27.2024.09.27.06.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 06:43:57 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 2/2] xfsprogs: update gitignore
Date: Fri, 27 Sep 2024 15:41:43 +0200
Message-ID: <20240927134142.200642-4-aalbersh@redhat.com>
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

Building xfsprogs seems to produce many build artifacts which are
not tracked by git. Ignore them.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 .gitignore | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.gitignore b/.gitignore
index fd131b6fde52..26a7339add42 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,7 @@
 /config.status
 /config.sub
 /configure
+/configure~
 
 # libtool
 /libtool
@@ -73,9 +74,20 @@ cscope.*
 /scrub/xfs_scrub_all
 /scrub/xfs_scrub_all.cron
 /scrub/xfs_scrub_all.service
+/scrub/xfs_scrub_all_fail.service
+/scrub/xfs_scrub_fail
 /scrub/xfs_scrub_fail@.service
+/scrub/xfs_scrub_media@.service
+/scrub/xfs_scrub_media_fail@.service
 
 # generated crc files
+/libxfs/crc32selftest
+/libxfs/crc32table.h
+/libxfs/gen_crc32table
 /libfrog/crc32selftest
 /libfrog/crc32table.h
 /libfrog/gen_crc32table
+
+# docs
+/man/man8/mkfs.xfs.8
+/man/man8/xfs_scrub_all.8
-- 
2.44.1

