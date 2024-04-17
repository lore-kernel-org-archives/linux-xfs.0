Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2633C84E14
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370624; cv=none; b=CDI6q8DhRbTJCpGKIi7kf3wHfijbvVZXIw+01JxsxCDiFkJaWkdUamLDh6UCxpr7q3GAu9ZL1NUrLd18/pGXuLaBl9Pt2dhed/7jT00N3AGZDbYF5X5cbfeI/EtZTohobV0S3G0xaitqn+wUSoRXdPOjVcuONra0nT54V38unbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370624; c=relaxed/simple;
	bh=uMgraw5bUVp/cLxtj0YcV8Twzxmbu/wm01VBfpRRFYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6BmLUSmAGJi4wpS96n3SSdPPu1XQjZ5jlSRuVtG3X9tdN+RFwpIP9ix11GrnmDV0A81DfncLXpA5MQ2i91z2ocaa5DmdL/TQadX7iDJ1dtNtPLcf8fiB41a0W7QmVMDV2dpj+f2l9oMgI7UAC9A7lDR9xuMQg1ZqoOzv6LmBvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TkZkWRRt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TkZkWRRt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mz77ZZV+ybkygcmEc8at/ITTnBHjlPSt3K+grgoD21o=;
	b=TkZkWRRt9t9bShjI7SdILJ+UjsVDXpVdAjhTIOIgV6jWDRUv9omQjbFTr0l0dReLHVduow
	xAcw5h3sC88uWu5fYwzC9nWoKZy2FZrl8m36DeA1iPaZRO0+87gt3soT1SCmoPi04o6dwL
	ZY6ifvTFMmHxpB134rB91fhqwn4CoM8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-eP2ToRVlMIO0lQinDSnwsw-1; Wed, 17 Apr 2024 12:17:00 -0400
X-MC-Unique: eP2ToRVlMIO0lQinDSnwsw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5195b8410d7so327218e87.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370619; x=1713975419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mz77ZZV+ybkygcmEc8at/ITTnBHjlPSt3K+grgoD21o=;
        b=K637G5FWJodUw3YonJPHA5oSJbh6K1HAvf33k3HTNKzy07GOKacfPGwMRFnnaYcDIc
         xpdJIsV9LPd7jKxyun4NkIfEUHJO9HcIGQfWNhNAHnyTWFLlOWRzUF6rNDdZjufyk5WA
         CnrAlATyRSuL97TQpYkky7/y73BLXDagd11Yv5NueI9YNca8PJYaZ1zfxsxE7copD1xu
         XCdJLtKpAKpaxMsvk0E+Ie87s+dvrtFzQWJqFC23Us/XX7N4k+hFL49JhCFU0C3/rlok
         rlp79QBY71iukq02rrx0v2bMQVSF4uX3er4leeWaI7ax3FiyYt4+zjD2Ccky6Kn5533H
         Ixjw==
X-Forwarded-Encrypted: i=1; AJvYcCWHcS9zgvXxk8BzTpS7HZ5WeLaSbWWUucW18LIvDR6qZeZJhOQa9m+ck2llDhZAj9/m7GvkbX3q/5Q03KVwNCfLVoRxWih3vOwR
X-Gm-Message-State: AOJu0YzVFPCpIyP0hSfxN/RUjDpUIlSXEdRenqSppGWhTN71hKBVJ5DW
	gI0JpzwlwWEwV8GkqQyP4AOSsaFuq5Cd3YMIgH4BpD4tgeFHWi9xdDtSmwSMmdXFbB45fwQqeaq
	gvbinD9Xpb9PHHUB4a0KE9GDltEaoF9x01n2qGZgifihskq5EnrRtzodt
X-Received: by 2002:a05:6512:3f08:b0:513:23be:e924 with SMTP id y8-20020a0565123f0800b0051323bee924mr12732771lfa.59.1713370619042;
        Wed, 17 Apr 2024 09:16:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEugluNmslbr8t3BlW+16PH0RxhtFQo8HcOPPO9eDSU5VzzvJbzBxpRuoZAYx3T71IK8ZGlQ==
X-Received: by 2002:a05:6512:3f08:b0:513:23be:e924 with SMTP id y8-20020a0565123f0800b0051323bee924mr12732746lfa.59.1713370618473;
        Wed, 17 Apr 2024 09:16:58 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090635c400b00a4a33cfe593sm8272427ejb.39.2024.04.17.09.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:16:58 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 4/4] xfs_fsr: convert fsrallfs to use time_t instead of int
Date: Wed, 17 Apr 2024 18:16:46 +0200
Message-ID: <20240417161646.963612-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417161646.963612-1-aalbersh@redhat.com>
References: <20240417161646.963612-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert howlong argument to a time_t as it's truncated to int, but in
practice this is not an issue as duration will never be this big.

Add check for howlong to fit into int (printf can use int format
specifier). Even longer interval doesn't make much sense.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3077d8f4ef46..02d61ef9399a 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
 static void fsrdir(char *dirname);
 static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
 static void initallfs(char *mtab);
-static void fsrallfs(char *mtab, int howlong, char *leftofffile);
+static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
 static void fsrall_cleanup(int timeout);
 static int  getnextents(int);
 int xfsrtextsize(int fd);
@@ -165,6 +165,12 @@ main(int argc, char **argv)
 			break;
 		case 't':
 			howlong = atoi(optarg);
+			if (howlong > INT_MAX) {
+				fprintf(stderr,
+				_("%s: the maximum runtime is %d seconds.\n"),
+					optarg, INT_MAX);
+				exit(1);
+			}
 			break;
 		case 'f':
 			leftofffile = optarg;
@@ -387,7 +393,7 @@ initallfs(char *mtab)
 }
 
 static void
-fsrallfs(char *mtab, int howlong, char *leftofffile)
+fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 {
 	int fd;
 	int error;
-- 
2.42.0

