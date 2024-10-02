Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3BD1E7646
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727865398; cv=none; b=br+A512PJGSoHz3/j7FgE+jk338viHtPojs5/5KemzcieRXKNIlzuvUnMBM3IsoTrCpAHcXfYETJhuHGa89f85ur7WVenqR9ECVbou4/V8sZG1A9zs26U3NW8tKRIH60DB+4bq6PR/z5pTtBq/5zq7y10vI6Lm2oYzbRLnZ4pfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727865398; c=relaxed/simple;
	bh=2JGhr2kkz0fNOAfQaItublnT7KxF9+P/zjt89rABLU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s46mXvRkwjB8+akut5aOhS1ebluMTJf1en3/SiOC2laWjANbVCGx4jnYd7+JO9aI33J80/Om7fBuc9JrmpX3tEUiL/kubmPwLA8LCzJw2Uid9VF/WNKa7wCl8CO01A/z1g5/wQ3KIy3iGUIBF1gPOrcgcg+czvvz7j8vbeJQveQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fh7ehCWh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fh7ehCWh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727865395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct3IrjSWViW5uDKl2N8YUeca9H+66kn6vgV1IZITSKM=;
	b=fh7ehCWhT1S383Sk7H5X6lViISNYPwas6ZCaCwvHguCFZUIAaGctm4mDckV6UBWgPLmz6Y
	Pt2Nfmt3OeqsO+daEZqZfdN/VeoPBdVOwCPXrDys7Skmn0Xi9OqsxLVEGqzG6i7KCFMQHR
	tje3ArhqZ+ms7P3haKC3Tye7F4XvNBY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-ycdWJbxmNrGWxot1LTsyRQ-1; Wed, 02 Oct 2024 06:36:33 -0400
X-MC-Unique: ycdWJbxmNrGWxot1LTsyRQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8d26b5857cso45104766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 03:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727865391; x=1728470191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ct3IrjSWViW5uDKl2N8YUeca9H+66kn6vgV1IZITSKM=;
        b=u60K92NR31vW7G2gFotjUIpaZuV/IpOJIYyTnVBQCzRzqCwPt4bVWdx4CzIPx6MJaU
         IOhjk5N9ILo1Da7j1ARcCfa7g8ZViFC8mrYuMBT/VkEj2LUSB4iHZ/wUzbdPJ+wNzyky
         5ro5NTytTIpoIfajZhRix89v7RuV7IlyCVMcScZ0lGR8uzv1wtF8i+UDDYUxJ2dV2gVG
         UG24pIrhhhm/y3oili0GiSjgs9BKpp1A7gGjapffcqazIi1JBSVO3xMB2FwninotceoP
         sWB/Ub3zrEP9Dzm1Bk0VOf43uCRzJwaVDExH7ti1kRZMlZeuLsqlBmoFuDvPU93GJxSB
         5mHQ==
X-Gm-Message-State: AOJu0Yx5Hfwqv5zPB4HyU5SpnA7v1iJhMis0E/DRycaxnzvUHpb0vICF
	bX3UljZLANjRyGvYb0YAQpV+g0MLHSv2CChj/tXz6DtYeia/bDRFYXrvcYEN3hx8dDuzYeiw+1b
	oo8WBv+RhIH/OIcMB6lKphxKW6lT63aEW9sxsSuVAheSKxb+iXx5eRHY7Jx70P9A+6NZhr08zKE
	NGT5H1HOjv/8EY6qO5owju2oSQrlj1tIqCsaunjxCh
X-Received: by 2002:a17:907:934d:b0:a8a:8127:4af with SMTP id a640c23a62f3a-a98f8268fc8mr253001866b.39.1727865391144;
        Wed, 02 Oct 2024 03:36:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNrIT9OBu7ZUWlTOGQEw/V/L8ZH3XeOiEGVoqNHrTkwMPVWkUKGMNwlPWY7Bvp3jEuOLWp2g==
X-Received: by 2002:a17:907:934d:b0:a8a:8127:4af with SMTP id a640c23a62f3a-a98f8268fc8mr252999766b.39.1727865390658;
        Wed, 02 Oct 2024 03:36:30 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2947e49sm845978266b.135.2024.10.02.03.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 03:36:30 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 2/2] xfsprogs: update gitignore
Date: Wed,  2 Oct 2024 12:36:24 +0200
Message-ID: <20241002103624.1323492-3-aalbersh@redhat.com>
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

Building xfsprogs seems to produce many build artifacts which are
not tracked by git. Ignore them.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---

Notes:
    Replace ./configure~ with wildcard ./*~ to remove all backup files
    which autoconf (or any other tool) can create

 .gitignore | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index fd131b6fde52..756867124a02 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,7 @@
 /config.status
 /config.sub
 /configure
+/*~
 
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

