Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A81C54FCB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 23:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCF0F215A4
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 23:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="U755vYzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgDXXF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 19:05:58 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:42023 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgDXXF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 19:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587769558; x=1619305558;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=rWJ3FYSUDBhtgg2HwAWLYSU0m92N3Fm0EkeAxiCPd8U=;
  b=U755vYzxSiMWPSo+6HFGrJcimtmLmkCA0+6JSK0mw+Ere80eKZnw4xFJ
   UvGP8JfTm70Bv+1I+q0/mnexnlOS4928rZDynl8QTklD+xNUWzXo17OeJ
   B7gZb4HwTT/VzBJpkNFSq8N39RR5AAMrlbsRH9MnAmHmkwbBizPXLbnhz
   o=;
IronPort-SDR: mfTedI26INg96UQ0DLqe5Mo6R3kgG5IPNsWEq3lktJodG3l4+3L1KY1OMs0pD54A8NTtlwx8I5
 XJFo0LPaCNeQ==
X-IronPort-AV: E=Sophos;i="5.73,313,1583193600"; 
   d="scan'208";a="27301188"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Apr 2020 23:05:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id D27CBA271E;
        Fri, 24 Apr 2020 23:05:43 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 23:05:43 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.162.70) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 23:05:43 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <sjitindarsingh@gmail.com>, <linux-xfs@vger.kernel.org>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>
Subject: [PATCH STABLE v4.14.y 0/2] xfs: Backport two fixes
Date:   Fri, 24 Apr 2020 16:05:30 -0700
Message-ID: <20200424230532.2852-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.70]
X-ClientProxiedBy: EX13D43UWC004.ant.amazon.com (10.43.162.42) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series backports two patches which fix known bugs in the xfs
filesystem code to the v4.14.y stable tree.

They are each verified by the xfs tests xfs/439 and generic/585
respectively.

The first patch applies cleanly.

The second patch required slight massage due to the last code block
being removed having changed slightly upstream due to rework. I think
the backport is functionally equivalent.
Only thing is I request comment that it is correct to use the following
error path:

	ASSERT(VFS_I(wip)->i_nlink == 0);
	error = xfs_iunlink_remove(tp, wip);
	if (error)
>	       goto out_trans_cancel;

The old error patch out_bmap_cancel still exists here. However as
nothing can have modified the deferred ops struct at this point I
believe it is sufficient to go to the "out_trans_cancel" error label.

Darrick J. Wong (1):
  xfs: validate sb_logsunit is a multiple of the fs blocksize

kaixuxia (1):
  xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT

 fs/xfs/xfs_inode.c | 85 +++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log.c   | 14 +++++++-
 2 files changed, 55 insertions(+), 44 deletions(-)

-- 
2.17.1

