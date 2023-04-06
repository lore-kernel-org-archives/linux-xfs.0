Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AF6C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjDFTPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFTPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:15:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0478FC1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91BB06365E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D4AC433D2;
        Thu,  6 Apr 2023 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808529;
        bh=DRZ3XblZ8AnZtOXqqpC20X67s+bOVHZ5XUXbirzuGuA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=S7UzDExVBK0RwgBOyoY4SaYETMS5GJ7Zjbs9FRqmgcltej1zXnaWbJi5zMqm0RVGD
         s7f4vyZUGfvOXYibDYNXNBvIt8EzICnxbAQNyxVQRRSNWLPsjgpAG8zPFlY7LDgv+M
         cq6A1hqwCZS5QMjGrQUvSq3OkkUk7pmu2/Pp0R3SFObSRP7WFiCAGguvrNbhGssawL
         NT79a22gKXnya0obG4bkGJzowbq/YoGbbiA4AqFt4ap06o4EYPUb+CznfDTYrwxJZa
         AC9wH8XeWDR5t2J9925KbQHS9QADU+Co6wZ0ySS+AhhqgGYazJN33EbEJ/i+12WAth
         13mi71bLX0bsA==
Date:   Thu, 06 Apr 2023 12:15:28 -0700
Subject: [PATCHSET v11 0/2] xfs: online checking of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080826292.616123.18366076398528767455.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Update the existing online directory checker to confirm the parent
pointers that should also exist.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-check
---
 fs/xfs/scrub/dir.c   |  338 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h |    2 
 2 files changed, 339 insertions(+), 1 deletion(-)

