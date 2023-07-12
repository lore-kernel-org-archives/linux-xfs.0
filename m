Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33764EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 09:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjGLJrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjGLJrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 05:47:39 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A165DB0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:38 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2b701e1c80fso104702271fa.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689155257; x=1691747257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b8R6z8xi1if1YL9lLsXa/UDZpVt29LMdY4x6ThkDN30=;
        b=Jy3hykNq+Nleoh+x1ZXT/UsxUDRomryZ2ST18CY4ovj977EUWauaFSnNr1WkcWbO31
         rZNyS6InFfeSFfo3WFjElYbCa+ewOc5BKqtNAxa9WZiNEewP4FQrkNgNq5NJJL4gD+KG
         7JqI81rzdQBzvAwQsYoHI6JynOteZqxJj/MILsInpzjS/RM/XYnhDXP5AAGr2fPvZyBv
         u3m5CU1Fm/bMa42EXJIC59aRMqI+tnR6YW2Fn2fnaeM+Aw28dkWEPrKi4Ay5fM7MxQ4U
         UP21/ap/ThM1ZJk0LVakMqcqWS8G0EEkjI7JZ4K/MaKOKA39Ujk+b8K1VnbBlfskbtnj
         LR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689155257; x=1691747257;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b8R6z8xi1if1YL9lLsXa/UDZpVt29LMdY4x6ThkDN30=;
        b=Px+jXaFjuEf7e35SK45J5kbCV00ZZuKeV7IIUWd1cjfkyihWd0tmNZjgdDem/UzBpx
         fGDReRA3Pm1RPuIcvjefXuvk6QoLKzvAR5b+7Ct5fv5yACyzSFnjsGrBVH2uQ7saWrU9
         AYP+Lp1XmBDKht0cJhhEOv8It6c9wcgUTiQ8JxaG2X7WxAmgRzsGEBJAN5aEcPJtVJqr
         HJ43HW8wc3lCA4lTPxjtGAqlGPZkUuQ5uO4PVhK2RJ8OY0A08lNDGfwApyw+C1Ul7jI0
         8Uf7+ZBBuEtKQLN2NnuH5gPHq1HvXKZoj77/Xs9hk3Kkc80Tc/tiZ6g7fPiymXX7ML3V
         OXKA==
X-Gm-Message-State: ABy/qLYw3ZNTnUYx5lLFTO8wtGoAhZsXeCWOFEFOJpCt/BoS1dwTU8Sx
        56472pHBk9PWe+nGkuIaqt4=
X-Google-Smtp-Source: APBJJlFclRowhByvIQvMmoDAb5H5D107ruqsuCxy9De+m6iLUHIkmrEyr2O16rRuSiH/Hf+0c8in+g==
X-Received: by 2002:a2e:8784:0:b0:2b4:7f2e:a42d with SMTP id n4-20020a2e8784000000b002b47f2ea42dmr16710477lji.41.1689155256612;
        Wed, 12 Jul 2023 02:47:36 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id u9-20020a7bc049000000b003fbc681c8d1sm15144548wmc.36.2023.07.12.02.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 02:47:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org
Subject: [PATCH 6.1 CANDIDATE 0/3] xfs inodegc fixes for 6.1.y (from v6.4)
Date:   Wed, 12 Jul 2023 12:47:30 +0300
Message-Id: <20230712094733.1265038-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

These are the patches we discussed that Leah requested for the 5.15.y
backport of non-blocking inodegc pushes series [1].

They may or may not help the 5.15.y -> 6.1.y regression that was
reported by Chris [2].

Note that I did not include:
2d5f38a31980 ("xfs: disable reaping in fscounters scrub")
in this backport set, because I generally do not want to deal with
backporting fixes for experimental features.

This series has gone through the usual kdevops testing routine.

Please ACK.

Thanks,
Amir.

[1] https://www.spinics.net/lists/linux-xfs/msg61813.html
[2] https://lore.kernel.org/all/ZK4E%2FgGuaBu+qvKL@dread.disaster.area/

Darrick J. Wong (3):
  xfs: explicitly specify cpu when forcing inodegc delayed work to run
    immediately
  xfs: check that per-cpu inodegc workers actually run on that cpu
  xfs: fix xfs_inodegc_stop racing with mod_delayed_work

 fs/xfs/xfs_icache.c | 40 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_mount.h  |  3 +++
 fs/xfs/xfs_super.c  |  3 +++
 3 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.34.1

