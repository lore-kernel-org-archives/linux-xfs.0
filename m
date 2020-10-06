Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5106C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 19:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7EA206F4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 19:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bd0jEn2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgJFTPs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 15:15:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbgJFTPr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 15:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602011747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nreLv5OTgGPdulTJHi5a2IWQ7ukW91dYM5moEnhMiio=;
        b=Bd0jEn2knCDP9TJ36RaIwbvcAQl2svUkDlRO5oKGAp4UKbEvXvOO8ZzchMoMzpDIWuviFJ
        +xCE5+hx4BKuv1osE462bfZ9CjbomNCSys6L8gPi4YgvHREM87r+JKuJOA8S9mhzIQJ1F9
        WTJzKwsAorDyr8WwaetQHgPwaVHYypo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-M7O-72cbM5Ou1FB2qSIPWw-1; Tue, 06 Oct 2020 15:15:45 -0400
X-MC-Unique: M7O-72cbM5Ou1FB2qSIPWw-1
Received: by mail-wr1-f72.google.com with SMTP id 47so3448617wrc.19
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 12:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nreLv5OTgGPdulTJHi5a2IWQ7ukW91dYM5moEnhMiio=;
        b=AIqkycv1cZwNuHVNq5XmJexoIOYNHqllkQw01k8ckHT3NDhfW2kdrMXp/Cad9FCci4
         A73sJV9Te9lFk3Eu0mqQoiUPQ/lVitb2/1OjsW/MqJR+vepoCpBeB+7GvRs5tLxOhr5j
         09zgxxE22qSbY45J+g9WetEbxZvuUxsXHyIirc9dmX4mG/hgTyBu1JnpjOszGDp8jZYr
         er972Lo4L0XRDwMOvg9ueIYM13eQLA8uz6AC7gR2jR8R/QQ6VZvufBwlCapVrMZEuNjp
         oCkYzjHbPqhhXMOtr6UHW6bqCXThWEOEAw5HnY7yWy7EZD5DfKVI2bK73snIkASZb5FX
         NrZg==
X-Gm-Message-State: AOAM533+cMCY7GXxEkBbqGN1u/MeI1T6QYq2oUV6kX/fW23B7RoG49dX
        Xw+53Nv1GpuxHhsM5jnBjgUzW6FZEQGR9QKrwo7zT4kg42/1q2KazXEkJf68hgyKHCAMW8r6kmj
        e3pLNXnlcizvVEXHA0ouV
X-Received: by 2002:a1c:6a0a:: with SMTP id f10mr6456838wmc.86.1602011743824;
        Tue, 06 Oct 2020 12:15:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrW4+CM5cSejCu/TE1V2nR6txJFhImMeKqOmU3+tusDIzBhbcFpE1/AiSRX08PBEhgA231ag==
X-Received: by 2002:a1c:6a0a:: with SMTP id f10mr6456817wmc.86.1602011743568;
        Tue, 06 Oct 2020 12:15:43 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v17sm5317074wrc.23.2020.10.06.12.15.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 12:15:42 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 0/4] xfs: Remove wrappers for some semaphores
Date:   Tue,  6 Oct 2020 21:15:37 +0200
Message-Id: <20201006191541.115364-1-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove some wrappers that we have in XFS around the read-write semaphore
locks.

The goal of this cleanup is to remove mrlock_t structure and its mr*()
wrapper functions and replace it with native rw_semaphore type and its
native calls.

Changes in version 8:
* Patchset was rebased so it applies cleanly.
* The patch 'xfs: replace mrlock_t with rw_semaphores' contains change in
xfs_btree.c which transfers ownership of lock so lockdep won't assert
(This was reported by Darrick and proposed change fixes this issue).

Changes in version 9:
*Fixed white space in patch 'xfs: Refactor xfs_isilocked()'
*Updated code comments as suggested by djwong (thanks!) in patch: 'xfs: replace mrlock_t with rw_semaphores'

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c  |   8 +--
 fs/xfs/libxfs/xfs_btree.c |  14 ++++++
 fs/xfs/mrlock.h           |  78 -----------------------------
 fs/xfs/xfs_file.c         |   3 +-
 fs/xfs/xfs_inode.c        | 102 +++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h        |  25 ++++++----
 fs/xfs/xfs_iops.c         |   4 +-
 fs/xfs/xfs_linux.h        |   2 +-
 fs/xfs/xfs_qm.c           |   2 +-
 fs/xfs/xfs_super.c        |   6 +--
 10 files changed, 111 insertions(+), 133 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.26.2

