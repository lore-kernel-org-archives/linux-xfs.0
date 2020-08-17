Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B32C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 477B320772
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UPupWvTS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgHQHHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 03:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgHQHHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 03:07:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82822C061388;
        Mon, 17 Aug 2020 00:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Muh/cDHM6s6tE0utzWJ3vrzs0mWs5xxvECuE/7QcT3Q=; b=UPupWvTSzF9NGz/RjpeVhIUiEv
        JT3A8ZhTsPbnfWU2Pe+bPcfzeBX1Ddu5bhOzJKqi5IWk9cpjLsuqkNR2U/IzJhSCNNGSophxaBUcH
        nRzqFMGlc0bYIrx/pWVhLjcUcdsEgeqWbTmjWfZKhxU5KsWKjIbJTW6j1RtNSm+gbl/0zfna0gHNQ
        weTG9kURMCXPqff/b0fCcTTKz80G1yFGyHv09+nF51BU73wJFC3IArzzzQIYuTKz9n2fBXmOk6VqL
        8O7nM2UT9KTXR3vB+ZuQUXGb0XK0QOQFqAJXR7iurOsY7ocbw6uGufO+daHAdnsWcZP8LIdx6vkAY
        AjF39yOw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7ZEs-0007bN-Vb; Mon, 17 Aug 2020 07:07:27 +0000
Date:   Mon, 17 Aug 2020 08:07:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, khlebnikov@yandex-team.ru
Subject: Re: WARN_ON_ONCE(1) in iomap_dio_actor()
Message-ID: <20200817070726.GA28668@infradead.org>
References: <20200813054418.GB3339@dread.disaster.area>
 <B409CB60-3A36-480D-964B-90043490B7B9@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B409CB60-3A36-480D-964B-90043490B7B9@lca.pw>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 03:52:13AM -0400, Qian Cai wrote:
> > No sane application would ever do this, it's behaviour as expected,
> > so I don't think there's anything to care about here.
> 
> It looks me the kernel warning is trivial to trigger by an non-root user. Shouldn???t we worry a bit because this could be a DoS for systems which set panic_on_warn?

Yes, we should trigger a WARN_ON on user behavior.  a
pr_info_ratelimited + tracepoint and a good comment is probably the
better solution.
