Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685903CD8BD
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179284; cv=none; b=Xae+eDJNbZyHgqFM/1mJ49WPZd+iDi1s8MUyaBKQQgzQirTexxctCAi5d2Rb6KXy1P9sGydy/XMIGe5X6leRAal2sCBooBLP8P4SBuv5hudyO0+Fmo+ANT8O+LrwSLhMnlKH9YGwgdxw6RM83vasRyc64lzRPE/FifFmrIl57nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179284; c=relaxed/simple;
	bh=/FwsLo4l7heHO64B6OkRlvverdrW6G8mDPTi6jxrdiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UhIJKSCh6YLJo3zsRtBngcEmY23XuV+CNjE64Qfsj9TmcW2/rr67VXKCSTVUDQGYuwfBwQs5YRlaL9j0nM5uQ8oj4U/QZOykL7050RNVd7sJEZ89u2xKpzRJdAEmzsk/OoulB7RlzJJqWEIGKpJIf3uXsfNQOQYCwEY0a8UCL2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VoFk4ZGZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jlJFzEue; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VoFk4ZGZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jlJFzEue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792179277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xs1mJpQ8yuu+2PY2ay2KReLmwdBrvHmkaYQyrE2j6ik=;
	b=VoFk4ZGZhFZCC9ofNHCRX1eafFaPvjbxSmn42fsBW+vF/UuafpxaqCj7y3O/aSTQs/F7uK
	vwWGKTldXhTH1sq1f3l4RpVOsiim6rPDzPcA/Id395eFIAuKD2CeF6SWp7chP0bMqd/qd2
	w9+Oqo0vvsAAjIlSPjjyvvUX/KGzl08=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-gZWhFv6yPh-tDH_pBN0j4A-1; Fri, 16 Oct 2026 19:34:30 +0000
X-MC-Unique: gZWhFv6yPh-tDH_pBN0j4A-1
X-Mimecast-MFC-AGG-ID: gZWhFv6yPh-tDH_pBN0j4A_1792179270
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93ea9ea9d13so53729785a.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 12:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792179270; x=1792784070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xs1mJpQ8yuu+2PY2ay2KReLmwdBrvHmkaYQyrE2j6ik=;
        b=jlJFzEuex0hs6ip1A01uw/6tRDGm92K9Z6XKOGpmNBf5hPC9MELRs9JrZHFd+O5q0Q
         /D6Z5ael3d5Gt5kOsVSXMyg3mahfn3nv4/37M4Jr+Fgx9LBJJDmKD9bFP2B7ea1CbXQJ
         SMUF4vHLYSNUoQXSD11xb296aYoAHBoDLx9fRjG5LH0jpmnUTdvOWw2Nf/ZHNrXje+to
         wEQ7zPU0f4XGg7aU89RFMVpZBq5nG2iLMzh0IdAH8BOmY7e0ygee/pPRxJZF2mr/Z8c2
         yco5rEpWYXJb888Fj/NvRGh2sWIxU3nkubnpQ0SOMrPxfeR/JELBgxkGvnZtbaQoJarn
         Z6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792179270; x=1792784070;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xs1mJpQ8yuu+2PY2ay2KReLmwdBrvHmkaYQyrE2j6ik=;
        b=23222vp1L+TJhW9Ej+d2v021S17JegllMjmUDIkCua5UBAB4/9lY054GHGxy1YM968
         Fzpr1MEdmuCpJLhI12KCpnJvqUaHMFUJAp8N0Qv1UIk2qXGJR+T8bmhzDMdxUBdXJvhZ
         SjJDYWCEYWI0rzxLxae9wW0teWG+hR/ToYWmIFVSJui0gSj5nBLotq3SGDWum4Gyjmap
         pLwgreX3Jv0SXISY/aohV4nElKi6BVrcJ6GFA7cMG3+tUBAtGj+I6Me57V8lawV6IXpb
         PpWtwQGnLI6Fwilol1EtEtOukJXOQcMgBZdDsUcQyOsksQYpeytFF61PuX8k/979gPlU
         TzFw==
X-Gm-Message-State: AFq9FYLnibuk7gTtrrqF4zCRu2L5ICekymxXiOrrzmV8LiDFZekUDdfS
	rCShFINsdBPlKoKKxShDDsNvmkAI6WyLEora0KDKpi8gdcIfG7vvaWP7st6IBC4q7wPoipqRamw
	3l6MuwPx1Uk7dKUf5EIJfZWmllLxPkAo45EF1Bn2OVP79l2MUei/wT8muZmOvfWF0okoDnxheFZ
	TIJ/dhO43lY5hvRZtW0JC4Dv6OhCd2T3fy3pev4tXfpThH
X-Gm-Gg: AYBFou2Nv7mH2lXEM/xIkpbKQpb4aFp/JSPQB8KG7lRx7yrARow6W2LWbUz3gWw8uci
	jHN+1wUChypK2kbkUiNs/NGu2AncPlriuP7EG1aV9jizDQelVTU5cDrYcCkdWrXRQwvBCTQaJDG
	AWpiHMgx2zGQyvzIlobZPWfmkWQi/f+FwObg2A+2ny8i/sKuh1UZssfZdx4blFHT7EDld5hG9WR
	PrhuXYJAAfqlz83+33hvB1fixGQ9tiMXxgLqMtVEl9vAShjLabAONbnNjyS4QThrGefjDLScSSJ
	KcFJc3fo+BmFhR6m7aSXDMy+6+FWwtBIUTZGU59rmkzy9/LmtTqQ1yySlcFtpDuGFb7Ckqk4hIP
	6kUNFUv2NIqpW3uEC9SWbs4C3+e7Hdrhfq3AiBg==
X-Received: by 2002:a05:620a:439b:b0:93a:2bdc:cd57 with SMTP id af79cd13be357-93f29b74a11mr147717885a.2.1792179269437;
        Fri, 16 Oct 2026 12:34:29 -0700 (PDT)
X-Received: by 2002:a05:620a:439b:b0:93a:2bdc:cd57 with SMTP id af79cd13be357-93f29b74a11mr147711885a.2.1792179268738;
        Fri, 16 Oct 2026 12:34:28 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a990fsm284359185a.35.2026.10.16.12.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:34:28 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@lst.de,
	dgc@kernel.org
Subject: [PATCH 0/8] xfs: consolidate btree insert/delete checks
Date: Fri, 16 Oct 2026 14:29:00 -0500
Message-ID: <20261016193422.1630907-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every xfs_btree_insert/delete caller expects overall only success
or failure, so these tests and mark_sick calls can be consolidated
into those functions themselves, with callchain tests and extra
"status" parameters removed.

 libxfs/xfs_alloc.c    |   91 ++++++++------------------------
 libxfs/xfs_bmap.c     |  139 ++++++++++--------------------------------------
 libxfs/xfs_btree.c    |   14 ++---
 libxfs/xfs_btree.h    |    4 -
 libxfs/xfs_ialloc.c   |   51 +++---------------
 libxfs/xfs_ialloc.h   |    3 -
 libxfs/xfs_refcount.c |   97 ++++++----------------------------
 libxfs/xfs_refcount.h |    2 
 libxfs/xfs_rmap.c     |   96 +++++-----------------------------
 scrub/rcbag.c         |   12 ----
 scrub/rcbag_btree.c   |    5 -
 scrub/rcbag_btree.h   |    3 -
 12 files changed, 110 insertions(+), 407 deletions(-)


