Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B952E8B66
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946939; cv=none; b=l1WMuwQeT+8SAtO7mNqjOdH7QPp1Am7cFsPcjfIh6xpAPe23j3WCW3wJAClwvaTcRISFkrCTQO+A2fB3rXw3f1RmwXzegt1VeBMruEh6PvopSL2PwnFEnqNaaBBH+bA825v4iPUNQSE3M1+3S78omImIA7wHs5mpluiD2q8ucEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946939; c=relaxed/simple;
	bh=r2IfulFKWgqr6c3e4mRBgVjx8GCWe3S1NwyohpLXChw=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ja6u8/D1HzHThQlLAh4N2VzV+itk64+iMBFOjhi877ZvmPUUlFfG3BDM93Zl76ger9BRu8nDQDcnazB/Jbq+KL2QVcwGDD12d/5CrTEnsRTbWsNlbzXyUMyQf4FWAAqfk5aFc0s1KSCDZxZYqPTrd8kVhIahyFSA3AiAKkK0+zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YHY9C0zw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lt8uv7PF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YHY9C0zw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lt8uv7PF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1Vg9dthvVZU0XlZPqjuSOSuv0JOFXI4UFFov9REydA=;
	b=YHY9C0zwvJ/fNEqNXX4IOIxjo4uVlroLlyG66YQF8TiyOJWL5AQg8ZTT2AzB/KhkgCUBRE
	uWNBrW4I21Hm2+tAqaZv2JD2ZoeerVXfJpEtH+13YDboqf4kBppOqpKHDe6uy2KgfteLa/
	qwCQgKiz0N+xWrw0Tjwmz0AqI6TQIhg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-nmGkz9dqMZiflsqzeCKHWw-1; Fri, 05 Dec 2025 10:02:09 -0500
X-MC-Unique: nmGkz9dqMZiflsqzeCKHWw-1
X-Mimecast-MFC-AGG-ID: nmGkz9dqMZiflsqzeCKHWw_1764946928
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3339cab7so2044071f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946928; x=1765551728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1Vg9dthvVZU0XlZPqjuSOSuv0JOFXI4UFFov9REydA=;
        b=Lt8uv7PFWdXZYhmb3q/nPcMxtag3YfRsV0FKuHGowwmI+CNhLk4GQrLrNxnV7pzCzm
         h6GPst+XYP9hrmlvVUU0Bem8e1ibuWjsL06WK/xODwiiewsZV28ikrrlPIpzRd7YemRS
         bwTYExu3os3uhH9ezO3WNl9s8JyOj1xFy9bC8Zjy770cyV2omQCLEBnXpRPgiUWxRydK
         KBCoF0ipDUZeuCARYZDJXcMAdARsWotBNgDvcOqUU2fzjuRtIheHvrcJmg2/qXZQMrKc
         wk3ZAQodto+qo6AMuT5bhz/0RtuBvkRXyxc9y96QnIlueAVAVB1aE7Vd+LdEy7AejqCB
         Rzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946928; x=1765551728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z1Vg9dthvVZU0XlZPqjuSOSuv0JOFXI4UFFov9REydA=;
        b=egcYJmqA8MSkZJrVqVMyONIGyi9iSEU9jO9YLrVWH5E8PeOYy6HsLvXxAielWg5h01
         CSry7YRnIWFbMeEioCmJHdr91ZZoxEMsjZJW1v65oN05bxRFDeKZcdKx4sXvRGNmOKDU
         EiWIiCZHLEfWTusjzEKpsFzhjvnbucSmpB0VLE4TC4+fF9wcj8T7gmH31OeQG2M0yWw1
         FIr4kXmZA8kl6zm6hmRDATVW1A86AqeCtMWNOXiOoVDbRJAzMl7546KxEOe4yLZB7DfV
         GUtYOXzIhh0zjiZ4Zc1WtM9VC5D6k4oSYHDCfp8FgQn/KBayfGzPa2UOMfKU1VjQ9oAy
         D6zg==
X-Gm-Message-State: AOJu0Yz/rTCWATqOD77p4yJe9CrCpmaHTZ9U2M+L2ferEPZl9ksPEAaw
	M0naxA+MSY5cENZ3ewOwT5Wlz9Pxw9HBdD0uXV4sbG3AwbmP4J7G3wfBsy6w4nIj76ydVTVNRvi
	sOc2a48dYNeOQ5OQupxuIupvdv+Ll0qH4fB7tFtCZ2viFoWRijxYYKzBjkl4Rn2L40etdZ8+OWW
	y5e8nm+lHLrYOlcXR0BlTpBlZ8GQqeuaU0v1/9e5UaI4Ma
X-Gm-Gg: ASbGncuj9RzuA8BLD1LB0euzX0UsOLpCTvX8icYGz5hRJ9bLwCSZWIj5fzKRzJ2N331
	I9uY3FJT/HKfzNcnzN8iTTDxhTVSjj3DA75uE9BvlOgT06ka4pcDvvJnXS4GNGxfLOveU8YIyKg
	PrV/6IBe4B1Jgvt6YIwZlnKOi+/GTujy1n23ambhAu4ScLHlm7qJSoJ89Feu/l24IFLpZhQDGcy
	VXJK24BIYgSUKG6HyefJGVijOMoUUJnBLf+7pT38jc/TTcALEfvF8/kI/Xtg/dXbh/6uqD7+qwJ
	Q+/83+YpuBJa7mDW5evkAvZLqJKpOHt5Dq/RszzR/4QoppvSHZQFmpA0SE6b1YPP9vFTFTBB36Y
	=
X-Received: by 2002:a5d:5f84:0:b0:42b:38de:f00b with SMTP id ffacd0b85a97d-42f798414edmr7808368f8f.35.1764946927761;
        Fri, 05 Dec 2025 07:02:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGn05Kfs7idd8NhkLGP1IbWvPYSqitqmMesOyD21Ws8YOrNmwMDJlbbn5qpoAAoUpR8SLv2rQ==
X-Received: by 2002:a5d:5f84:0:b0:42b:38de:f00b with SMTP id ffacd0b85a97d-42f798414edmr7808298f8f.35.1764946927051;
        Fri, 05 Dec 2025 07:02:07 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331aeasm8984239f8f.37.2025.12.05.07.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:06 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:06 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 8/33] xfs: convert xfs_dq_logformat_t typedef to struct
Message-ID: <34byrxhu7f74xci72nbxlc2srooxrrmoggtk46otj64kh4hjp2@rrhhchwiihu2>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 logprint/log_print_all.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 1d6cee99ba..0afad597bb 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -202,10 +202,10 @@
 xlog_recover_print_dquot(
 	struct xlog_recover_item *item)
 {
-	xfs_dq_logformat_t	*f;
+	struct xfs_dq_logformat	*f;
 	struct xfs_disk_dquot	*d;
 
-	f = (xfs_dq_logformat_t *)item->ri_buf[0].iov_base;
+	f = (struct xfs_dq_logformat *)item->ri_buf[0].iov_base;
 	ASSERT(f);
 	ASSERT(f->qlf_len == 1);
 	d = (struct xfs_disk_dquot *)item->ri_buf[1].iov_base;

-- 
- Andrey

