Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEA1C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FF4214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387689AbfKGLf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:35:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGLfz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 06:35:55 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 697A437F73
        for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2019 11:35:55 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id h4so810358wrx.15
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:35:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cofLaSy59K81UsyWPH2DBX+wkTnX260eVGZRfiVyeYI=;
        b=Aq9zhaxzgIaYL8OK5TWEqiNDHQexxf/wafxEXFlhcnXwlGvzDtItqtmf6yDYTRJW8k
         1SmVyIlPtBByQk4SuLLXgPWG6s9yOOfh0sRo9Ska5H91tF+DFkCGsINT2CenubqrZQ7a
         z7oIw/1OvvSDbRQ2HfDeNHLI/V7pt/LIFWxiCo8Dczl4noPxXJZPKKhMYlq4OCFaVtXp
         0ML3hx0llLuUaPAk9iB6sPEN+SDaHH+6jgsIw+hxgECOO/OZl4WKYcFZUlFnVyymEM7V
         xVAm9re0C3U7thgqIMykinEOPxFf8lB65vB3xv2VjZUOJiI0sbzgAcAzrPEK3j06MpYb
         hMzw==
X-Gm-Message-State: APjAAAXZWDoeOumyF8f4yOUuwsKoxGZx0Z/40QWG8PlmoCYpwD/OBE8F
        sXzYmN8wg1l25x5FneDSAEScG2GWlu95wJf1OVzHtFdaoXOtR7sjbMPiUKJaR5DKkfATco4VXTG
        JT8PYjVAoKKZMPlCbBqMk
X-Received: by 2002:a1c:99cb:: with SMTP id b194mr2567587wme.100.1573126553976;
        Thu, 07 Nov 2019 03:35:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxU4MR2Zp3/KmAn+PQBbSWyx0SeqQeovHL2rKn0RKTtxPB9vJKUgQ7JWfgMV/dM/4a/Mw8FYA==
X-Received: by 2002:a1c:99cb:: with SMTP id b194mr2567577wme.100.1573126553831;
        Thu, 07 Nov 2019 03:35:53 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a6sm1532888wmj.1.2019.11.07.03.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 03:35:53 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 0/5] xfs: remove several typedefs in quota code 
Date:   Thu,  7 Nov 2019 12:35:44 +0100
Message-Id: <20191107113549.110129-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate some typedefs. 

Pavel Reichl (5):
  xfs: remove the xfs_disk_dquot_t typedef
  xfs: remove the xfs_dquot_t typedef
  xfs: remove the xfs_quotainfo_t typedef
  xfs: remove the xfs_dq_logitem_t typedef
  xfs: remove the xfs_qoff_logitem_t typedef

 fs/xfs/libxfs/xfs_dquot_buf.c  |  8 +++---
 fs/xfs/libxfs/xfs_format.h     | 10 ++++----
 fs/xfs/libxfs/xfs_trans_resv.c |  5 ++--
 fs/xfs/xfs_dquot.c             | 18 ++++++-------
 fs/xfs/xfs_dquot.h             | 31 ++++++++++++-----------
 fs/xfs/xfs_dquot_item.h        | 18 +++++++------
 fs/xfs/xfs_log_recover.c       |  5 ++--
 fs/xfs/xfs_qm.c                | 42 +++++++++++++++----------------
 fs/xfs/xfs_qm.h                |  4 +--
 fs/xfs/xfs_qm_bhv.c            |  2 +-
 fs/xfs/xfs_qm_syscalls.c       | 20 +++++++--------
 fs/xfs/xfs_trans_dquot.c       | 46 +++++++++++++++++-----------------
 12 files changed, 106 insertions(+), 103 deletions(-)

-- 
2.23.0

