Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33514C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 089B520656
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZKUiuD9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgGORqm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 13:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGORqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 13:46:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0309AC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 10:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oRWukn0BCZ28mR2hFn4Vz8LgbRpVVEUWn/sgk4kk0k0=; b=ZKUiuD9JbpeMkn1YI022aQv9Se
        220b8qI0OGX/ypdQ/gF27rM/GNDEbse30VMhKoGbFOovxYKBJK9XOXSR3zdZ5vGX7qEvB6pxU8d50
        9xhqPEie1/B0mb6YJ/18l1MVz8l/mxiz5iwe9aAlPImtVv5juPzEgJcdhb8ibIWBD1ZsEB6UiZ6XA
        NtILZAM9mmO7MSGpo7vgecVGZCDy/qQ+R3FV/ZH/wpjIXTDkKsZB0lNPnwVEFAZoW1qQ+FG8H2xBV
        sdLLxcJxDRRT+txja9qrhgYXKNdkutqN2dgG/yVJ7EsUnHDWLBKWTFmgxdN0SxBPx4T3VwDH/qiyX
        Cj2ExTEQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlUL-0003ZQ-Mq; Wed, 15 Jul 2020 17:46:37 +0000
Date:   Wed, 15 Jul 2020 18:46:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_copy: flush target devices before exiting
Message-ID: <20200715174637.GC11239@infradead.org>
References: <159476315531.3155818.235241123940681968.stgit@magnolia>
 <159476316158.3155818.4118699262119926332.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476316158.3155818.4118699262119926332.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Flush the devices we're copying to before exiting, so that we can report
> any write errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
