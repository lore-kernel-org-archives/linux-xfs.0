Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182DFC4CEC5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 14:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9CB420830
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 14:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbfILOc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 10:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732444AbfILOc0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Sep 2019 10:32:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1F8D8980EE
        for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2019 14:32:26 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 561A95D712;
        Thu, 12 Sep 2019 14:32:24 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH REPOST 0/2] xfs: rely on minleft instead of total for bmbt res
Date:   Thu, 12 Sep 2019 10:32:21 -0400
Message-Id: <20190912143223.24194-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 12 Sep 2019 14:32:26 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a repost of a couple patches I posted a few months ago[1]. There
are no changes other than a rebase to for-next. Any thoughts on these? I
think Carlos had also run into some related generic/223 failures fairly
recently...

Carlos,

Any chance you could give these a try?

Brian

[1] https://lore.kernel.org/linux-xfs/20190501140504.16435-1-bfoster@redhat.com/

Brian Foster (2):
  xfs: drop minlen before tossing alignment on bmap allocs
  xfs: don't set bmapi total block req where minleft is sufficient

 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
 fs/xfs/xfs_bmap_util.c   |  4 ++--
 fs/xfs/xfs_dquot.c       |  4 ++--
 fs/xfs/xfs_iomap.c       |  4 ++--
 fs/xfs/xfs_reflink.c     |  4 ++--
 fs/xfs/xfs_rtalloc.c     |  3 +--
 6 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.20.1

