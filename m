Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6F4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGKFVy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKFVy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:21:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE3913E22
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PxfQ4rXMXIExOd7+Xy9aN7nivFpgM5VgovzOolCVGJQ=; b=3Jztec3MF3sguo5eBG/wHXF0DO
        7/SjktS1e56P7VjHnhKTf5alX/eSWEw3k76JYSz7LRusNL3HDony1tN1WHnYJDjvl+peNQsYMRrnA
        ts/uqQZFYAVlqk+tbjQM3PmhphFDSMSy1u4VVj3HkfqcSxQkP1Ef2Hiyc1F2ERD/y+LJ6jZbXfrO1
        ZzZ+v0watE11qBTNSj47K18asRNaXlENg05ritPaaKlinqpyUy5fMEK1DLaPM8dLhXAl4ZfgvlZo3
        4bSb2miFomzNbfcCU55gGpNbkKYYCvTzrSJ25SfI50ZH+dmPJBi0dD2OWite15WRlE11UFrOq1jKt
        woqFIgvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlrl-00G67U-8P; Mon, 11 Jul 2022 05:21:53 +0000
Date:   Sun, 10 Jul 2022 22:21:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: double link the unlinked inode list
Message-ID: <YsuzcR6hjsxwqqrf@infradead.org>
References: <20220707234345.1097095-1-david@fromorbit.com>
 <20220707234345.1097095-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707234345.1097095-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:43:41AM +1000, Dave Chinner wrote:
>   *
> - * What if we modelled the unlinked list as a collection of records capturing
> - * "X.next_unlinked = Y" relations?  If we indexed those records on Y, we'd
> - * have a fast way to look up unlinked list predecessors, which avoids the
> - * slow list walk.  That's exactly what we do here (in-core) with a per-AG
> - * rhashtable.
> + * Hence we keep an in-memory double linked list to link each inode on an
> + * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
> + * based lists qould require having 64 list heads in the perag, one for each

I think this qould should be would.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
