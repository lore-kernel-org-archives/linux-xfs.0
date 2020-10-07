Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE8CC4363C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 04:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D260F214DB
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 04:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgJGElT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 00:41:19 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49565 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725981AbgJGElT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 00:41:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 39A245C00B5;
        Wed,  7 Oct 2020 00:41:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 07 Oct 2020 00:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        hd5J2/Be4IytJCrhq5331+QcCfOwWRF38cD3TmIFC38=; b=UYf1JcSwo/ldw8q8
        nUQ8mbjLQlG+Is0wmRHZBBp0DooBoz/CHAnOUx5WI4qcoGyrjT7qEIfwXxu0bPoR
        QxeX4UWLuv8o3U+T+0HcZl5taDoNa7CXpKEyclUSQJt+ZbdF4omXhmhW/XiRbAdu
        QKlG0Hwk8R0eOUADYr7T9jJTyTdsc5c/pCt9uqEf/d7FhbWq2rmPvCbAwDqHLkjI
        Ua5wgyIEv117pNDs6gaNPSuAP5T0Hmvin3vh0C2M8JayN4xgV67jhSL5h3afvtBW
        a2jRqOs7fP4mUpZ28i/Ih3Ht0Y8Nft6g/DmTT+/d/fQAdeji9v18SrA6zqjRS2jR
        EOo7mQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=hd5J2/Be4IytJCrhq5331+QcCfOwWRF38cD3TmIFC
        38=; b=lftWx27MsonmghwChOHccX00WovXTqTwc05AmqFPmSEcVGYW70ebO2NjU
        4BL2LsPczJm8TZZTAZEUAhwuPFSoIVQwobfjpmJCzksbIKRXefElPYt6aiRKurf6
        YMlUTV+WVAis8tpjPZ9koSglu2W+MJOb4WzvtdjIYGf2PPnUb3B2YI2RU40njQ0q
        Q0EmKUqgOC/QefbknGcNKaoNj2f1GE66S8X9cHunrHQtw3ZzhhHuLRlTMS3XqbB/
        eF3gmplDGiE326axBg/I4Iro0qldEc3JsKRj9sbzi0gdximot599RQV3DXbvV0+a
        CtXoC5j5pJlMXY5+LTSGMbuij+4FA==
X-ME-Sender: <xms:7UZ9X0UyKkfSa8k3DNpshTykiJHxwbjDL2nQUoe0jCa__5RyXKgBag>
    <xme:7UZ9X4mBs6t_JNCzHIhPLMOx4uVfWuuj5sPQ7VTDCScb7fTj9uYNl_OmHhooN8niv
    GHgWzAPXRok>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgeehgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvdefledrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:7UZ9X4aVe5HmJnTGNMqRF64MUKeodEFokK9MKLmHVocm5zu1N2syRA>
    <xmx:7UZ9XzV6YEr5BHceQZ9ZSPulydcDuldw0HTzdclKWGEsEEK2Lv9-0A>
    <xmx:7UZ9X-lq_zNvpJtg8kXb0ePtsRZWOIh0jQ0ZsUkksN5o7BUeGi7DJQ>
    <xmx:7kZ9X6zA8gw1YI855j9xk1BR2fk57Txnb-jJoZDLKcqWvZJd-8nWew>
Received: from mickey.themaw.net (106-69-239-238.dyn.iinet.net.au [106.69.239.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id B48863280059;
        Wed,  7 Oct 2020 00:41:16 -0400 (EDT)
Message-ID: <d338a54d247ec560d019aa9e9a7be4c8aa69db6d.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Date:   Wed, 07 Oct 2020 12:41:12 +0800
In-Reply-To: <bb1c53a5-5f96-e1cb-502d-e8e4c1e2a9f3@sandeen.net>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
         <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
         <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
         <bb1c53a5-5f96-e1cb-502d-e8e4c1e2a9f3@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2020-10-02 at 10:15 -0500, Eric Sandeen wrote:
> 
> On 10/1/20 9:27 PM, Ian Kent wrote:
> > > I'm mostly ok with just always and forever filtering out anything
> > > that matches
> > > "autofs" but if it's unnecessary (like the first case I think?)
> > > it
> > > may lead
> > > to confusion for future code readers.
> > I've got feedback from Darrick too, so let me think about what
> > should
> > be done.
> > 
> > What I want out of this is that autofs mounts don't get triggered
> > when
> > I start autofs for testing when xfs is the default (root) file
> > system.
> > If it isn't the default file system this behaviour mostly doesn't
> > happen.
> 
> Yep I'm totally on board with that plan in general, thanks.
> 
> I wouldn't worry about refactoring in service of the goal, I just
> wanted
> to be sure that we were being strategic/surgical about the changes.

Back to this ...

I wasn't thinking so much about strategic/surgical because those autofs
entries only add overhead, particularly if your loading the mounts and
traversing them later for such things as searching.

But looking around further it's platform_test_xfs_path() that does the
statfs() that causes mount triggering. It wants to know the fs type of
the passed in path so it has no choice but to call statfs().

It's called from various places originating from fs_table_initialise()
and one spot in xfs_fsr.c so excluding autofs mounts via the initialise
function is petty effective at getting rid of that extra overhead and
avoiding the platform_test_xfs_path() call.

I don't see a sensible way to eliminate this call from xfs_fsr but
reorganization isn't the sort of thing that udisksd (or others) would
have reason to call anyway so there's no real point in doing it.

So I think just dropping that first hunk, as you recommended, is the
right thing to do.

Ian
> 
> Thanks,
> -Eric
> 
> > My basic test setup has a couple of hundred direct autofs mounts in
> > two or three maps and they all get mounted when starting autofs.
> > 
> > I'm surprised we haven't had complaints about it TBH but people
> > might
> > not have noticed it since they expire away if they don't actually
> > get used.
> > 
> > Ian
> > 

