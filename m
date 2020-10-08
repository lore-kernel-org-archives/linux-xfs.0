Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA08C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB3520782
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UG0+u4JF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgJHNqM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 09:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730361AbgJHNqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 09:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602164771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+oz8yC6XAkSZi5rPXraOFXHTFfDgzi0mPy32WS2Lzss=;
        b=UG0+u4JF5g5+8fVm6ZcNOMgYxhFuCO2tuuXVx86KL3Ov3GGaToNc8QjASBaTuGjAt/ULRT
        6I9r/GKG17qL6jWCCVAemDFxwlsR6WeVE/i7bRSWxqwK2BggbzC4bgFR3BsS4G3Q08Ydxo
        9q5DSFWlLTIKqToSftyufUFzIqRUhnk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-0WOgmKZTMXWB3hWvFG0Zfw-1; Thu, 08 Oct 2020 09:46:09 -0400
X-MC-Unique: 0WOgmKZTMXWB3hWvFG0Zfw-1
Received: by mail-wr1-f70.google.com with SMTP id l15so3918875wro.10
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 06:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+oz8yC6XAkSZi5rPXraOFXHTFfDgzi0mPy32WS2Lzss=;
        b=mmrciXdRpg6k+qIhro0KEo6G4WsRgNbTyeCr6N1fS6499SoXIHr0kGkBXS01ZR/06G
         0vbvdm7/f6PgWVCKPN1liUdO/3/Y+0a1KkFG8X3v6oF0wRJVBdd7LlsdiNPILSBzAyDV
         Xz6vQ6YSQRAbSqU86AFY068IndO1dE6xKOy/W+xz4YvFBFmjegs4b9IWPyFeb8R1gFYh
         LEicebkTP8I7d54xF+2aqhpM0Zf/cTkWy159r3ovV41L3834/3ikwEvVPJt2Nxl4qO8l
         I6Hqk55Gq42l2ykRS6bRJQ9OCzfProFcvvNKALgUMQkQDihnEFtS2m+yZpGiQDaGWIWf
         BF7g==
X-Gm-Message-State: AOAM5318+2Fs+uRu7HNUS7OoVrfT0UjfJoEZ6US70ukYfQLzK/HWPf1A
        UiLAZWrEQ/xXYaOncNyHE/vADF6e6yAnSYYCcCV07BT+EHgRGjGsmExsmiqPLblxG0wmmWtyqR5
        HCGvemybUYhBmN3ykoI47
X-Received: by 2002:adf:f50d:: with SMTP id q13mr9218135wro.215.1602164767865;
        Thu, 08 Oct 2020 06:46:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYC5ksA5k26lTH5KHfd7rcbOvZqqky8AFAr3NqSDgFxzTC8WGlUW0j7jhNSUn3JZhjzqNu4Q==
X-Received: by 2002:adf:f50d:: with SMTP id q13mr9218122wro.215.1602164767687;
        Thu, 08 Oct 2020 06:46:07 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id s19sm7069465wmc.41.2020.10.08.06.46.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:46:07 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 0/4] xfs: Remove wrappers for some semaphores
Date:   Thu,  8 Oct 2020 15:46:01 +0200
Message-Id: <20201008134605.863269-1-preichl@redhat.com>
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

Changes in version 10:
* Fixed use-after-free in 'xfs: replace mrlock_t with rw_semaphores' (thanks Darrick)
* Moved part of refactor of xfs_isilocked() from patch 'xfs: Refactor xfs_isilocked()' to patch 'xfs: replace mrlock_t with rw_semaphores' - to fix compilation error
* Typo in comment in 'xfs: replace mrlock_t with rw_semaphores'

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c  |   8 +--
 fs/xfs/libxfs/xfs_btree.c |  24 +++++++++
 fs/xfs/mrlock.h           |  78 -----------------------------
 fs/xfs/xfs_file.c         |   3 +-
 fs/xfs/xfs_inode.c        | 102 +++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h        |  25 ++++++----
 fs/xfs/xfs_iops.c         |   4 +-
 fs/xfs/xfs_linux.h        |   2 +-
 fs/xfs/xfs_qm.c           |   2 +-
 fs/xfs/xfs_super.c        |   6 +--
 10 files changed, 121 insertions(+), 133 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.26.2

