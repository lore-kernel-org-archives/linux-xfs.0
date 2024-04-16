Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAEA1D530
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270935; cv=none; b=NgQHeebuEU/tNjCIfNtmQWe54fyzUFk2JiyjFjlHrcqbrzE2XlcIqNJHvz2b/TJe8Oq9+hFLqBu+EYiExg3W1hNBf0zibyJogz9hSWe7XDMOmSwj3+hXCQxZFiXyODFfOT/VsAhaor23CeED1NurNWUz0LRnudWPjoiov7pdZVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270935; c=relaxed/simple;
	bh=3ascfFz0yJ9DW3L4FpFS11QKO1uIcAFtys3gVzj85VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8wHh7sHr7F9urEENh296IbUc81c1Nt0qTPhCwZc3ACdswcXNRZ7s85at8acYWivKq2R1/pxKVVHaYjHnTqor/P9OZltgks7QJJ1wk372/I153QU4kq1VeP0b2jQOXBid0z1dYNC7OGQNS6Ah9TMkQBd7rnWAlJyecZzDpT6u1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gBo3H6Dc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gBo3H6Dc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713270933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6zJZ26n/NMVKGNdDpKks9wqLSHav9BWg6+5RJ8ZRMg=;
	b=gBo3H6DcgLrLwSsJosvw8LKnw/ymH8CcK2/2lH9XTDGirweIcJFd3h4wMW440pFz7zXTu6
	Ki/KjVjiRqSDTIFssoNvMI+H3tDNMSlD6WFPKxpnOxgMFI+9BNFgoHxUfaA3xHMF+gr348
	q2NlPkceUH6688AKyXA6kVyiHbclqKo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-VivcClWzPkqFHP8CI77wQA-1; Tue, 16 Apr 2024 08:35:31 -0400
X-MC-Unique: VivcClWzPkqFHP8CI77wQA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-56e4827e584so4418454a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270930; x=1713875730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6zJZ26n/NMVKGNdDpKks9wqLSHav9BWg6+5RJ8ZRMg=;
        b=TbLJlu3GC8pGIkK94nAMu3plS6uy2uQVdQELe2ddYeQ+5LBPwyWyPhTRS6UltSO5Bb
         pnbb3fp5P3bjqGwYM/xl+BhTDH4cwaFTxMUWlomX3kjYETq92ZlpsbKBzQeFomcMQ6A+
         lgmLnouSqauG97EgEH0w2ZMJKafow8vHguN1XCudeyErnDQs77+67tyRKsPDv1M4I+2E
         JTQXVPWyaiFg5NIk4s3GgRSAR/aHiWUTspa2LQHrImhi2n26KuRWWhYJhTmOz6xMQNn9
         WB55BtIUybl2fyED69ceFSKIiFXNonfaKCHNUS22c2UH1f2SdFJR9F5M4A1zDZXkeg4V
         06fQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2vus9iPtGli2tX7H4OjHoMJD5p3Beor8qJA0Kco0c69rBnwmv9XUikQe8rc91VidjSNB6BYXaMaZOye6VK3qTYSAAlfc5muTb
X-Gm-Message-State: AOJu0Yy14UAeha0UGjKXEbaXLDkdacdzZ+GZ7dNZbSGu3dqDviqFbz8j
	UsYEqJl1GpVbiUoIqdlZvPYY+IaN3FihBk2U5a3JIs+GJUIMQaGYf33pprkNF7O5xK8i1xzojjQ
	GdCE4yExtGCEvibylXI64RtPoI43aBZPaXzufnHErulDT6EANbRsLGnSv
X-Received: by 2002:a50:ab08:0:b0:56e:2e77:169e with SMTP id s8-20020a50ab08000000b0056e2e77169emr1340007edc.20.1713270930128;
        Tue, 16 Apr 2024 05:35:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTyduBLJk/NT+mPJIRIPwqP4EVEESaW8KScHqvUZXuq8fjaRzN6BkGuHVqB7m3SETGLQHgEA==
X-Received: by 2002:a50:ab08:0:b0:56e:2e77:169e with SMTP id s8-20020a50ab08000000b0056e2e77169emr1339990edc.20.1713270929635;
        Tue, 16 Apr 2024 05:35:29 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm465584edu.27.2024.04.16.05.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 05:35:29 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 1/5] xfs_db: fix leak in flist_find_ftyp()
Date: Tue, 16 Apr 2024 14:34:23 +0200
Message-ID: <20240416123427.614899-2-aalbersh@redhat.com>
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

When count is zero fl reference is lost. Fix it by freeing the list.

Fixes: a0d79cb37a36 ("xfs_db: make flist_find_ftyp() to check for field existance on disk")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 db/flist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db/flist.c b/db/flist.c
index c81d229ab99c..0a6cc5fcee43 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -424,8 +424,10 @@ flist_find_ftyp(
 		if (f->ftyp == type)
 			return fl;
 		count = fcount(f, obj, startoff);
-		if (!count)
+		if (!count) {
+			flist_free(fl);
 			continue;
+		}
 		fa = &ftattrtab[f->ftyp];
 		if (fa->subfld) {
 			flist_t *nfl;
-- 
2.42.0

