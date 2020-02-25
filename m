Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D105FC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7FE921556
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NuDAZLnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgBYTtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:49:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYTtq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:49:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=HMJ4FvSTtHcG1GNZpsZVpzMK23Y4YQVFK2i/n6xLvhE=; b=NuDAZLnc/GJ+pcooqrZILgzsXP
        BI83mO4s88+PaDefSIys56i06mOqNvfCgMzjyBb5u/3C9gmgG0fFKFYmAq7C2k9RBhe042Gw1euVs
        6m8iLt2Vd1zii9E5TDgOUWtHpgVbgsIF6sc1lbjHzO38joik8wYdzfjKIhXN9kvtvZMsdfD84kZbu
        QmvzIzeV/TjeCcJLvuCn1i0jvnJJS8HznwTc2y1QZsoDwCR4mJTzaDerrdDZ8x7eLoY9pe/9eQFE6
        c8WQAUwDkgnzJBdKhKMKc0HmGywdt396FD6/nTLzo7HYkLMtnlqCfl53iz2G61bnAMu4QUv6nv7uL
        z2DVibUQ==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6gDC-00061b-Nh
        for linux-xfs@vger.kernel.org; Tue, 25 Feb 2020 19:49:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: clean up the attr interface v6
Date:   Tue, 25 Feb 2020 11:49:15 -0800
Message-Id: <20200225194945.720496-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Also available as a git tree here:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup.6

An xfsprogs tree porting over the libxfs changes is available here:

    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup


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
