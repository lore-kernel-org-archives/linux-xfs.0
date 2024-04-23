Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E18130AED
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 12:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875823; cv=none; b=FIS+v8AXZ6CtQcA6w9CdSOdqkVoJC4N6Jfx09A7TeUaSArto2plAy7JWhG3Hk4zVDq1/IeGhCXbw51NHyWXpx5+yeckdU5g/dJ167UxrN9Yq+kFZcuiRbMo83Bh43bzbazXk/z02bIfdqWs0JfUa2PVYQJ3tv/bRTUbSFBT8jCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875823; c=relaxed/simple;
	bh=gphV23+db5+xQxfJ5m43f/Izi9RUhfIHndB2Nzlk5nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMdfqTVX6dJ8oicCCJstk7qkFGCcLzi/Eu4lLGVQgyHxcRAmpLEJt8dP7Fxvf9eb7hGcxRrcKYmNZW51Z3mHkAtc3ulHHA/JzVr7BLgYht8DjZVnmLqS/i0RWL5pRtIPZGgwaeC/fd8+ds3Vn15I+cXYE0zC+l6LQHU7P3RPIEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AcZ3GBVT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AcZ3GBVT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713875820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DkqxvFgqINBe0oqn/LzATlRSjKi9+CINDNl39XwIbm8=;
	b=AcZ3GBVTFpdsJaJNyh0n3XbKQIQcQeu08Q1l7ecQ9PTB3OBYLNfsTB6mg9bd0ew3ZfGfRE
	3QcYy/tAmrs4yR5OxKHBWamO/eTs1FSQns4Sf6OT+77azo/I5/QBvtSb8ttGcWmXAi41MW
	yUkQ1XC2fA3KBrJm+aamtxCHJ2dtIv4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-8q-QD7PQMsCWOk79niNmJQ-1; Tue, 23 Apr 2024 08:36:59 -0400
X-MC-Unique: 8q-QD7PQMsCWOk79niNmJQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a587ef3d325so22966566b.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 05:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713875818; x=1714480618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkqxvFgqINBe0oqn/LzATlRSjKi9+CINDNl39XwIbm8=;
        b=v1VluAD1ZbandoB/EvKoCsYwAMScXOjPV1gpj21ZWuXIdmxwQ4603/hdn3dhuaLoGt
         ic6HDEqVXMpGQfREA0jTmCOfv+IfEynZ3UGJJbW37I7yxw03ZC7Tx/8EfMMFg1wCes4m
         /TDSUXYb/jdUdGN+x1UnmN1SBn1TFz1UMAfC6NsrgJGEqUgkZ/SrXlwuttQ5jXSORP4E
         9fF4QBX90zgTy9lwChHVO9Z8gVoJiVDDV5sAQzAmm/LBTAZ9PQnJq3pLRc5OcOsJp7Kn
         fD7DU+TJxD9UM2hLkAsyEcpMRNSvdiFreDfh2j3oC8gT3jM4Zdg8GEgrBUypvAAPoqSd
         8N3g==
X-Forwarded-Encrypted: i=1; AJvYcCVvmcwwhwhHbasG9XqF5arlPLDQE7ALTNIywEJjJ/7X83IMh3cxmylfMNH0/SSF8IqjiIwxZ8ImQOjEqLXwIjWVJfhvSVW4jKNV
X-Gm-Message-State: AOJu0YwfJT5yl/0iB84JX/zvQWC0gAOz6vJFmI9jZEcbofXE+jYCjzQe
	8Z7RgAYqZZ3cYahFXNuqJio8J5wZ97+B9o6rZaCZPSKGJEYAgPVS4jTf/piIStPkuODNbMTF53e
	Ic0Naf/KdY9KB26vjnGLC/E1nMP9yhHbxouZbi88bimm2J6oiQmMW40Zm
X-Received: by 2002:a50:ab04:0:b0:572:20cb:475d with SMTP id s4-20020a50ab04000000b0057220cb475dmr1693141edc.7.1713875817910;
        Tue, 23 Apr 2024 05:36:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGahSVxNw5BxHtMCyA9Q3fONUXTHi/k20qlW0g39PsblMo7h0wIIAVwhTtvnERfdbj6pTTFlQ==
X-Received: by 2002:a50:ab04:0:b0:572:20cb:475d with SMTP id s4-20020a50ab04000000b0057220cb475dmr1693104edc.7.1713875817248;
        Tue, 23 Apr 2024 05:36:57 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id et3-20020a056402378300b00571d8da8d09sm4783170edb.68.2024.04.23.05.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:36:56 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 2/4] xfs_repair: make duration take time_t
Date: Tue, 23 Apr 2024 14:36:15 +0200
Message-ID: <20240423123616.2629570-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240423123616.2629570-2-aalbersh@redhat.com>
References: <20240423123616.2629570-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In most of the uses of duration() takes time_t instead of int.
Convert the rest to use time_t and make duration() take time_t to
not truncate it to int.

While at it remove unnecessary parentheses around 'elapsed'.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 repair/globals.c    | 2 +-
 repair/globals.h    | 2 +-
 repair/progress.c   | 9 +++++----
 repair/progress.h   | 2 +-
 repair/xfs_repair.c | 2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/repair/globals.c b/repair/globals.c
index c40849853b8f..7c819d70a0ab 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -116,7 +116,7 @@ uint32_t	sb_width;
 struct aglock	*ag_locks;
 struct aglock	rt_lock;
 
-int		report_interval;
+time_t		report_interval;
 uint64_t	*prog_rpt_done;
 
 int		ag_stride;
diff --git a/repair/globals.h b/repair/globals.h
index 89f1b0e078f3..2d05c8b2c00f 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -160,7 +160,7 @@ struct aglock {
 extern struct aglock	*ag_locks;
 extern struct aglock	rt_lock;
 
-extern int		report_interval;
+extern time_t		report_interval;
 extern uint64_t		*prog_rpt_done;
 
 extern int		ag_stride;
diff --git a/repair/progress.c b/repair/progress.c
index f6c4d988444e..2ce36cef0449 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -265,15 +265,16 @@ progress_rpt_thread (void *p)
 			 (current_phase == 7))) {
 			/* for inode phase report % complete */
 			do_log(
-				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"),
+				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %ld %s per minute\n"),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
 				current_phase, duration(elapsed, msgbuf),
-				(int) (60*sum/(elapsed)), *msgp->format->type);
+				60 * sum / elapsed, *msgp->format->type);
 			do_log(
 	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
 				current_phase, percent,
-				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
+				duration((*msgp->total - sum) * elapsed / sum,
+					msgbuf));
 		}
 
 		if (pthread_mutex_unlock(&msgp->mutex) != 0) {
@@ -420,7 +421,7 @@ timestamp(int end, int phase, char *buf)
 }
 
 char *
-duration(int length, char *buf)
+duration(time_t length, char *buf)
 {
 	int sum;
 	int weeks;
diff --git a/repair/progress.h b/repair/progress.h
index 2c1690db1b17..9575df164aa0 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -38,7 +38,7 @@ extern void summary_report(void);
 extern int  set_progress_msg(int report, uint64_t total);
 extern uint64_t print_final_rpt(void);
 extern char *timestamp(int end, int phase, char *buf);
-extern char *duration(int val, char *buf);
+extern char *duration(time_t val, char *buf);
 extern int do_parallel;
 
 #define	PROG_RPT_INC(a,b) if (ag_stride && prog_rpt_done) (a) += (b)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ba9d28330d82..2ceea87dc57d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -377,7 +377,7 @@ process_args(int argc, char **argv)
 			do_prefetch = 0;
 			break;
 		case 't':
-			report_interval = (int)strtol(optarg, NULL, 0);
+			report_interval = strtol(optarg, NULL, 0);
 			break;
 		case 'e':
 			report_corrected = true;
-- 
2.42.0

