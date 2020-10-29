Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D490EC55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA0720790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lW3jEyGn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgJ2Jfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgJ2Jfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:35:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAEFC0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t/ti83ES/iYoLV/XlD7aFONb65YEwS1ccbcE0ZW2rwY=; b=lW3jEyGnQUuzp5+WdlivOyQUgw
        vcfGMhQlnTTQE79Y6lZ6TzER8bemliJ5t2/5iZJMlm9tlOBOk/M6Z/aXDza0iFqlBvaUiXHCpeZtW
        jYzH4R8c1AjsRL7QjQYYn3KnZMYbpLxLtTP9k51clwMOWbWPczJF1IVN2azwkWmLuDedYWj9aEH/4
        fh438BZnJHKq6QqPllaII7iNhAI9KnAJpHxh1SXma41TROROA9LHcGaYiq0jNyI53UhF1HImbJfml
        15GK/rhAVCEwOqay2NzO8z0fnnQQA8mL9rUYc3lA2yRwpYbRdYFrUnhzJ+AO+c0pKyu99HbszN/+6
        EKK/VFjw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4LG-0000lU-C9; Thu, 29 Oct 2020 09:35:35 +0000
Date:   Thu, 29 Oct 2020 09:35:34 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] repair: Protect bad inode list with mutex
Message-ID: <20201029093534.GA2091@infradead.org>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 04:15:32PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To enable phase 6 parallelisation, we need to protect the bad inode
> list from concurrent modification and/or access. Wrap it with a
> mutex and clean up the nasty typedefs.

The patch itself looks good, but if you touch this code anyway, the
linked list here seems like an incredibly suboptimal data structure.
Even just a simple array that gets realloced would seems better.
