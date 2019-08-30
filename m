Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EB4C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D942186A
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:30:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="MkXC1SkZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Pr8qcsAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfH3Lav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:30:51 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50719 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727170AbfH3Lau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 07:30:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 78BEE546;
        Fri, 30 Aug 2019 07:30:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 07:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        tpTcNueO0tFXPnnU47P0ZRDRZVc+O+Ks697k850s4Bc=; b=MkXC1SkZPPfzghgf
        tD7JYwYLsqQwGWUxl/RISpoNazQfhxhw0P9CB4ErUntns1/Kg8u2+7qTNQzn6A5d
        rRht1P1DNPqyWOAnth5IwV/z82P5ve4Dc83uwezNIYeY+KmNOPAYVa25I+dDg7ZT
        qwNpljZ54jb+jeyQFpLp1YWB5p8inVknCK7eMbZWmjwU2PFcRFKYY2N6Mou0CQKe
        Xxaynu5+7W797uQPNLMdAzqs/B82KXhT1cSB9K0mgyvNTJCDiZCKg44F92zzX3oh
        lyXxIjODNMdLb1cH2HQ8sDYIw11AjA2Z9uP7J/akJ5qCaYFgY4C8jIwKv9dWNjvk
        EKYsrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=tpTcNueO0tFXPnnU47P0ZRDRZVc+O+Ks697k850s4
        Bc=; b=Pr8qcsAXP5jTr7ybAVDVhjAj2/4dHWeElu/BgnDPmWipAN7bOQcFIF8JK
        vBwu450gpApvQ/ttkT4hpGZ9J5eDrvmkstEKS+vA9olRr4XfhGNQMNMwDMdddiEI
        aSORT9ARArlURJrsptBQ9/AJvTQOTKg+fXqqfNpHOyeqpd3ekhz7OgG9ncxYgxfn
        PWJx02Duz2QfaXn4ihNTkk4CUHOSdWcDjG+QoAP2cWJsNGFQuL+QM6UV58wdWucF
        F7roK96XEQoNlnSJG/oePGQFfhxa6irCPxxoLlkkj0l1/F+5z/X/RFpZAIykOVF8
        7zXeFIlXNlfqIeEpsgAfd6nMWoUjQ==
X-ME-Sender: <xms:6AhpXSIe8GeoQVMi6DP64vdJ2oWqkMXyxfsaqorv_fTOTmK6t-EcfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6AhpXT-oErMoAkxebNAvTdWJdvXvhX_IJRD9FoQLHLCq2xlKw7pbNQ>
    <xmx:6AhpXRgo18OV7HmNuDU9O2k1pTfQ741eNHxg9XJciiy_1lpTVsC8Kw>
    <xmx:6AhpXSzMJhUGyhwWR9PE43A3UHI6g5rQVXMj8tBclcpfOpUeFBCvHw>
    <xmx:6QhpXVA-qvUE9kSePAq_1TkTpRgnOrJpIeIIUp0KdfzsdZwJ2Go_lw>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECFCD8005B;
        Fri, 30 Aug 2019 07:30:45 -0400 (EDT)
Message-ID: <a4bf8b47af125c1eeadfde9b53300a4fdf8fc567.camel@themaw.net>
Subject: Re: [PATCH v2 14/15] xfs: mount-api - switch to new mount-api
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 30 Aug 2019 19:30:42 +0800
In-Reply-To: <06cb4d91-4ee8-1830-02b6-c88ed83bef5e@sandeen.net>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652203256.2607.18022916035406730007.stgit@fedora-28>
         <20190828132914.GG16389@bfoster>
         <06cb4d91-4ee8-1830-02b6-c88ed83bef5e@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-28 at 08:34 -0500, Eric Sandeen wrote:
> 
> On 8/28/19 8:29 AM, Brian Foster wrote:
> > >  static struct file_system_type xfs_fs_type = {
> > >  	.owner			= THIS_MODULE,
> > >  	.name			= "xfs",
> > > -	.mount			= xfs_fs_mount,
> > > +	.init_fs_context	= xfs_init_fs_context,
> > > +	.parameters		= &xfs_fs_parameters,
> > Just a random observation.. we have a .name == "xfs" field here and
> > the
> > parameters struct has a .name == "XFS" field. Perhaps we should be
> > consistent?
> > 
> > Brian
> > 
> 
> I sent a patch to fsdevel to just remove the .name from the new mount
> parameters
> structure; it's not had any attention yet.  But I had the same
> concerns about
> consistency if we have to copy the same name to multiple places.
> 
> [PATCH] fs: fs_parser: remove fs_parameter_description name field

I didn't see that yet (ha, I haven't really looked yet so no
surprize there), I'll add it to the series if David hasn't
got time to deal with it and see if we can get comments on it
later on in the process.

Ian

