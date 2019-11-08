Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A14FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAF7C206C3
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfKHVGS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:06:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfKHVGS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 16:06:18 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D69ADC057F51
        for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2019 21:06:17 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id q6so557772wrv.11
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 13:06:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O9c9IZBLcOpWsxdnuzVDBO6FH/cipqhGDPF7kPPkbVk=;
        b=MykkwhlwHxFIqKUjVOiV51ETzUW7H3TI5dXEt6lj+prTwAEOLv0En7jVIXbmp3VTl2
         cU8RTmSo2k/wJ8eBIRppP0JXV2FNEDT31ANGprXcEYgt5IIDcKljtVKtBMiuDMvjG3j5
         occnq1edEry47bdQvof3senr0aRTumSNXMSunSVlup+Ej3JmSG8p0Nxd600yoA11kA9K
         Xw3hXLFapNV0LbHiHLnYoBo8DJlWjfsvR3vAcFxQIauBmmRzD8G7EAKO3NboSJ88RLux
         wcUTIJ9V3IpFS+bHEVh7aoA0I8ZHMM5NPwvfytWQkKyrfm430VfI+Fw9o+8EekDv2DWw
         Gb6g==
X-Gm-Message-State: APjAAAWWa3JDPh64wyBjXCBJjZEag9Ks1P/kKinpJM1JzMuklBilelXM
        pqAFmmznXluw5TVtetY4UuCT9xxIYYqLoi5Iv2jnPvZZ+fM9uPQZoVG0aEpNvFJBSxpx5eqDydk
        FvIQbq0z0KO1fZaFIK+LU
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr9783427wrn.71.1573247176500;
        Fri, 08 Nov 2019 13:06:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUX2UfsYrxEUe5cfONDIErLzE8BLL/3oGJQknQgg25QkJbKLMVA3RURuy8UvPRksrardkw+g==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr9783419wrn.71.1573247176379;
        Fri, 08 Nov 2019 13:06:16 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id n23sm6489086wmc.18.2019.11.08.13.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:06:15 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v2 0/4] xfs: remove several typedefs in quota code  
Date:   Fri,  8 Nov 2019 22:06:08 +0100
Message-Id: <20191108210612.423439-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate some typedefs.

Pavel Reichl (4):
  xfs: remove the xfs_disk_dquot_t and xfs_dquot_t typedefs
  xfs: remove the xfs_quotainfo_t typedef
  xfs: remove the xfs_dq_logitem_t typedef
  xfs: remove the xfs_qoff_logitem_t typedef

 fs/xfs/libxfs/xfs_dquot_buf.c  |  8 ++---
 fs/xfs/libxfs/xfs_format.h     | 10 +++----
 fs/xfs/libxfs/xfs_trans_resv.c |  5 ++--
 fs/xfs/xfs_dquot.c             | 20 ++++++-------
 fs/xfs/xfs_dquot.h             | 53 +++++++++++++++++-----------------
 fs/xfs/xfs_dquot_item.h        | 18 +++++++-----
 fs/xfs/xfs_log_recover.c       |  5 ++--
 fs/xfs/xfs_qm.c                | 48 +++++++++++++++---------------
 fs/xfs/xfs_qm.h                |  4 +--
 fs/xfs/xfs_qm_bhv.c            |  2 +-
 fs/xfs/xfs_qm_syscalls.c       | 35 ++++++++++++----------
 fs/xfs/xfs_trans_dquot.c       | 52 ++++++++++++++++-----------------
 12 files changed, 133 insertions(+), 127 deletions(-)

-- 
2.23.0

