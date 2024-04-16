Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0E9139D17
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299062; cv=none; b=ef/qxVC0/uYheFVzLBLZhatRR2qZ27Um0HMfsaOBqnh+2NNzTtq+1ok9FfHYdvdLnpCCe1LCr/oXfl3VT8rOxBR73cRZp7PuBUQycUiKI9UG0xyhOLwXLE99fH9d7PXwP8Y1BXwffDtKOGWVNhz1I/ahxkOOXl1RMXuJWiPU2oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299062; c=relaxed/simple;
	bh=V/tjt0tdFAghHcu3N6R2wKQczfbxfAL6UGZFpH6Ta2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC7UbSCgYQvrGGTt4R/yBGchXsT3bpy5weWHLazVVgMUIamj5pzr9QK90RrB78ykae2wCeyzPJrrdLdJ0gwpO6O2T5JoKmJatKekPfkZEs016SHoUmB9sbh6fKeEesB77mb90QNv7mX7eMNa99DiLsAWgEqqxJny/B00j8J2UEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z1tdHWei; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z1tdHWei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XACU+dctAk7FszI/nYNHcXO931+8urejDikxe9NRQVU=;
	b=Z1tdHWeiQDyKzcUpiz802usYHAXyTlQBuD26h8U875iebdB4pu1/P5XB9B9fytKHgs8YKc
	rm9mmpzXGUY7clnLEs4pBz5tb7OkEoszDCOE8XQ88IfPBE1tINB/NF2hT/Z2uM4demPLFT
	orCtqA9puUiG3sMukFm/8zlmUN2jl98=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-X0Gf3ZHENzaStFX3VTyuNQ-1; Tue, 16 Apr 2024 16:24:18 -0400
X-MC-Unique: X0Gf3ZHENzaStFX3VTyuNQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-516de13dd48so3113024e87.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299057; x=1713903857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XACU+dctAk7FszI/nYNHcXO931+8urejDikxe9NRQVU=;
        b=qkAcKIl2S/czCXPRTH0L2KFW5Skomn8K/5GeZ8RNwZxFjJtA/6BcyaQmjlxVToPDua
         30ccD9KOjzmEHOFCbXKLx5JvW9wjzxYzq1iyR5XQlVwCn0ukZ6UXzzcqRVBi/1QIDfPC
         Sunw22/9O151PFmtv/R8acwnC/dxWmyQ6/oI4iDrcMTzVG7XW9ONGPuNQ8X7gmrDNpss
         +cgb3bggGU0xdNnAiLyaD8yFolGj+mHezo5bLX0VNQ2Rvsmg6kPHu4nnJNR4AGuC3yCq
         25kr7gqdl6vIgAnI5c18eCYxZyjaNuQh5+2m/mkxhkX1dRwy5aS3ub91uFLE7FjoL3lP
         1lRw==
X-Forwarded-Encrypted: i=1; AJvYcCXBcLgxRG+nA+KznBXjGjD6rreJFRsFTX3l44tdycVyymG0ZstGoliDw3++gveW7SEfLVjIpIa+L8aKNezBvSqSQlmf+S8r4v6r
X-Gm-Message-State: AOJu0Yy4FFAbGnZjeKYGvP0pQr+ILYF5G3frTk6VhLZt07h9Q7ffll5p
	OI4/ANcPqPiWUcr2K9waB2nxiprNnHeSwW0ZHXhAz9thHSFEeWwm7CI2KPlXU1qm2LNCdX7glxA
	8a01EWERG5FCcLQTdBjv/Vpro84WdWLnK92Xh9vWtuismj19sSs50MufDqdDIRmtP
X-Received: by 2002:ac2:4187:0:b0:518:bdeb:20e1 with SMTP id z7-20020ac24187000000b00518bdeb20e1mr5488855lfh.61.1713299056513;
        Tue, 16 Apr 2024 13:24:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTZVLOBZHLFPqI1YfCm4gFfiEE9KaYZ2mZnfEFdAFKwttxNw36W/Rqp+RkRlGCDQNtFbiezw==
X-Received: by 2002:ac2:4187:0:b0:518:bdeb:20e1 with SMTP id z7-20020ac24187000000b00518bdeb20e1mr5488842lfh.61.1713299056008;
        Tue, 16 Apr 2024 13:24:16 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fe1-20020a056402390100b005701df2ea98sm3655687edb.32.2024.04.16.13.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:24:15 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 2/4] xfs_repair: make duration take time_t
Date: Tue, 16 Apr 2024 22:24:00 +0200
Message-ID: <20240416202402.724492-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416202402.724492-1-aalbersh@redhat.com>
References: <20240416202402.724492-1-aalbersh@redhat.com>
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

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 repair/globals.c    | 2 +-
 repair/globals.h    | 2 +-
 repair/progress.c   | 7 ++++---
 repair/progress.h   | 2 +-
 repair/xfs_repair.c | 2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

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
index f6c4d988444e..5f80fb68ddfd 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -268,12 +268,13 @@ progress_rpt_thread (void *p)
 				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
 				current_phase, duration(elapsed, msgbuf),
-				(int) (60*sum/(elapsed)), *msgp->format->type);
+				(int) (60*sum/elapsed), *msgp->format->type);
 			do_log(
 	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
 				current_phase, percent,
-				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
+				duration((*msgp->total - sum) * elapsed/sum,
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

