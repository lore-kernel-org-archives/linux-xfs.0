Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA9C14F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714455978; cv=none; b=Tl9roe+u2pRKPSQ2aobZF/aeA2FdhhAZSfmpAm4yoKmMJgbG9NI1S9SMwnKtWHNJJ5piYcQMJHh4QhvX8HKljpHnwD7YinWwBHeosGpZhUCrcLdAzBCXzL/Bnw7Kk8MWUUWkXqF8MmGUSUtI4iHGTde0yDnqw4nDTEsg/RKB8VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714455978; c=relaxed/simple;
	bh=kj7Cfecgeuuhltck+i9pLUJsdGM4ofnZoUoPkjFxc0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw7YkTNuzVF70so1OV/SmwtxzvqdSiaeflefDEYY+JDCzyZk3VogtLmLXw4S6Ew6178Kil2206OpXxRdwICok6EbOeXG3r/Y7FgR/hLJZnzozI8dPwyCISKleHOSX4ChYihmLbn9uFc6mXCAzdRPXmJxmOnN8zmixNCWpzLyEWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qrC7pu2L; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qrC7pu2L"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-23bd61fbd64so2022465fac.0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 22:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714455975; x=1715060775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NV4GJbGFzoY56PgdrQSIf6/6C14cbaCO2NcKy+lGqTw=;
        b=qrC7pu2L03+EEbD0melEhLwp7CItkkE3xu+xGFFdqRJG6jd69JS66jqMj/hoY5H0yU
         N8fNPJswuqC7xszDkpYX4A1WGL4yaLOwKaZMCrwuBDXSs6AXzjj47uafuO1oA4WlGWSG
         8hOp5cgrCpM2S1r0kd55eYS50d8U4MtrvA0SRqRLBRSE2RYFOJTis5ZWQbhgpsjO2h/j
         9RdAqlFqykSiwnRMAr/KmD+28aqZaIzrcSBosvEs6q7TomLnUzxuabqmFV3ZYPTBno1x
         iZRpD4m6GvaHrzu/9VKBHai2swQncOdGOtsXZg2tOxQgLMSNi5h/JzmNX79rmHsZ9hBd
         IkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714455975; x=1715060775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NV4GJbGFzoY56PgdrQSIf6/6C14cbaCO2NcKy+lGqTw=;
        b=KXKsFNqVfOhcoaUCtskc4jyOCeLI79FKoPl3jF+//9yRmqJWCYEgcpCMTfpdpOHJvT
         0hVu/3f/MfDm5R4VA5Cd8UqwVXcoo5PHP3geq1Aom+Qq1O+0jDbUE0VWOVe+tHV0MhEM
         UiojkrxiWzU6re1QoQOP7IKlzHzFhbwnMuz5AzY2kEP1txdeaWgeM9pArhCo3IkISo7t
         ScU/ydwFG8ZOylvfBjJbaZguzyHgjgFO85oFweIK0FhV6U/azdDOWk2kHBPkSfQchjD5
         6YkeGNAleVxW+aluXkfpHq9oGX3DGCHDgcPDtceH0ZgDN4GFdEgaC0a/LHPNBqkwZofy
         V8FA==
X-Forwarded-Encrypted: i=1; AJvYcCXbEi1kYVTEzHweGV30yZMyqY8S/qkNifgv8e57dZ5/WRC/243pcoC0gu+vcmaugfW6EG2g8B6XyTkwioc7awTPTEg43GPQa+Z5
X-Gm-Message-State: AOJu0YwkDyfrusOo4sYE5xsh3Y36LT+508597nZZ7Gd9+L7TFOZsaLkW
	XR7KcV9bo29uZ3t9K7FScvhLBz+0LwoEa7Z+IA7JRJfPCVXaje3HF/dtnGT/SzLsW9J+J23YbzA
	y
X-Google-Smtp-Source: AGHT+IHSe22zH9AEzfdykd197j0sgft4/vE2xJ+69aNwgLdPObVthGLdo/lyUt2tlIufut/wICnAyg==
X-Received: by 2002:a05:6871:3308:b0:22e:fec:707a with SMTP id nf8-20020a056871330800b0022e0fec707amr11386433oac.19.1714455975418;
        Mon, 29 Apr 2024 22:46:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id gs9-20020a056a004d8900b006e694719fa0sm20968511pfb.147.2024.04.29.22.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 22:46:14 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1s1gJg-00FsCN-2N;
	Tue, 30 Apr 2024 15:46:12 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1s1gJg-0000000HUwz-0uIM;
	Tue, 30 Apr 2024 15:46:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	osalvador@suse.de,
	elver@google.com,
	vbabka@suse.cz,
	andreyknvl@gmail.com
Subject: [PATCH 3/3] mm/page-owner: use gfp_nested_mask() instead of open coded masking
Date: Tue, 30 Apr 2024 15:28:25 +1000
Message-ID: <20240430054604.4169568-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240430054604.4169568-1-david@fromorbit.com>
References: <20240430054604.4169568-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The page-owner tracking code records stack traces during page
allocation. To do this, it must do a memory allocation for the stack
information from inside an existing memory allocation context. This
internal allocation must obey the high level caller allocation
constraints to avoid generating false positive warnings that have
nothing to do with the code they are instrumenting/tracking (e.g.
through lockdep reclaim state tracking)

We also don't want recording stack traces to deplete emergency
memory reserves - debug code is useless if it creates new issues
that can't be replicated when the debug code is disabled.

Switch the stack tracking allocation masking to use
gfp_nested_mask() to address these issues. gfp_nested_mask()
naturally strips GFP_ZONEMASK, too, which greatly simplifies this
code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/page_owner.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 742f432e5bf0..55e89c34f0cd 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -168,13 +168,8 @@ static void add_stack_record_to_list(struct stack_record *stack_record,
 	unsigned long flags;
 	struct stack *stack;
 
-	/* Filter gfp_mask the same way stackdepot does, for consistency */
-	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
-	gfp_mask |= __GFP_NOWARN;
-
 	set_current_in_page_owner();
-	stack = kmalloc(sizeof(*stack), gfp_mask);
+	stack = kmalloc(sizeof(*stack), gfp_nested_mask(gfp_mask));
 	if (!stack) {
 		unset_current_in_page_owner();
 		return;
-- 
2.43.0

