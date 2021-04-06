Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE012C43460
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A043E613CB
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343632AbhDFL7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:59:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33668 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343633AbhDFL7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 07:59:39 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BEF85828C69
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 21:59:27 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-00Cns2-RB
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-007IOP-JP
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4 v2] xfs: fix eager attr fork init regressions
Date:   Tue,  6 Apr 2021 21:59:19 +1000
Message-Id: <20210406115923.1738753-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=flHsS54QbmZ26e2A8jMA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Folks,

Update to the fixup patch set first posted here:

https://lore.kernel.org/linux-xfs/20210330053059.1339949-1-david@fromorbit.com/

Really the only change is to patch 2, which has had the commit
message reworked just to state the problem being fixed, along with a
change in implementation that Christoph suggested.

This version has passed through fstests on a SELinux enabled test
machine without issues.

Cheers,

Dave.

