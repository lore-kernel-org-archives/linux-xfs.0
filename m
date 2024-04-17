Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D48F1487F9
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370621; cv=none; b=DUFLlOwHomp5pns/AH5mEv8O1U+2JBrTAlH7kU84bzPgeyWPLTPfwhz4FqOljgV3wfPa78rA1KH6/TPKNl913Ro85sBY+tU2k6PB2UY89d9tJdSMPrKfperxHkldrUhcdq6VCjzfw0qV8xREa7hx5JJTY6C5wXr0tebocGRkNQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370621; c=relaxed/simple;
	bh=wY2tq1B//mZeOkq3xwVsr2uwJrRTR4TjXEKPh8qkRxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NGYYRD0aW/P+YUAFg6qZF8Ue2VXFF+WlDGu3JNUQJK2DcI6vz5OD48z0tAp2Kltp7iNXKRtkar09IqxNbJH5nNRZa/q8Bn6yKH4pebeE38B+XFxp2gDDehmezfzUr1ve0/cwGkfrcMsuaurYGUzOKr5YVajdUemPCjZWNSsp9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ALJyDKyl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ALJyDKyl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nRRLovry71cgv+BdKoEPqGQctfDDkV/IEeIQXMGow9I=;
	b=ALJyDKylynQKXWXhfNU4rYlJl92bPH0jUS0zwbn87fecdOSsBALvK+DckVXu9jYOQ/B6Vp
	aCuRGqZIXiwS3s7N+ssgG8WFRBmm/PbvMqh7tTbkJXsKQfbomuWx/0kVsJg70Jr1TwGnJp
	Es1NmYAE0Szh32rgNhr+UNANKZGKtCM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-WSPBSTGxO1GQ-cwgg1L5uw-1; Wed, 17 Apr 2024 12:16:56 -0400
X-MC-Unique: WSPBSTGxO1GQ-cwgg1L5uw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a4488afb812so342803866b.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370615; x=1713975415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nRRLovry71cgv+BdKoEPqGQctfDDkV/IEeIQXMGow9I=;
        b=LFU1QxNuXX8dFDGrT4LQN6uvwc2p8k3ONq3eYBgmt58ixuVrmqkH+Wh+i3LZeVo3lZ
         /a1UrBDhxlQbGdX/MU02QkP1WlZlgb0jXBnNzYRqFvG88PCUVmipcH1j4dnwPt7JWDCI
         PF+2K+DwZMYfs1ajvGHhOvEcz4+6N9pC2HxHvUyrumiucgAPMoVa2QYjQ4RrJN0u9lVG
         Hd6bTy2No4LW01n/gAezUyBjpICAfsSQ/jgPjB2p7wtPghUQI1m4NGTm1/CmPKMo5XQc
         7OLVRlkTEiJERgL1o5gqfKJwEJikMkeEj1RpIGVoofaYw72aeiAHOM/QHAg3tg8VPzqc
         /BDg==
X-Forwarded-Encrypted: i=1; AJvYcCXmeP6OtJQ2LtWxmoSypOVVEDKNXdQJ5YJAJC5qS5N11nQ46Vav22j3NSmbFkrgLvg8u0R0k+YUEvMVUSXJXbM/PhaIntP+UqZo
X-Gm-Message-State: AOJu0YzhnIsKLIVgX8YLB9wTNzCkNEdBkdOgusteFFS+urK07zcKJZ6M
	lqcTEQqHsshO0u9aGdJiPO5ZL0FEwQ/NdNM/U5oRBFpbpsaAPYZ3aN6l7XgVHUr1NVUq5qhlYdA
	LtX+wxqgPo3y67Y9nIoqz9lJ7CP0n8o57N55/OqFGNJvPRjRv1kPGk4dq
X-Received: by 2002:a17:906:f34c:b0:a55:5620:675c with SMTP id hg12-20020a170906f34c00b00a555620675cmr1604313ejb.34.1713370615217;
        Wed, 17 Apr 2024 09:16:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXuF92fdhm3lXDkXPLq3GUBPEhEiBualh4Y+mXv+WXVJ4G0M8BbgsrGOxIVu9AZz3uy1nPOA==
X-Received: by 2002:a17:906:f34c:b0:a55:5620:675c with SMTP id hg12-20020a170906f34c00b00a555620675cmr1604293ejb.34.1713370614550;
        Wed, 17 Apr 2024 09:16:54 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090635c400b00a4a33cfe593sm8272427ejb.39.2024.04.17.09.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:16:54 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 0/4] xfsprogs random fixes found by Coverity scan
Date: Wed, 17 Apr 2024 18:16:42 +0200
Message-ID: <20240417161646.963612-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is bunch of random fixes found by Coverity scan, there's memory
leak, truncation of time_t to int, access overflow, and freeing of
uninitialized struct.

v4:
- remove parentheses and conversion in another expression; add
  spaces for operators
v3:
- better error message
v2:
- remove parentheses
- drop count initialization patch as this code goes away with parent
  pointers
- rename unload: label
- howlong limit

--
Andrey

Andrey Albershteyn (4):
  xfs_db: fix leak in flist_find_ftyp()
  xfs_repair: make duration take time_t
  xfs_scrub: don't call phase_end if phase_rusage was not initialized
  xfs_fsr: convert fsrallfs to use time_t instead of int

 db/flist.c          |  4 +++-
 fsr/xfs_fsr.c       | 10 ++++++++--
 repair/globals.c    |  2 +-
 repair/globals.h    |  2 +-
 repair/progress.c   |  7 ++++---
 repair/progress.h   |  2 +-
 repair/xfs_repair.c |  2 +-
 scrub/xfs_scrub.c   |  3 ++-
 8 files changed, 21 insertions(+), 11 deletions(-)

-- 
2.42.0

