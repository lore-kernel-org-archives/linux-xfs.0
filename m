Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E0FC05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjBHRwn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBHRwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:42 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B075278
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:40 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so421157pjw.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t21Mag0/M/o7lkJT8QABlP9DLkh4YWIQpTFiPVJltWA=;
        b=pIF73iEpEI5bLk68UbSG/ohLdbWjFnKGWZuf2zc8Fcy3adxygePCyo4Ji14JIyblbG
         DG6nwCm3bu97ST49RnVoNVSA5ylJ3yCVi1DxpzlFgWXKgmpnWljvrnBc2bkF6xBnkRra
         VPv9b35XWt+9nvKZxo+ckBoDi9D/8zD9HHgHFIk/kxtHnRUAC2Dmn8SdIHOgWQKzcLL/
         japIaiaSJLiezabHcvfiJFYGz+fUtckRSZJfaSI7nZPBlDs79WQRhRbKbZgYbq5CM6QF
         Z89L9OumBjWhy1gOK/mIS7paOfY+mPhdW4GGIEd7OaOASpfgygDC/OeeIMxXaNl4S9SO
         Ex5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t21Mag0/M/o7lkJT8QABlP9DLkh4YWIQpTFiPVJltWA=;
        b=50q7Kmk57v0TjaWuq2FOvV7aIoCvZG1OZmklebKwDI4fP+oo6D3VwbZ/SmdUzuH4HF
         HOctz3VFoiO/udVcCtDA4Vjuvjxa04w0PVWHaGFHIsms0SFMmiHEH1qfdH7G/yhrkXPw
         uY3rTmyz1lMuwWvd72nfD3ORzzxyieyprFBQHtB8zHNmWSD4KilaS/6qTWnF8BSxU04/
         9eJFOD88F5mPBF7nf1/1KfcxLCwP4j1UVzkun8HQom8T3R7IgEsd5rXsVPpJ5eO/7L3I
         cJwC3X+uZsFZBHixfzUECBgFCKAiWmF1XtvarxETunHWZPC7yRltVwcFl3MfwQJdS3VP
         iO/A==
X-Gm-Message-State: AO0yUKU/+/UbUInsF1uFJVYP61o2/UKPx+OdnxqdeszFOS53t08iDCio
        lUtPdNOhn7RxcNhNWYCYgfvM2b7kQC8=
X-Google-Smtp-Source: AK7set/k210hKwxtnN98Esc2at+2cU8OPojIaeGf22LyXMC3j6jC6RNGnSWNw5XMdqJLhVrFjy+t1w==
X-Received: by 2002:a17:903:182:b0:198:f289:cf86 with SMTP id z2-20020a170903018200b00198f289cf86mr10044001plg.37.1675878759277;
        Wed, 08 Feb 2023 09:52:39 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:38 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
Date:   Wed,  8 Feb 2023 09:52:18 -0800
Message-Id: <20230208175228.2226263-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello again,

Here is the next batch of backports for 5.15.y. Testing included
25 runs of auto group on 12 xfs configs. No regressions were seen.
I checked xfs/538 was run without issue as this test was mentioned
in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
unable to reproduce the issue.

Below I've outlined which series the backports came from:

series "xfs: intent whiteouts" (1):
[01/10] cb512c921639613ce03f87e62c5e93ed9fe8c84d
    xfs: zero inode fork buffer at allocation
[02/10] c230a4a85bcdbfc1a7415deec6caf04e8fca1301
    xfs: fix potential log item leak

series "xfs: fix random format verification issues" (2):
[1/4] dc04db2aa7c9307e740d6d0e173085301c173b1a
    xfs: detect self referencing btree sibling pointers
[2/4] 1eb70f54c445fcbb25817841e774adb3d912f3e8 -> already in 5.15.y
    xfs: validate inode fork size against fork format
[3/4] dd0d2f9755191690541b09e6385d0f8cd8bc9d8f
    xfs: set XFS_FEAT_NLINK correctly
[4/4] f0f5f658065a5af09126ec892e4c383540a1c77f
    xfs: validate v5 feature fields

series "xfs: small fixes for 5.19 cycle" (3):
[1/3] 5672225e8f2a872a22b0cecedba7a6644af1fb84
    xfs: avoid unnecessary runtime sibling pointer endian conversions
[2/3] 5b55cbc2d72632e874e50d2e36bce608e55aaaea
    fs: don't assert fail on perag references on teardown
[2/3] 56486f307100e8fc66efa2ebd8a71941fa10bf6f
    xfs: assert in xfs_btree_del_cursor should take into account error

series "xfs: random fixes for 5.19" (4):
[1/2] 86d40f1e49e9a909d25c35ba01bea80dbcd758cb
    xfs: purge dquots after inode walk fails during quotacheck
[2/2] a54f78def73d847cb060b18c4e4a3d1d26c9ca6d
    xfs: don't leak btree cursor when insrec fails after a split

(1) https://lore.kernel.org/all/20220503221728.185449-1-david@fromorbit.com/
(2) https://lore.kernel.org/all/20220502082018.1076561-1-david@fromorbit.com/
(3) https://lore.kernel.org/all/20220524022158.1849458-1-david@fromorbit.com/
(4) https://lore.kernel.org/all/165337056527.993079.1232300816023906959.stgit@magnolia/

Darrick J. Wong (2):
  xfs: purge dquots after inode walk fails during quotacheck
  xfs: don't leak btree cursor when insrec fails after a split

Dave Chinner (8):
  xfs: zero inode fork buffer at allocation
  xfs: fix potential log item leak
  xfs: detect self referencing btree sibling pointers
  xfs: set XFS_FEAT_NLINK correctly
  xfs: validate v5 feature fields
  xfs: avoid unnecessary runtime sibling pointer endian conversions
  xfs: don't assert fail on perag references on teardown
  xfs: assert in xfs_btree_del_cursor should take into account error

 fs/xfs/libxfs/xfs_ag.c         |   3 +-
 fs/xfs/libxfs/xfs_btree.c      | 175 +++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_inode_fork.c |  12 ++-
 fs/xfs/libxfs/xfs_sb.c         |  70 +++++++++++--
 fs/xfs/xfs_bmap_item.c         |   2 +
 fs/xfs/xfs_icreate_item.c      |   1 +
 fs/xfs/xfs_qm.c                |   9 +-
 fs/xfs/xfs_refcount_item.c     |   2 +
 fs/xfs/xfs_rmap_item.c         |   2 +
 9 files changed, 221 insertions(+), 55 deletions(-)

-- 
2.39.1.519.gcb327c4b5f-goog

