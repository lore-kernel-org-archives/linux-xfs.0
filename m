Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2203E242D9E
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 15:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975075; cv=none; b=IutaWm7vqy00466Rem4LuSjl7yYuk+tVShVmGJ6H+WrNxQxv5EoDFjX2JrA1glRyyWi9cGxepDofvdE/+XZbNVBqgVlyJ28Qn5SbSks7WPlbyClVXFEZwOt6fD1mK6kJVGpitnUAwN2z4niYyOtYpdJqj4qeyD1w9bxkk41kVdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975075; c=relaxed/simple;
	bh=b0AxqkJsIWLhJh2OZHuBaRi1Af/zgm4mSeyry+w/3CE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LJ/f5E++CK83BKNY0/gBvWJgxqs01p2RGEa9eFrSFAd2Sb93Jf15CB05QM/Ssud10V6NEHDbmoZZgQTuHj28/n19cPcck1HHfNO1hB8xpDb+IjeofSvl9r6gtJXBxoLEFOA8SWvnXZoGS7DKzA7Iu9NFz7hLpVHir74hdTNqlZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BGQGkSwC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGQGkSwC"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-781010ff051so3383384b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 08:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760975073; x=1761579873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nHLY/O4MWS0Nzf3N10x7iU6IAOHpEm0SWfzT703B9lE=;
        b=BGQGkSwCXmZOpKH+lXdJMNhYyhFBj1OGii0Hug3I4n79f+VrgGD9hV6L9Du9kZu11n
         bPGyTaEdVr8MOQB8eYdZ3xdEceYsf1ld2FyWMpDfbypP25mZgCvqXZzunc97cqwdMUpV
         uYLNzkVvFXapOGE7uJpG1S8DGxVQI12oGN+3tswypfjPLNIaivgr/DDzBCE6TBttFqjJ
         XDyTdI7odDhHEupLzi5mQ+Vn0O8C2c9RxKpHSH4jykAzbv1Y2qDGjqWI75PtqoA3C5fn
         A56lQtbiXSE3NlKHTeRwvyhl1CiTejB/HlPotI/rkWgaVTDvpp1K6Ssu3Uzk2AmFYezM
         khpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975073; x=1761579873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nHLY/O4MWS0Nzf3N10x7iU6IAOHpEm0SWfzT703B9lE=;
        b=gmdO/LuLYCvjlwL/G8Eqs+MtnoZqxktUr+lRvWop+6Gi9+4stu2cSEXX5StBevTR93
         uVGrMBmE4QjEjYSslPttTupkW6t6teW0UG4G62NJjdu6B++p1FqjKp7gau702yKzA3pa
         yvUr8Wpg+0CjhP0qXfZDtAOAJRcwNFQiqccoxGJeH345+tfyj0NWkbaWe0mH/bf3hP4K
         FYCAXJC7oymYSbSq1t08lIjekMOVCdhdNN6lEiKhca3/6W8brUJHSEpqEEuMUjLoYZtA
         hyak51+fzhAmDLuXNM3LFsgLSf2RtB8FqZTpu25Snb5RCHyeLuZ85bHPQJI4Vt6yJ8at
         v1wA==
X-Gm-Message-State: AOJu0YwEHl7tA+5O2PoAFiBJ8nKSkOAxy6+KF0Qgrx6Vw/P5ivWhPt8K
	lFJwDsWOf+7BwhrmPZDUlk9Mi5SOWuED/EUErZdY/jH9N7tbe8q3OIgCx2ep7w==
X-Gm-Gg: ASbGncsX04Iwkxbs8EbFBzxl0IZNeTgi6LpfGDq+zTDwIJHkpD6Zh494lu6DxRC2wrF
	8TCh2gEYh5ehxWmA1QQjvUrDK3o/NH2DE5BVSPGFxMT1iEzQMGi2E8MHO7ZRgDAFHQtGOUY3cEq
	C59prdygu767ZPaZDFCTTQMBSyebwbP60+MPwE+ivLIInlLxHnfJbC0wNwDUeJaQMFrZ74C1mSI
	nBwhyyXdkmeuuRzmwuyTPbo4S9NW/W0rzAjCgwQf3sDVqDs8GriQ3HwDcOZljAJdgmY1Oglz3Qo
	Yjw08eRzMYHyTT6aGc6nijwwXPb2diDfEOSDZOSAIzAIMWskUdo8qsBLJ0cR/iNPdg9THODFmtB
	NqYcLNO/FQx2AxIRkUjEit+MxRTpF9MjILiBwwhzGJXJUpBwqAx2X2Rze0/0l8nwHe0TGuAQvaT
	GAchqJIlzzzukC7vz0wNKtje0rRcZIgzz6jfTGJrsgH6A9Ssq1lNK07g==
X-Google-Smtp-Source: AGHT+IFCQA9TFNQHmd/VowGyj8wlwjjbuxdURnQ0Rk/jwhibSc/is6QyZTuUJ6IO4TkQsKCzsV97yQ==
X-Received: by 2002:a05:6a20:9745:b0:2f6:cabe:a7c5 with SMTP id adf61e73a8af0-334a86077fcmr13866682637.34.1760975072781;
        Mon, 20 Oct 2025 08:44:32 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b73727sm8075327a12.40.2025.10.20.08.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:44:32 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Date: Mon, 20 Oct 2025 21:13:41 +0530
Message-ID: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This work is based on a previous RFC[1] by Gao Xiang and various ideas
proposed by Dave Chinner in the RFC[1].

Currently the functionality of shrink is limited to shrinking the last
AG partially but not beyond that. This patch extends the functionality
to support shrinking beyond 1 AG. However the AGs that we will be remove
have to empty in order to prevent any loss of data.

The patch begins with the re-introduction of some of the data
structures that were removed, some code refactoring and
finally the patch that implements the multi AG shrink design.
The final patch has all the details including the definition of the
terminologies and the overall design.

fstests are in [3].

[rfc_v2] --> v3
1) Function/macro renamings:
    1.a xfs_ag_is_empty() -> xfs_perag_is_empty()
    1.b xfs_ag_is_active() -> xfs_perag_is_active()
    1.c xfs_shrinkfs_stablize_ags() -> xfs_shrinkfs_quiesce_ags()
    1.d for_each_perag_range_reverse -> for_each_agno_range_reverse

2) Modified the commit messages for patch 3/3
    2.a Modified the definition of empty AG
    2.b Slightly changed the description of some of the steps in ag
        quiesce/stablization and ag deactivation.

3) Design changes:
    3.a In function xfs_growfs_data_private() - call
        xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, delta) instead of
        manually restoring the fdblock incore counters(which were reserved
        during AG deactivation) if the AG count is reducing during shrink.
    3.b Introduced a new state XFS_OPSTATE_SHRINKING. This flag will be set
        during start of the shrink (in xfs_growfs_data_private())
        and will be cleared after the shrink process finishes/aborts.
	Now, using the function xfs_is_shrinking(), we turn off the
	following check in xfs_validate_ag_length():
        if (bp->b_pag && seqno != mp->m_sb.sb_agcount - 1)
		return __this_address;
        We do the above in the following way:
        if (!xfs_is_shrinking(mp) &&
	    bp->b_pag && seqno != mp->m_sb.sb_agcount - 1)
		return __this_address;
        Shrinking is a rare operation and hence the above logic makes
	sense.
    3.c In function  xfs_perag_deactivate() - Returning int instead of bool
        and replacing wait_event() with wait_event_killable() so that the
        shrink process can be safely killed by an user. If the wait is
        interrupted, the offlined AGs (if any) will be re-activated.

[rfc_v1] --> v2
1) Function renamings:
    1.a xfs_activate_ag() -> xfs_perag_activate()
    1.b xfs_deactivate_ag() -> xfs_perag_deactivate()
    1.c xfs_pag_populate_cached_bufs() -> xfs_buf_cache_grab_all()
    1.d xfs_buf_offline_perag_rele_cached() -> xfs_buf_cache_invalidate()
    1.e xfs_extent_busy_wait_range() -> xfs_extent_busy_wait_ags()
    1.f xfs_growfs_get_delta() -> xfs_growfs_compute_delta()

2) Fixed several coding style fixes and typos in the code and
   commit messages.

3) Introduced for_each_perag_range_reverse() macro and used in
   instead of using for loops directly.

4) Design changes:
   4.a In function xfs_ag_is_empty() - Removed the
       ASSERT(!xfs_ag_contains_log(mp, pag_agno(pag)));
   4.b In function xfs_shrinkfs_reactivate_ags() - Replaced
       if (nagcount >= oagcount) return; with ASSERT(nagcount < oagcount);
   4.c In function xfs_perag_deactivate() - Add one extra step where
       we manually reduce/reserve (pagf_freeblks + pagf_flcount) worth of
       free datablocks from the global counters. This is necessary
       in order to prevent a race where, some AGs have been temporarily
       offlined but the delayed allocator has already promised some bytes
       and later the real extent/block allocation is failing due to
       the AG(s) being offline.
   4.d In function xfs_perag_activate() - Add one extra step where
       we restore the global free block counter which we reduced in
       xfs_perag_deactivate.
   4.e In function xfs_shrinkfs_deactivate_ags() -
           1. Flushing the xfs_discard_wq after the log force/flush.
	   2. Removed the direct usage of xfs_log_quiesce(). The reason
	      is that xfs_log_quiesce() is expected to be called when the
	      caller has made sure that the log/filesystem is idle but
	      for shrink, we don't necessarily need the log/filesystem
	      to be idle.
	      However, we still need the checkpointing to take place,
	      so we are doing a xfs_sync_sb+AIL flush twice - something
	      similar that is being done in xfs_log_cover().
	      More details are in the patch.
           3. Moved the entire code of ag stabilization (after ag
	      offlining) into a separate function -
	      xfs_shrinkfs_stabilize_ags().
   4.f Fixed a bug where if the size of the new tail AG was less than
       XFS_MIN_AG_BLOCKS, then shrink was passing - the correct behavior
       is to fail with -EINVAL. Thank you Ritesh[2] for pointing this out.

5) Added RBs from Darrick in patch 1/3 and patch 2/3 (after addressing his
   comments).

[1] https://lore.kernel.org/all/20210414195240.1802221-1-hsiangkao@redhat.com/
[2] https://lore.kernel.org/all/875xfas2f6.fsf@gmail.com/
[3] https://lore.kernel.org/all/cover.1758035262.git.nirjhar.roy.lists@gmail.com/
[rfc_v1] https://lore.kernel.org/all/cover.1752746805.git.nirjhar.roy.lists@gmail.com/
[rfc_v2] https://lore.kernel.org/linux-xfs/cover.1758034274.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (3):
  xfs: Re-introduce xg_active_wq field in struct xfs_group
  xfs: Refactoring the nagcount and delta calculation
  xfs: Add support to shrink multiple empty AGs

 fs/xfs/libxfs/xfs_ag.c        | 191 ++++++++++++++++-
 fs/xfs/libxfs/xfs_ag.h        |  17 ++
 fs/xfs/libxfs/xfs_alloc.c     |  10 +-
 fs/xfs/libxfs/xfs_group.c     |   4 +-
 fs/xfs/libxfs/xfs_group.h     |   2 +
 fs/xfs/xfs_buf.c              |  78 +++++++
 fs/xfs/xfs_buf.h              |   1 +
 fs/xfs/xfs_buf_item_recover.c |  37 ++--
 fs/xfs/xfs_extent_busy.c      |  30 +++
 fs/xfs/xfs_extent_busy.h      |   2 +
 fs/xfs/xfs_fsops.c            | 379 +++++++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.h            |   3 +
 fs/xfs/xfs_trans.c            |   1 -
 13 files changed, 701 insertions(+), 54 deletions(-)

--
2.43.5

