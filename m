Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE74C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 11:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiEYLRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 07:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiEYLRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 07:17:38 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB89BF57;
        Wed, 25 May 2022 04:17:34 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i82-20020a1c3b55000000b003974edd7c56so562791wma.2;
        Wed, 25 May 2022 04:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uuHHwNINyMSOCqXVj12EP1KOoOXQxeSy9GpwK1fGgXE=;
        b=Ka+2K4At7mgaxormi55291lX0xC6u50+hPpUJs+cjmidlMmbsm2+E95eFUj4I94F4f
         cDHGDP4UAplwj5UaUVJ9gKe9t2ngorYNXv57QitOpecRgA0bvR0XpjgVVVRH8ks0EUFQ
         cEZ8S5L8q3NIR6yWEf88leSWROmm3jdp/4SGkFDrwZK04cQ5Hf5m2Cxguqu8y9WdE/z6
         B9WTtpCcR6lgQI7+9SKoIqilHWsgWadobG9X501l1d00aO6Hxz610AF0qs4wDo8xYsHp
         oORZ8G7psJTVISRxXJRblV0RqmWTQUBGJV//fPa/kHLA9d9/AgrGDeia4/QjPK2m+1Pz
         Zpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uuHHwNINyMSOCqXVj12EP1KOoOXQxeSy9GpwK1fGgXE=;
        b=XTrR2unJUknmsxReDIp/VEwHV3DOLNOpsDKMgkJO7cQ0TULoDjAsjYbw3u+G2b+gb+
         TxxypaQk2q3YlZOoo1fhnC/9YJ6LWyAbtCKWhIoTVWc3VE1cCzDXezQK7cjCYuRAYpBN
         n6tYJW1sNhilnzaPy5w7DVwHVVESD0fGtjRhZ4bco3wYHAdoLTQtk/mE32X5JMI/vGEy
         GK4mfp26H1d1ktK7SjLESCQtjcZduND+ujIG/WU578kFKqhS36fl9qEJRoqFHmfZ6b6w
         t+Crgg5fruNJPEIaFE3GSFl3do1sgfMDiX8tU3py8E7XIdCxUsTs6OA2iZu+yUsLrzux
         dyXA==
X-Gm-Message-State: AOAM533W8mm1q/H9aPiGdkLR7FTMSxSMvHotJkNjqLb3S0QLsJ+UI7FB
        xMzXRxOI/kN4/RPPnwdDNJE=
X-Google-Smtp-Source: ABdhPJzHh38BQxustqLmiwAz9l96x8v2g+3o0fRoVXLq3w3iUgnSH9I8Bmfyf/gvRk/FO4tAFGvRwQ==
X-Received: by 2002:a05:600c:6015:b0:397:54e1:8279 with SMTP id az21-20020a05600c601500b0039754e18279mr7496806wmb.100.1653477453025;
        Wed, 25 May 2022 04:17:33 -0700 (PDT)
Received: from localhost.localdomain ([5.29.19.200])
        by smtp.gmail.com with ESMTPSA id e12-20020a056000178c00b0020c5253d8besm2059904wrg.10.2022.05.25.04.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:17:32 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Date:   Wed, 25 May 2022 14:17:11 +0300
Message-Id: <20220525111715.2769700-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all!

During LSFMM 2022, I have had an opportunity to speak with developers
from several different companies that showed interest in collaborating
on the effort of improving the state of xfs code in LTS kernels.

I would like to kick-off this effort for the 5.10 LTS kernel, in the
hope that others will join me in the future to produce a better common
baseline for everyone to build on.

This is the first of 6 series of stable patch candidates that
I collected from xfs releases v5.11..v5.18 [1].

My intention is to post the parts for review on the xfs list on
a ~weekly basis and forward them to stable only after xfs developers
have had the chance to review the selection.

I used a gadget that I developed "b4 rn" that produces high level
"release notes" with references to the posted patch series and also
looks for mentions of fstest names in the discussions on lore.
I then used an elimination process to select the stable tree candidate
patches. The selection process is documented in the git log of [1].

After I had candidates, Luis has helped me to set up a kdevops testing
environment on a server that Samsung has contributed to the effort.
Luis and I have spent a considerable amount of time to establish the
expunge lists that produce stable baseline results for v5.10.y [2].
Eventually, we ran the auto group test over 100 times to sanitize the
baseline, on the following configurations:
reflink_normapbt (default), reflink, reflink_1024, nocrc, nocrc_512.

The patches in this part are from circa v5.11 release.
They have been through 36 auto group runs with the configs listed above
and no regressions from baseline were observed.

At least two of the fixes have regression tests in fstests that were used
to verify the fix. I also annotated [3] the fix commits in the tests.

I would like to thank Luis for his huge part in this still ongoing effort
and I would like to thank Samsung for contributing the hardware resources
to drive this effort.

Your inputs on the selection in this part and in upcoming parts [1]
are most welcome!

Thanks,
Amir.

[1] https://github.com/amir73il/b4/blob/xfs-5.10.y/xfs-5.10..5.17-fixes.rst
[2] https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.10.105/xfs/unassigned
[3] https://lore.kernel.org/fstests/20220520143249.2103631-1-amir73il@gmail.com/

Darrick J. Wong (3):
  xfs: detect overflows in bmbt records
  xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
  xfs: fix an ABBA deadlock in xfs_rename

Kaixu Xia (1):
  xfs: show the proper user quota options

 fs/xfs/libxfs/xfs_bmap.c    |  5 +++++
 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 fs/xfs/xfs_iwalk.c          |  2 +-
 fs/xfs/xfs_super.c          | 10 +++++----
 6 files changed, 38 insertions(+), 25 deletions(-)

-- 
2.25.1

