Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D7DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiD1M61 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346716AbiD1M6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:58:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACFD2A27B
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q3pxH8m7pXrXsMf6uzXYkY+UYC
        6fUoBM6TVgk2fde8aeb0jSZm6VVvla1VPWXr3WuGKOqowRit29uqc4PPvNMgnofYSeFNWyNehpYKO
        m0S/JyCAhmS7UvZuE1Oo5LHeVmZUgPRiBgFeoVwWg2dBIau+WuRGIdHd3jUbrD73Ihrtrc6gILQoC
        Zq6MinrxqtAI3abY4O2s/fBQJx3p7d1kR+ZHWbeU/a4uRhq5xRjzS0WbqO1irpwBJbwpcCfgAVFIa
        tf6cSttSSBsbzAwyAT4puX5S1hTP2xjiPo9isS8pdbTdR8YSpErL6QSnzzcYs9Hkr+weOhdgUjv+t
        4IbEmAJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3fo-006uok-GR; Thu, 28 Apr 2022 12:55:08 +0000
Date:   Thu, 28 Apr 2022 05:55:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: reduce transaction reservations with reflink
Message-ID: <YmqOrDHVof+5RS9d@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102075178.3922658.11792444708694506676.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102075178.3922658.11792444708694506676.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
