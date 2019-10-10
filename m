Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619E5ECE58C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 381DA2086D
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="kNQR8AZS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="i8JF7t3+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbfJJBMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 21:12:34 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53511 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731553AbfJJBMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 21:12:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0B8FF5E1;
        Wed,  9 Oct 2019 21:12:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 21:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        gjiQSw+eCQ8ZiBF6nrQEqp8SybD1ksx6+Wl7e1qv81c=; b=kNQR8AZS4Cn85OpJ
        C0PQw6AwTp8cXB0Wg/M29DHHGO9jUMFGLZk+1Bs+EOgyBq908SsiBhVlPO76sC77
        i+bInMWAQCEUMY4Yi/5dilEAZtX1VqcHIwbjd9EkpFoKOx+1jaSuZpJsFUoAM2Fd
        UZwV91yPy35zcXeIw/XAEIXteHUIDzS7fx0HZXJ4bypv4DHOAYOTU4k4P0kjRRGI
        UjGXUZ+cSb7XVih7AvbrWCLBNAVCrK1RM1GWu3WlOqhshJBRgBFjHKranA7cgxJW
        8NZHwclp9FzGGD2xgYBxEdCa2qoiM5Cq6D6z2zKgspivAQNFyejlVLyybRIz7Qgk
        OiEopA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=gjiQSw+eCQ8ZiBF6nrQEqp8SybD1ksx6+Wl7e1qv8
        1c=; b=i8JF7t3+bUJws68+lb6j3neRlpzgZevktrhIg9gR6F/BhD8X57kX1uH88
        0/NW+VTDhlwfxrHMdIMEhP71aOr19X0FaVFAAmlCPOxj68nmvkjLIBShYUErb8RE
        8MUoImINrNoO2giy29Nuu9v9Rp+V9xqAAhIcBnwadYvY9o1pwDu1GqflxmkGYSVz
        YoBbJC1wEPtUBu2ij8yG5uwxagRq1FGj+2E44hJ7Q2p1a+U3P6FKZozjgVV6DWt1
        bL1tV1Gn/MRQL6LBfueY2bUUFFAtHpRw/dsGZpliatUdQ8jyxcXpDKzgkwtzel2e
        +w0HL5gN+Px2SvYlrbYTr+YHpBpmw==
X-ME-Sender: <xms:gIWeXdBX0NkuWW1PoKps4pVg7WYb1q5WXxs_HpLeUNN4XobFG2KtMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:gIWeXYoAcHUBdcNVE4oJh5mGdOlhHPcItJZlR2Dl_74IPPaS7TgxwQ>
    <xmx:gIWeXXmQYNBdnGt-yZVYO4--NAwDdO6DXtISmnpoP2ewGZG_ACb4hQ>
    <xmx:gIWeXYyBr-6424Df61QVphoB4JlIPBE1j5AplsizSR0j8rUVUVOIBw>
    <xmx:gIWeXUytX9XLRQkKH64tVi4OUBpPRSHUhG_5o9PABMX7Tpao_jp-Eg>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADCEAD6005B;
        Wed,  9 Oct 2019 21:12:29 -0400 (EDT)
Message-ID: <ce83c1a2e8ea735561163bc842fbce2075934903.camel@themaw.net>
Subject: Re: [PATCH v5 13/17] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 09:12:26 +0800
In-Reply-To: <20191009150531.GI10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062067944.32346.8228418435930532076.stgit@fedora-28>
         <20191009150531.GI10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 08:05 -0700, Christoph Hellwig wrote:
> > +/*
> > + * Logically we would return an error here to prevent users
> > + * from believing they might have changed mount options using
> > + * remount which can't be changed.
> > + *
> > + * But unfortunately mount(8) adds all options from mtab and
> > + * fstab to the mount arguments in some cases so we can't
> > + * blindly reject options, but have to check for each specified
> > + * option if it actually differs from the currently set option
> > + * and only reject it if that's the case.
> > + *
> > + * Until that is implemented we return success for every remount
> > + * request, and silently ignore all options that we can't actually
> > + * change.
> > + */
> 
> Please use up all 80 chars available for your comments.

Will do.

Ian

