Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF3CC4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8340C207DE
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 15:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZizUASTy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbgJAPD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732513AbgJAPD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 11:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v3mnU9IdA4r/AoeCsPPbECrl8aljvybDqoNWkFDtiMQ=;
        b=ZizUASTy7H5SbAUaJYDgyWtj/oDjz2obTeSrm4NmoOBWp/PJauT6K9QiQLehTEkypTS4bS
        o6wXVuCipJjpjQif8yvxUPg2ql5nbV5WydfGdTHuatp52FW6CxDR53NXyY9qjGNo7W5aVF
        NjsnB3/fj8ImFyizn686ImQAEop/8Ls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-QQiFJq4JOw-J0lQ_hkTOaQ-1; Thu, 01 Oct 2020 11:03:23 -0400
X-MC-Unique: QQiFJq4JOw-J0lQ_hkTOaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D404640AB
        for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2020 15:03:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A53710013BD
        for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2020 15:03:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: rework quotaoff to avoid log deadlock
Date:   Thu,  1 Oct 2020 11:03:07 -0400
Message-Id: <20201001150310.141467-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a proper v1 of the quotaoff logging rework. Changes from the RFC
are fairly straightforward and listed below. The one outstanding bit of
feedback from the RFC is the lock / memory ordering question around the
quota flags update. My understanding is that the percpu rwsem provides
the required consistency through a combination of explicit memory
barriers and RCU, so I opted to drop the unnecessary wrapper functions
to make the locking more clear (along with comment updates) and also
eliminate freeze/unfreeze naming confusion.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Replace patch 2 with a proper internal quiesce mechanism.
- Remove unnecessary freeze/unfreeze helpers.
- Relocate quotaoff end transaction to commit inside quiesce window. 
- Clean up comments and document new algorithm.
rfc: https://lore.kernel.org/linux-xfs/20200929141228.108688-1-bfoster@redhat.com/

Brian Foster (3):
  xfs: skip dquot reservations if quota is inactive
  xfs: transaction subsystem quiesce mechanism
  xfs: rework quotaoff logging to avoid log deadlock on active fs

 fs/xfs/xfs_aops.c        |   2 +
 fs/xfs/xfs_mount.h       |   3 +
 fs/xfs/xfs_qm_syscalls.c | 133 +++++++++++++++++++--------------------
 fs/xfs/xfs_super.c       |   8 +++
 fs/xfs/xfs_trans.c       |   4 +-
 fs/xfs/xfs_trans.h       |  20 ++++++
 fs/xfs/xfs_trans_dquot.c |  22 +++----
 7 files changed, 111 insertions(+), 81 deletions(-)

-- 
2.25.4

