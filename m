Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3BD32F77B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035111; cv=none; b=qvjgKwejpmV1ih5V9G9EUTWxj8nigjZPWjOnDZoHiRffGI7kY4qM21R1pwJUVh2MSobi0Bkh+PNROFmRrMf1dKwnqHXPsTWjxnBz8nGgOhdOcZ0qgBTTlWwsK1DctF2++/WegAx/TUYfhewIyPfCA7eRiIEggNSlOY4xl5rSa/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035111; c=relaxed/simple;
	bh=5hgwYPJocCl9HYaKDdyFROLy9PiIEQBDX831rz3bhjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MKqg1v1lt/BW3Xi+f63nPvJ8Fg1cUY2svhO/Y7cEVk3NpLp6Eghz+hMfD0DFejwazRuCvWpdoxZPDrPQRGuyQT+SP0Ctq1aNqzp8uLy8SB+yPP7e8d5OjBpRCqUPFM+dlXukS/A4PVqUuUDYdfXtjrrNVdCAL9q6fJr5y1YFEjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KpL31hQK; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpL31hQK"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so4842557b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758035109; x=1758639909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQn8HexdeeEtSLrJVGgSLV/IkF8TMZ+tKFVciUgJc50=;
        b=KpL31hQK7R2ZRM+CgU2ok61SaB1rSzc0EQqhbiC62V4Z0ugn3qK3lwLqajiYai9K6v
         hGk77W8Sr8aJ5NAY48F5UZMpa6kW7PCJzSCx4talyMy8Ogu1qghuPXePaDhcvUxNgG/+
         a7oeIUfqvwqsX7yFD6U2sW6MMczFTkqllsuP+/+QuwzzJVwFcvKZj8110s4n1Ob+hA++
         XvTeh9SjPqm9z0Ogt0QkiaZDv3uWlL08jJn7mfd7p55Waqpa/SKdxCcmqiVoTblx0ixe
         js3u8MgT76DlTCe6f+oAMiyfn9298f94st0bWwTvAZlZza3Koa0mpp9anJFfJdXhBq02
         ltlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758035109; x=1758639909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQn8HexdeeEtSLrJVGgSLV/IkF8TMZ+tKFVciUgJc50=;
        b=rgwyD7hIgT8wLvOKeb+1nlkMaL2tHd1hg264vG9YZa0ZgmNvM32YrwWOlxpgCDcKun
         nEPgEkzat5XwewJfGaSv5xu2d1bwf5cROFnRb0OiJ04HXsT2mmU+qVHGyLIb+yJJuL7M
         AL8/1pDRFA2caIHv8V1yzIAY8E+xaPX5nxp83HMSEN0tLEWRPWlWoDELgrQc3oa/IA8G
         kjjDSah/1SbWLKRVUfxUUpVH0Gn3eWthTOHiXwmeXEqsybhPnv4uo9LO72DOKT/Fdqqc
         IGXtFyuLMSwNY0wZuRCSXvK/3DufknLMcEcNZecNRwy/FMzGoalX95UNm8EsnjxIA59E
         pOUA==
X-Gm-Message-State: AOJu0YwEl3u4uTDXsCMF+FPdrlZdoVIfKbG7JYkrbJJdW2GrAJ9mvhNc
	tZ2cFDxycPq2fjttO6DGigfZn67zmqXyinB+k7f8bi5+HA6ScxnyZgZk1AxfAw==
X-Gm-Gg: ASbGncud2/2wu6Dyva0U6+6tSyAW7q0qBFXpv/ndhwBIt2t6/cv6nBxXz+a+oyS4Q2U
	VUwK/mLEwsmyb2EPIk9kk8uYLC+dgG1EuKMk7FGiCYt2o3v+Vshx0gWlFBk2d7M0Ziggymvq3vz
	HvEmi/3wU9dryB4Ffu3LPQ9VLG/B7JqWmT+v8OvrThICqCPlvbaPSN/4XWdoo4q/TDtuVYhN0ik
	ko+O1EPPb0tQEQx5HMHRJBgQANlZMbLevoVl6TwmF8FQXc6dhDLcm0i0RiLk84vlCGhr9+u2XFC
	1UNVWzndaOcZqJJveK+olzaQKbjhrZ3k1W2vieJocovSE9ku5R36FYgSzt5y1nnh+ipmp95xOci
	RTtp/MW+FCQP2D8t2Z1Gw8+Wgb5mMWgzJHmzVaarRV3LP7FaH0EyRcg3UoZOKXVqzfoX89XI7v0
	dK
X-Google-Smtp-Source: AGHT+IFQI4hFVBwFxl3LF/y5Uehugng87Asy0d9MO3dkBe7HtGiP+pgQVpVjFdjDI5EF4ciUUIxlPg==
X-Received: by 2002:a17:903:1ac8:b0:246:c816:a77c with SMTP id d9443c01a7336-25d243f023amr174543765ad.8.1758035108535;
        Tue, 16 Sep 2025 08:05:08 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.211.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26263a76cd4sm94737175ad.31.2025.09.16.08.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:05:07 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V2 0/3] Add support to shrink multiple empty AGs
Date: Tue, 16 Sep 2025 20:34:06 +0530
Message-ID: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
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

We will have the tests soon.

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
[rfc_v1] https://lore.kernel.org/all/cover.1752746805.git.nirjhar.roy.lists@gmail.com/

Nirjhar Roy (IBM) (3):
  xfs: Re-introduce xg_active_wq field in struct xfs_group
  xfs: Refactoring the nagcount and delta calculation
  xfs: Add support to shrink multiple empty AGs

 fs/xfs/libxfs/xfs_ag.c        | 193 +++++++++++++++++-
 fs/xfs/libxfs/xfs_ag.h        |  17 ++
 fs/xfs/libxfs/xfs_alloc.c     |   9 +-
 fs/xfs/libxfs/xfs_group.c     |   4 +-
 fs/xfs/libxfs/xfs_group.h     |   2 +
 fs/xfs/xfs_buf.c              |  78 ++++++++
 fs/xfs/xfs_buf.h              |   1 +
 fs/xfs/xfs_buf_item_recover.c |  37 ++--
 fs/xfs/xfs_extent_busy.c      |  30 +++
 fs/xfs/xfs_extent_busy.h      |   2 +
 fs/xfs/xfs_fsops.c            | 358 +++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans.c            |   1 -
 12 files changed, 678 insertions(+), 54 deletions(-)

--
2.43.5

