Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C9325720
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946921; cv=none; b=LYQ2Zwxw4Og0E2vwAHgtFbfa24AALNSIDFanbFijC2YRMeRcPy5Qnx16Y+HAsjyBLT7drMROKenmajK8pZbFDaj3VT71KwrTH0zR4jFqd9wLsMoC0d41RaqKbAU/F9L5VezU/N1UUli32cV7UllgqpmLIh+40a43rUm/6n0zFkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946921; c=relaxed/simple;
	bh=QvZ+vqATg39Xja4qeF7RjHWZdlohdmUKl8AuhNhUvBo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Byn95jh957jwdL/gQPriTj2kWIqpWBcYA/Bki7DowpGLLHMADlhMieoCcVQvx84OqwOrPZPzTxL8yhQqy/daqXeDMFGaOC0IOveiNTv5u4gIf15v+arIvVTHQAQrsQV4y74Npr86oxUBqHfk6snyUUu01A3cfHLivN4S66nu+tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILQLT2TJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsKDccmw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILQLT2TJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsKDccmw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akLaZDADCj9/ycco+JK5dqgVdweLnPNSgjp9u15I1so=;
	b=ILQLT2TJwYOI54jOkS2Z5KL3M6A0D/FMOWrFJ4EhCFacEQuG1qC8LGPZs+j2QqD8gE9K32
	1sJuO5W633p/Cb/EZVZcbXOBuwN45h/czOPKHeHiCb8/ydsiL4R5txxF7MXB/bQHARuEwS
	mzVe1Nz3luqRvuad6zSbEOUR9pBgfsw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-gH7wtrrfN6eTyeMhV84e9w-1; Fri, 05 Dec 2025 10:01:43 -0500
X-MC-Unique: gH7wtrrfN6eTyeMhV84e9w-1
X-Mimecast-MFC-AGG-ID: gH7wtrrfN6eTyeMhV84e9w_1764946902
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so13869825e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946902; x=1765551702; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=akLaZDADCj9/ycco+JK5dqgVdweLnPNSgjp9u15I1so=;
        b=dsKDccmwEyRtPVRrvzuK7X1quJ/3u+1iLNYj1KzMG4KsVG1BKZP54E3e6TYe5fOJ/m
         C/8AIaGrBEHJNopVYv0aOC2t1Alpcx4YLSRh8pvS10ln/2mv+jVBrwJhdZITn7b7jAHq
         kNHJRjbSleuKSjXnET5iEevjDk2aRnGk0jEeiQX6Hm5yXplAfA7EC2xLScfEJGdmYk2i
         //gpAjDuEu9mHtL78Lrxs1ct4DN7hsads2STvycUbnPJc/PwqwUs7AgAjIkCI7LGcb0F
         ataU5Aq6YLEThK4LezT2yrWACP/Kprs92YoCEkGxzpZMvqgfnLGjJ3sfjRVxTfiORfsf
         y1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946902; x=1765551702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=akLaZDADCj9/ycco+JK5dqgVdweLnPNSgjp9u15I1so=;
        b=YvmMlNIoznDYuOx3FVG+NyPdsLay/WqoQsnZ2n/RqOCUna+feDHieS7S7e+fLfhyUF
         ZK3kgefk+4Vz2L1YxhEPHShL21L2yep9iwRkorzlqgrKneU3gWKdqq0m3KYM7y3Qv1Pi
         Dlz4QKK990NelNHB5YkBxbbSALI53dTQs6gZyKhtYdrcjoMzcGVv5N6HfLV0Ubn3NRqZ
         dDNjybvHaza8qGCmUUYp4xZ3heMD2W0Pv+ijC6UuT4dwSliltuwPkpYSzTgGpHyO3suB
         UfncA2gNjdoP57jePPsoxGbnt9Er1uTL+BMMU4JrhA5iN9byix9YlTulkpHgcXV4deQm
         lc8Q==
X-Gm-Message-State: AOJu0YwZrmn73vxgdk4GIz9B3MO1v6Qs/04yl9xE1cX21C1DivhqUFoF
	gUXnwIUU0MJIWgyyvexR5Iq212VDY0+SWe4Dm5+Bcvp5XVp7tl2T7BcIGTON4gtnJfGlPV1tv6e
	JvshAs4k9v9DdOVALhrsSpGc3alE68t1Bj99oe7eiOIpsPyjj6Gz18oWlm+n5LTfmtLl4eVcJqT
	/HvHM7wd3TEDuSjjEi2dyw84cMjSTaSMXgZ1Nk09bNtqeY
X-Gm-Gg: ASbGnctnS6taUOcibJDeThkoHHXDykGL0tkVcHACdfksdHQLw1EUg9N69jctle/dnZg
	hkFMbn3E49ypASnf8u/CwsUDCzJ2qq1faRL5csPwKXVg0o2FtA1znHpoa6tERIIajnhTgPu+Hev
	85n3Fs/vklxgU/OyaHO6fedURqrgRwqQC4c+RHWYXSjFIHL5dq/nxXE6fwtrMmjAQChOs3phm9f
	zk0UcVmPpdaJRGA/EonKNY24vJ41USelxnSt3qKNUUEMQnUq0VArYhicJmIr3dlqfHltrABVlYG
	Cr0SXtb8d3+0jqF/eZ8ljiqW0L8g4zVNtzXdIvAI+NwmrFqMMvgtZAHiQusxyOAQm29qVUrgc8M
	=
X-Received: by 2002:a05:600c:1c81:b0:477:7af8:c88b with SMTP id 5b1f17b1804b1-4792aeea8b2mr114126285e9.11.1764946902016;
        Fri, 05 Dec 2025 07:01:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4I2rzAWdVZJqZGkGtz2RxJVZnJ1sv4LWxoF9ZGcrav9UGcxKuiKuZDZh+9YH9AU+ML+zTJQ==
X-Received: by 2002:a05:600c:1c81:b0:477:7af8:c88b with SMTP id 5b1f17b1804b1-4792aeea8b2mr114125865e9.11.1764946901510;
        Fri, 05 Dec 2025 07:01:41 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222506sm10074360f8f.28.2025.12.05.07.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:41 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:40 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 3/33] xfs: convert xfs_buf_log_format_t typedef to struct
Message-ID: <vtmdkqiumavvm6tv4ggtxd52iphiumgsw6ao7pq67yjamqxevf@y26jmzl52xyj>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 include/xfs_trans.h      | 2 +-
 logprint/log_print_all.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d7d3904119..d4b546a0e3 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -50,7 +50,7 @@
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* recursion count */
-	xfs_buf_log_format_t	__bli_format;	/* in-log header */
+	struct xfs_buf_log_format	__bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
 #define XFS_BLI_DIRTY			(1<<0)
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 39946f32d4..0920c4871c 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -72,13 +72,13 @@
 {
 	xfs_agi_t		*agi;
 	xfs_agf_t		*agf;
-	xfs_buf_log_format_t	*f;
+	struct xfs_buf_log_format	*f;
 	char			*p;
 	int			len, num, i;
 	xfs_daddr_t		blkno;
 	struct xfs_disk_dquot	*ddq;
 
-	f = (xfs_buf_log_format_t *)item->ri_buf[0].iov_base;
+	f = (struct xfs_buf_log_format*)item->ri_buf[0].iov_base;
 	printf("	");
 	ASSERT(f->blf_type == XFS_LI_BUF);
 	printf(_("BUF:  #regs:%d   start blkno:0x%llx   len:%d   bmap size:%d   flags:0x%x\n"),

-- 
- Andrey

