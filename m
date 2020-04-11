Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE800C2BBC7
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A022084D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCzCzn0p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgDKJNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:08 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39849 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgDKJNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:08 -0400
Received: by mail-pj1-f66.google.com with SMTP id o1so796520pjs.4
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MwQEI1DKkFiXlSV02EqzlzqkML0bDLjDHQkXIawDuCE=;
        b=NCzCzn0p2g/EE5A9sIxQteUARt76GiFUZOBFBz1pjcr2G/JejiO74tjbu74jqbznaN
         OxyWOQM+e147lwekaiQbOdwhUZbufnqQhqlVIMsGOIqyvxPUoa1kDXt1AKlGF2o2cbkW
         Mz4mA6wuL5diBGYYR6TIB8OEV7jYE4fXVopMVuWsEppbnLSfdRi9lf2rP/ETGxAae63D
         6xSp+Hqxc8bwZ5wF2+7bi6OhkbRmQuU2j++EdFhiIao+URYt62gl8QZ0WHxc4cvOX3rC
         W41/VhoEt/T9436yDd67c2SEHf3FfXDISTG1S8mxffNdW5TUK0Zgo3ybhVECAIMibNOW
         eLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MwQEI1DKkFiXlSV02EqzlzqkML0bDLjDHQkXIawDuCE=;
        b=LghtxIjqnhIvBzd2ZEA7IGjM32kp+Y6cTvMsBRTKJsnH7XHQd1INC+5pBN32rvJVnR
         wUGKZHCokEXzA15s53Qkw7maDHw+oRoz8zGxQyS4PgAAodsM3XnTEeiA9BzxowvQxByV
         s8RW3sD4qzaf4UqyAjvQywP9AuoaK0ooZtkw+a6eMZpPFeWk/SS1xFI4S5DDn5im41KJ
         nkdrKiF55+cT4XlXm33jNdiMIRC0iA26oD7BSPlbCaGue6WvC90mxELrNcDYFNwjRviX
         gCFiZsL0hm31QSczqQTCWVxsp171ERK9WKT00iQZGIrDRDwULuQ54/Ap88SES2Y2hw0D
         rrKA==
X-Gm-Message-State: AGi0Pua7Ut/+jbcinuKFgnrufxIjIzivQJSd9yzUz7cgXMyBQm9vr0Lm
        eysHd8dD39U2sEJuK7ebG2FovqQ=
X-Google-Smtp-Source: APiQypJvgqlZcNQVjGykurPPWv2zRIwTyT8KwDxO48WYgg09KPQPpQNzwbAtX7wcdRLx+jMQzN8YfQ==
X-Received: by 2002:a17:90a:6582:: with SMTP id k2mr9464272pjj.180.1586596387181;
        Sat, 11 Apr 2020 02:13:07 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:06 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 0/6] xfs: some bugfixes and code cleanups for quota
Date:   Sat, 11 Apr 2020 17:12:52 +0800
Message-Id: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include some bugfixes and code cleanups for
qupta.

Changes for v2:
 - put all the scattered patches into a single patchset.
 - update the git version to fix the no function show problem.

Kaixu Xia (6):
  xfs: trace quota allocations for all quota types
  xfs: combine two if statements with same condition
  xfs: reserve quota inode transaction space only when needed
  xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
  xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
  xfs: simplify the flags setting in xfs_qm_scall_quotaon

 fs/xfs/xfs_ioctl.c       | 7 ++-----
 fs/xfs/xfs_iops.c        | 5 -----
 fs/xfs/xfs_qm.c          | 7 +++----
 fs/xfs/xfs_qm_syscalls.c | 6 +++---
 4 files changed, 8 insertions(+), 17 deletions(-)

-- 
2.20.0

