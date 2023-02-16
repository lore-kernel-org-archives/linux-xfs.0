Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0655C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBPUbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPUbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:31:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD977196B9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:31:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 496CB60C04
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EDFC433EF;
        Thu, 16 Feb 2023 20:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579513;
        bh=wpHsLp1HfZaWChZJKCCdj6eDsNU1ZOGdbDOnxFjN9cU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vBJvBsZ4XlJ68X1N6eHcxkD4e2V/MW0L9teqiZYiiPRadmfKWLxrSbiwDNvsu8Euw
         zuSSfz7JEPLYxz389OGAP5SPYVVnGTyQnwSP5IIM8WtZsW9YVrm3w4NUiNGCOqnHaq
         2p//AiP/v35P+zcfkZc/hjnRKzV/KZmsHBtU1Rx9AqeI7FB4J1HZsThmKARzcwAyyr
         DRlyYESHf9JvTcN+OLleNU19xkqVieVhY6oBiUMcacif0ilx+mVJ5yFIbv1yd2l163
         5Z7ya6EGsba7lK54cpJ39Luz0hgemkaX0z46qvyQM52+4OfWxPqmLMgNmEtpppf299
         O+DmsFixS2xQw==
Date:   Thu, 16 Feb 2023 12:31:53 -0800
Subject: [PATCHSET v9r2d1 0/3] xfsprogs: turn on all available features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657883060.3478343.13279613574882662321.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Enable reverse mapping, large extent counts, and parent pointers by default.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-mkfs-defaults
---
 man/man8/mkfs.xfs.8.in |   11 ++++++-----
 mkfs/xfs_mkfs.c        |    6 +++---
 2 files changed, 9 insertions(+), 8 deletions(-)

