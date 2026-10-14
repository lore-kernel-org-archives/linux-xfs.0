Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC731397923
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949867; cv=none; b=GByPWodRqHIpESDAri3snACdJZrL48dByfZ1/Q8DLE6TnbTqmPj/Hl1x7YTtW3l6cl7fdanZ/vpY3kHqacpqB7+DBNj4pZd0sIWgPtwL3u+L4ZjcPcltrZSe1ZNHHO9wH5mdm9s07IHbZKRWPRv51pnebBvBLnYIVnA/4Ln7TF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949867; c=relaxed/simple;
	bh=faw8bVtKcGUKCU8pqeH4vzljHRKM/5k/kGmCyOVCnGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1itV8SvvGZZrH/5r7b4Ebog5B8t79CmwhB4GgGKbvDF+1vYHSU2nRp7qsBhAfHVFfuZLYGHKDb1O0NPD4Xy6kjqbeEU+h38SNdGHSUBfiB+rMDNbmmaOTCYiMzgTsLy2r1vlQ131zteZSaa8RWS11Yr0NSyzfqXoRkuqPOR2pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J0H8QRrg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQf4hBF9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0H8QRrg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQf4hBF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791949865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NSfo4MdxoCBQVKLO6V+j8O7y98bv80hQs7oOekcsGA=;
	b=J0H8QRrgaZzB1mL/7G/DcUTMLAbUPD1Ew5V0SzIil6tixe8PCqYFE5tsgTtSoLzCTLYQSd
	IE25lwpr5PmplFAcqr5c2xEUvMrovJFy87ths9f04sfVdTGYtRZ5+WmBiFoLcaNbrdtIlt
	LiYrc+Bxgh/xPvWHfVYtbRM/fwdymOI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-uKsBP2FhMmaIxn2JMGmRbg-1; Wed, 14 Oct 2026 03:51:03 +0000
X-MC-Unique: uKsBP2FhMmaIxn2JMGmRbg-1
X-Mimecast-MFC-AGG-ID: uKsBP2FhMmaIxn2JMGmRbg_1791949863
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934956beec8so719389685a.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791949863; x=1792554663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NSfo4MdxoCBQVKLO6V+j8O7y98bv80hQs7oOekcsGA=;
        b=OQf4hBF9vwijNI+XaLvuqUMLNfVlY6OPDIO1ILRkL/O0pD2GArSDzILtHSHxm8TSPm
         wicGDJw6tWuFY2FuMh4R6MOZJPNIP48QGH7xYKhiJ4pf0haPGtianhAvx2nw2Qfkjiwb
         XxIlyqST0bWecsW2HWdO3yhdRKhQlq23ftQxDRbap6gIETudXTWwOLS8Ac1SP2jt77Ay
         rUdCCzS4vGsziOMLovDgyUaTJqkzJsUJkl78TO25WJ9Pn27+YMeFxopp7xttZ5iX6dS3
         AuqQVX4sa+Wl9UuXwDI8cK5ZVleTItwz4z6KJGDWuAi5Rv+EKsx+a8EAITQ0ERKwYIwV
         6XIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949863; x=1792554663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+NSfo4MdxoCBQVKLO6V+j8O7y98bv80hQs7oOekcsGA=;
        b=U0iQtkoAlKsyQxiuSlWp+dTIUSko1Dq0plnLwkEXAOuZyl5jRd4GgmEEa0t0BVz2Uy
         4UIx7tZBjWOakFl6XqkPNxb+PN2BoJkQBuk6tbBJynA+u/PHKQlTKjXfxz2Hatk9Ms+p
         VThVmzwG09UBzE51dN9WYtob46XPPT5/Bi4Po2GHYzuEvTws/kcxt4dSGLK+Bh/sOZOM
         C3qKpnkfKOyzlKva7lmqEFmPMGFmmXoaxirDwEq5rxgiq2VbYiGf1umv/M6/liVK3ejb
         p4a+ntOVc+s9d4DCOng7baPLliyEbEHR5ZF0TlgXmyp13NneAdLmp4nTY1jSW8gF5S7R
         kqQg==
X-Gm-Message-State: AFq9FYJNIOmBgJkq8OQtmO73pD6jqED/fzpn9IQJNBfSbB2438ph3cRZ
	if1O3WiSVRbU8+hU778GqhfzfRRnU6AqF0vtVLVrM5nQWHTufOc17p/Ym54tnovLYCUZbJJo18S
	d6JCPVKybUfmimEVVuYm5TyrvFfhG/Q9b6F2KP/9Zvz7jpGvSQMglozkJBKWCTEnFV6kYGu/j08
	Hl5crNIUurXu3xjp9YN/DwSdKOGmW9pqNARjYZjI7VIjpo
X-Gm-Gg: AYBFou2l6QLN3+w3vEiCRJ3Z3BEYlL3oScmCSwCnXfIeJRx+kGwtjD+szf/Wygqqtvd
	/pmaVoL6p9rsS2Euh9MYWX5xUdogrjTHPBEuHj8irkFXIjYcqgriwOnt0WL2D9OHmZUp4ursymu
	wAnB37waPVJo+qYbkb7rtCvAU/O7nPQPT3zWBShHfux3lOX0nfugzYaynndwqDSe0Da4g8PlXBo
	IOZ8wZRQ1zhIA3ScMCT1Sw6zyQpOmPNDFWeG4sqZGPITdXEegEowxvU+oySAa3RwpRuP0y5gRcB
	rA+hDN2KLksCqQrKwkNucVSZ8JwoAiGCeMRlda7OpIT4P/JHEpkk9nZKnFVTEt6nkRkqDGLCIbT
	iQrlb0rJBMV7XZozuhlUnwdOip4bEkrF9v/YYNQ==
X-Received: by 2002:a05:620a:808c:b0:93e:6068:7e8d with SMTP id af79cd13be357-93ebd0e41b0mr2264713885a.10.1791949862978;
        Tue, 13 Oct 2026 20:51:02 -0700 (PDT)
X-Received: by 2002:a05:620a:808c:b0:93e:6068:7e8d with SMTP id af79cd13be357-93ebd0e41b0mr2264711685a.10.1791949862513;
        Tue, 13 Oct 2026 20:51:02 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm393907285a.47.2026.10.13.20.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:51:01 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/5] xfs: remove redundant stat check after rcbagbt_insert()
Date: Tue, 13 Oct 2026 20:30:02 -0500
Message-ID: <20261014013505.759089-5-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014013505.759089-1-sandeen@redhat.com>
References: <20261014013505.759089-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rcbagbt_insert() simply returns the error and status from
xfs_btree_insert, which has already validated the insert
or returned an error.

This makes this instance of this idiom:

	error = rcbagbt_insert(cur, &bagrec, &has);
	if (error)
		goto out_cur;
	if (!has) {
		error = -EFSCORRUPTED;
		goto out_cur;
	}

duplicate/unreachable code. Remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/rcbag.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index 8f3a10f7c908..fd9ccb205725 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -105,10 +105,6 @@ rcbag_add(
 		error = rcbagbt_insert(cur, &bagrec, &has);
 		if (error)
 			goto out_cur;
-		if (!has) {
-			error = -EFSCORRUPTED;
-			goto out_cur;
-		}
 	}
 
 	xfs_btree_del_cursor(cur, 0);
-- 
2.55.0

