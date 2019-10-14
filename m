Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979FDC4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 741672067B
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732352AbfJNSNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:13:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731926AbfJNSNB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 14:13:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B28F73079B77
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:13:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70FA75D6A3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 18:13:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/3] xfs: grant head concurrency experiment
Date:   Mon, 14 Oct 2019 14:12:57 -0400
Message-Id: <20191014181300.15494-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 14 Oct 2019 18:13:00 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series (which is RFC for obvious reasons) fell out of recent
discussion on Dave's CIL throttling work[1] over the raciness of the
lockless log reservation algorithm. I was originally exploring some
improved debug mode checks when I eventually determined that would be
pointless due to the fact that with small enough logs, grant tail
overrun conditions become prevalent.

This is currently suppressed by the XLOG_TAIL_WARN flag, which is
removed in patch 1 simply for experimentation and demonstration
purposes. These warnings would likely be mitigated some by threshold
tracking improvements to the warning itself, but the warnings were
continuous enough that didn't seem a useful approach. Patch 2 does some
minor refactoring and patch 3 ties grant space update failures into the
grant head check mechanism.

This has only seen limited testing to confirm that tail overruns are
significantly reduced on smaller logs (without noticeable performance
penalty) and that the newly added retry events are nonexistent on
filesystems with normal/default sized logs. The caveat is potential
change in ordering of transactions in some cases, but it's not clear
that's a problem given the loose enough nature of the current algorithm
with respect to the (limited) scope of transactions impacted by this
type of change. We could also look into whether something like adding
retried checks to the head of the list vs the tail would preserve group
ordering, etc. Anyways, thoughts on something like this?

Brian

[1] https://lore.kernel.org/linux-xfs/20191004022755.GY16973@dread.disaster.area/

Brian Foster (3):
  xfs: temporarily bypass oneshot grant tail verification
  xfs: fold grant space update into head check function
  xfs: recheck free reservation on grant head update contention

 fs/xfs/xfs_log.c   | 58 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 43 insertions(+), 16 deletions(-)

-- 
2.20.1

