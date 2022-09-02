Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E3FC38145
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 14:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiIBOSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbiIBOR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 10:17:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2849715F8B7
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 06:43:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0419FB82AC5
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E72C433D6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:43:33 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfsprogs: fix covscan issues
Date:   Fri,  2 Sep 2022 15:43:28 +0200
Message-Id: <166212614879.31305.11337231919093625864.stgit@andromeda>
X-Mailer: git-send-email 2.30.2
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix a couple of minor issues found by covscan

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Carlos Maiolino (2):
      xfs_repair: Fix check_refcount() error path
      xfs_repair: Fix rmaps_verify_btree() error path


 repair/rmap.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

