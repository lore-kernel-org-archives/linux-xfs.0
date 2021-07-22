Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED3AC6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9969361287
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhGVGBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhGVGBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:01:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544EC061575
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jul 2021 23:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kmNivVvmCPfNUH9oquDxG79MGFnye5uN7HqvtCbKgMc=; b=ga5afbaDLkjTyalccIaJ2aV+gn
        izqfzjaKs7sF7a8ZHp0uRnaqvv1UXc72DKBpvP6LtzdNmMn3oIPk96p/O1eHigEqevGGF26xEujAn
        1Ll39jEGkiYVDaeviGlqtNLfi38IOnDwLL+pM03A+5oC5fqAvPisTAuIs+5a/Cwd4l76NGzgjKWrE
        yOUIdjnbJolU8mfZlF+l2EqYgKmykf26AnI2RnbuTm6WHAVtAi+5V5GofYJvzDXJLhWKXwzqcM0kf
        uxymyV/VPrnbtIUOdQonRiP9fH6Ssk6PTsS+U0erstoJOMvUa8riEAL65zpz/GrmX9OvXzs04TQnD
        UMyFztBQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6SOL-009xw8-Tp; Thu, 22 Jul 2021 06:41:18 +0000
Date:   Thu, 22 Jul 2021 07:41:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: flush data dev on external log write
Message-ID: <YPkTBRQvVYkgccDo@infradead.org>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We incorrectly flush the log device instead of the data device when
> trying to ensure metadata is correctly on disk before writing the
> unmount record.
> 
> Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ooops, looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
