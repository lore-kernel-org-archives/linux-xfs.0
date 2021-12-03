Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE24C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 07:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbhLCHaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Dec 2021 02:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343808AbhLCH37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Dec 2021 02:29:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21DEC06174A
        for <linux-xfs@vger.kernel.org>; Thu,  2 Dec 2021 23:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J8ZpJ7IEUIssWYiGn4JUZV8YSFiAwMHHgkpgEGYWdV8=; b=EcBXeU6KKgp3c+0n1TowsuTVe7
        M+qOrOi4ZhWSV2+OJ8lmkcgzojziH8ickey96KZv4KReYa8u+Suk6qxdwFjwevKR3GD61J1X6TKZb
        NIH+TZ9LD5J6+Bm+CVmv4dmhqWQlFUKYhPnucwo0w1BC0WSTdvItH0mnnQmdhzwVYoawBF+XYWw9/
        C34sup6dzheoMfwse2np3WNHMnmeYylRdiUV4BWu25zNKa+t0s08eBl6lm4PuMWMPf3q0SQxyAK9K
        ZFZM6l3UZJTsgUQXy1CXcswSyAg8W7fJDHH/E8XKZmMESsq4DpuwkzznEQ6XyXBn/SneJD16fosTb
        jOsdiMUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mt2xj-00Eggr-VI; Fri, 03 Dec 2021 07:26:31 +0000
Date:   Thu, 2 Dec 2021 23:26:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxcmd: use emacs mode for command history editing
Message-ID: <YanGp5QnaC++Kjs2@infradead.org>
References: <20211201175846.GM8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201175846.GM8467@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
