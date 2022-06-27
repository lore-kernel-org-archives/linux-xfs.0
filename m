Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0D1C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiF0ASk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiF0ASj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:39 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1BD32BF0
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7CD8A5ECD0A
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSY-00BTVA-Sf
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:34 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSY-000uAc-Qk
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/14] xfs: perag conversions for 5.20
Date:   Mon, 27 Jun 2022 10:18:18 +1000
Message-Id: <20220627001832.215779-1-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=dmHgvlz_5PEwZAN8VjoA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is the set of per-ag conversions that I'm proposing for the
5.20 cycle. It is the initial subset of changes that were listed in
the larger "upcoming perag changes for shrink" patchset here:

https://lore.kernel.org/linux-xfs/20220611012659.3418072-1-david@fromorbit.com/

This series drives the perag down into the AGI, AGF and AGFL access
routines and unifies the perag structure initialisation with the
high level AG header read functions. This largely replaces the
xfs_mount/agno pair that is passed to all these functions with a
perag, and in most places we already have a perag ready to pass in.
There are a few places where perags need to be grabbed before
reading the AG header buffers - some of these will need to be driven
to higher layers to ensure we can run operations on AGs without
getting stuck part way through waiting on a perag reference.

The latter section of this patchset moves some of the AG geometry
information from the xfs_mount to the xfs_perag, and starts
converting code that requires geometry validation to use a perag
instead of a mount and having to extract the AGNO from the object
location. This also allows us to store the AG size in the perag and
then we can stop having to compare the agno against sb_agcount to
determine if the AG is the last AG and so has a runt size.  This
greatly simplifies some of the type validity checking we do and
substantially reduces the CPU overhead of type validity checking. It
also cuts over 1.2kB out of the binary size.

This runs through fstests cleanly - I don't expect there to be
hidden surprises in it so I think these patches are good to go
for the 5.20 cycle.

Comments and thoughts welcome....

-Dave.


