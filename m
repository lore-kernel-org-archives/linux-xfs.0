Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A556AC433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E04022257
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgJIAz7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 20:55:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45495 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgJIAz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 20:55:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D1035C0220;
        Thu,  8 Oct 2020 20:55:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 08 Oct 2020 20:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        mSjiwVjQMxQDQl3SiV6vQK/HxLBgD0pIqntyLtmNzxo=; b=TbWkUvpQ376xOLQ3
        rqo5DWluLpGVuC4sKMrOVFR6MZiQN3VXHnuFnY8eixf/ovnUSV1uXDTd16yATFFB
        W1+TlWAlFdyaXkPo2DHPTJ0r8/rMRczwWX2+ZPJiI8JdeHY9VMFWhaoBcF0M0dWi
        RtnDuR3N+mE+jjONaEalIXgZMKRpbS9iy9dky0SVPSO8WrR4p/nmiMqPyDu4rcjz
        V/0kwzYHNmf8ZhkJzmM0Xcp3jltBtO2cUG/XDdJqOj6FcEss6skUDgiyhWxAxWT8
        t4tGpYt1FI/Ja+/dXYuxLEwkDi6s8H6FUPyeWKZhoVqKuITZbdfNIpzXawDJkgvd
        Gxzw4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=mSjiwVjQMxQDQl3SiV6vQK/HxLBgD0pIqntyLtmNz
        xo=; b=I74dUiIhGDD4tbxXRy8fKh6IJqU6DXX87ognfbeC0wZs2FUnYG+lmOnfw
        oCKZnwa7xzytQ+ynmHlPoB1ANlHEflpkWzbg+5mezyv6ZEH/4TLQnuHB7Y9HiquM
        kIi2huETnMjMr7lHq31grmqsoQ+qPs/A4wk1YLmojTnI1HW4tjrZQNXbnhtJIuR8
        ZZPI1xuF1Tr7IIOtCq63AST/5p/bPBQmAl8Bu2szCRL8vtXmtrzaJXPS3vhi8rB4
        /kdcl8g1XV5OpSWFs4D9HiWG60/zPmaPdU1J7WcmmVVCcCoP+g/diQAdwcl6Yq+a
        69Ne2vW94W8PwOY/xI6lE2tCm4bZA==
X-ME-Sender: <xms:HbV_XyN3T8wKuvNJyEQNf0aIFRausRxLscloqVGTKBv2qb4X9xocgA>
    <xme:HbV_Xw9IGdmN0XZTLh45L28A0VrFHUxUHF0HeZ5pPVvflqif0EX__x3k8gglCvaya
    sUz8fYWHcpL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvddvhedrudefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:HbV_X5SAtY3vWKydA38w5GZyqBvEHu7Axaa1ByJhTf8MaVSx4SpTNw>
    <xmx:HbV_XysjII3-pfKSmLq99mExJ_OHmpAtmsJbACYkEVhaTPUkBbZCMg>
    <xmx:HbV_X6dfL-giMIob1HjZEuqq9L3gDdMM5XvWfoaJj6jUX0NykzPoLg>
    <xmx:HrV_X0qDnDIVtuBVgtZzo2sRVxm7imER1pS8de6XEAiil9hn16VTNw>
Received: from mickey.themaw.net (106-69-225-138.dyn.iinet.net.au [106.69.225.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 922943064610;
        Thu,  8 Oct 2020 20:55:56 -0400 (EDT)
Message-ID: <807229591e708eeeff2547345dd31776849fd567.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Date:   Fri, 09 Oct 2020 08:55:48 +0800
In-Reply-To: <d4bb3e43-5ccf-8849-8b56-effc759d1f26@sandeen.net>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
         <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
         <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
         <f2dbe235ba34db4568e93c87edcd529a606e20ce.camel@themaw.net>
         <d4bb3e43-5ccf-8849-8b56-effc759d1f26@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2020-10-08 at 15:02 -0500, Eric Sandeen wrote:
> On 10/1/20 11:40 PM, Ian Kent wrote:
> > On Fri, 2020-10-02 at 10:27 +0800, Ian Kent wrote:
> > > On Thu, 2020-10-01 at 16:22 -0500, Eric Sandeen wrote:
> > 
> > snip ...
> > 
> > > > Backing up a bit, which xfsprogs utility saw this behavior with
> > > > autofs mounts?
> > > 
> > > IIRC the problem I saw ended up being with xfs_spaceman invoked
> > > via udisksd on mount/umount activity. There may be other cases so
> > > I'd rather not assume there won't be problems elsewhere but those
> > > checks for an xfs fs that I didn't notice probably need to
> > > change.
> > 
> > Looking around further, there may be another assumption that's
> > not right.
> > 
> > It looks like xfs_info is being called via udisksd -> libblockdev
> > and the xfd_open() triggers the mount not a statfs() call as
> > thought.
> > 
> > I can't see why I saw xfs_spaceman hanging around longer than I
> > thought it should so I probably don't have the full story.
> 
> probably because recent xfs_info is a shell script that calls
> spaceman?
> 
> Tho I wonder what udisksd/libblockdev is doing with xfs_info info ...

Haha, I wonder that too.

I've only looked very briefly at udiskd so far, enough to know that
its object oriented'ish factorization is enough to make it hard to
follow.

Over the years my impression is that it takes a very special skill
to write object oriented code that is maintainable/readable and
that's skill is sadly lacking in a lot of cases.

But maybe its just my poor old brain that's lacking, ;)

Ian

