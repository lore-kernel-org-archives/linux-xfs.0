Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCF5C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 509BD24656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="frLWpf8k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBZUXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:23:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBZUXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=v3sPhHblbT7BziSuk+ZZD31diiF9yZVjeaOppxqSxHk=; b=frLWpf8ktrqn9wKUeDoWIokfhM
        5bfW1k/pibKBGTg4Hp+ejAawrZOFb9T8l909Tb4w53uS1HQUGaE5HDgo0cztbJSF6t/uO5AJQ+pfM
        we1ATLkTry+OPDAFWyOruC5JHtFofdH0MMNLxOynXrBfuTbSSr5w93QYV0sUpmN4wPrtoml4hxf5K
        gqhs8ADSKwwrS2mpy5QsOlb2RCXR6PMmWVfkHn6rAvSaVlZqI1p+wb+umX8e+A2vSiSZnSMiI2V4V
        bEJMGEhzF8c0ZmFsMSDzf8C2aoANH50zZ8xPKPwm05x/O12njQWSx0e+PhRic36VIMsUqjHRAxjfL
        ALL1zolg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73DB-00088G-8t
        for linux-xfs@vger.kernel.org; Wed, 26 Feb 2020 20:23:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: clean up the attr interface v7
Date:   Wed, 26 Feb 2020 12:22:34 -0800
Message-Id: <20200226202306.871241-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Also available as a git tree here:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup.7

An xfsprogs tree porting over the libxfs changes is available here:

    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup

Changes since v6:
 - spelling fixes
 - better set acl buffer sizing (new patch)
 - lazy allocation in the attrmulti ioctl (new patch)
 - use unsigned int for attr_filter everywhere
 - trace attr_flags

Changes since v5:
 - don't move xfs_da_args

Changes since v4:
 - rename the attr_namespace field to attr_filter
 - drop "properly type the buffer field in struct
   xfs_fsop_attrlist_handlere", this was causing too much discussion for
   a trivial cleanup
 - improve a few commit messages and comments
 - improve the ATTR_REPLACE checks a little more
 - turn the xfs_forget_acl stub into an inline function
 - fix a 0 vs NULL sparse warning in xfs_ioc_attr_list

Changes since v3:
 - clean up a cast
 - fixup a comment
 - fix a flags check to use the right flags (bisection only)
 - move a few hunks around to better spots in the series

Changes since v2:
 - add more comments
 - fix up an error handling corner case in __xfs_set_acl
 - add more cowbell^H^H^H^H^H^H^Hbool
 - add a new patch to reject invalid namespaces flags in
   XFS_IOC_ATTRLIST_BY_HANDLE
 - remove ATTR_ENTSIZE entirely

Changes since v1:
 - rebased to for-next, which includes the fixes from the first
   version
