Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626D0C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 22:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377D92072C
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 22:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgESWY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 18:24:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55145 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbgESWY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 18:24:28 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D4C517EC000
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 08:23:19 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbAdm-0000OZ-ER
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 08:23:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbAdm-00AoIf-3Q
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 08:23:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2 v3] xfs: improve transaction rate scalability
Date:   Wed, 20 May 2020 08:23:08 +1000
Message-Id: <20200519222310.2576434-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=DFouaPKPe1dX9iUXcuEA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is the third version of the patchset to improve the transaction
rate on higher CPU count machines. The previous versions can be found
here:

https://lore.kernel.org/linux-xfs/20200512025949.1807131-1-david@fromorbit.com/
https://lore.kernel.org/linux-xfs/20200512092811.1846252-1-david@fromorbit.com/

Changes for v3 are:
- completely reorganise the struct xfs_mount, not just a subset of
  the variables. This seems to improve performance even more than
  the original version. (Christoph requested this.)
- remove the m_active_trans counter rather than convert it to percpu
  as Darrick suggested.

Results are just as good or better than previous versions, passes
fstests without regressions on both low PCU count and high CPU count
test VMs.

Cheers,

Dave.

