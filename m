Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D451292D7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270935; cv=none; b=LsnGzxGMI2+RfqeBmIitZU+hN/ATPfWjm9l6FzPjKSPGCP3bouJ8M8vXcJRz/Iv2pmUQIx1TC2EKSvzvqOxcqGFyGkvKuLpf+3yOpVmWqogCXqTLe5yfe1AfHNi2KfAwt+YpYUh8mjgGlJcxP1ktfYbnmGWwsG5zqtsF26+vyjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270935; c=relaxed/simple;
	bh=enSbR7naXFZfcdvMaREm9iZhtw5Ng0LD3gQ30+QEFuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE8hVwB7pkjXmYhvEAK1w8FnmAwnL/O3lKDENLmECf0ec5GrV1h/IOutDaBjzaO8/yQqxb4RuI05VT8v6u4PtWqAg8PB/q18tHnpQuAsKHOIrV/1qCr0lhWvF7UkVzbrB61AoZxVGGXPhonbKCdXVjTLB+Bt3Ymac6DiBj9NFgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BZeMJVTt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZeMJVTt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713270933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VBucZD+Hh5n3YcvOClOQFrDeYmk591h5yJuMvZn8z9U=;
	b=BZeMJVTtR7JcfYJATWZrEZ/kU5YH57s265F21C7vfFEDSXWo991TAehGtHd81cKfTsxY3d
	QT1oafYbBqig/7KMEySuQC1+C+c7oFWoqbSJijpymjFW1WXD+OQDp7LfYY16Wj5325ySjS
	Zz0S89ZZYXO7iCE4mnMYJHUI0V8HmyA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-ByzMaYTLOPiWVdaD_voqYg-1; Tue, 16 Apr 2024 08:35:32 -0400
X-MC-Unique: ByzMaYTLOPiWVdaD_voqYg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-558aafe9bf2so2997521a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270931; x=1713875731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBucZD+Hh5n3YcvOClOQFrDeYmk591h5yJuMvZn8z9U=;
        b=C/janFIwUS/5JlfyRp4LlhfV/yvcZmYPMG8RXA0JexFa0qqdC2VES6V+o+SPhKq55c
         2DEziuW1eAfH9ZuPqTHHaJxcEQ6P7uKzYSJx1T16IW7GGHj5mV/R+uGd/LfppbG+YC0U
         S72gM2uKGt2x2ACtikFBdyUXngM+BL++uBgOySHAlNGfXG7q0NrCZFPjWqXwE0jXobWT
         tI3Ngqx1g93YxLDBSVbMbiDxU4+bdPGigm7WPuZ//x2ERVY69NaqWDuDhv5GVMlEkiaO
         k85WsinyvPPlW56RHzF/7mdjT10X5VOCLOSkflabNV/W3xw+aoYMODz2NTc8u1vRnCLE
         YfgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmh8LXTiZlZ1rFpPfHRwnMdMx8h9XzgZnnPRxNZar5TEBNlclC3Sw7C/j7PvZnt0CEwBD19jVYASGuhqSc0kNn7Nb4f3ela+vZ
X-Gm-Message-State: AOJu0YxbvtTYW76lk4mUzi9CXvwPpsqrt8/MR11t74vra5FTnWiDxC76
	d1k7mtqmYwk4PnVEeyzHCDCOKHe03AgD+bM7chFIdP3K0J5ZTjd3Zple/cFFtZldCucMWORsJ6V
	U/M3hwtx302nZrmedGQEdT86Y09T7fOCYaWDRgoI2pow4xZZ4mUYj0p1k
X-Received: by 2002:a50:d79a:0:b0:56a:ae8a:acc0 with SMTP id w26-20020a50d79a000000b0056aae8aacc0mr8775898edi.21.1713270930671;
        Tue, 16 Apr 2024 05:35:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbBlIOnhC5lhXOqUlS/WueNztG6UefimASU5xxM1kcAhsak/eIZm2PSPLrqUqoWrGaPKkrSw==
X-Received: by 2002:a50:d79a:0:b0:56a:ae8a:acc0 with SMTP id w26-20020a50d79a000000b0056aae8aacc0mr8775883edi.21.1713270930204;
        Tue, 16 Apr 2024 05:35:30 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm465584edu.27.2024.04.16.05.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 05:35:29 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 2/5] xfs_repair: make duration take time_t
Date: Tue, 16 Apr 2024 14:34:24 +0200
Message-ID: <20240416123427.614899-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416123427.614899-1-aalbersh@redhat.com>
References: <20240416123427.614899-1-aalbersh@redhat.com>
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

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 repair/progress.c   | 4 ++--
 repair/progress.h   | 2 +-
 repair/xfs_repair.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/repair/progress.c b/repair/progress.c
index f6c4d988444e..c2af1387eb14 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -273,7 +273,7 @@ progress_rpt_thread (void *p)
 	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
 				current_phase, percent,
-				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
+				duration((time_t) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
 		}
 
 		if (pthread_mutex_unlock(&msgp->mutex) != 0) {
@@ -420,7 +420,7 @@ timestamp(int end, int phase, char *buf)
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
index ba9d28330d82..78a7205f0054 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -377,7 +377,7 @@ process_args(int argc, char **argv)
 			do_prefetch = 0;
 			break;
 		case 't':
-			report_interval = (int)strtol(optarg, NULL, 0);
+			report_interval = (time_t)strtol(optarg, NULL, 0);
 			break;
 		case 'e':
 			report_corrected = true;
-- 
2.42.0

