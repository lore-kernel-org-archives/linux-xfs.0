Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E133C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 02:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiFQCbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFQCbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 22:31:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B70764D36
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 19:31:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso6600501pjb.0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 19:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ydQAd/KUL2HxHcZ6WmBYJjq1p3MkSEob3eJfHRJ1mls=;
        b=pIlnY2MZys3SuUbWqsUHCe6R5Xv4utaX8Ef1/yiqJVx4c9UdvE5KtgxpmuvrGsEkh7
         xcFRUXMRyapOAntJADJ6t1QLI9tX2Y/SZ2Pu89Xr09S5Ap/+kxmsoEE29hNMSUkx9+wa
         du/I42iERJHPkGwDaqcx2sAP3m+A8mcW8SBu6r4HTtChnCqlJFobBBRpy2RjWmhvgBWH
         QPAfwQatsG5WZe44zEuxcJbz1avwZ3KOb4I0uJzw29PHF2nkcCOYCqpOuJTgQ3i3M93o
         UXvCD9VbnRr6K2h6Ov1aPJ2jO1tygBYvIAr66wXlh8vLpSiIpqBkyR4vHbb2rxIW2oY9
         DzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ydQAd/KUL2HxHcZ6WmBYJjq1p3MkSEob3eJfHRJ1mls=;
        b=iq8nq0M1OJhO8wpshL79ErhTOfH6oUKFeUsHNfM7Jgr82djzCSNhML4ObdT8fVlpsJ
         G+Gb7ig5dmhsRWG8joIY/HCfc6ltCB5roHonzofGW0ogpR0pk+WY0m4qKGwMyVFtL95Y
         qOz9bhHuGuzUOHqMs2YByuLfHXJN7r/PoizszJz85ISn57pv1Zu6yRbpq0+AqYC664QN
         liAZL3VJHy9xy3kA3Y3k1S6g0w/RgtAit1+/tkUsEESYfTvTznFOrwyxQXBviiiXTRBJ
         jZzV1JacK/x8E/2g6LM2dMOnCOSG4znEeq2rI3lt+P5U3LC3zf7u4UNEbZPgAHc6W/dH
         BqRA==
X-Gm-Message-State: AJIora+W+02UEbPnobagEVs35cMzxyJKXooeXmBe1DAIlj/T0fL/vyx5
        0i5tNnnndWBngjPX/eDXXXEM4sDv/w==
X-Google-Smtp-Source: AGRyM1vOLh6T5dF4pZwnfBJN9cn+TUhunDLtJ0dMW7muoxhJcmnGccl62suiGOJqQ/NduwypsXobmg==
X-Received: by 2002:a17:90b:188:b0:1e3:1feb:edb2 with SMTP id t8-20020a17090b018800b001e31febedb2mr8278097pjs.195.1655433062392;
        Thu, 16 Jun 2022 19:31:02 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b0016892555955sm2282654plh.179.2022.06.16.19.31.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jun 2022 19:31:02 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [RESEND PATCH 0/2] xfs: random fixes for lock flags
Date:   Fri, 17 Jun 2022 10:30:32 +0800
Message-Id: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi,

This patchset include some patches to factor out lock flags
and fix the mmap_lock state check.

Kaixu Xia (2):
  xfs: factor out the common lock flags assert
  xfs: use invalidate_lock to check the state of mmap_lock

 fs/xfs/xfs_inode.c | 64 ++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

-- 
2.27.0

