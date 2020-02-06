Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8888BC33CAC
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED8320838
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3K+PNuc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgBFTFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:05:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727698AbgBFTFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581015909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IGTdK3/4RtOB+VOgb/N+27bk+/v/0ZEvysqME+TQxzQ=;
        b=N3K+PNucWqeCIVwwL9471QB5PKQMG3uJtKj6ydI6+4GtGiEM0jXGTGZvwUrwjEvT07YlCM
        1f25Q4JS252J8EddENSYxM/AoXKNnwpInDTqb5FHkwwdg8sN8F5sB8qwEbPV/JGrvFu1zo
        gr+rzvj+kEV+abgpCH2QISN6VwYA0j4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-4Zjl7PcfMHO9oyAmnfjImQ-1; Thu, 06 Feb 2020 14:05:08 -0500
X-MC-Unique: 4Zjl7PcfMHO9oyAmnfjImQ-1
Received: by mail-wr1-f72.google.com with SMTP id p8so3978032wrw.5
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 11:05:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGTdK3/4RtOB+VOgb/N+27bk+/v/0ZEvysqME+TQxzQ=;
        b=KZCGAbzvpop9iS9n3EO3UMRKghC74C7r+sjKZrnW+t5UOOfEqHbm85bZbPm6wZ3GcV
         xo1e3nLcz+u/TcP7MP/kl/HcH1y7WePBJvwCr/Bxs6sygL3nvQFH+mkmLRxg6bZ3k/Ud
         U8lrGJAR1Dgs0R7EUjPj+v6unYngIgGE3+ni6Ku8RCUiV+N+1ZdBQK4GHjPvOmaUOTAl
         qO9qBSBVH5sz8yf394z2wk6gk8TYUfe0vL9/W6GiqRuMt4Qp1a/63ycS5+aoJVGRjGRS
         iQDXekfpGBSkR2zx++G9BP9qeIMdVlkdZpRtekzeZtYew2ySdtwZ8xeCFcSWgB/imSXU
         CvNA==
X-Gm-Message-State: APjAAAVvZ1jqJmrv1mur8rr+5Zkhyx7EiybFlVIOdvG958BUaNlJnXxO
        xYNMdXvPvsEsqoL3YKg21Bp7dYcoQzpZ3mA3ExNNYpY6FBu6kzCcZQCCNx5Ycak/2ecVFB2aAgP
        jShMj9FzeMIqPVcAYF3Ar
X-Received: by 2002:a5d:4481:: with SMTP id j1mr5178460wrq.348.1581015906691;
        Thu, 06 Feb 2020 11:05:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqw2wSN12+riDFo9oH+9wj5pONWQabtoj4b4PBMq3pqr2nAYHdiy+JxoVB6JY4RWDLYS4VubtQ==
X-Received: by 2002:a5d:4481:: with SMTP id j1mr5178449wrq.348.1581015906504;
        Thu, 06 Feb 2020 11:05:06 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id l29sm215448wrb.64.2020.02.06.11.05.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:05:06 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/4] xfs: Remove wrappers for some semaphores
Date:   Thu,  6 Feb 2020 20:04:58 +0100
Message-Id: <20200206190502.389139-1-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
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
  xfs: Fix WS in xfs_isilocked() calls
  xfs: Fix bug when checking diff. locks
  xfs: Replace mrlock_t by rw_semaphore

 fs/xfs/libxfs/xfs_bmap.c |  8 ++--
 fs/xfs/mrlock.h          | 78 -----------------------------------
 fs/xfs/xfs_file.c        |  3 +-
 fs/xfs/xfs_inode.c       | 87 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_inode.h       |  8 ++--
 fs/xfs/xfs_iops.c        |  4 +-
 fs/xfs/xfs_linux.h       |  1 -
 fs/xfs/xfs_qm.c          |  2 +-
 fs/xfs/xfs_super.c       |  6 +--
 9 files changed, 72 insertions(+), 125 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.24.1

