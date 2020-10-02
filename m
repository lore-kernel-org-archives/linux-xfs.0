Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AA0C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE6220796
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJBEkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:40:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48079 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgJBEkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 00:40:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E7395C00D1;
        Fri,  2 Oct 2020 00:40:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 02 Oct 2020 00:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        qh9lBoZexUn0xPP8qSNqjHLWPaJJm/9ZhH4XsITRRpg=; b=WdDYUTOmBVSRDHU4
        Qv18L7/S/vVVhtRRjibA0RA2WecYgzSyAnOest0h0n2spmcCbb8Be4sB6vgMWvjS
        n9eXGYpPwCZgK6wf6HQsUuIx8KRcJqkCx+T2U9oYtzSy3+g75pjonFgAviAgJuh1
        SiCymE0Vk8IYqniwWCf0mJ1OWF6oesZAPNdzix8czv12K9ge81ieaD+u+582pHQB
        Pm5TnnlH+NkmHqG94Auq31V+rivfPewp4W696Ahnvi/0+W4IiT1WFIYMQZ43mDHi
        b5vUbHgBmmXwcOy3tjAs5vYhbHUPVsrTo5+OZdufNJt3eQDXMJ6ePfIians9p49B
        nBU9vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=qh9lBoZexUn0xPP8qSNqjHLWPaJJm/9ZhH4XsITRR
        pg=; b=bFbOnjiqUlxVsSM2uZfC7WEn0aN9ulYARkkqm08PXtBmeXEchacVkhCI6
        xGcUScY6vui4AfVLMkxo2Es2+3IuoToh8bDL8tQmhJtM1zLPr35tmfHh6A8OBxE6
        J0HsB4ctV3WagGkOrYQa7C1sXPtJhBC2+yA3jBu12zdeX0TljJXQ/ziTa9yzUksL
        8f37Hnu0hxE1WRVVvkL2OVI3z5FTcu1IYltNr8XONtYUCXXRcKvLzj1gIA+43rxh
        0xyoOGMJLHn4LFAy6MUB2OROxm0iqbsgOv6OQgKstmPoxaL5wKfcmGmZ41bv5TyN
        gRDwjQk+mTcL+qgg2s7KDVRbfFo2g==
X-ME-Sender: <xms:Kq92X2o0Kd7Nz6tR82eXs13eMKbHCEiisYbB1ld9xez4geZoPeCKIQ>
    <xme:Kq92X0qpUCJeXhUmXAPcvqz7kyatnNZM1rkapETSZdFpIJW9G5hOfcbJvwqyRoTXQ
    Ii9ReBeJGkR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfeehgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvdefledrvdehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:Kq92X7PoCEhvTkjhQxMc5nHHAiW1-9e6vi8Zh7kB9-wNJXshez2rmg>
    <xmx:Kq92X15Sw7CMZ4Cbh9OhBlg6U7YvJCv2GS0UdJZSA1fxdH4Xaf9nPQ>
    <xmx:Kq92X15KFm6J6ER781tYrzmULVF3gSNuLBCf2Kvy1otQiPMJVbo8uw>
    <xmx:K692X3ECgDBZ-8hCDsp-bcaGgPopu5kLlYbHvyGwcyretZ8DfLaROw>
Received: from mickey.themaw.net (106-69-239-253.dyn.iinet.net.au [106.69.239.253])
        by mail.messagingengine.com (Postfix) with ESMTPA id 928093064683;
        Fri,  2 Oct 2020 00:40:09 -0400 (EDT)
Message-ID: <f2dbe235ba34db4568e93c87edcd529a606e20ce.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Date:   Fri, 02 Oct 2020 12:40:06 +0800
In-Reply-To: <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
         <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
         <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2020-10-02 at 10:27 +0800, Ian Kent wrote:
> On Thu, 2020-10-01 at 16:22 -0500, Eric Sandeen wrote:

snip ...

> > 
> > Backing up a bit, which xfsprogs utility saw this behavior with
> > autofs mounts?
> 
> IIRC the problem I saw ended up being with xfs_spaceman invoked
> via udisksd on mount/umount activity. There may be other cases so
> I'd rather not assume there won't be problems elsewhere but those
> checks for an xfs fs that I didn't notice probably need to change.

Looking around further, there may be another assumption that's
not right.

It looks like xfs_info is being called via udisksd -> libblockdev
and the xfd_open() triggers the mount not a statfs() call as thought.

I can't see why I saw xfs_spaceman hanging around longer than I
thought it should so I probably don't have the full story.

It's a bit academic though because there are good reasons to ignore
autofs mounts in the libfrog functions, platform_check_mount()
and fs_table_initialise_mounts().

If an autofs user has large direct mount maps there can be thousands
of distinct mount table entries which, mostly, if not always, serve
no useful purpose to utilities. They just add overhead so getting rid
of them at the earliest opportunity is the sensible thing to do.

In fact, before the mtab was symlinked to the proc mount table, I
simply didn't update the mount table for autofs fs mounts so they
never appeared and there were never any problem reports due to doing
this.

I could go on (and on) about this, but I'm starting to digress ...

Ian

