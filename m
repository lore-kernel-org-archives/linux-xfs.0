Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A24B1E4BE
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774493695; cv=none; b=o9X6AR1xsHQPREpvSJHfktFyuthbfftnMZNrAI1sxxMcU1VtHwK/hECLIF0HrKHuOxUzqGgpV/2b0uj7O+uVew3k/JZkUfEXRN3EV0fUKyj8d9fxEJlrOlExwbPmnj8/WAdBQK+FZGdeCzdaPUqnC5OtemmX+znI9RLrH0vAJmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774493695; c=relaxed/simple;
	bh=FZOOjW/pWtUixpQk6K2MK5ocnfV29xUO0SCGn1ARciU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vhp6N+i/JDS+9e+hZKoUR8C3W51Tl3/fLaC9CCF3xAhPwWMwRW0AKlMTFW72/+obMcKPiY4iu2MMHloPe1SLyx0dWNPo6kVajytJ4lUHYkeotFOiOTHjc4auNgF8fxusB9Ap1/gCB+HRSJgeXr651+ZHnlVhLDA9ZqLZCf16Kc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YF6qGzRy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aHnt363/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YF6qGzRy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHnt363/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774493693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l0TKlHBbtoqT0CPI6F+3V2dswoIqhZsEn2ZEONFF4e0=;
	b=YF6qGzRyMjvKMuk1KlIhUbyzjpV+NbyxxSoCQ9bZH3AFK6z7xoAbbl0Cs9Yap7rmegNiyI
	6g9I9c1YkLuGvYnJGCiSr14Hxkw6eZZCPJNTxRxiLGmvTJod7cHLj0wd+PsL4sGHVZ6FLx
	SxfVAXtGrJXFFpUF3O5XaPJ4VffV20Y=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-iaruyjQ-Mk6nW3OwnjLJlg-1; Wed, 25 Mar 2026 22:54:51 -0400
X-MC-Unique: iaruyjQ-Mk6nW3OwnjLJlg-1
X-Mimecast-MFC-AGG-ID: iaruyjQ-Mk6nW3OwnjLJlg_1774493691
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82c2054b584so1160037b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 19:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774493691; x=1775098491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l0TKlHBbtoqT0CPI6F+3V2dswoIqhZsEn2ZEONFF4e0=;
        b=aHnt363/ksNlynlH9Kn16iEdeKtGTokVx2jwu8uZ+DO4+FXAVg9AMV0w4zX+WnZClk
         TuZQmSobpnJkm27n/+v4Jne1RISmqC1QPVlka7oH2EGGZoGxEf0x9URobsQHt5ojIU8o
         4Dla5hhtEegfv4q15vXhhzzXidOtfHVroAwmU9zT4nZR97zU9cx+dpGEDKQ5pPd6n0Qd
         SVl6xX2hiLEWpapHingRQeu1uRUd+J2LxoP3/ufengqK9zf+Bn3lxf+LVxs2LQsfxv2r
         7xmui16+QA1AaxlPgoMR8pF5pFNiAPGW5plsGAoirIsRenoacv19kfOlnOx5ZZrchZFT
         5MLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774493691; x=1775098491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0TKlHBbtoqT0CPI6F+3V2dswoIqhZsEn2ZEONFF4e0=;
        b=YFcqV/4fnv5/4mW1s+IaQR8mI8sgfHjyZqYGhq0FmQk/QtIeLp9CukOLkFxnFFAHkG
         uSrlYc1V3K4mf1dkFYvnh5PHya4/MUWWqhjYPkpBXaiqo5XzAGtpSzc9AndE/YJhZh5+
         r/dO0Do5CzWW0t4TWvz8h9PiUdUT+bgYm70WDg/Sb+FhSrz6qWNalP69dV18l8Ln4vt5
         r54+XG94rEoSpzLCdoCykCoAFcrXBMx1OnZ1kWY+gDWufCZ20kYYbvYe0pZOIDi3iZpq
         gv2fUdGE6+4F8Pf1meYexXoMOTpjw2UR/XqGntz8mxfcvIJR9so4YhGuCY7M84hy0sjp
         QztA==
X-Gm-Message-State: AOJu0YwEmQvgMG2cQZV8z3n3TwMHV9QhZoejUQyuCR6mXIh4arKNy69q
	dwp12BvM2Ig5GEqH05nhyFho80/KU9zL0hMYH3GKR204m1o56W8DNGcMI2hgKNI2Qm4+HKRhCEx
	xfIwcYjT9NUhmBdJsX6WLKYnaC1zliNsOaY+G8zrEFX4spaeT4hLd9+vaF6AG6Hp5G32iCl1yj0
	QgTPZgzknxXp1Gzeni6QUDygxk7UvBB8giK9ELJSirVI9gqg==
X-Gm-Gg: ATEYQzxhBBHwh7pwEkkFjuaRijO4FgOcU9HZInzF0F61k6Fhjlwp4QvXh8dU0SWqu2U
	OUN/SWBVUdFIOTv/urpLfqGMHRA7gtU2r8l41iP1nNukrunGzLxMis1bRKxA8Xj2cNbBt7sa9kf
	Uw5dWum7PdICbkC181YHShQDs5jNn/4LIAO52IMNT4nS8iKA2l/99pbKzyIX7yTRdZ9APiaSHGk
	BPPgXfuwmpq+ZH8wzO6Kz22fayYY5pUC/a2fcHz4Kcw/8+9J6rcuyMls1W8C/fP4EKnUvWFgD3E
	jzmpsqEZwRaDIxoravHLqS3lfGzr0gcwL1VMCPlmuyndkYbCCpDPuhtVXrlNhj/Bc/my0/OKrc5
	1oOr7iqRXnlPuWV3utjM0ICDhZ6u/oGa0mQ==
X-Received: by 2002:a05:6a00:bd12:b0:82c:68f6:a18 with SMTP id d2e1a72fcca58-82c6e0e4d14mr5577154b3a.34.1774493690604;
        Wed, 25 Mar 2026 19:54:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:bd12:b0:82c:68f6:a18 with SMTP id d2e1a72fcca58-82c6e0e4d14mr5577134b3a.34.1774493690055;
        Wed, 25 Mar 2026 19:54:50 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d3c289dsm1026798b3a.47.2026.03.25.19.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 19:54:49 -0700 (PDT)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfsrestore: only process subtrees that are selected
Date: Thu, 26 Mar 2026 13:54:43 +1100
Message-ID: <20260326025443.1569874-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are getting reports from the field where xfsrestore is aborting due
to the failed assertion:

  # xfsrestore -r -f /tmp/l0.dump -s somedir /mnt/scratch
  ...
  # xfsrestore -r -f /tmp/l2.dump /mnt/scratch
  ...
  xfsrestore: 8 directories and 7 entries processed
  xfsrestore: directory post-processing
  xfsrestore: tree.c:1369: noref_elim_recurse: Assertion `isrealpr' failed.

This occurs for cumulative restores where the initial restore has used
the subtree option to limit the trees being restored. If a subsequent
restore encounters a rename for a node outside of the selected trees it
aborts when It cannot find the directory to rename.

Make sure we skip processing for directories outside the selected trees
when eliminating unreferenced nodes in tree post processing.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 restore/tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/restore/tree.c b/restore/tree.c
index 4e7cf7b..91c5e9d 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -1321,6 +1321,7 @@ noref_elim_recurse(nh_t parh,
 		gen_t gen;
 		bool_t inorphanagepr;
 		bool_t isdirpr;
+		bool_t isselpr;
 		bool_t isrealpr;
 		bool_t isrefpr;
 		bool_t isrenamepr;
@@ -1337,6 +1338,7 @@ noref_elim_recurse(nh_t parh,
 		isdirpr = (cldp->n_flags & NF_ISDIR);
 		isrealpr = (cldp->n_flags & NF_REAL);
 		isrefpr = (cldp->n_flags & NF_REFED);
+		isselpr = (cldp->n_flags & NF_SUBTREE);
 		isrenamepr = (isdirpr && cldp->n_lnkh != NH_NULL);
 		renameh = cldp->n_lnkh;
 		grandcldh = cldp->n_cldh;
@@ -1352,6 +1354,11 @@ noref_elim_recurse(nh_t parh,
 
 		Node_unmap(cldh, &cldp);
 
+		if (!isselpr) {
+			cldh = nextcldh;
+			continue;
+		}
+
 		if (isdirpr) {
 			bool_t ok;
 
-- 
2.47.3

