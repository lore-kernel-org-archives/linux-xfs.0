Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90E6C25B0E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbiHQA41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbiHQA41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB727F240
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a8so11152368pjg.5
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=G3ybyjIbOOw2/O3RrkMccEkjuyDC1jmepdpBrH/4dhI=;
        b=hoSroQfYAvai6/8TdWOO0LB55hgQh9KW3HA8FLVrmve528Fdu3EIBZBkaut3OcpFMk
         gwoil983+wO3Vul60Azz9KHfeg13HTI0uUhruORp9q01xKfM4QMGG1crIRbVBvVN8zPC
         g67jFsQVhcSgD/J59DnejGxUKvOw4fS5byM8TmqmwoVNMPpEW6X4RHWdL5orBat73fA7
         H2O/Jeok0+Rw/Z6j+lUQJQqbAvqWmZZ3e5l6i141QxrAMm+KMBgmD6YW845gtHZqb5Ju
         tU2V2huhBl92/NQA88GCo2QOEzfiKWdSTIW/79O2v9m2zzRPgTNXXvVE88PjIjWQWrI0
         mk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=G3ybyjIbOOw2/O3RrkMccEkjuyDC1jmepdpBrH/4dhI=;
        b=adkO8jNmKTiR2thjInJZmRVPYXv+4yk9dmgoxT5gtmlme7gFwZawEoulZqZvCJ4kOB
         RIQUnSbJt34vjHcQpaUO3KrWaWU8NdDzfGl7aUlBf7R7ACyrMsqkiZG0IPBRajZas8K7
         4ETUiAKQenEwVn2qCPi2SaoByNZrkOJi5d2RAJxP/gquvb5Qijk10etblnRpYbe7Tt7W
         i6GwdIU3T0u0Hp3xsjJqOVHhPk7G2AuNx7hI2FSNixZ5nsYzR4DgYCz0Lc6YrLvMHcIt
         u7U4RQ+Zga7qKxucg7hXTd9MuBeICOt/dW4bIN97R1JWmqRKDlmo6klNHcHJAaQUgy2n
         c7bA==
X-Gm-Message-State: ACgBeo2saapbXIKhW/vlTFcxYvJ4hex38C0hKiOfpi/rdBgTEywwE6+C
        rQqysV1Vbg546n/T9NvATeGDnaipOwc=
X-Google-Smtp-Source: AA6agR5WtTWaHVv/qS3BukeZIskQRpmoY9Lj6myaKNeZK60UCCAOTy9xu++JTBzzx8DqdlUoyJhBoQ==
X-Received: by 2002:a17:903:40c7:b0:16e:e32d:259c with SMTP id t7-20020a17090340c700b0016ee32d259cmr24395596pld.67.1660697785884;
        Tue, 16 Aug 2022 17:56:25 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:25 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 0/9] xfs stable candidate patches for 5.15.y (part 4)
Date:   Tue, 16 Aug 2022 17:56:01 -0700
Message-Id: <20220817005610.3170067-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

No regressions were found for this set via the usual testing.

Additional targeted testing:

generic/691 for bc37e4fb5cac
generic/681 for 871b9316e7a7
generic/682 for 41667260bc84
  Ensured these regression tests failed before but not after backports

xfs/170 for f650df7171b88
  Was not able to reproduce failure before or after on my setup

- Leah

Brian Foster (2):
  xfs: flush inodegc workqueue tasks before cancel
  xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong (6):
  xfs: reserve quota for dir expansion when linking/unlinking files
  xfs: reserve quota for target dir expansion when renaming files
  xfs: remove infinite loop when reserving free block pool
  xfs: always succeed at setting the reserve pool size
  xfs: fix overfilling of reserve pool
  xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*

Eric Sandeen (1):
  xfs: revert "xfs: actually bump warning counts when we send warnings"

 fs/xfs/xfs_filestream.c  |  7 ++--
 fs/xfs/xfs_fsops.c       | 50 ++++++++++-------------
 fs/xfs/xfs_icache.c      | 22 ++--------
 fs/xfs/xfs_inode.c       | 79 ++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.c       |  2 +-
 fs/xfs/xfs_trans.c       | 86 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h       |  3 ++
 fs/xfs/xfs_trans_dquot.c |  1 -
 8 files changed, 167 insertions(+), 83 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

