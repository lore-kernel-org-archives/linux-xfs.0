Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93F1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 08:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiESIgT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 04:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiESIgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 04:36:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E042C4BFEE
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 01:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GdTPHaMfxCV0DtguStnJcxlzHo
        VCPHYkalXbdEGFmZTS8iXB3PikKO4s9Qc+4/cLbwT1YughYAsEbKjtZhS+CeECARp9MNxegMFkb+T
        7yp50nJhBqQKTMjItXvgr+gdR7AEmv6KAOPMm6irfIyFyBlAxNzJefTixHEp1riRZomLD/wkvcDvr
        PN60i6O1v/LyJsx6D7+/32ZuW6sx6Lo0GmayPu8hyWPoLvRmZXKriLP7HkkxW+VaUmd8Qw1MoE6YT
        emAMUh6ClEe19gf8tP5mTE38777GjXFG9zx4UeyuJDuk1/7P9mDgVebefmhBHxzSne2ougyvC6gPS
        lvmliUwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbdq-005tcU-Hj; Thu, 19 May 2022 08:36:18 +0000
Date:   Thu, 19 May 2022 01:36:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: don't leak xfs_buf_cancel structures when
 recovery fails
Message-ID: <YoYBgg8GKTH08T3d@infradead.org>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
 <165290013462.1646290.6497497049561091089.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290013462.1646290.6497497049561091089.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
