Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA42C15AA
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 07:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917468; cv=none; b=XmTwFQVPudYwpdi8fQ7bj2pgHQoOSkUHl9W5JnQCR1koGvy0+nuahcKgEjPPCMN50BWCzlSwrQ7F5R2VboEWqCfMM5GmwPwzF9Gmv0eaTCIr2OzQZRWZ3dCFfCOq79ljGXYsO/IbuvyNJP0qCahQprY/rXOI7ydgvprP6nW552o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917468; c=relaxed/simple;
	bh=MlqJjm78MdCh5WJ8+ky+0C33uwof02Z0sd84FYHReA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+q+keKoPu3nU1H3nJ0u9AQrRt76EQCAsZ79QRZXJAZChpdoyErgCyuH+5g8/Eblx0aADgJE+Ax5qN0zXC1RQ0Zn3R9LFAtZngqmnhYpvR3YhWzguhcvUfhi9XXxy9p48h6ov6BJeSfIoYDqhxzR5fGk+LgKGSP/QMy1Pt6xyss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+9EKuAp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ygf5PZQq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+9EKuAp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ygf5PZQq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771917465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9kbbdB2CXEe3h12mwmcPuIG5euiEtFQ8Fr4Zob7smyU=;
	b=G+9EKuApx+5MPMOVzZ+PFvvRkzCocZdyNjdCwiYE4LF9JHJRA9gtRifx5HUYU3FWrXcJzK
	WuuUzTPq9X0scQditi1hH8mYUTy350ZYjUs3toWwd9HrxIf4SBnBJALMXMk7+k+YCA29ou
	aJxb/UuvEpoV5V921+C9HoHinxUefTE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-kXPWU-QdOr25fDGW6M-dqw-1; Tue, 24 Feb 2026 02:17:43 -0500
X-MC-Unique: kXPWU-QdOr25fDGW6M-dqw-1
X-Mimecast-MFC-AGG-ID: kXPWU-QdOr25fDGW6M-dqw_1771917463
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35449510446so5217679a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771917463; x=1772522263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9kbbdB2CXEe3h12mwmcPuIG5euiEtFQ8Fr4Zob7smyU=;
        b=Ygf5PZQqZs98nxmBjJqRYIfI8rQ2oYVnNZz7/IccrlQHbaGYnLGx83EfD0xV5JUDIX
         AAU30n6JNhGm/Qa+MS1TQSpzAniYSS5rbZoYK2NlxHubIiztV66yb2CmQRzC058Fnn4y
         N/xCsrpfmj3AhUTvtWEnEK/83nEWGz3YStCqS8KGBiJZxmJdl+tUmVZeuYUdR62Tydd8
         i1G3X0ylTZi2PUJ0Cny4P/p0RtYUBMRAzz2QwfwB90pRQibt46aGhyRCDq2mhqXJ/qAR
         epKcSp11PxIomul6gpjC/ok0pBLx4fmG4kNiKZRlVGyhq4BK7hUyZruBirg88E5h8Ex8
         XOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917463; x=1772522263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9kbbdB2CXEe3h12mwmcPuIG5euiEtFQ8Fr4Zob7smyU=;
        b=bnAsW/SGyZDsTb8aBsok5wFYGeozWosFoYt/iEbHtmdO3iCSHzAtHKgPQfAh8dtpfv
         hw05ycGT1G2IRpneuv8sbsSaopUZolFxG45qwf8as3lmFIM5/fTkaz/ym7DcjQeA3wr6
         1nfwzIMHBnUNox/Y0noiRzBy4c/Q3et8Xz5jev5z1nFnyJbpwsVy/Qu8EuKbisYCAaOG
         fWhqjvvseIcoy5EtEMQl1K6K1WAbwGRA6eIyGMVyLWipewNucYIftRr/7VCoGVjplIMo
         cHy4iaVQcaWp09GPxGQ2F3oAoYaUk6LivqdnZuHOOesdoWdNBx/milzQlcEAgt9SLy/I
         gGzw==
X-Gm-Message-State: AOJu0Yx/dXCz6ni4Lze+ZISMdpzA2Z6K68lnSe1+TwV+/rCwEup3ATr1
	BEzaP7scO73ZG0JC3grBwuOIiMv3mplzL1aCYt4p/rlVJ+dl/HbBksT1eLRpueNXV+z2uo9pESk
	mmR9Jeo7gKngIYqJEwFxKQ0iaNZ5JKRE2dx8rxebNKpYxyvq/9v/MZ++VmWVkfVU/srRg2YCuaY
	2ixzFcvq6n17gfT8FmIQ7GywRE1VqamRIBJs/Mf5PI1qLeWA==
X-Gm-Gg: AZuq6aL5WD7eJwsg5cvuInEyWgTlkKWRNik4tRpnQSnm+4yrGrjblOWLorfzSOVva5e
	/UYER5/7DMbQzRFtFFRsst+pqMVdDiCoxdEAdLyKgssLv0qjkdGfkAs5k6j9ekDVqWzZvy4Eugg
	AUduKhQfxLmeVxoTWs/5AJVLXEha2IpSzgTv7g00kgr4ghNLcAunu7B21uupxaThv2GZWVzodSm
	LHzY6b3DRcxdfCANA/zDlpCfCDvSL7ruo3R816dckZ6QMmv8dQlXDz3UH4gLl8NzQSrQBoSUmkA
	ErIJRSS1exBuq/ReXNy8ZPKsZeeOVSem2SqywxfwZDa4lnfUwZQTvTVTAdUfGg0cb0Q//teoejx
	9wX8GT9MclhPAlhYZdYIRxtFr1zGD3i4XhA==
X-Received: by 2002:a05:6a21:2d44:b0:38d:eef7:6acf with SMTP id adf61e73a8af0-39545ec0446mr9232525637.31.1771917462681;
        Mon, 23 Feb 2026 23:17:42 -0800 (PST)
X-Received: by 2002:a05:6a21:2d44:b0:38d:eef7:6acf with SMTP id adf61e73a8af0-39545ec0446mr9232506637.31.1771917462209;
        Mon, 23 Feb 2026 23:17:42 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad80907b4csm58720515ad.78.2026.02.23.23.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 23:17:41 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 4/5] xfsrestore: remove failing assert from noref_elim_recurse
Date: Tue, 24 Feb 2026 18:17:11 +1100
Message-ID: <20260224071712.1014075-5-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224071712.1014075-1-ddouwsma@redhat.com>
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are getting reports from the field where cumulative restores are
aborting due due to a failing assertion.

  xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed

This appears to be caused by a rename within the tree between restore
levels, or a combination of modifications occurring during dump.
Fixing it will likely require changes in noref_elim_recurse and
tree_post, to ensure elements of the tree are created for these edge
conditions. Given the state of xfsdump this is a bit risky for
maintenance streams.

While current builds have assert(3) active, remove this one allowing
xfsrestore to continue, warning on failing renames for directory nodes
that haven't been created. Once the full tree is built referenced
directories will end up in the orphanage allowing for user recovery.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 restore/tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/restore/tree.c b/restore/tree.c
index bf89c6a..81666ac 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -1404,12 +1404,13 @@ noref_elim_recurse(nh_t parh,
 				Node_free(&cldh);
 			}
 
+			/* Process renames for directories that have been created.
+			 */
 			if (isrenamepr) {
 				nrh_t nrh;
 				node_t *renamep;
 
 				assert(isrefpr);
-				assert(isrealpr);
 				ok = Node2path(cldh,
 						path1,
 						_("tmp dir rename src"));
-- 
2.47.3

