Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB475C4332D
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 04:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B0D64F9E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 04:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCQE5q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 00:57:46 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50846 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhCQE5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 00:57:23 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id AAD4378BB14
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 15:57:10 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF2-003R8A-Uq
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF2-002jZs-Kp
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/8] xfs: miscellaneous optimisations
Date:   Wed, 17 Mar 2021 15:56:58 +1100
Message-Id: <20210317045706.651306-1-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=_6HuQ8JaEcU1K4YFvFcA:9 a=6RyHdP9wf0s6W1bbVaoE2bQoMl4=:19
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These patches have been separated out of my big log patchset as
standalone optimisations and fixes (hence the "v4" version) that
was posted here:

https://lore.kernel.org/linux-xfs/20210305051143.182133-1-david@fromorbit.com/T/#m2eceb42c20de51dccbf7d34a1e84f581d1c801cf

These are the changes that are easy to untangle from that patchset
to make it smaller and more manageable. All of the patches are
unchanged since they were last posted for review (except for rebase
noise). They pass fstests cleanly, and this posting is based on
5.12-rc3 + xfs for-next branch.

Cheers,

Dave.


