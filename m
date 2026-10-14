Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8A1DDF0
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949862; cv=none; b=gncGg37L6b+/vfLqI0A3tKGb1HfGazje1wYKnwWiOE/HVKQFgB93iIOW/ZHNE9i8+TQD/KjsYVxQ/O38pD3t4MMv6/qT5KQ1pkb56hpIY55KNt5kNsBt68ZgFZTjqcFKvftKiqZGnsB4wGS45Lw2biVdS5cA+V+/wCTf0FB/FPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949862; c=relaxed/simple;
	bh=IeGWdaRCgygqBy0CDRrhmJPh9HV+GCslxsG8OMz/gmY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZ6pCrY5LxKwCPY/3Kn9yUQKXN42vZNEULQQdiywFaO6FM/q3HQNrMzcjy/8PbNjTWf+3TmYn701zNe/LtblzYsXsWBt+nqAUP0RPYy6ihr5MahC5NJF4QyUUks5bQuAc0EkM22psvFjqyBkZMyqUrF+5A8Bp1W8+4caCmZDOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PrJusu8A; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rEQd1KUD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PrJusu8A";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rEQd1KUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791949860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8o1J6sMA+sP+PCrClhwlF71A5SeIYOyiK52tT8L7wuA=;
	b=PrJusu8AUzoZJ0Ch76LGlcuyIHyxRK1GwF/kunDSOQ5qS0vBccjpWGbhQU/tMUogDQKhl3
	eg27U+FWf60k8FrWomBpsFq3ZjqCgcNdT27YU97EYxSyMjzw3XOMa/7MoA6khZuBr93pbH
	DycQhx7k8yA+470JtqHcG/mMNCQz2qk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-F6dGJlmAOKq3eeF_MXIV1g-1; Wed, 14 Oct 2026 03:50:59 +0000
X-MC-Unique: F6dGJlmAOKq3eeF_MXIV1g-1
X-Mimecast-MFC-AGG-ID: F6dGJlmAOKq3eeF_MXIV1g_1791949858
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93ae8e7e546so778935685a.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 20:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791949858; x=1792554658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8o1J6sMA+sP+PCrClhwlF71A5SeIYOyiK52tT8L7wuA=;
        b=rEQd1KUD97boPPPFPZHoiMZZtsJU+Lfqs4kcLg0ZYhsde/t/0uhVNbd76JXr48WaQY
         0G+jRIIgZJVNCbGxLUBAKNZkoN1vsrdqjIkOcDrVyB46Jvk84OYVpVcUnebwvUcJgiXu
         P1kTkljRQeT60kwygy2fQmdGo2XL4LtlG+YUUprnWMOLpaGVzYlxKkgcHxjQhWDKC+ct
         rvvm5BQRZbeRhnEkXtF4TBqJ/DkeCpp1xtUU1RIfyokSrJcY9OoXxadX8/Uyi61JXi8V
         2XXvfxgoxI4CPgXx7IRQgLkP60cs+7x02HI9Up1yLyzfsdnTEPvlVxgoDM2XVeNQWGuc
         Twvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949858; x=1792554658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8o1J6sMA+sP+PCrClhwlF71A5SeIYOyiK52tT8L7wuA=;
        b=Z8odQDh9M4Mk5kQy+d7EfIp/Zrvpmyh6Ys6IRLpB2mV0fa0KZ/InqDHTZB+i370C7i
         vD6Pw57Vthzue6XYt8avZ9kBDntaT8uZhXfsUhGxwdS2J2k8OoWIHi+y+5mY0QQ0Wn5n
         8Vp+uhtgz6mmAI8y5tbB0ojvUQhx7FPbUEDdiHZfwVYghwiD9l3YgvcZrfAj5RXPALk1
         0CMgRAisDLYESzLJT/3HuyyWCrcuugrxKJFiyq08GXr6tU5nhrfoFZxTLNW5e+jCIYSd
         8yowtsEmxBhGvO2gA9qVslSl9ajuUdgA6G5+soNQBhkRMwew7la2Uhurja91+CZggMtL
         LRBQ==
X-Gm-Message-State: AFq9FYLZxOYW9Xh2TxOCcr/hI5Chg6TDX8FiZDU/fttJkU8httGqJLCL
	CRRh5hyU9UFUga+1PEdWcw/ESXXpB0n4AeVEdxCQusT0d43MQA2lol+yWMV7iII/RNsc2v2dAgt
	+PmlcZicgTATexsFWl9pgDcBdrC7NcH1FdjEChzYmUSwPZ0rb+q6Vw2PykH9L94Zhh6NYeU8B+U
	nHIVtUGlLr0cxg6vjURQKD6uElc7Z6NSzksCA/mNysS6Zx
X-Gm-Gg: AYBFou3Hf/yeyeFFmFOH83bk7BQYumJA5nkU6aE87tC3d93V45PmH+HAFY346PBRklM
	1z49+TGp/G0B1njMCFwJQoeHsOmQnqJQ/HI0KwPF6XZwUrz5vOo6JtEPPNiRVIzCtUWNcByYk6W
	P4wnHQqvHNQSQ8j5GU3HyaFDQEFcjXf5AhCRBpnPI91ukZN/vdpTnLEtCK4uPGEbULIzgzlza9y
	6OsG2q9j/HrRGKYyt/3XR8EfIdTAEQnJJQwJSsmcznhSiO7kZXvGZGo0NT1ZfH49Ga1fezDWOyK
	a62Ef21ilXBKmb4PseVLOnEu5s03gB5So1UxoBgvyq7Kk7svJvl+NzvGiVl6gpPj5nD8YOMcuee
	gInGxqONRvf7W1cv7HCogZ6nwhY47HqJVW08kCA==
X-Received: by 2002:a05:620a:7106:b0:93c:7e9c:3bba with SMTP id af79cd13be357-93ebd24c5c9mr2399914885a.41.1791949858424;
        Tue, 13 Oct 2026 20:50:58 -0700 (PDT)
X-Received: by 2002:a05:620a:7106:b0:93c:7e9c:3bba with SMTP id af79cd13be357-93ebd24c5c9mr2399912685a.41.1791949857885;
        Tue, 13 Oct 2026 20:50:57 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm393907285a.47.2026.10.13.20.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:50:57 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH RFC 0/5] xfs: Remove redundant btree insert code
Date: Tue, 13 Oct 2026 20:29:58 -0500
Message-ID: <20261014013505.759089-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This depends on the prior changes
([PATCH 0/2] xfs: add missing cursor status check after btree ops)

The btree insert code returns both an error and a status var, but
they are redundant as described in the first patch here.

Every caller handles the error first, and never gets to the status
check, so all that can be removed.

RFC to see if this direction and the patch splitup/granularity seems
ok.

If so the opportunity exists on the btree delete side as well.

 libxfs/xfs_alloc.c    |   32 +++------------------
 libxfs/xfs_bmap.c     |   76 +++++++-----------------------------------------
 libxfs/xfs_btree.c    |    4 --
 libxfs/xfs_btree.h    |    2 -
 libxfs/xfs_ialloc.c   |   28 +++---------------
 libxfs/xfs_ialloc.h   |    3 -
 libxfs/xfs_refcount.c |   45 +++++------------------------
 libxfs/xfs_refcount.h |    2 -
 libxfs/xfs_rmap.c     |   46 ++++--------------------------
 scrub/rcbag.c         |    6 ---
 scrub/rcbag_btree.c   |    5 +--
 scrub/rcbag_btree.h   |    3 -
 12 files changed, 46 insertions(+), 206 deletions(-)

