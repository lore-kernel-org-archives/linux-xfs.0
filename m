Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E45C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D1102073A
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P3IPABbF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgBUOLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:11:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59254 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUOLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=2BiIpatK+dZuW2zjP6EIk8sRgyGya9eA9Y60EBNq+ak=; b=P3IPABbFhupe8mlhRyWchvEhOV
        b5C4kiLSaeoME4cNf9q3Jece2rYu0h/dhHbk08p/An7dR83AwJcVIuv9XS9DSMbZyooWaCVXwx0P1
        +1zvAWOYUtF6kE7sl3QaTkEZbtvQfDfrFhI0t8iU6jn5UyXeYZg2pvZR1q2+IBYaOuswnwxxbGUnU
        9QsCyYWfe8WNFruv3mHEn4j3QdF+GP7k/LO5/WamR3EvE6FU4xBL8p87BimT5wGYzy9IpRICrhMaE
        ht6AQ2lJDiIdn+3tueY4NRiMqd+NW77EnTYkt/L6TDa8S9BJBvteAl6RUr2nj0cQEB1e5UWGtli4T
        d++O5Y4A==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5922-0000G6-TG; Fri, 21 Feb 2020 14:11:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: clean up the attr interface v5
Date:   Fri, 21 Feb 2020 06:11:23 -0800
Message-Id: <20200221141154.476496-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Also available as a git tree here:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-attr-cleanup.5

An xfsprogs tree porting over the libxfs changes is available here:

    http://git.infradead.org/users/hch/xfsprogs.git/shortlog/refs/heads/attr-cleanup

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
