Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4294FC4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1397E20658
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JF7fasQJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgCTVD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 17:03:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28192 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727261AbgCTVD2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 17:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584738207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sq5X+GtmhPye9bt1FRMsq9QBmVGxBimrDoacyNXcUr0=;
        b=JF7fasQJcsRy5toHPvQK7aGGNrOwVBri+up3KDDYB1VCna50mfQMBtq0opNFdIpux5/sDg
        mlKJWs8No9/QZ483EWrYS+T+c90CNOz7XbReIsm0W3eRBXwxzMMNZWViXBfTP8Fh4fDRYO
        jefVwBcHRBM1ABzUiplEpQCQe1kAEcM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-iApL93RLPuyPREZK8dV-FA-1; Fri, 20 Mar 2020 17:03:25 -0400
X-MC-Unique: iApL93RLPuyPREZK8dV-FA-1
Received: by mail-wm1-f72.google.com with SMTP id w12so2820565wmc.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2020 14:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sq5X+GtmhPye9bt1FRMsq9QBmVGxBimrDoacyNXcUr0=;
        b=bRQyIpNNLxA3VFqFLjY4YVcp9YeMxsgEZItdyjELW4B8HodMCONkYMhgGyv8ATc90a
         LGbx4CYzJtQnf8tk1/a95rkni1jW5udOzJXcVhitWBcfkcCfTeKE3qcsEwy/XFqhsdSI
         dTh5NOlD1Gcfq7KoXmw7vGhcQ03xHAZJCp8in050TRNR1Un/tkmbpLeV5rwpjei/Peb9
         NsSKX0MogsqpTleFI3W7XgVM2qAtC4dfzm3xcRnsYoIggpH67nAuN1LwSVQg8/5Yy05z
         Gjv9a2W2gs8TtlxAahT4HVywefUI4rSuS+8Cu/ryRcNH7Hi6qQl+mAssuLRjyGrUJXQO
         +M3g==
X-Gm-Message-State: ANhLgQ2Q1mSdtXY/reHqto8THwOAo18R/6rC7RplONJox8iUsP9UUIMm
        pJm/yzFom5F6JKaz5x/WpmTivo+m6gvWYDI8u/txJe4/Z/RmJKGwJhnfQxMYcTqaBo0p21HHuzK
        +DLNPxmP2ZXVcagrccLUh
X-Received: by 2002:a1c:9d41:: with SMTP id g62mr12911632wme.131.1584738203570;
        Fri, 20 Mar 2020 14:03:23 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtT4mX+g5gFmjIOVMFxogaBWrHZiJAxnu7+L+3p3CFgtdssVPeDWzoIw+/muKmwy8o2m5pv6Q==
X-Received: by 2002:a1c:9d41:: with SMTP id g62mr12911624wme.131.1584738203396;
        Fri, 20 Mar 2020 14:03:23 -0700 (PDT)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id w7sm10479668wrr.60.2020.03.20.14.03.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 14:03:21 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 0/4] xfs: Remove wrappers for some semaphores
Date:   Fri, 20 Mar 2020 22:03:13 +0100
Message-Id: <20200320210317.1071747-1-preichl@redhat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove some wrappers that we have in XFS around the read-write semaphore
locks.

The goal of this cleanup is to remove mrlock_t structure and its mr*()
wrapper functions and replace it with native rw_semaphore type and its
native calls.

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c |   8 +--
 fs/xfs/mrlock.h          |  78 -----------------------------
 fs/xfs/xfs_file.c        |   3 +-
 fs/xfs/xfs_inode.c       | 104 ++++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h       |  25 ++++++----
 fs/xfs/xfs_iops.c        |   4 +-
 fs/xfs/xfs_linux.h       |   2 +-
 fs/xfs/xfs_qm.c          |   2 +-
 fs/xfs/xfs_super.c       |   6 +--
 9 files changed, 98 insertions(+), 134 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.25.1

