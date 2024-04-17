Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802A7147C9E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370622; cv=none; b=kNjeRQVSgw9SAJQbS9L/h2O94gY5evpnWQHH8k2V7fj7oHAYPWf22ewMtlH1LARWNaJXIgHoxR+nFaV8vvqDPIyMcY9vDLZzdFTytA8GFievfXyahiZStS6LKVMuTSjv6Rx6KrWb/Cmr88Pc9DXNzVj2yhRHwee2wCqCZtjqSN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370622; c=relaxed/simple;
	bh=fV6Ft5BaHumro5racGCNpoSd28ETk+SAa+W4S/Qp7Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkCEph+0ZDo8Ny3/yG9y7cP/cB+ABKrVCieSVOLMcpvfI7HLzYDfYj0mFoHwRZFwRaVFBf0WPF6ZzduOeSeYzxhR8GWsIQiSncd7qvO34yxNl01er2IPcsPJDwfgAQDTRRQLV2SWHv/e6C1nBjTU7s14dE7m6ayXJyVLJgNpGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StstT+62; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StstT+62"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0mBNkkQbwyPGTqCU/n/p4EAhVFXvPO3aXIVRD95Fw=;
	b=StstT+62oihaBwaI83mnAYdSE61g4Ewmdysd3Fwj7Vv3cy4V7yJ7ioWFe+KusiOoxn2l1J
	AV6Herk7ufCXbTICSN1lpROOo8xXFkKdH3TkcXvC0ojHr6zV2TKrZxOaV7HNQeewdKgKds
	ZkmPVC5+9E12hF6sjW4wiV5nusYCPDM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-1iywr5M_NWWUl2gcSa-ZlA-1; Wed, 17 Apr 2024 12:16:58 -0400
X-MC-Unique: 1iywr5M_NWWUl2gcSa-ZlA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a5563ef10d4so31796266b.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370617; x=1713975417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pK0mBNkkQbwyPGTqCU/n/p4EAhVFXvPO3aXIVRD95Fw=;
        b=YgRmLnFRk5BdBuHz0CdXsPGCYucQK/KHkMjKLa/IqnStV8lxfdOe/08HflibZnsVaF
         7EKTFB0gYCqHXS/sGnx+83CdiIKfx85IWeqbyDQXgjZJ1CIT3XkE2A+i4rdnILhVOavF
         YxsDt/w6T0R4q3L3lSChmxSgUFD82O1Ihkdgn1AXRH7W1ZZYoic2nzKWzLTQXj+FQCb4
         MzOmtIVElD+qc4yfB3Reyl2RCblSzm+66DBqVeXP1zEEIbmt6+jAlB+0G2OPmx80sp+M
         79rr6SPGh1LtfUqwyvRxoKf1DSwbxgvawFVqaHyFybcFrAyKN3mP4YcJnKe6tv3inX9Z
         W+Zg==
X-Forwarded-Encrypted: i=1; AJvYcCX6SWe9r1hHZuAnxBF46KpItAbKzdZeTeUfGuE2N7dmKKaDo6Dzz7Ra1vlIjKop5fvE/jrIi0XOuwe9zNwpXOJPcRhOkyGCoIMb
X-Gm-Message-State: AOJu0YwOIaeKOrvZUtkWyXeZn8XUGftASlhdSR4ZhIxRPG112zqgzKae
	scnoJG8JkMDTcdCivEA9J7AQN5atOBjE+qfUWk2NgHadnrteF9wFrvClw9Ior53oWmYeqaR6rAN
	oTRKw605oLGmqpDfMrhVRrMqKNp3NN4IKLyAdFZRF6NgzqMgv6qNNYubh
X-Received: by 2002:a17:906:d9cb:b0:a55:66d2:95d8 with SMTP id qk11-20020a170906d9cb00b00a5566d295d8mr444980ejb.48.1713370616933;
        Wed, 17 Apr 2024 09:16:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbCiF5RC28A3hpiS/QDTvemBc2GDyLulGIChVtCCZuYBLEE/6P5Ki+fYr6wjgJxjUhkkhcoA==
X-Received: by 2002:a17:906:d9cb:b0:a55:66d2:95d8 with SMTP id qk11-20020a170906d9cb00b00a5566d295d8mr444956ejb.48.1713370616480;
        Wed, 17 Apr 2024 09:16:56 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090635c400b00a4a33cfe593sm8272427ejb.39.2024.04.17.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:16:55 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 2/4] xfs_repair: make duration take time_t
Date: Wed, 17 Apr 2024 18:16:44 +0200
Message-ID: <20240417161646.963612-3-aalbersh@redhat.com>
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

In most of the uses of duration() takes time_t instead of int.
Convert the rest to use time_t and make duration() take time_t to
not truncate it to int.

While at it remove unnecessary parentheses around 'elapsed'.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
index f6c4d988444e..71042fbbfa4c 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -268,12 +268,13 @@ progress_rpt_thread (void *p)
 				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"),
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

