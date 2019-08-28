Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86040C3A5A3
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 00:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6E72064A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 00:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="vug4bqZa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0Wmz1SSC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfH1AzL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 20:55:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54667 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfH1AzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 20:55:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id ABCC421B81;
        Tue, 27 Aug 2019 20:55:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 27 Aug 2019 20:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        Hfg0jLEQJSx4jUh0DTerbfhqHMfgRMuu8zxpLO/OLKQ=; b=vug4bqZaq6uy/ASR
        7bAxXc3iLVwwF3Cowl2BruDMOrvVJKtoGcTyHNUZQ8ylrq4PEGi1ikO5CDVJnx80
        6hPRUQwblnpU1KYLFW1qhQ/DQ348Hqs6V5KNeH4Uo7QxQ+gYvn6AwqWVBIZbOvgC
        75S0bl+D2oLFtkg1U5Ph+rJti/dTEvKUPhdzOVPg3qVcwcEwqREAUNhBVpqKlhHZ
        ou/nC/NFkM07go4IsHb5AtcdBZvi9Rj5CukwAqHOMatcDxPb+W5jdvcAfCQjxNE9
        Z8n+8zpe5kUJmjoI/QCHBLIuBwmljF1ncJIhHTgeZLRH2Ks+RgMMZJpivoV0g0R3
        0G991A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=Hfg0jLEQJSx4jUh0DTerbfhqHMfgRMuu8zxpLO/OL
        KQ=; b=0Wmz1SSC1odbhcEDyNrM3YE2ZWLOjoLxnVAnB1FtYDurbxtLykP6XwTKX
        TUoxa/L1KmZ0459FxziJU+n+4Vedeu3zpVmg+/V3wHM44ezQpqWqQqcz5aXlinog
        z2QZKlR8bpYj5UieqOvw0x1/5yWKykAxv+OdppmDemvJ1SUO7/+MkqGUVpcpinwU
        nErkSPWs6ehL+34MzzP3No9yLPvdJ3DzAhxBXT7k9Myfst86yCJAgbplRYGrS5/a
        sg8CYDHvC/VQgsGPb8Kl3xPmnKgy9jzJl2FbuHyYsgka6EwCP3/GbJGQZEAt91z9
        faLIScm7SeebRXaorV/A6x8+7LEfw==
X-ME-Sender: <xms:7dBlXU80nC2EQy_uk0hy0qAggX3YasVL2o-jzQahp-7U_tWHGfypTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:7dBlXesF8kB2NGVUhRhOF36Suf_ZoCNW1bbZd6lcB8Y7giLUhStXPg>
    <xmx:7dBlXS3-NRgKieB5WeIOuR6wlOmfCku2khucFTinLYylhkNihGuzPw>
    <xmx:7dBlXcUTr-qhNQNEMKiQd5hAno_Tbol28Y25UOyRlirM32mKSQPW6w>
    <xmx:7tBlXeL87EWIHmM3AQRY9EhRNsV8HFb0Ay8Ono5m3vs8pPMVVxRANw>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4909D6005A;
        Tue, 27 Aug 2019 20:55:06 -0400 (EDT)
Message-ID: <bd9b7a5e0851b910290695c2cf93d8a6163df5e5.camel@themaw.net>
Subject: Re: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed, 28 Aug 2019 08:55:02 +0800
In-Reply-To: <87150884-f903-56a8-45b9-e7cd72bb3297@sandeen.net>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652198391.2607.14772471190581142304.stgit@fedora-28>
         <20190827124120.GD10636@bfoster> <20190827151058.GZ1037350@magnolia>
         <87150884-f903-56a8-45b9-e7cd72bb3297@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-08-27 at 10:15 -0500, Eric Sandeen wrote:
> On 8/27/19 10:10 AM, Darrick J. Wong wrote:
> > > Eric's comments aside, it would be nice to have some consistency
> > > between
> > > the various result.negated checks (i.e. 'if (negated)' vs 'if
> > > (!negated)').
> > Frankly I'd prefer "if (result.enabled)" or something affirmative
> > so I
> > don't have to twist my brain around !negated == MAIN SCREEN TURN
> > ON.
> > 
> > --D
> 
> I think it's probably possible to just keep explicit Opt_ikeep /
> Opt_noikeep
> and dispense with the whole negated/enabled parsing, unless there's a
> downside
> to doing that.  Not quite sure what's best, but it also exposes the
> inconsistency
> we have with flag-ish options - some have negation of defaults as
> well as ability
> to restate defaults, others don't.  (i.e. we have nouuid but not
> "uuid,"
> norecovery but not "recovery," but we have ikeep/noikeep,
> attr2/noattr2...)

As far as I know there's nothing that mandates using the type
that marks these as having a corresponding "no" option.

Not using it would also eliminate my compultion to always have
the short block in "if () {} else {}" first (at least mostly).

I'll do that when I'm fixing up the problems Eric has described.
Thanks Eric and Brian (and for that matter, Darrick too) for spending
time looking at the patches.

btw, I will get around to replying to the comments that have been
made, just not straight away, since I want to have a look at the
option parsing problem that Eric has seen first.

Ian

