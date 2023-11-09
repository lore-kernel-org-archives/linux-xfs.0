Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD09C4167D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 05:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjKIFaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 00:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKIFaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 00:30:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696B126A4;
        Wed,  8 Nov 2023 21:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=EuOUjQnuRcQgv5Tv8L5wkxAXibpL7SxSr9JEBf1UCk8=; b=E5Y5L/SPURwspOvK1ryZxa2fOq
        dWnNKyNVYbewgS8lY4yDp+c95zKpQ6sjqgX1I4qh2oRNclt++5iOm2u9jmKwJmhIwgaQAJbNTZaBn
        Eliy2bJ0YKIv5LIJxQek3+j8QeS57oCzsA6P01cKt6zncsSWLqdcs/ZblZQKCFr2JVGhCAiuOCmZD
        nsnBRd0q5ODxEav9REYTWbYGCEpB89atG+JrGOgyYQHhSnfyLMhh4mrzdI8HbnyR49vtdhRtkiCTL
        Sy6qjWgXwpqpkt3hhylZyRxJzzst+EqR5+uJQOStwJ1oB0uSfyA9hKj63KDNP4fUF8NPyAHtwts4j
        65ml0jLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0xcJ-005KFO-0w;
        Thu, 09 Nov 2023 05:30:11 +0000
Date:   Wed, 8 Nov 2023 21:30:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-sparse@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: sparse feature request: nocast integer types
Message-ID: <ZUxuY13JnQ8IIFd1@infradead.org>
References: <ZUxoJh7NlWw+uBlt@infradead.org>
 <CAMHZB6G_TZJ_uQGm5an0-bhG8wCxpEQrUCShen7O61Q9arAf+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMHZB6G_TZJ_uQGm5an0-bhG8wCxpEQrUCShen7O61Q9arAf+Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 06:21:05AM +0100, Luc Van Oostenryck wrote:
> Such 'nocast' attribute already exists and seems to do more or less what
> you would like:
> See Sparse docs at https://sparse.docs.kernel.org/en/latest/annotations.html
> :
> nocast <https://sparse.docs.kernel.org/en/latest/annotations.html#nocast>
> 
> This attribute is similar to bitwise but in a much weaker form. It warns
> about explicit or implicit casting to different types. However, it doesn’t
> warn about the mixing with other types and it easily gets lost: you can add
> plain integers to __nocast integer types and the result will be plain
> integers.

Hmm, that's a little suboptimal.  But still a lot better than nothing.
I'll see what I can do with them.

Thanks a lot!
