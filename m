Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48FBC32789
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiHVQ2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiHVQ2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:15 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1C440E37;
        Mon, 22 Aug 2022 09:28:11 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so6310484wms.5;
        Mon, 22 Aug 2022 09:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=e8nHPhI14ODkMKZrPnCTg/UWERm5T7Rqw2ZAHl2G/As=;
        b=k77NLUfIOhDgZFAZOypP3GJsr98Re6jYcm+DySQWcXRISvHXLQT8QDJjh+fDErybZA
         t4Rfe9dWDNaygkY8QAvU4w3P1NA5UxC4HByEens0ohLH5jkgG72/edC8Qd5Z+7h6bTnf
         n8lV55sI3mErVJYTGrEAsRiH92GrdFkmVCnM2IHmRuxpxTNyl6EjMEPaxk6zHGluv42n
         fq3cb/ZAglrJ385/m2j5GSLxfqtaoPamn4E4sEo+6y8aRpxiD/Q5apCdvihUKeLibkev
         MKn7g9mO44rGP5COvUUDrJk91sqgyVp88IuZrtDa1AbvXkwW/GvjJ+/XudmG2jBHFtkm
         mmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=e8nHPhI14ODkMKZrPnCTg/UWERm5T7Rqw2ZAHl2G/As=;
        b=BPeLz60sm03AZAUiUxmddTZDLBbJNswrU2XMqFAK+ZSK8vLouxNxA4bHcGaLxJwcfk
         SHMQBXwUtU7OVHimKuDieUpnF0sMTFscY/7NkMjGQMlhQk0Pg2JwS+4ofhx99IotBjjt
         VqJ2pAQeau3ZA/tjdkYAZrxfDSdfenyZkIefb4vSaN4cbuvogWXY96vp/5FnhR8OBVyr
         f40nLbonah96dXgVvXqIRVADCVKb0Q4fDcTQVlecUJw+rdQlURnqWHh6Xoas8vGYnsH6
         SLS9ugo1ntGFT0CG34NlP7gpHmBMKZn6KOV/wG7uJ8csESVyzM4oiXbQCJIvtq1PSAJk
         uFPQ==
X-Gm-Message-State: ACgBeo0RlV2KeCakAVsKRhItnf8vi5Hsol2f8Y/RSn0xxszW8pK/5/OY
        g72lQfjrYer4KnQqyHbNV2U=
X-Google-Smtp-Source: AA6agR6OKbXaqpOpY7cUiMGHQ+Zu9v43TCwaAuWme7K+7fpggrQ8F4FfCE5ahe9JWPmmbaRYEsSr8w==
X-Received: by 2002:a05:600c:5010:b0:3a6:804:5b08 with SMTP id n16-20020a05600c501000b003a608045b08mr15482001wmr.10.1661185689860;
        Mon, 22 Aug 2022 09:28:09 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/7] xfs stable candidate patches for 5.10.y (from v5.17)
Date:   Mon, 22 Aug 2022 19:27:56 +0300
Message-Id: <20220822162802.1661512-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This is my collection of backports from v5.17.

Patch 1 is a small fix picked from Leah's part 3 series for 5.15.y [1].

Patch 2 is a small fix picked from Leah's part 4 series [2].
I have some more fixes queued from part 4, but they are not from v5.17,
so will be posted in another series for v5.18/v5.19 fixes.

Patches 3-6 are debt from the joint 5.10.y/5.15.y series [3].
Per your request in the review of that series, I collected all
the sync_fs patches and verified that they fix test xfs/546.

These patches have been spinning on kdevops for several days with
no regressions observed.

Please ACK.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220721213610.2794134-1-leah.rumancik@gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220819181431.4113819-1-leah.rumancik@gmail.com/
[3] https://lore.kernel.org/linux-xfs/CAOQ4uxjrLUjStjDGOV2-0SK6ur07KZ8hAzb6JP+Dsm8=0iEbSA@mail.gmail.com/

Christoph Hellwig (1):
  fs: remove __sync_filesystem

Dan Carpenter (1):
  xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Darrick J. Wong (4):
  xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
  vfs: make sync_filesystem return errors from ->sync_fs
  xfs: return errors in xfs_fs_sync_fs
  xfs: only bother with sync_filesystem during readonly remount

 fs/sync.c          | 48 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_ioctl.c |  4 ++--
 fs/xfs/xfs_ioctl.h |  5 +++--
 fs/xfs/xfs_super.c | 13 ++++++++++---
 4 files changed, 40 insertions(+), 30 deletions(-)

-- 
2.25.1

