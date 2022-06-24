Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664C1C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 05:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiFXFUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXFUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 01:20:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D5F62C16;
        Thu, 23 Jun 2022 22:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CmZzTyGW86kGCLkluUVgPh+OfAMYe+DuVFM8OGCdpCU=; b=fA6geQpWNnz816AjU0KE7HCJMS
        iEK3mYQ1E1tZfmJ7Lpzb4e5cD9EEafs31PkdzJyZaBUR3cQTU6JyzFLYgZYlrlb6dm5jb3s9Xe/pY
        8QXUWwzdNlTgshaiYxclesvtpCci0unpNLP8ZzyvlMpILHVC4rpq1vBIfAHf8cE4AsPbALZ+KZD4Q
        fdYMd1W252YHFaaBLb0E/y5qKnh85QjKG+uDZ0TaKbM6qWzhXLBYP/jSf/Hkj08pc2JEHGXZclcna
        B6I+bBnGzZ55M1zRGRY21gllsIP0+R/jWWDigRww5M61EuOcgZn+8JCGbeljlc/hDsat9ziNc0UkY
        mAk17aQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4bjZ-000ZoG-0c; Fri, 24 Jun 2022 05:19:57 +0000
Date:   Thu, 23 Jun 2022 22:19:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org
Subject: Re: [RESEND PATCH v9 06/14] iomap: Return -EAGAIN from
 iomap_write_iter()
Message-ID: <YrVJfPWQ29hYJ03M@infradead.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623175157.1715274-7-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 10:51:49AM -0700, Stefan Roesch wrote:
> If iomap_write_iter() encounters -EAGAIN, return -EAGAIN to the caller.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
