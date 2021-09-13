Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEBBC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 05:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C8160F9B
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 05:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhIMFnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 01:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbhIMFnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Sep 2021 01:43:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ACBC061760;
        Sun, 12 Sep 2021 22:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=fmH2LXB3YYbj1yq4cqvqVQN291/Bevk7C+ybmXkGJs4=; b=MXOmqSVB4wrbkg1XuD8128fiQz
        CoUNXmPtB7i4NkqsXyoCpNKf0PDLmGLco654RxYnXy3k/+Jas+6l1fkaJCTJlza+dPHXSUR1bcvwQ
        U5MYc6d+C/rTkRV5T1wgXg9Udu/4TuAxLuuT+FXWhjn48+Rj5Y+RZfwEzfMCLdFN1Ai0aMCpsyiz4
        3CMSbgqoecqVIL41PDlOJZ3gO5EWGMXSuAqoWJPxFNfc4TMZCAg9zCEb/KSdEGfhr99nzE1BE61TA
        Lttv6IVSVLflJW+z2FG1xuZoc5VoFTVrQn3WDKcL0kho+oPm+JpRYwu6Wt/PdP412f+Z1imGtjVuS
        t5mNUCDQ==;
Received: from 089144214237.atnat0023.highway.a1.net ([89.144.214.237] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPeiZ-00DCUF-KT; Mon, 13 Sep 2021 05:41:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: start switching sysfs attributes to expose the seq_file
Date:   Mon, 13 Sep 2021 07:41:08 +0200
Message-Id: <20210913054121.616001-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Al pointed out multiple times that seq_get_buf is highly dangerous as
it opens up the tight seq_file abstractions to buffer overflows.  The
last such caller now is sysfs.

This series allows attributes to implement a seq_show method and switch
the block and XFS code as users that I'm most familiar with to use
seq_files directly after a few preparatory cleanups.  With this series
"leaf" users of sysfs_ops can be converted one at at a time, after that
we can move the seq_get_buf into the multiplexers (e.g. kobj, device,
class attributes) and remove the show method in sysfs_ops and repeat the
process until all attributes are converted.  This will probably take a
fair amount of time.

Diffstat:
 block/bfq-iosched.c      |   12 +-
 block/blk-integrity.c    |   44 +++++----
 block/blk-mq-sysfs.c     |   64 ++++++--------
 block/blk-sysfs.c        |  209 ++++++++++++++++++++++++++---------------------
 block/blk-throttle.c     |    5 -
 block/blk.h              |    2 
 block/elevator.c         |   42 +++++----
 block/kyber-iosched.c    |    7 -
 block/mq-deadline.c      |    5 -
 fs/sysfs/file.c          |  135 +++++++++++++++++-------------
 fs/sysfs/group.c         |   15 +--
 fs/sysfs/sysfs.h         |    8 +
 fs/xfs/xfs_error.c       |   14 +--
 fs/xfs/xfs_stats.c       |   24 ++---
 fs/xfs/xfs_stats.h       |    2 
 fs/xfs/xfs_sysfs.c       |   96 ++++++++++-----------
 include/linux/elevator.h |    4 
 include/linux/kernfs.h   |   28 ------
 include/linux/seq_file.h |    4 
 include/linux/sysfs.h    |    9 +-
 20 files changed, 376 insertions(+), 353 deletions(-)
