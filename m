Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A71C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359638AbiFPHjo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359698AbiFPHjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:39:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29675D664
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ls1GnxL4QRR3ySlj7zS66CVtz5
        QlDVWQYtDRr0/hmvt7TnJh++9YpW+A98zZM5rFclvQVUMMYE2wk8IjFPES/B5fQxfOTC3W6+rPRRK
        LlXNUgkWiWbK5ZrGFN0LFy2qls1jgP/w4GS7sGgiaKIkums7gn5AC53f0pAi4OHK6DZFnh5Vvj2NJ
        H6tcKqeKQJ4e2l2mpfr4l9D9B6vrFHzX4ufT3NSdmwv0z/FVfokhG4UXSt3qFVwxL3tCgyA+0Gq6P
        y4ztMQ5dCZcMLHFWX0dogt5QBe89k3yIqFcdHTjvCG0C0iDWgb3EdPCy9WkbUOvDeHUbkXzKP01t1
        0wthvUKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k5q-0016Ik-Nz; Thu, 16 Jun 2022 07:39:06 +0000
Date:   Thu, 16 Jun 2022 00:39:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/50] xfs: pass perag to xfs_read_agi
Message-ID: <YqreGu8mFen//VAv@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
