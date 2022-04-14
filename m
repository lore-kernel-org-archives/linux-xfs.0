Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97C3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347370AbiDNW44 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347374AbiDNW4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:56:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDD465F6
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FBF0B82762
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D5CC385A5;
        Thu, 14 Apr 2022 22:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976866;
        bh=QShktMXVwqWprnvmn19NlKPk9YsNsNPcOInH7O/emBY=;
        h=Subject:From:To:Cc:Date:From;
        b=VE9YUlLYBUjVKH9uoPdT9hx9RIBcG+Wij+3IyH4Tj7I48S+epq8acPJgC6kEvsZG4
         uamPKE/FD70Cf7ASJVfk11hNnJysmidW7xQa0IYJchUCBdpDc52PScTty3Z5qNbq4w
         A/LXeYFIy5GKkyOSLdzW0nssJxOFgL1OFB8EW/b7jWWJTGz4ywkkPMSszz8DSW7nBN
         xjW7pJrVRq+a6bFrciIPb8135eFyqDTU5VjmwxntBPJvYnYLPfI5FOpVPcgQSgZSxA
         XYcme2maVWfqxlwPP2Mn6hcug0O2/f9nuG1yDR4Y6c3BTqnluMp32iovQItf2uamrA
         QpTL900Hi3zgg==
Subject: [PATCHSET 0/6] xfs: fix reflink inefficiencies
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:25 -0700
Message-ID: <164997686569.383881.8935566398533700022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As Dave Chinner has complained about on IRC, there are a couple of
things about reflink that are very inefficient.  First of all, we
limited the size of all bunmapi operations to avoid flooding the log
with defer ops in the worst case, but recent changes to the defer ops
code have solved that problem, so get rid of the bunmapi length clamp.

Second, the log reservations for reflink operations are far far larger
than they need to be.  Shrink them to exactly what we need to handle
each deferred RUI and CUI log item, and no more.  Also reduce logcount
because we don't need 8 rolls per operation.  Introduce a transaction
reservation compatibility layer to avoid changing the minimum log size
calculations.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-speedups-5.19
---
 fs/xfs/libxfs/xfs_bmap.c       |   22 -----
 fs/xfs/libxfs/xfs_log_rlimit.c |   17 +++-
 fs/xfs/libxfs/xfs_refcount.c   |   14 ++-
 fs/xfs/libxfs/xfs_refcount.h   |    8 --
 fs/xfs/libxfs/xfs_trans_resv.c |  193 +++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_trans_resv.h |    8 +-
 fs/xfs/xfs_reflink.c           |   95 ++++++++++++--------
 fs/xfs/xfs_trace.h             |   15 ++-
 8 files changed, 264 insertions(+), 108 deletions(-)

