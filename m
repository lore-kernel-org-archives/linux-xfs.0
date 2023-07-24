Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEDDC0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 15:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjGXPoG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 11:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjGXPoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 11:44:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60E110D
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=btAs4vfaFRL2qZDqX3yMjEbvk1Tk/aGSXPXPxawOIJM=; b=Kahd0qMiBMLn/uFYq4gFIZN/tq
        l1lqrSERLEmamm42f7u9WJxRRyKK04TRByvtoRVjK81rJlarFhbNvNdFl0FdxueK6/Nbv1JLRvzbl
        3ms90YIysqME0D0llRsMNulbjxnTSTNSsPN/AMbc2mKGUjkUMSvKBVrt5J58Qy3/EWF8j/LrS5vSg
        XZUHroolrUTaZVA+1p+JUqHUqydUNqAhMviSz5Htvtge9ofVWTdTMeguo1soRbYvSOFL/Lg2ymwED
        tzEMAKld/Ifxq3NqJdxHDR7MFlGojoi9KiQlNnE0b0+P19Lw2j0H2nkKRszGn8zqQ7DLxlOuySx1i
        VJm9RNlA==;
Received: from 67-207-104-238.static.wiline.com ([67.207.104.238] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qNxjA-004ldR-2a;
        Mon, 24 Jul 2023 15:44:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: stop exposing the XFS_IOC_ATTRLIST_BY_HANDLE uapi structures
Date:   Mon, 24 Jul 2023 08:44:03 -0700
Message-Id: <20230724154404.34524-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

this is the patch I've been talking to to stop exposting xfs_attrlist /
xfs_attrlist_end because that could potentially be harmful with the
variable sized array conversion, and certainly hasn't ever been useful.

It ports triviall to xfsprogs, and xfsdump still builds and works fine
with the change.
