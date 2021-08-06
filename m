Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00686C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF4E60EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbhHFVXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239689AbhHFVXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1Pv7woJZa7hFoLGgDvTspaRzjzWtC20VdtR5OgpKqI=;
        b=TIgOvcNwqNHDnmtBs6CSCvqUd9aUXR5VIr16dtMS7tJMP1wK4SH87J/sZyl3p9XAOpL2EJ
        NJp7df1F+NscreX0u8UTcnt78MqRtaVXWNcwayoTDLH7FvBmryXu1Yec951toePb2bTL7l
        hc7Svu4qqFg7sLMQ43WAZDlCGfFbCug=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-UKdQ0tXHO4G3rjeMx2omSA-1; Fri, 06 Aug 2021 17:23:29 -0400
X-MC-Unique: UKdQ0tXHO4G3rjeMx2omSA-1
Received: by mail-ej1-f71.google.com with SMTP id a17-20020a1709062b11b02905882d7951afso3524409ejg.4
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l1Pv7woJZa7hFoLGgDvTspaRzjzWtC20VdtR5OgpKqI=;
        b=QTDMgI58AKAs79oRSGnDK2rV7+9Rd1jB4WOcR+lq09Vb5eNwYhLACP9uAkafPUlsp8
         rwi8R3vUSuLly6+O5EyRoaShNA+Zfr8jbq1plow52o+oloLbH28bgNX/MPk+YyxyMQTA
         hvIfvqnKRXpXJlX16re8qODFmhDTcBeRGTzQOyr2OYQd3erzaiD2arX3brn/sqUJAaGH
         GuIisq+wM+DwtWdQ8Ul9paJGmIvzxnNceWK4QfU2QSj09wkR9d/UNQF5lBBFr/HKvKrJ
         JEKkOn7H2MQnDijbNz1DTM44SOFO9WfaoG7QXYJ1NK/jk0aHicv0h+4NVYisYp0bh8x7
         yQoQ==
X-Gm-Message-State: AOAM532ODuuvQPw5L0/B8UgWF1pNvzwx5wNNlGw1R5dlaEFS6THddy3j
        wYcUtnCHoIN4ieroMMsG7ez+kQAonONGNCXG9HsFESe5efMlwzfGV/axU0YJSmwitqCeoq2psju
        hDCQAn0NeOZjq8sVYqBxOG6AXEfOUSyObhSR3kP4EKkPl1+GMb/HLnp9rvQz+mKo2TP6tndw=
X-Received: by 2002:a17:906:2c45:: with SMTP id f5mr11364419ejh.464.1628285008302;
        Fri, 06 Aug 2021 14:23:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLPV1CakMJbkQr6g657bOY/3gru8lMNF6EVDzJH8RhigoCaW1jBaGY5T9RZMJs1OA286bIzg==
X-Received: by 2002:a17:906:2c45:: with SMTP id f5mr11364407ejh.464.1628285008147;
        Fri, 06 Aug 2021 14:23:28 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.26
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:27 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 05/29] xfsprogs: Stop using platform_getoptreset()
Date:   Fri,  6 Aug 2021 23:22:54 +0200
Message-Id: <20210806212318.440144-6-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 db/command.c      | 2 +-
 include/linux.h   | 7 ++++++-
 libxcmd/command.c | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/db/command.c b/db/command.c
index 02f778b9..65d8a056 100644
--- a/db/command.c
+++ b/db/command.c
@@ -84,7 +84,7 @@ command(
 		dbprintf(_(" arguments\n"));
 		return 0;
 	}
-	platform_getoptreset();
+	getoptreset();
 	return ct->cfunc(argc, argv);
 }
 
diff --git a/include/linux.h b/include/linux.h
index 1617174c..ae32f0e0 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -89,12 +89,17 @@ static __inline__ int platform_fstatfs(int fd, struct statfs *buf)
 	return fstatfs(fd, buf);
 }
 
-static __inline__ void platform_getoptreset(void)
+static __inline__ void getoptreset(void)
 {
 	extern int optind;
 	optind = 0;
 }
 
+static __inline__ void platform_getoptreset(void)
+{
+	platform_getoptreset();
+}
+
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
 	return uuid_compare(*uu1, *uu2);
diff --git a/libxcmd/command.c b/libxcmd/command.c
index a76d1515..3fa3d6e6 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -92,7 +92,7 @@ command(
 			argc-1, cmd, ct->argmin, ct->argmax);
 		return 0;
 	}
-	platform_getoptreset();
+	getoptreset();
 	return ct->cfunc(argc, argv);
 }
 
-- 
2.31.1

