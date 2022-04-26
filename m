Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC6FC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 23:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244233AbiDZXsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 19:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356007AbiDZXsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 19:48:07 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1D0114090
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 16:44:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6470B535043
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 09:44:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njUrY-004wJh-8N
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 09:44:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njUrY-002rVj-4f
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 09:44:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfsprogs: fixes and updates
Date:   Wed, 27 Apr 2022 09:44:49 +1000
Message-Id: <20220426234453.682296-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=626883f9
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=proFv_4rasc3zN-VmiMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

A handful of patches I have lying around for xfsprogs. The first two
are fixes for metadump when handling corrupt filesystems with bad
inode fork layouts. The third is a patch I've used for testing
bulkstat scalability to minimise userspace CPU overhead so I can
drive the kernel code as hard as possible. The last is an autoconf
updates to silence a bunch of build warnings I now get with the
latest and greatest autoconf releases.

Applies against v5.15.0.

Cheers,

Dave.


