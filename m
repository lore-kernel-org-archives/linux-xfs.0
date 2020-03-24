Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF7EC54FCF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23ABB208CA
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s0CU0o0/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgCXRpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:45:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgCXRpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=PV5J0mGLxU4eiHQQnH1GkoT6GYPqXAjVUwics11qB3w=; b=s0CU0o0/4Jc1xNI3jPBkrfcUHX
        B5gTwLn0cxqfZBc4BECQJd2eTtHhW7fmpkaWaVSDioDUc9P5Jn9O7VEnPyg9dORNFwotd91SCCDC4
        1DovjJW2Ib+X8n65bh+qfeullvsEWb5pzMPZPbdKNxMJ8l2rnXXsYD55lOJxfqpQ7vwAmlYAQ33vV
        gCAalEOL/1V07s/BzLz0+YQ/Gn2mxBhcaWiHrqezMfOem0HYZHI2hBB0GGQu0IceTDYb0NEtJwR+/
        LCba3js1wSginA3rhwGFXDaoYBtJiUEyEldPSPeuqIGjGA8MdDot28mDesRzKyd3UkhKHUUXhsTSp
        SR6qTGoA==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGnbo-00021y-Vc; Tue, 24 Mar 2020 17:45:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com
Subject: xfs: clean up log tickets and record writes v3
Date:   Tue, 24 Mar 2020 18:44:51 +0100
Message-Id: <20200324174459.770999-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series follows up on conversions about relogging infrastructure
and the way xfs_log_done() does two things but only one of several
callers uses both of those functions. It also pointed out that
xfs_trans_commit() never writes to the log anymore, so only
checkpoints pass a ticket to xlog_write() with this flag set and
no transaction makes multiple calls to xlog_write() calls on the
same ticket. Hence there's no real need for XLOG_TIC_INITED to track
whether a ticket has written a start record to the log anymore.

A lot of further cleanups fell out of this. Once we no longer use
XLOG_TIC_INITED to carry state inside the write loop, the logic
can be simplified in both xlog_write and xfs_log_done. xfs_log_done
can be split up, and then the call chain can be flattened because
xlog_write_done() and xlog_commit_record() are basically the same.

This then leads to cleanups writing both commit and unmount records.

Finally, to complete what started all this, the XLOG_TIC_INITED flag
is removed.

A git tree is avaiblable here:

    git://git.infradead.org/users/hch/xfs.git xlog-ticket-cleanup.3

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xlog-ticket-cleanup.3

Changes since v2:
 - fix a commit message typo
 - move the XLOG_TIC_INITED earlier, and move another hunk to this patch
 - keep checking for XLOG_FORCED_SHUTDOWN and skip regrants
 - merge the two patches for refactoring and renaming the log unmount
   record handling

Changes since v1:
 - taking this over from Dave (for now) as he is still injured, an it
   interacts closely with my log error handling bits
 - rebased on top of for-next + the "more log cleanups" series
 - fix an accounting error in xlog_write
 - use a bool for the ticket header in xlog_write
 - add a new patch to split xlog_ticket_done
