Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9545C4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CC922072D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="epqx2T3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgCWNHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:07:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgCWNHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=dM39QosUVAH2ljENskW2WsoR0u3VF1JWeBLyvoos9FM=; b=epqx2T3bROomvt5h2E38o6Dmy2
        Pi2yBtk4NUgyvXrur74NrTPwKSr2j4dTbVAo7Kjxz8bQGXLKosjycL2p/gaabcBzETM0nWuEX/8TN
        oMzaKbLfWUvK8D4fx/r18zbTupjXU6CTsC8es9FnEQHsXequ4/pim0Zynh1KawZtzKa3+pSZDJI5J
        laOUeNgFJRrk5tBd1kBMqztdKD/2VOwGqUbLc5DbgW52z9gIN4znNcWt8fOlQwoOI1anZBjIiuf+b
        XimSSUDtFURDK0o8zN21W9rIEELqtkAyZ585Iz8LranHgoLIhLm9RI+Nj0Cw1L2Ap18C8KugoxfPi
        KD/1GD6w==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGMnM-0005hR-TR; Mon, 23 Mar 2020 13:07:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com
Subject: xfs: clean up log tickets and record writes v2
Date:   Mon, 23 Mar 2020 14:06:57 +0100
Message-Id: <20200323130706.300436-1-hch@lst.de>
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

    git://git.infradead.org/users/hch/xfs.git xlog-ticket-cleanup.2

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xlog-ticket-cleanup.2


Changes since v1:
 - taking this over from Dave (for now) as he is still injured, an it
   interacts closely with my log error handling bits
 - rebased on top of for-next + the "more log cleanups" series
 - fix an accounting error in xlog_write
 - use a bool for the ticket header in xlog_write
 - add a new patch to split xlog_ticket_done
