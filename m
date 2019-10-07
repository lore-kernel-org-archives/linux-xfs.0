Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B80C47404
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C4E2173B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfJGNTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfJGNTj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 09:19:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34297308FB9A
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E189C1001B30
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:38 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/3] xfs: fix sf to block inode fork logging
Date:   Mon,  7 Oct 2019 09:19:35 -0400
Message-Id: <20191007131938.23839-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 07 Oct 2019 13:19:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the directory inode shortform to block logging fixup. This
also addresses the similar attr fork conversion function. I put the
other cleanups into separate patches because it wasn't totally clear to
me if we wanted to add the log call to the conversion function given the
other callers log the inode outside of that function. IOW, we can either
keep or drop patch 3. I have no strong preference either way.

Brian

v2:
- Also fix up attr fork conversion.
- Add patches 2 and 3 for follow up cleanups.
v1: https://lore.kernel.org/linux-xfs/20191004125520.7857-1-bfoster@redhat.com/

Brian Foster (3):
  xfs: log the inode on directory sf to block format change
  xfs: remove broken error handling on failed attr sf to leaf change
  xfs: move local to extent inode logging into bmap helper

 fs/xfs/libxfs/xfs_attr_leaf.c  | 21 +++------------------
 fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
 fs/xfs/libxfs/xfs_bmap.h       |  3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 4 files changed, 10 insertions(+), 22 deletions(-)

-- 
2.20.1

