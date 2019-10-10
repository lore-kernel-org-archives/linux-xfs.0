Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAC1C47404
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F25E2086D
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="TqIqCtWJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="inbjMDxJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbfJJBPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 21:15:30 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49455 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731155AbfJJBP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 21:15:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C5A70620;
        Wed,  9 Oct 2019 21:15:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 21:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        jwFKTtRbE3XZ2gucEPNrGHAxkXDQQigCe3IoO5zF39M=; b=TqIqCtWJ5Auygv99
        cU4V7t/z1gbtnt3ufEbQ2680PgW9ePWpW5S2YcQKW1pcwNgacUB7AGQ+h4cVWkcH
        yzu44n/KjZg9/DI2r6xGIgQJlzsazyePzP2l7PvOepoG3dy720Yvfh8aPgIH25Ys
        b1HKKYjMz5G41yYtaq+kEuL9Py+APWg/QFhLDCHiFBr6ggUeSjqKaROLUAxMO94r
        gTsNBFRuo5v+1uK6fbHGWAVck+zTnNPUrT4V/hWk6VKpwJzZc5DiiRwO5E2t1c5v
        rYqgLU4HGpcUAjSy5YzIIMv4/Xb733lgmZBzs5WnBWPyN25b8G3ZBkEYd9Z9cCo9
        FxQUXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=jwFKTtRbE3XZ2gucEPNrGHAxkXDQQigCe3IoO5zF3
        9M=; b=inbjMDxJN5Sj+2xMNXyGmJESPAqOafv6biycahtfWTe7g7k0sJMtXQYpi
        i0M4+tbKccQ5w4qf3IaRBiK6bbnU8Cn+LCOA7n2MyWu8ruYT+fUesFYHEQ3kxo9o
        2ZB9xT/Dsh4wtCCbDCL+EEZJ61bLvaFzZQqXdcRSQNMEeNANXlTgnwyN62GKXRJR
        g+83z9dul5nnVzrmchJUPKmXLPpYAGH51iYlx0U9yqoDFcR2yirYlTO+25kL0xj1
        017XCVJxZRDfoduuJ8BYQxPvfcBV+AsVvAObOCz7BZOIrtB9PXsWUs05xLSeeA6z
        WJIN0hkfqy6AMWbxBWm47kNiQujTg==
X-ME-Sender: <xms:L4aeXbQiqowW3IEOyJFX2n3nf3imrR9P0MfXDXiwrE8aJBgklnGMcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:L4aeXebdnRmDbdTciB9Onud88pMLjbqLCenJxntZa7F6LReBQ8sShA>
    <xmx:L4aeXfjIjWVsVdFWqK-Ex8A11HUhn1DiK8W44tKrTOx-SZtVWY-8NQ>
    <xmx:L4aeXTi5hKwaTbkLnmWiLtbt7dgOG4Annnil1nnl-u4AC8_USslimA>
    <xmx:MIaeXdsrRJuqXGJrV0KSiALPCvGU5eVkbASNfzY4ifQIfKG33AUhfQ>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7343FD6005B;
        Wed,  9 Oct 2019 21:15:24 -0400 (EDT)
Message-ID: <12df6f88486bcae8b0b0390d811e1380beb2e206.camel@themaw.net>
Subject: Re: [PATCH v5 16/17] xfs: mount-api - switch to new mount-api
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 09:15:21 +0800
In-Reply-To: <20191009151008.GJ10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062069523.32346.10316532216437532792.stgit@fedora-28>
         <20191009151008.GJ10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 08:10 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:31:35PM +0800, Ian Kent wrote:
> > The infrastructure needed to use the new mount api is now
> > in place, switch over to use it.
> 
> I find it weird that you add the methods and params table first and
> think the series would be a lot easier to understand if you just did
> independent refatoring first and then a big switch over.

That sounds like a good suggestion.
I suspect it'll take a bit effort, I'll have a go at it though.

> 
> > +/*
> > + * Set up the filesystem mount context.
> > + */
> 
> Not exactly a very helpful comment, after all it is a method
> instance..

Yep, I'll remove it.

> 
> > +int xfs_init_fs_context(struct fs_context *fc)
> 
> This should be static.  Btw, for most of the STATICs in the series
> we'd
> just use static these days as well.  And at least for method
> instances
> STATIC actually never made any sense..

Ok, I'll fix that.

Ian

