Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166A53EEAF8
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425015; cv=none; b=tClUfxWV9CqzK5tjbGxVJIOqxISl7XfkQJkFQi921Ia+q+JFSysdCybDTJCVKG4+OLxbumYebSnDc6AlpGU54Hs+spmbU4H5KV1lptP2oFlESpEWYf2QUcI7bpUMibsi4I8HKJqoChOnyhXGzt6BXNw5V51EO/ZO1c0MmNGoL28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425015; c=relaxed/simple;
	bh=vjpiQKgXEfXeHpjEFbteFL3h+uIJCsyYnuHpPkdK+vw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mjNoRT0XY8LlgAIAb4SxXmLKSCE2tRarA8ftsdmst7hpVKvG5JA7Kq/pjnjmiBv00FdRGkZ5XYtwKKL/tPnIkJImI+q1dXWJQubi9/hwodz09flK9Lttld7nxQlC8CD+lbOIXDLeSGl93X1QbwUzX6KDp68OovO9Ymyz6zfwdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O7oRvpgh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kDxVwIcX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O7oRvpgh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kDxVwIcX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KanMiIfIQGe8keBbk8IpPuoiNzuXST6boQNBpJFpgQE=;
	b=O7oRvpgh1rIKHNgcLt/UUm1/uaI3feBSY/XaB6xDYXke1t4yEagUgvQtAiLyXFBjTB86Gv
	ciQ2Gih6fwu/F0ibdXpb+5HUMBaOW6Bz/KeNG94gGeEpI8jZnA60v2Ss8tV5Er6VDujf7R
	j7Dxe/jMcLVKmPoZgSU0G7mEQqvviRo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-vsDgbl-wNe-l5aPhTscREA-1; Mon, 14 Sep 2026 18:30:11 -0400
X-MC-Unique: vsDgbl-wNe-l5aPhTscREA-1
X-Mimecast-MFC-AGG-ID: vsDgbl-wNe-l5aPhTscREA_1789425010
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-530f65ddee1so44471581cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425010; x=1790029810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KanMiIfIQGe8keBbk8IpPuoiNzuXST6boQNBpJFpgQE=;
        b=kDxVwIcX/+kgju0YddaNlDwrVH9XqQCDC9Ik10Ned607V8Iug7zR41jN7R1eAMRwgf
         bo9aFDjWd5D36DWxCsJrvLbio6cG9Zcs7DNItiGLAFJwH1HFDcK8uWiu5yRF63YZar5K
         2v0//CzDF4li7upqmRzqaTxiwOhrk9szC8Vkk9fRXJhkKlSoaNBmzpiSCxxKxLSJt/cG
         uCGC+vfpyqUCFtIkao5vA6T9lxU6Eccn449O8xmPsUsRnNVeyd3s60M22y4SnplCKbUk
         pD0GiLYWETCBa1PIH218MLdx+OFidbt61IKGUt2rEurxCN+MR0G91jKf148m1FiKGlUB
         QgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425010; x=1790029810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KanMiIfIQGe8keBbk8IpPuoiNzuXST6boQNBpJFpgQE=;
        b=dXMnouoNSOOY+aQr4raLiMB5UmVsTUrIVjucwqBTFqqJEhSU+x8zkbxQ5Zvi1doCMO
         x5a8SUETEDjsrNsQUqDRMqpD/lwC6o6pxlhKp5fDfbqgXc+6TZE6YqlOxjrpsMls0Nhn
         7NK2QCHvUXrnzY1Sge42vvZA8GR7odsv/dxEFkIKaEmLd/06JXUnLh0onQjNgif6UcE+
         omYrpzpAcKx+w/YDqxFxZYjCJf1YydvG3Ie2fdLy+54Swg0Pchs6S03D8orgA69CdAZw
         OzHdLZQGVi/8yrOGWiyvA6KWom1ASZjZvGUymP10X686jQMi/NbMQjcGEQ0lPfIbQ6jN
         kStw==
X-Gm-Message-State: AFuF++muDz0uJI9ssb8KhLK6W7k5tSyuz026j7bFiwtgAimz3rj7KwLQ
	rMd3hAXVM5AE6FyQdBPmJmnJpDco+lWtMDICn4drDMHGx2A1zqxUj22P01+NPKqSQVLWbf16t1C
	s4r37hA5GvRra9Ysnx+rRj+gt/PP7A12sxstfrbOF8C38CNLY4rknjhsgeRvYGeJw/3U5sxUPmg
	3y7BBfv8JiEQyWpkAOu2WSL8UVwTgzhb/ZaqcYWPwPpNjYM9Y=
X-Gm-Gg: AYBFou1X66AM05TqB8f39aB2aZK1a961/XtrlcHZnfs7PQ9cGyvj/kgM02sqQy1tUBv
	PzOvPHv37utj0ntrEV3jVt3x1rlMu1jj1Iu1xX9js68IINDs6Th77OEneHne4RiV6hGMoUMpfvh
	b8gT2hzeeyoAgrO5w5tTqf2sxncyjI3gC/i8gZIzOvWoDbMNP/gtpVRfqShtt168q4e7rG2VyBb
	/F+cM7lm3F1KK92JwZkdvBuz+DSkSsu1bbX35vprUuTEZm3nChUFohGKNA4bQ9G5CoMD1M/hU86
	X/FqyrrNcpu6a9GeSW0FjTxzkJNnUirRXOtQSKtaoP4Dwk9kHA5eqJq6Q4nKHW0MpEGYW7FDl/Y
	bmkWgegujiRn9kPtpJAoSi5yAUvYBE0SZ1/a8yA==
X-Received: by 2002:a05:622a:592:b0:530:cfe8:ab8c with SMTP id d75a77b69052e-5310cf1fbe8mr73238131cf.7.1789425010553;
        Mon, 14 Sep 2026 15:30:10 -0700 (PDT)
X-Received: by 2002:a05:622a:592:b0:530:cfe8:ab8c with SMTP id d75a77b69052e-5310cf1fbe8mr73236571cf.7.1789425009659;
        Mon, 14 Sep 2026 15:30:09 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH V2 0/14] xfs: remove unused arguments from many functions
Date: Mon, 14 Sep 2026 17:28:46 -0500
Message-ID: <20260914223007.1587017-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V2: Sorry, that was stale already. This is against for-next in
    https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git :(

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


