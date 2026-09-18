Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081834F93D2
	for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755211; cv=none; b=qmW7SKE6jgCAwrIajP1dZGBISqbQyELqjw+ka9pi9qKdnbCx58lo3q4gCoHtTI0OrpbFhePZUA2lPtDaPN9rcRsZyBz99Ry1NYk6mG9Aad7Mu3EUY05K1v5ek8nJ21J2M27LacZkTNaTgsf8VK4M0mfdm+uxljAgzjfWfITSKUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755211; c=relaxed/simple;
	bh=UhjcCSEBASRP3pXwxc/w2uSr349i7/rs0SVbNkpMJuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oEDTiF61dbm6iVQkA8/QeqHTBl2AjfXly1PoG86Nh352k0d4B61uf7mPOm+/dasXATOvBELJSS/KfErZeAy3nqiQ68qje12TiPw42q9+HFRWHq9++Vip0RPMpyCKUgAp1uIsSTcmyOwEib+yOmg+BvLuIpTCmVPHkWVbwSABHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwrE+oIj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWtBKlIp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwrE+oIj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWtBKlIp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789755208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9vuWJxHkZ9DC1Q1CXIH6hA57OU41aSrhKvEiTRuTeR8=;
	b=JwrE+oIjTgEtu6eWkw9VY4CF8FqCC0CEN9Kq/D0NUfXFqF4BwyCW4VwSaGk0IT6PG+YSUJ
	qf/kfomXbaGGpOzfPEn14W6X5mIVkyvQd8VwhSQfoqZKCmYT6pit0q7EmP8psrgpGwhq7M
	ZhLEw43krmksCdjrcj8r+dZL9HYfk0E=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-P0akmq4ENV-oBwoHyofuyw-1; Fri, 18 Sep 2026 14:13:27 -0400
X-MC-Unique: P0akmq4ENV-oBwoHyofuyw-1
X-Mimecast-MFC-AGG-ID: P0akmq4ENV-oBwoHyofuyw_1789755207
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91213a1aa68so18197076d6.0
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 11:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789755207; x=1790360007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9vuWJxHkZ9DC1Q1CXIH6hA57OU41aSrhKvEiTRuTeR8=;
        b=AWtBKlIpRF6CVFdrfM6Ngke8H40AF5i7ruK6v4Jd8xlufLcXo8hL5u8VFOl49q0IFt
         yUH1e+65Obp1ctURZo7jxCF1GPe+IkGYkgBL7Gn6SoKZP1cMqoS/R7h0D3lXkGUurRb/
         4vytRDclzq6sSbWSsBVo0JC6jp6xwXlFuRg1a4/fUUNgdnipXVnDR4sVA61ao4F4bjQZ
         rZoxz2vhW5DWfFkLj9XKlGV1yh+wnP0xggEhz8AWw0Kh3EGi2KRrdJh3wcjqho402+lB
         gVLvHK+l13sVQpJDsEdf7P+Ry6P/X+UKw4ejexLdokTAWAgm0My/j3jBhC/dTyHgXDiJ
         12Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789755207; x=1790360007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9vuWJxHkZ9DC1Q1CXIH6hA57OU41aSrhKvEiTRuTeR8=;
        b=OBRcEXn/ecEhzL9BbajWCT5MJ7bDpsNXF2EAzF/y3wmHnUpLluzSqoPvtgKzzH933x
         aKdx0MUwEDW237QGTJo0GZiTtbT3cUdbB26+K+bLoNC8f0DRgkweuaablgUZ0C95Bn6V
         /BKV53uEN4Fxzt3ar/tOuWMO3L2lEQ5vhdEEjWdTHWnH4Tuo5ZtD98q5ObgLUcZVu4UZ
         LbeZVt+ED0Bd1fPtf/MoxxMxOOr05vqTvidQ7FJqVnBZiVV+g62vmoiwLfxNYk64vlAL
         KDwqObxwpfgUEx/sXRuFEs0ZFCZqCv87uU3OnO4rQjagDqDbqSQeZ1vXdm/hyiIhh645
         lVnQ==
X-Gm-Message-State: AFuF++mcpKs+YQYDktAx47Z/oP5xPwIA/Q82/siJJG3r75C/gXidfIjU
	AbGUaqmhRUdY8HnEOdgynd78xdM5xd8dmNX7ZkGwdlcB8rwHSyqsLztKlh73qUvn/AlkFfjoAsu
	n314ZutW9S8+NIR8gqYyOhc9/lB+VUbEoS4R/KeJNnxHLJabgv5/RBzTf1A9/TuKV1TD7//twrl
	D1mA3uIEhbYg+u1k5do7H6KUqPe90N7jp6HNza2F4Qw5pVQHo=
X-Gm-Gg: AYBFou1TGrTvWsogD3ShDfi7wUPYmSxamtOnafnVXTdM3YgEtupGXkiRKh38dzbfpKz
	NYX5hNbyomUgHwGxepOcyPHg1ZgxmPJdPm9Q0Od+E2lUDvc+QKUVI6SUIwoMp6l+z3aDOqvcLLO
	eNhiL6OJp47sycQcFjRJF4q4G+OhCk7ihzfISxjazCSvqFH6LFKe89lNCcImdViL342urwWVvSy
	ivDcOLsfZla4+oF01qoDju8vsJdw0yt/S6PdVroI/Y5OTQSTShNhwo/e3SaYM49497qRvObFI0S
	7w1e8i8OEWbjuYL9FMurmnLO5YNoIEdoTHViv4JosCWqZic+vxyx/PM5XS/ugjCnh7Rsr+bLF1o
	1ZNSa2tn7DW12nYeqcqdzrGubMhrGpHmugHaevQ==
X-Received: by 2002:a05:620a:6010:b0:939:f513:cc3b with SMTP id af79cd13be357-93bdca3b239mr477551185a.42.1789755206790;
        Fri, 18 Sep 2026 11:13:26 -0700 (PDT)
X-Received: by 2002:a05:620a:6010:b0:939:f513:cc3b with SMTP id af79cd13be357-93bdca3b239mr477546285a.42.1789755206269;
        Fri, 18 Sep 2026 11:13:26 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93beda707b7sm4583185a.10.2026.09.18.11.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:13:25 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 0/2] xfs: dedupe realtime rmap btree code
Date: Fri, 18 Sep 2026 13:01:31 -0500
Message-ID: <20260918181324.2472127-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_rmap_btree.c and xfs_rtrmap_btree.c have a large amount of
duplicated code, differing only in function names which add "rt"
in the latter case. This can all be shared to reduce the cut & paste.

Tested with an auto xfstests run as well as the rmap group with
rtdev & rmap enabled.

 xfs_rmap_btree.c   |   16 +--
 xfs_rmap_btree.h   |   26 ++++++
 xfs_rtrmap_btree.c |  230 +++------------------------------------------------
 3 files changed, 51 insertions(+), 221 deletions(-)

[root@fedora-rawhide xfstests-dev]# ./check -g rmap
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 fedora-rawhide 7.3.0-rc3+ #330 SMP
PREEMPT_DYNAMIC Fri Sep 18 10:23:43 CDT 2026
MKFS_OPTIONS  -- -f -rrtdev=/dev/loop0 -m rmapbt=1,reflink=1 /dev/vdb2
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
-ortdev=/dev/loop0 /dev/vdb2 /mnt/scratch

generic/365  2s ...  2s
xfs/114      3s ...  2s
xfs/233      1s ...  1s
xfs/234      5s ...  5s
xfs/235      1s ...  1s
xfs/236      6s ...  6s
xfs/271      2s ...  2s
xfs/272      2s ...  2s
xfs/273      4s ...  5s
xfs/274      3s ...  3s
xfs/275            [not run] This test requires a valid $SCRATCH_LOGDEV
xfs/276      3s ...  3s
xfs/277      2s ...  2s
xfs/310      0s ...  1s
xfs/317            [not run] XFS error injection requires
CONFIG_XFS_DEBUG
xfs/331      2s ...  2s
xfs/332      1s ...  1s
xfs/334      1s ...  1s
xfs/335      4s ...  3s
xfs/336      5s ...  5s
xfs/337      5s ...  5s
xfs/338      2s ...  2s
xfs/339      2s ...  2s
xfs/340      2s ...  2s
xfs/341      1s ...  1s
xfs/342      2s ...  2s
xfs/343      2s ...  2s
xfs/450      1s ...  2s
Ran: generic/365 xfs/114 xfs/233 xfs/234 xfs/235 xfs/236 xfs/271 xfs/272
xfs/273 xfs/274 xfs/275 xfs/276 xfs/277 xfs/310 xfs/317 xfs/331 xfs/332
xfs/334 xfs/335 xfs/336 xfs/337 xfs/338 xfs/339 xfs/340 xfs/341 xfs/342
xfs/343 xfs/450
Not run: xfs/275 xfs/317
Passed all 28 tests


