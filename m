Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F4FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211A4229C7
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbhARIi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 03:38:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387851AbhARIi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 03:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610959051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XiloATaYbpCajaLQqF1MtOHDfTmGddB2aqqrXnEViD8=;
        b=CBtEdpK3XQ/RHPfEQtvc+GIu6MI8vOetVVrgdjHrO6QvyFe0MsMaw1FEXnN9tXD+GdwkTw
        DnXV05uiqOLFYfeJJPSKg3xPgpm7d3pbZtjYjhg0sOnBim/h585d5ko7GsGMNEIygLCDJp
        2qzw2TVnamj3sbXV9Jy8n8SoLKfL3ec=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-KtoXehknOOCnQ0Zsjb8GOg-1; Mon, 18 Jan 2021 03:37:29 -0500
X-MC-Unique: KtoXehknOOCnQ0Zsjb8GOg-1
Received: by mail-pl1-f200.google.com with SMTP id m9so10930122plt.5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 00:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XiloATaYbpCajaLQqF1MtOHDfTmGddB2aqqrXnEViD8=;
        b=a2ZgG9Kq9hlNPQk5I2u7QSjeFctys0ZARge/YMIW1bmIldUYw8mrdLKzy+eAyHeamx
         mfwmNQ3iTv9zCcHvSCyMzpj97px920kPXu79lLgWof2c0OC+1BHTFHbtpVE44qXXLLyA
         KXnfE4Y1gWU6Z/u5HMJFxw6vcima9cRiMvTRs8DFVqzFamlVT2xXXTcexiNMZghUFZi4
         1MKmQUI9AmGMGU8leLwo42AePqjBozs1wwDCG1Ri6//dfF73XVRSrJ7F1lvHVTcZk5nu
         aWCOA/G0gFGFL61N2rr5pqhDVhGUw1unxjqLu0d/Id//cOzWKQKpt7MMEl5kt6ayliMk
         kGGg==
X-Gm-Message-State: AOAM5313WZrO7T7wA1x5ycstX0ApOIytaq1+RGx1WOPptpEof0+wBiV4
        IS4oByaYMvt+zZ+G4jD1++4l/Qk4nTdSloMHMuvOhQE8XqlFAsy3blrJB0/shMxR5yQQEM003Wo
        oBNjdE76twnnyhgfhkar7nkK7kLC92Mj9tdsL9oAqbUgEf2hMCIs2Lbc/jws3Oz2a8h4gv2O3gg
        ==
X-Received: by 2002:a17:90a:d58c:: with SMTP id v12mr25621688pju.37.1610959048561;
        Mon, 18 Jan 2021 00:37:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzC6oITeuwll1OqDi4QhL2bCUxRgehm04et3QmDyv8BC17u/GHtxZ8qTys+494tqpIY6Eb8oA==
X-Received: by 2002:a17:90a:d58c:: with SMTP id v12mr25621665pju.37.1610959048245;
        Mon, 18 Jan 2021 00:37:28 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm16293916pjs.0.2021.01.18.00.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:37:27 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 0/5] xfs: support shrinking free space in the last AG
Date:   Mon, 18 Jan 2021 16:36:55 +0800
Message-Id: <20210118083700.2384277-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

v4: https://lore.kernel.org/r/20210111132243.1180013-1-hsiangkao@redhat.com

This patchset attempts to support shrinking free space in the last AG.
This version mainly updates the per-ag reservation fail case mentioned
by Darrick, also add error injection point to observe such path...
If I'm still missing something (e.g. not sure of the log reservation
calculation due to another free extent dfop) or something goes wrong,
please kindly point out...

xfsprogs: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
xfstests: https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

Changes since v4:
 - [3/5] update a missing typedef case and move the comment to the top
         of the whole function (Christoph);
 - [4/5] put onstack structs at the top of the declaration list;
         handling the per-ag reservation fail case;
         do agf->agf_length, agi->agi_length sanity check;
         leave a comment in the error handing path above
         xfs_trans_commit() (Darrick);
 - [5/5] add an error injection path to observe the per-ag reservation
         fail path (Darrick).

Thanks,
Gao Xiang

Gao Xiang (5):
  xfs: rename `new' to `delta' in xfs_growfs_data_private()
  xfs: get rid of xfs_growfs_{data,log}_t
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: support shrinking unused space in the last AG
  xfs: add error injection for per-AG resv failure when shrinkfs

 fs/xfs/libxfs/xfs_ag.c       |  93 +++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h       |   2 +
 fs/xfs/libxfs/xfs_errortag.h |   2 +
 fs/xfs/xfs_error.c           |   2 +
 fs/xfs/xfs_fsops.c           | 167 ++++++++++++++++++++++-------------
 fs/xfs/xfs_fsops.h           |   4 +-
 fs/xfs/xfs_ioctl.c           |   4 +-
 fs/xfs/xfs_trans.c           |   1 -
 8 files changed, 211 insertions(+), 64 deletions(-)

-- 
2.27.0

