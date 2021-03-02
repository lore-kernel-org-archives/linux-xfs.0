Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07A4C28E86
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952D964DE4
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245713AbhCBGjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:39:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242574AbhCBCy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 21:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614653580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B8jzMEbuN1OPhRSTE9ecggwOYOH+0mj7cuae+E0KEsg=;
        b=cB/vi4Nfo6mlgAMx2ba3BZy/FSbAUROeRvP5LRIPxKt2zufaZxcy3OzJrL4YDNEWN9wAI/
        ub3ispXNq4YKefKlF2d31thahdvCp9mbGZp4iCINp81VTUb85IWuR8VTRubmY9LHDxcSb/
        Lqx3IUJC52SutrNp7OE4oYXt8m2iLls=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-uhDqKQZhPSOHkWlcMNO6AA-1; Mon, 01 Mar 2021 21:49:04 -0500
X-MC-Unique: uhDqKQZhPSOHkWlcMNO6AA-1
Received: by mail-pj1-f72.google.com with SMTP id s3so869821pjn.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 18:49:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B8jzMEbuN1OPhRSTE9ecggwOYOH+0mj7cuae+E0KEsg=;
        b=gH1cDdB5pTMostE9Vg1kbEvxsto/G24xsRtpPo2qH0FSIkxGa9aep6K3Rak9HtBqKO
         FitE2KTIbuYFe0Puh3JhCxEr5cJHpw67gA4g4E5tUV7vRvwdT77iUWFvJURl1dZ+fUhp
         l/tgFusMBow7LJg79BA8N7oq5irtX5NIi5NYd+XqzqhQK4vzMhAO9G94lYbbblyM0CUO
         QJTHGN97AUGNSLejITDGnl/6XqrUNdrvuH6njhrO0ah8Rg/9ewEkm5fq1OE4k1ig0zq1
         wqO/rrv2CeB61YcMI+Lp9UYQzUrxQiVBvbXRcOcG/1Sg1obYd6cy0ntCv0FOagnkpyzl
         yjCA==
X-Gm-Message-State: AOAM531SLIUHXmgIKUngeCjm8GN+zqEYY8Lwi1dsC4GDbuBft9to7g00
        aOYGgFWkz4ZCxVXA1tKWcjWtJ8wuIsiVPvoRjMdWs9PeE4cgFTPOdTyPaZdLt+UJdll9uG2eRd7
        7QyHoFAZMILhQoVnZEOUU+SZWTWBj0HL4y4CalZspRIVgEdMDr2tgEoV4ZotHFmXuPEnLGKSOAQ
        ==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr16423900pgp.68.1614653343403;
        Mon, 01 Mar 2021 18:49:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxF2uOfTMfcbkdMVPy1UWBEXLWitAiZBaF6XSqVE8uUa/t8dyPHQUIDln9/Ph0mieGvVowkxA==
X-Received: by 2002:a65:50c8:: with SMTP id s8mr16423886pgp.68.1614653343128;
        Mon, 01 Mar 2021 18:49:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d24sm18451031pfr.139.2021.03.01.18.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:49:02 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v7 0/5] xfs: support shrinking free space in the last AG
Date:   Tue,  2 Mar 2021 10:48:11 +0800
Message-Id: <20210302024816.2525095-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

v6: https://lore.kernel.org/linux-xfs/20210126125621.3846735-1-hsiangkao@redhat.com/

This patchset attempts to support shrinking free space in the last AG.
This version mainly addresses previous review of v6. hope I don't miss
any previous comments. Details in the changelog.

gitweb:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/ tags/xfs/shrink_lastag_v7

changes since v6:
 - rebase on the latest for-next;
 - [1/5] refine the comment (Brian);
 - [2/5] keep `delta' constant as nb - mp->m_sb.sb_dblocks, avoid
         `extent' boolean but introduce `lastag_resetagres' for growfs
         per-AG reservation judgement (Brian, Darrick);
 - [3/5] pass in agno directly for xfs_ag_shrink_space() (Brian);
 - [4/5] fix growfs 1 agcount case (Brian);
 - [4/5] refine xfs_fs_reserve_ag_blocks() in the end only for growfs
         due to mp->m_finobt_nores == false (Brian);
 - [5/5] broadened error tag (Brian, although I think xfs_mod_fdblocks
         shouldn't be triggered then.)

Thanks for the time!

Thanks,
Gao Xiang

xfsprogs: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
xfstests: https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

Gao Xiang (5):
  xfs: update lazy sb counters immediately for resizefs
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: introduce xfs_ag_shrink_space()
  xfs: support shrinking unused space in the last AG
  xfs: add error injection for per-AG resv failure

 fs/xfs/libxfs/xfs_ag.c       | 108 +++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h       |   2 +
 fs/xfs/libxfs/xfs_ag_resv.c  |   6 +-
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   2 +
 fs/xfs/xfs_fsops.c           | 195 ++++++++++++++++++++++-------------
 fs/xfs/xfs_trans.c           |   1 -
 7 files changed, 242 insertions(+), 76 deletions(-)

-- 
2.27.0

