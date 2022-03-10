Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A775C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 21:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiCJVyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 16:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343617AbiCJVyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 16:54:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D934B18A793
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 13:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89974B8287C
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 21:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E4AC340E9;
        Thu, 10 Mar 2022 21:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949208;
        bh=4/andI+7TUlomjZu26EI1hg5GKtgF73ycAqdjXVhXXw=;
        h=Subject:From:To:Cc:Date:From;
        b=BCmiM+fGrWoQEGl16Kdl4qVOOztNuUsaoWewkJmqx/du/F9butI26njH2NblErKfZ
         Z9yXEAoz8/aLhHOBK0dHq0nhJab0nEPwQpcptlRgwN7yqjwOJdI7SGBLkuqPJSregt
         a5P/Ui8KWonQm1O58roQBD7b0ASp7fmFLvc3h4vJs9Njr9WJFsDAGumUfX21q85RXE
         QBmeIfjcflmRhe9AYdPOFuEHua+vxvOnfyUkWozIskgRDIq+7weOPXwBHx0yb3ps07
         jd9dj3mLdIUkGHhdYx1X5Q2cj1FmZ2FrK+qeJcE/Vi9oHfC9slHlZPw5qQ9hVTHZ+p
         eq1hRG8j9KOOw==
Subject: [PATCHSET v3 0/2] xfs: make quota reservations for directory changes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 10 Mar 2022 13:53:27 -0800
Message-ID: <164694920783.1119636.13401244964062260779.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of weeks ago, I was triaging an unexpected quota counter
failure report coming from xfs_repair after the online repair code
rebuilt a directory.  It turned out that the XFS implementation of
linkat does not reserve any quota, which means that a directory
expansion can increase the quota block count beyond the hard limit.
Similar problems exist in the unlink, rmdir, and rename code, so we'll
fix those problems at the same time.

Note: this series does not try to fix a similar bug in the swapext code,
because estimating the necessary quota reservation is very very tricky.
I wrote all that estimation code as the first part of the atomic extent
exchange patchset, so I'll leave that there.

v2: fix unlink and rename, since Dave suggested it
v3: enhance comments, clarify variable names

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-reservations-5.18
---
 fs/xfs/xfs_inode.c |   79 ++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |    3 ++
 3 files changed, 138 insertions(+), 30 deletions(-)

