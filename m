Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98C356778
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419156; cv=none; b=mBKi/PrYtvbQaR4gIdkduA41v1F85MhX8rJKy6E6dBykthVg+DFKNSFt2LokI8L2yUSoWBErcZMq3/AGNwEGZt0kTZEopXsMlLqA2H+QbWQ6zXZ9nKCL3pDGoRXaHKGCFuE3o5Mg6ay5I2v4zJNTx1sAQYqZ9GXhmffPqu3WVYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419156; c=relaxed/simple;
	bh=7mWWBPnGw8vL6GzWYnbKupt9+GH+8d4iHwo8GyEgbjs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RqGBT5JbLieaPS4Evq2GViWeuwz1d+kn/lpKwE5QauEUv4b7335oj4xSO2h8Rm57x+SdQwJFurpDsMv/UxHbmtXZk3ebt5RynyxuXSwPVh3zA081yRKNmfHbJ/qwbpjyGYGYPK9BMuKmNARL5XEY4IrW3CWBLsxBh+gVO9mmHxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3HlpdXJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QA4XAdGh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3HlpdXJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QA4XAdGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S9yb3/ntsdMdKY0x4OLyCu6FCyqB1/ZFWxSIS7R2Wnk=;
	b=b3HlpdXJFHJTsZW9rVCV8oMVVKPWJlWgkcJXOUhg96uUaA2VxyRBM6/Z7JcfvYvAlH4CZL
	Gkl9+NEh4/Zkwv4K0LxdJDcS8XJDdMkMQQPRQ1HJHUQuQdl9W1IYkoGQXxvyookvqwgKKr
	PpeV4mKb6TZc2Yu1riqFJLh7W9C2PP0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-3gwPZNoYNNqiwo88NCm6uQ-1; Mon, 14 Sep 2026 16:52:25 -0400
X-MC-Unique: 3gwPZNoYNNqiwo88NCm6uQ-1
X-Mimecast-MFC-AGG-ID: 3gwPZNoYNNqiwo88NCm6uQ_1789419145
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93909014c85so715531885a.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419145; x=1790023945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S9yb3/ntsdMdKY0x4OLyCu6FCyqB1/ZFWxSIS7R2Wnk=;
        b=QA4XAdGha4gxUjX5xwod5R4QpnboCSXy8gyqbAsH2Zx9Xd03Y8tdBsF+I4PVMTR0Ab
         FAQ8jUdognEX82KouGlFsBf+5wmSusqdc1wL4U8taezdHtIbVH/oETT8qAN+pSOnRowI
         s25Ax0bLmraWRuQm45xMB2MypP+VQbUl8vaV8nhbUNfeLAXPUCj4XbTsFOLtETEnNZ7r
         saOyvlhX7kvHsuYFFWWa3bs0WL7kvFPvMKRKppisT5M8mt2oeIEZor6vXsHKQG5FLyqW
         13w54qsPxT84De4Ay344mSAv+xnilameD1PS/uY13c43yhZhauMhh28MytvxF60GkIXK
         UQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419145; x=1790023945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=S9yb3/ntsdMdKY0x4OLyCu6FCyqB1/ZFWxSIS7R2Wnk=;
        b=qeD6c+qPh7J5DsprvthfFqZvffoFkndLjxc2S8yEsz0AvcVWleg9jfvVj3kep53ppP
         f/YB5tRgtHcws7XVN/9XZEJ/DT0VD1wQOopRHEuwH4F6ABbKSCiJJkRXZQrDaXc4ZKB6
         EZky9E0BwPhHYc+2X9dSi6vjiELfItBfoDrNK/x9UcGKU11tAbRh0dQRwD8YkaA/3sfQ
         pz4MsXR5HXddZUR89MjTYp6AizawtPT/PAm/KSo4q1Dhf7Jd+v3wjZquBrTwH1XEBCgo
         vXuEOhDdNHMDFNNMvxqL9XFPdjyX7+cV8HZC7sY49mv2Vw8yfDQqP32iuD01qIxcM8H9
         UuUg==
X-Gm-Message-State: AFuF++m3RlB83VpwRlAvYKGmMJUq9/k7uKgOuzeYjh+Z8eXG2FNKUmKn
	syZv/83uT7RmkN0GRQeqnXbsnV7W4qcfC5mlzGogp1z8ISGwn6U0Ag6Lpqz4uznY7kGJ6tXsUji
	GtkqFPgoaoKVenRR9LBJhVTUpyBVNn9TEZLb0PQQYGYaDegIPdnBik5EloxsIH1y6c1LcmxTABJ
	5fsAXKVCmxIYIzv9eenP+bV08qiZp+xwtJZKAo3M8iE6SJM+E=
X-Gm-Gg: AYBFou2+5XOn8kaAOVdL3QxaKPltIpGA0jPuLS0O8nW/nR1eqb5/omsqjfT+UJ7l7Dp
	WzJ1K+7MzqOOoRj9InRfxmStuCvSrr1bdWHFaj/t2YSZ0kst98hN1/dObbZCfhly5yneY3Zi+i5
	87ZJ0mCTJePBIvCx+0guadUdvLAt1ghTRdtXX4S9Al8jPM5CBgI7kUhZWWudF71wRg9f6yobIgl
	yFs8TnuGH/m0IKsuVxnMrTrJgLh+XmrT1GA870ZtK6bW3aGEA91Kb78mGjm/o/vryG6vEdBUm+X
	R/7TLHzzP6jaq3lgzTTq6yg1O9Be42uO0UOWQNPQzIV3QP+eA138aPvZVT59HQi4dNr96YLvmwz
	rPNuwOqXbX26ujAvrHj0GQY41dXczTntUkSpOWw==
X-Received: by 2002:a05:620a:1a1b:b0:939:b55a:3c7 with SMTP id af79cd13be357-93a29b98594mr635085485a.41.1789419144782;
        Mon, 14 Sep 2026 13:52:24 -0700 (PDT)
X-Received: by 2002:a05:620a:1a1b:b0:939:b55a:3c7 with SMTP id af79cd13be357-93a29b98594mr635079885a.41.1789419144140;
        Mon, 14 Sep 2026 13:52:24 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:23 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/14] xfs: remove unused arguments from many functions
Date: Mon, 14 Sep 2026 15:46:05 -0500
Message-ID: <20260914205221.1516254-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Seems it's cleanup season lately on the list, so figured I'd play
too.

This removes unused arguments (mostly mp) from a bunch of functions.

I did a quick check of the xfsprogs port, and it should be fine.
(Left out xfs_rmapbt_maxrecs changes for that reason; all the
.maxrecs functions in xfs_db need to match.)

Assisted-by: gcc version 15.3.1 20260722 (Red Hat 15.3.1-1) (GCC)

Total diffstat:

$ git diff 654ae5d73c05.. | diffstat
 libxfs/xfs_attr.c             |   14 ++++++--------
 libxfs/xfs_bmap.c             |    5 ++---
 libxfs/xfs_bmap.h             |    2 +-
 libxfs/xfs_btree_mem.c        |    6 ++----
 libxfs/xfs_exchmaps.c         |    1 -
 libxfs/xfs_exchmaps.h         |    3 +--
 libxfs/xfs_ialloc.c           |    2 +-
 libxfs/xfs_ialloc_btree.c     |    1 -
 libxfs/xfs_ialloc_btree.h     |    5 ++---
 libxfs/xfs_metadir.c          |    2 +-
 libxfs/xfs_parent.h           |    1 -
 libxfs/xfs_rmap.c             |   13 ++++++-------
 libxfs/xfs_rtrefcount_btree.c |    8 ++++----
 libxfs/xfs_rtrefcount_btree.h |    5 ++---
 libxfs/xfs_rtrmap_btree.c     |    6 +++---
 libxfs/xfs_rtrmap_btree.h     |    3 +--
 libxfs/xfs_trans_resv.c       |    7 +++----
 libxfs/xfs_types.c            |    7 ++-----
 libxfs/xfs_types.h            |    7 +++----
 scrub/bmap.c                  |    9 ++++-----
 scrub/bmap_repair.c           |    4 ++--
 scrub/inode_repair.c          |    6 +++---
 scrub/orphanage.c             |    2 +-
 scrub/quota.c                 |    2 +-
 scrub/quota_repair.c          |    4 ++--
 scrub/rtrefcount_repair.c     |    3 +--
 scrub/rtrmap_repair.c         |    2 +-
 xfs_bmap_item.c               |    2 +-
 xfs_exchmaps_item.c           |    4 ++--
 xfs_exchrange.c               |    2 +-
 xfs_inode.c                   |   20 ++++++++++----------
 xfs_rmap_item.c               |    2 +-
 xfs_super.c                   |    2 +-
 xfs_symlink.c                 |    4 ++--
 34 files changed, 73 insertions(+), 93 deletions(-)

