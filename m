Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F3AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiF1Uui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Uui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875DC31912
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 498CDB81E06
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C35C341C8;
        Tue, 28 Jun 2022 20:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449435;
        bh=vVcAwcC0+u8IOytUjmcOqRu3IyNYc1AmDUVjyS/yous=;
        h=Subject:From:To:Cc:Date:From;
        b=WdUEyqJAhQVV9hMPMsHxabpAnkNE23YqxcYk5nqXA1Gf+BI77IlBChywc4mGyNgJX
         tA62rtsSsWNpdPA9I0pBJmGg9Unru4uYuVV4tFwiJKPPfjcHvDRIVBSq0otgaXuou4
         h8DiCwfIFOPwKbc3uEXzaszpIb+oNef5nmZJHLLXvrH6oGk4R+a+ypIMVxe0GsVXKh
         Lqsgk49EY7CwR45mL7QpTYkWfwV98HeYLz5oxAtmmPv84fY/TAKM85BUAvGCBYZLLL
         cj1WLwnRIPX7S5ygpztQsLHCuIfNb2SNZBhdFr+zkA6J0owAYzvhO+ORhwvuzGlxzs
         1Lgw1dqUFMPrg==
Subject: [PATCHSET v2 0/3] xfs_repair: various small fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:34 -0700
Message-ID: <165644943454.1091715.4250245702579572029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Bug fixes for 5.16 include:

 - checking V5 feature bits in secondary superblocks against whatever we
   decide is the primary
 - consistently warning if repair can't check existing rmap and refcount
   btrees
 - checking the ftype of dot and dotdot entries

Enjoy!

v2: improve documentation

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes
---
 repair/agheader.c    |   23 ++++++++++++++++++++---
 repair/dino_chunks.c |    3 +--
 2 files changed, 21 insertions(+), 5 deletions(-)

