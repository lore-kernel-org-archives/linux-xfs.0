Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DD8C74A5B
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Mar 2023 17:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCZRGf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Mar 2023 13:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCZRGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Mar 2023 13:06:34 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8F444B0
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 10:06:33 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id q16so8299907lfe.10
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 10:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679850391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qlYEmHawRUc9CXHZvxz4hcXryBGUW3aSpn5U9HU8xgw=;
        b=U2RMt1ltWUI8b/9xLkbElYtyYdou3M887Jvk2GDM0SaocnKt6n30zHVHWmS7A7mKf0
         6cFUsUwuQsbDWG86Uwh+hg5c9ikTLP8oOZM+KAuUyoYIvfCMYFmqgM96jXltsSuTmNXE
         /kgby636C10siXtjqLlVkAQ+2RB0RnJVx4DR1DbKgoD8NkVi1h270HXh7EqrR4zgozeT
         8HztZesM8vlLdoBvGl95KkvHXhjA8W7f+JdTQRL5aA4Z+5hrYC6nElRn+fSVcv4JkHfd
         7Vq/gzQEHV2HCWJiW0vxFJFY59Q0RrPn7KG22dfgYJfqev+EeaoMHhEimSn9jX7y/UDs
         MD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qlYEmHawRUc9CXHZvxz4hcXryBGUW3aSpn5U9HU8xgw=;
        b=yccZcot2hSGsq2ffAPrOISBctp1JrTrBpUaeJDZO2WjYOWqR2l43l5EzPfCzBYcjrH
         XSqbK1TQKpDPv3613dqCv3hnbTjjJhusnnjEu1vJ8vNzHIpqXheP7Hw4Jvh5y8fUWsNq
         qDWKloMCTAmN8Y3gl3dPNd2lIR7cGIRp9seQYDb/7HFv4oluLhlHecNo0ur/e8IVKfEs
         06QDhDOy/Ze5cpGcrkyKrMDJtfcK8B4SMOxEhxVZvMnljkAJAHVLa+w7o/hsBLuQohMq
         oxpyQgVfV2whvz808oYVBr9vNjQAsuGIKTzqo5OrOv2ku1isEVDrHT+N2f2/poUrKlNZ
         sq0w==
X-Gm-Message-State: AAQBX9d076m1H5HNiRnBLyv/TVdTZzpURxqZUUgjr9owIXpOLbjvjXvz
        rncVccB6fBNd0KslISJ3cmU=
X-Google-Smtp-Source: AKy350YLEtLKqjZ5+2kD6hWm0P4/sY8bMOeIfvxtQIfd5UNhSOnEw16cAYE9IN6kd0KWKseWZtBWdw==
X-Received: by 2002:ac2:4105:0:b0:4db:381d:4496 with SMTP id b5-20020ac24105000000b004db381d4496mr2340810lfi.51.1679850391377;
        Sun, 26 Mar 2023 10:06:31 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id m7-20020ac24ac7000000b004d858fa34ebsm4288720lfp.112.2023.03.26.10.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:06:30 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/2] Two more xfs backports for 5.10.y (from v5.11)
Date:   Sun, 26 Mar 2023 20:06:21 +0300
Message-Id: <20230326170623.386288-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

These two backports were selected by Chandan for 5.4.y, but are
currently missing from 5.10.y.

I've put them through the usual kdevops testing routine.

This is the second time that I have considered patch #2 for 5.10.y.
The last time around, I observed increased the probablity of a known
buffer corruption assertion when running xfs/076, so I suspected
a regression, and dropped it from the submission [1].

At the time, the alleged regression happened only in the kdevops setup
and neither I nor Brain were able to understand why that happens [2].
This time around, the kdevops setup did not observe that odd regression.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220601104547.260949-1-amir73il@gmail.com/
[2] https://lore.kernel.org/linux-xfs/YpY6hUknor2S1iMd@bfoster/T/#mf1add66b8309a75a8984f28ea08718f22033bce7

Brian Foster (1):
  xfs: don't reuse busy extents on extent trim

Darrick J. Wong (1):
  xfs: shut down the filesystem if we screw up quota reservation

 fs/xfs/xfs_extent_busy.c | 14 --------------
 fs/xfs/xfs_trans_dquot.c | 13 ++++++++++---
 2 files changed, 10 insertions(+), 17 deletions(-)

-- 
2.34.1

