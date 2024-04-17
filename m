Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DFE13CFA6
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358384; cv=none; b=fkeWm/Fj3/UVL15XHys3H1RdIayJxPM9WG4aEMvGdU5+/Bbb19fbKXvLwtkKV7GZeZsaJRlq3fEjQYDci4/Y4HFmDetegKLi+/ZYNBzSVnMU+ATC9TTn4aubuSRDoi3gSy3haTwbYGJabvEltTXKqGwr+tNzyzH2DoihT+kmtBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358384; c=relaxed/simple;
	bh=C5+iz15Iw2env74n4pq0MNv1b4Sz+flYCAOmRifMWCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCEWVdu6lKwgqiBCZc98x7GNNTsxXh3FEot9mJMj4NaHsHE7nr+pP5tthMJqpBd9+B85eFOJUkgn1A+G2fgYZJrMVwfBdEfsQGgASceXQSxXGDuv4Ui0pte72qFy69hhnLBWtXQUwHRurOFlCzl7uaPX+014vtPSwvpTslMx/Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AiXcxQkg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AiXcxQkg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5tUSmPSFguzDZMGlK6GyurAr+DFBgPGYwHDlJ6OTWto=;
	b=AiXcxQkgXkDsnkU+pyVmrxJg8IBuh/X8azMgLePbUqm+4UcAcL0mVDM9WV46E1jixViwp1
	9X8quZKtHunVZvPp8OJkDFzDuHZKRsVVIRAJg4LG+vDGOsZvjuyVyPM+HCXd7LFSLrTfbN
	/Bmb9aGm87WWzYir0dZ7kgkTulR5e+c=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-QnrTqCucNAWsogLr7zl_Iw-1; Wed, 17 Apr 2024 08:53:00 -0400
X-MC-Unique: QnrTqCucNAWsogLr7zl_Iw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a524b774e39so101502966b.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358379; x=1713963179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5tUSmPSFguzDZMGlK6GyurAr+DFBgPGYwHDlJ6OTWto=;
        b=hX+gyXBVTIZNwdqk98Uhp3uOjhri0SmU4tByhKVcLPqoT2BdXym2nYjjNiRy0yTOeQ
         by2Df+VNsc7L5/SfkiEOFcz+bdYjeuICnc8wz5+0OVzO/pdw5xrguWTLPLxxObyPbaTl
         yLvolYwDdVzbposiRkqxIWmQJVAJ79X+T0iIpkwBS5M30Fv0DUjgQWGU4T+6ti9AErTI
         HN6v9okG+qhc3JDbQn3u1ojckbB+2QN3d/VwdlaxbPr/TdZYdQg84Xtvd8L0DgHOaunc
         EVQm0fbGPTtclkyWdFom8SzZrYvJIKU4A4OTGKa2PCXI0SPjYnIj3LV67TbKXTOqPhMU
         SfWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJp/788bKruAWPsNuG9bVDqR655d481T79Rn0atkudpRcClEUGk0d0Yql95XLMGuo0dPjIYt1U5+9e+wtIgAAcKKFlUPMdcYmw
X-Gm-Message-State: AOJu0YyweLlEr3N4HR44hhfgTmPTGyDz4v8tcq4ZevFue7q44YHNP7hI
	mbsEObIZUd9cozxLejY0I5KbuDMbTf7qXxGjlqP/okeLw/7uJvlkAd9NLOMb+iVX6AAFJLZXYWo
	d36u+n/zekTJfRC0hiVBLoqaPVLV1vlMkhgiAKY2+ZiXfDxCCicbiI8iU
X-Received: by 2002:a17:907:320a:b0:a55:58f0:5684 with SMTP id xg10-20020a170907320a00b00a5558f05684mr1669742ejb.28.1713358378821;
        Wed, 17 Apr 2024 05:52:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpg4qHDB3hZFz/VNSl/YyH53PUBFMXK7paNr9sNEVr5/V0EWo8s/RwMvSWOwB1TlM/RJhdPQ==
X-Received: by 2002:a17:907:320a:b0:a55:58f0:5684 with SMTP id xg10-20020a170907320a00b00a5558f05684mr1669729ejb.28.1713358378345;
        Wed, 17 Apr 2024 05:52:58 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id en8-20020a056402528800b0056e2432d10bsm7258169edb.70.2024.04.17.05.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:58 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 2/4] xfs_repair: make duration take time_t
Date: Wed, 17 Apr 2024 14:52:26 +0200
Message-ID: <20240417125227.916015-4-aalbersh@redhat.com>
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

