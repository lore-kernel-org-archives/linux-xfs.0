Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1A025EF9C
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788919; cv=none; b=AzZdK6U38sy3evOP9TzNd1N6D+he5YMpVzQWNU8kV7HNfm2AuJVGkpEnSQdKJKJ+3+u0gr0k3+56mgY4WnXfrUbt8QgKVZkhfqrZMcIHXGQGTaVPTKC0jOmtMHvLF96dfukDO8wlReYXfiXDKSGnPuMNBgMum+V1iMrTqlyzBRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788919; c=relaxed/simple;
	bh=VhXJRf7Df6l7Q8fnveLpLO/R4S34gz+S0t4u9iQcGes=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/LAea9pfzJuc+efo8MxHYPiVz2On8LQU4xSeC4OYDMOOhD5afRicV2VqBr4dXN39sq4h1hnWNe+FjuL+Yq/nVziegFNfUzjdwkAw9n5n7HBWxi6so6BWhhfFYiu9F3zgGMz1zphe6814uJDtOfT/FIOREnQg9M+iGJPTb7wb0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iI0RiWoA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IV/D2/Do; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iI0RiWoA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IV/D2/Do"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yISSbdDkt26F205oNOj/y0M02KlI/wuWqA0CK/yH6Z0=;
	b=iI0RiWoAcwk0xSCn6VXFWNhncpfzdbxWp5DKjr+yD5UbKhp/u2DCl9TzBRAHUQicCumKne
	SMiiSO3fR5RATKIm7BaI/0MsYTCTkvBG4LA83wwX226kEP3HUKZJfdrEt6sq2kuI8Yhga8
	ghxym131sTBdMGszQ/xPSxiP9Qgkt2Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-wBmf7Hn7OAi_MoeEznsCSw-1; Wed, 03 Dec 2025 14:08:34 -0500
X-MC-Unique: wBmf7Hn7OAi_MoeEznsCSw-1
X-Mimecast-MFC-AGG-ID: wBmf7Hn7OAi_MoeEznsCSw_1764788913
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477964c22e0so773385e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788913; x=1765393713; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yISSbdDkt26F205oNOj/y0M02KlI/wuWqA0CK/yH6Z0=;
        b=IV/D2/DorB+6kaW0wgd1cm543qTTsXjoA9qM7XtBpcq0gSNd1nlUTcqhfdWch9o+ml
         2kpv1Gst0UmK0oQCnYD0HeLlI8l3ePGiZEqZlcbYNjQJf6h2s7G32fH7mL/Zl+jJjra1
         LtTiO/vtICJGZy6dQCbEp9CcfkIQ6y/szEB/WMwNQVeis9uds4usf3XNkSJTCzkJU0G5
         8TuBXhzMcHTN2s3hpbXofHJfacHrJcorwb70xpf21NTetmiMlF+Hc6n5V95lNQTp3ce+
         k3W4rvNUovLDeS9ZaI8MRTcsgn0pytOZU56mhAwQb5BPQuAiQu8qcgCBMMBVzobx1SoW
         3/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788913; x=1765393713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yISSbdDkt26F205oNOj/y0M02KlI/wuWqA0CK/yH6Z0=;
        b=n5KkhuJF0vjYQu5WzId8iYz0NEtCxlUeZ/SyGS9yhGzoqbe+BEzexBk9QeZeuUhnmR
         Iz0sKnI5e6Epw8fFUkRdR86E36PyshGjlRpzQSVpDXN4C/6iZq6l+LitPjWCaUqBq0aa
         SGja4jQ/dIaLqIVeYsrLF53eqBgQwMrw/s9zbbebTY9/gE7Kux/AOJIwn+CnAcy51F1h
         93vafKb2wyFlNo7Q6VdMVqNTHdQR4YrNGxJI7f3FCadeRc6sF356ZzXhRUPG34XQXqAi
         1jdGEOBoMA3xajOOb4m1eaCuLrtRKqwqEl1L/AudiaH+M8EUBbCf1+dGrXZMRBU1kfZ5
         7Jyg==
X-Gm-Message-State: AOJu0YxPhewrRccCJT+GzT+x1N4UrN9/t45hTGxTFvoShvDZe8kGXzkl
	WKfIFw2XK+i4aHxaMqGOabODkcisxzwSew8LcfySAo5Od3iBHrBvUCiwzO/Mz2WmfGUZUzvr8Ct
	5KKWvMaYQlAwC2cV0BJAdrzYV1Pa9ZMy8zg4+yB0EXjFK1tEwKJmATFNC0xqJM5AP8oIwwvVbKH
	KS0DK5qOio3q2PgPMCUsdEXQQ9+DTKe9+/AhFyOFHezk1Q
X-Gm-Gg: ASbGncvGBoA2pUE8O0YhdGet0ila0QG6HccoMxdaXE1WYhSLew7NkHu0YCT3VZX8oPa
	wi1WBLV4DsLpNRB3fuL3zH/SE1bAH6iTcr6BtFSxsx5qkLZfrU54s4aIhp8Y9/dImBsZmw28sNl
	jOJD20U//ExKCK5x27KvTlyNsfcduCkBsbPyZ3zewVh4SC7LvnHuzHIMU96ciIdT/keb5vDfid4
	W86PSOEwLrteEQeWy3WlFumY4HFoCGfYCDwoyzfYtzdcLJ2g6SMNDJa8IRJMhcvzVQzl18TU9hw
	dMhz/rGFDlualPxMuxdL2SR+tKZ4zkZ+lZrpFsKTEn44HmWeS3cV+n8L0LJ+OtqDvlWGy29Av/A
	=
X-Received: by 2002:a05:600c:78a:b0:477:75b4:d2d1 with SMTP id 5b1f17b1804b1-4792eb73092mr3562435e9.15.1764788912786;
        Wed, 03 Dec 2025 11:08:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEaphZYrHTNDb4H0alNOQ5qWaQfzG7C6eiLySGewM6FiAswzBKyY02Po/h2Zv7FedsTslGZhQ==
X-Received: by 2002:a05:600c:78a:b0:477:75b4:d2d1 with SMTP id 5b1f17b1804b1-4792eb73092mr3562065e9.15.1764788912229;
        Wed, 03 Dec 2025 11:08:32 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7af97fsm62617345e9.13.2025.12.03.11.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:32 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:31 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 15/33] xfs: remove the unused xfs_dq_logformat_t typedef
Message-ID: <efuvg2dvdn65cforq5gk6ytg3afqnqpxwsl4scoadr7beafnro@qxz4iejf7lus>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ae1ef3272b31e6bccd9f2014e8e8c41887a5137b

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 631af2e28c..fff3a2aaee 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -957,14 +957,14 @@
  * The first two fields must be the type and size fitting into
  * 32 bits : log_recovery code assumes that.
  */
-typedef struct xfs_dq_logformat {
+struct xfs_dq_logformat {
 	uint16_t		qlf_type;      /* dquot log item type */
 	uint16_t		qlf_size;      /* size of this item */
 	xfs_dqid_t		qlf_id;	       /* usr/grp/proj id : 32 bits */
 	int64_t			qlf_blkno;     /* blkno of dquot buffer */
 	int32_t			qlf_len;       /* len of dquot buffer */
 	uint32_t		qlf_boffset;   /* off of dquot in buffer */
-} xfs_dq_logformat_t;
+};
 
 /*
  * log format struct for QUOTAOFF records.

-- 
- Andrey

