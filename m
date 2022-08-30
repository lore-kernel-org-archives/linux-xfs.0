Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A947ECAAD5
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 04:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiH3Eoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 00:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiH3Eox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 00:44:53 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A58BC90;
        Mon, 29 Aug 2022 21:44:50 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id y18so7737882qtv.5;
        Mon, 29 Aug 2022 21:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=dOEv9hIXfiaMqY+tsrgaoJMgV7rSwIMk/A0LInKQids=;
        b=aMTlogrLeuE307snE9fCaoqIyDT5VJFy0c56T055vyphoKHTUQ/I/AtkS3ei25K2p9
         ZolnZ0sy5b32RxLEwCdUti6d21yA+ecNhBtzHibv7lu/+hnre+K9H4JKP6N7/RN7BibI
         hQIQweoEeWMzYKjLSX/n06RlrcXYtnM9iRJQVpgT9Ls2msqIuejMwNHBgP3RWSqHm6rM
         Ahdl6HaDjoYnBpoI3LkwFoTF7Z8Kk9sA/I7M8/zVb9lUw2D7YDfqdpSz1KWWjar4JoI5
         xauh0mCv94RNN0Cv58WF5dlX12oGkeUg2hgpWUUg/nikMzk/bU7gkd1iXHvolyiKLTXT
         77jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=dOEv9hIXfiaMqY+tsrgaoJMgV7rSwIMk/A0LInKQids=;
        b=jEi9/oRfM0YRPLDu3dN2aSt9AYTDiRaplFhzfJaAIyp3fTYu2irDn+Lq0CRelW72ZN
         ryFQaT++8NUIxCAKdh+CJuKXx9uIiX237pJIXa5dGS55zYA0LlGso8Vt/dU/51OpeBQa
         p076iCXLceZqLjsFCk0Br/hccc30cPHkNASn/cSkPpCo8364DvmHsUfGw2jXfQdjWgiE
         KNj8vWf/fgLEu8RQVMvyDcwjOA5ifrupwY7soLlxaEO8V8OOAVqG6ZZwEly8Xuvm1cPq
         A/XOhHv0GxYofiiHj+R6u/etDfsNwHAExyqhpzsVMzmiU0oVR6L+rqhvU7+MiMzk5xHt
         Ak+w==
X-Gm-Message-State: ACgBeo1C2QiyesCumFXrJN1YKDe8yWmXts1hnnxIZh5bqv5LfKcFOe1j
        bLRSyUu1ZGkjMS+DHqQoLQfUtWT03Cw=
X-Google-Smtp-Source: AA6agR78dJ/+ByMv/VbBUoqN1F27s+WlNUBz2Vh8bgD00Nuv621cZS0UqFb3KwRlqIbm26bs5+VBMQ==
X-Received: by 2002:a05:622a:2d1:b0:343:6193:3348 with SMTP id a17-20020a05622a02d100b0034361933348mr13115115qtx.633.1661834688870;
        Mon, 29 Aug 2022 21:44:48 -0700 (PDT)
Received: from xzhouw.hosts.qa.psi.rdu2.redhat.com ([66.187.232.127])
        by smtp.gmail.com with ESMTPSA id bj11-20020a05620a190b00b006b60d5a7205sm7478585qkb.51.2022.08.29.21.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 21:44:48 -0700 (PDT)
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/4] tweaks for denying tiny xfs
Date:   Tue, 30 Aug 2022 12:44:29 +0800
Message-Id: <20220830044433.1719246-1-jencce.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since this xfsprogs commit:
  6e0ed3d19c54 mkfs: stop allowing tiny filesystems
xfs refuses filesystem size less then 300m, log size less then 64m,
and filesystems with single AG.

And with this xfsprogs commit
  1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
part of xfs/144 is removed as it is not allowed.

v3:
	Fix more fs size and log size limitation;
	Fix more single AG tests;
	Fix xfs/144;
	Tested group all excluding some testcases from dangerous_fuzzers group
v2:
	Fix more about 300m limit;
	Fix about log size larger then 64m;
	Remove xfs/202

Murphy Zhou (4):
  tests: increase fs size for mkfs
  tests: increase xfs log size
  tests/xfs: remove single-AG options
  xfs/144: remove testing root dir inode in AG 1

 common/config         |    2 +-
 common/log            |    8 +-
 common/xfs            |    6 +-
 tests/generic/015     |    2 +-
 tests/generic/027     |    2 +-
 tests/generic/042     |    3 +
 tests/generic/054.out | 1410 -----------------------------------------
 tests/generic/055.out |  126 ----
 tests/generic/077     |    2 +-
 tests/generic/081     |    6 +-
 tests/generic/083     |    2 +-
 tests/generic/085     |    2 +-
 tests/generic/108     |    4 +-
 tests/generic/204     |    2 +-
 tests/generic/226     |    2 +-
 tests/generic/250     |    2 +-
 tests/generic/252     |    2 +-
 tests/generic/371     |    2 +-
 tests/generic/387     |    2 +-
 tests/generic/416     |    2 +-
 tests/generic/416.out |    2 +-
 tests/generic/427     |    2 +-
 tests/generic/449     |    2 +-
 tests/generic/455     |    2 +-
 tests/generic/457     |    2 +-
 tests/generic/482     |    2 +-
 tests/generic/511     |    2 +-
 tests/generic/520     |    4 +-
 tests/generic/536     |    2 +-
 tests/generic/619     |    2 +-
 tests/generic/626     |    2 +-
 tests/xfs/002         |    2 +-
 tests/xfs/015         |    2 +-
 tests/xfs/041         |    8 +-
 tests/xfs/041.out     |   10 +-
 tests/xfs/042         |    2 +-
 tests/xfs/049         |    2 +-
 tests/xfs/073         |    2 +-
 tests/xfs/076         |    2 +-
 tests/xfs/078         |    6 +-
 tests/xfs/078.out     |   23 +-
 tests/xfs/104         |    6 +-
 tests/xfs/104.out     |   30 -
 tests/xfs/107         |    4 +-
 tests/xfs/118         |    4 +-
 tests/xfs/144         |   10 +-
 tests/xfs/148         |    2 +-
 tests/xfs/149         |   12 +-
 tests/xfs/168         |    2 +-
 tests/xfs/170         |   10 +-
 tests/xfs/170.out     |    8 +-
 tests/xfs/171         |   10 +-
 tests/xfs/171.out     |    8 +-
 tests/xfs/172         |    4 +-
 tests/xfs/172.out     |    4 +-
 tests/xfs/173         |   10 +-
 tests/xfs/173.out     |    8 +-
 tests/xfs/174         |    4 +-
 tests/xfs/174.out     |    4 +-
 tests/xfs/176         |    2 +-
 tests/xfs/179         |    2 +-
 tests/xfs/202         |   40 --
 tests/xfs/202.out     |   29 -
 tests/xfs/205         |    2 +-
 tests/xfs/206         |    2 +-
 tests/xfs/227         |    2 +-
 tests/xfs/233         |    2 +-
 tests/xfs/250         |    6 +-
 tests/xfs/259         |    2 +-
 tests/xfs/279         |    6 +-
 tests/xfs/289         |   22 +-
 tests/xfs/291         |    4 +-
 tests/xfs/306         |    2 +-
 tests/xfs/445         |    2 +-
 tests/xfs/514         |    2 +-
 tests/xfs/520         |    2 +-
 76 files changed, 151 insertions(+), 1790 deletions(-)
 delete mode 100755 tests/xfs/202
 delete mode 100644 tests/xfs/202.out

-- 
2.31.1

