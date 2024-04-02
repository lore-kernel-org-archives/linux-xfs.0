Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C9115E5DC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093749; cv=none; b=RzrG3aUMYO415exn1I6SGQYGo5Xc1tpzArx+m3OYk2g5TIe815564NQkg6fx31CVudmKpDb4gXv9bJmo+RrXjItdhkTabUhKbgJbnHBpGnJuBXRXW8rP7SMXGHrhRyVHRAsUnlFZ21KxDBsg4VC/rmu0fVyBxQOHWE7O5MaQ7Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093749; c=relaxed/simple;
	bh=lztd+BvvC/tgLjagG/Lp2VpLta0TLp3t8MrR6gBNz0o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgaL5VywlOWqhU2liFje55oIEvQpktrdjxIinxyc8Bq+X5o04e8TsKoyi/KItS9am714ZIjY3E1TXsOk+SLl1WnsuVIIvuvDDHe8jBMcZR4kQzpzegpWJYhaoOQK7U8gler7Sd6/Pnn7MTjW/n1ZxBCA/aWra1JWlk+WSNE8z4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=NXzQZRzH; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NXzQZRzH"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e0d82d441bso51165555ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093747; x=1712698547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOw+VF89Und/L8z1kB7MLa5I0o0oJqetO+bP0JEvy/U=;
        b=NXzQZRzHCMMtlJuXLShLxFwFknVBpkhB9L214Ua2f5zXFC9aoaXkTuYQljOPF9j7IA
         Hz08lh+omfqBWX488gdGii5sJWhuBe9EiiCaa725DbihnsktE2kN+BAPGxIHrbErThFN
         LU8u+LOpZERhw+oQ4dgTHXwJmtphCGFQgQUMo7FPELPqjt6656P+TXZse/pUZG+qyc+r
         QflcheA12RuMqfPNMPLwOh72AuNuoJkAReKi5+aMs2vW3UVXtshgYKtEtSUynl5GPNq3
         s7cvjyemWHMRH294OplDAie26ZdYHUd6YatYR3WiunnX2xJbu8jXNCYB/tbZQe2eCOk0
         Onaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093747; x=1712698547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOw+VF89Und/L8z1kB7MLa5I0o0oJqetO+bP0JEvy/U=;
        b=NqiVuL2FM8KccKQ4RFBWjl0Aaf3oHmwe4Elbeqa3pbZB8qvGix07qW0UT0hH3h34mn
         y3P76UfzciiK32fVEPgw2apQK5s290DxFf1e5ZWpXnZPKJNUB6VN/WNT1mdiuEFKQs4N
         43sp7Lk77mZa1yIwPeM4qxPOi3EFGcgp77dH2dw6QVx98uDpr7lYCq4cdFhKa/+D+8G6
         iB7671fTT18iroMM3fjyjuBrXeCGPUOGlkhcDna6OaiYIZxIScDpgK37nlAiTfVF8xAQ
         ZY0Sj7g7NUNTVp1dnSCd2WKur4edMHIM7HW3lMebs5HM7q6+zRnEUjZU8b5qTdyGguOd
         9d5Q==
X-Gm-Message-State: AOJu0YxWrnCa0OHAbmDF39hn84BzfNZD4konfShX8ubzA6xGzjOIj00P
	UI9ZaY53cLIYJALEPcPmIUAglLIhRjw0mKNApmvTEI66rJEdmrqA1DeE9ACrdJGv7a5LkHWjqzg
	S
X-Google-Smtp-Source: AGHT+IHn0q1zs2l7SEybokM5u0U2y5B/279zux9CDdtmcH3BlJrxigp8H4BDjuYExthcz13yHElTDg==
X-Received: by 2002:a17:902:c40f:b0:1df:f859:91bd with SMTP id k15-20020a170902c40f00b001dff85991bdmr877949plk.4.1712093747223;
        Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902b18200b001ddb505d50asm11643331plr.244.2024.04.02.14.35.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrlnE-001n76-0Q
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrlnD-000000052FW-2ctf
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: fix sparse warning in xfs_extent_busy_clear
Date: Wed,  3 Apr 2024 08:28:29 +1100
Message-ID: <20240402213541.1199959-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402213541.1199959-1-david@fromorbit.com>
References: <20240402213541.1199959-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Sparse reports:

fs/xfs/xfs_extent_busy.c:588:17: warning: context imbalance in 'xfs_extent_busy_clear' - unexpected unlock

But there is no locking bug here. Sparse simply doesn't understand
the logic and locking in the busy extent processing loop.
xfs_extent_busy_put_pag() has an annotation to suppresses an
unexpected unlock warning, but that isn't sufficient.

If we move the pag existence check into xfs_extent_busy_put_pag() and
annotate that with a __release() so that this function always
appears to release the pag->pagb_lock, sparse now thinks the loop
locking is balanced (one unlock, one lock per loop) but still throws
an unexpected unlock warning after loop cleanup.

i.e. it does not understand that we enter the loop without any locks
held and exit it with the last lock still held. Whilst the locking
within the loop is inow balanced, we need to add an __acquire() to
xfs_extent_busy_clear() to set the initial lock context needed to
avoid false warnings.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extent_busy.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 56cfa1498571..686b67372030 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -534,12 +534,24 @@ xfs_extent_busy_clear_one(
 	kfree(busyp);
 }
 
+/*
+ * Sparse has real trouble with the structure of xfs_extent_busy_clear() and it
+ * is impossible to annotate it correctly if we leave the 'if (pag)' conditional
+ * in xfs_extent_busy_clear(). Hence we always "release" the lock in
+ * xfs_extent_busy_put_pag() so sparse only ever sees one possible path to
+ * drop the lock.
+ */
 static void
 xfs_extent_busy_put_pag(
 	struct xfs_perag	*pag,
 	bool			wakeup)
 		__releases(pag->pagb_lock)
 {
+	if (!pag) {
+		__release(pag->pagb_lock);
+		return;
+	}
+
 	if (wakeup) {
 		pag->pagb_gen++;
 		wake_up_all(&pag->pagb_wait);
@@ -565,10 +577,18 @@ xfs_extent_busy_clear(
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	bool			wakeup = false;
 
+	/*
+	 * Sparse thinks the locking in the loop below is balanced (one unlock,
+	 * one lock per loop iteration) and doesn't understand that we enter
+	 * with no lock held and exit with a lock held. Hence we need to
+	 * "acquire" the lock to create the correct initial condition for the
+	 * cleanup after loop termination to avoid an unexpected unlock warning.
+	 */
+	__acquire(pag->pagb_lock);
+
 	list_for_each_entry_safe(busyp, n, list, list) {
 		if (busyp->agno != agno) {
-			if (pag)
-				xfs_extent_busy_put_pag(pag, wakeup);
+			xfs_extent_busy_put_pag(pag, wakeup);
 			agno = busyp->agno;
 			pag = xfs_perag_get(mp, agno);
 			spin_lock(&pag->pagb_lock);
@@ -584,8 +604,7 @@ xfs_extent_busy_clear(
 		}
 	}
 
-	if (pag)
-		xfs_extent_busy_put_pag(pag, wakeup);
+	xfs_extent_busy_put_pag(pag, wakeup);
 }
 
 /*
-- 
2.43.0

