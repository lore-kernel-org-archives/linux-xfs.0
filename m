Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34464C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 23:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbiCPXON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbiCPXOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 19:14:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCDBAF4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:12:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BA875533483
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 10:12:56 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUcp5-006KDF-W1
        for linux-xfs@vger.kernel.org; Thu, 17 Mar 2022 10:12:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nUcp5-000Pur-T3
        for linux-xfs@vger.kernel.org;
        Thu, 17 Mar 2022 10:12:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfsprogs: improve metadump handling of corrupt inodes
Date:   Thu, 17 Mar 2022 10:12:51 +1100
Message-Id: <20220316231253.99577-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62326ef9
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=IhPcJCG2bZiE5i0qbJkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These are metadata patches I wrote a while back when helping to
diagnose the amount of damage a RAID failure made to an XFS
filesystem. metadump doesn't handle corrupt inode forks particularly
well, and these patches fix the two cases that were tripped over
while trying to metadump the broken filesystem.

Cheers,

Dave.


