Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865F3CA9EA0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 03:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5788B21872
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 03:17:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="dsKptBE7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HHZ51f2v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfJWDRP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:17:15 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47991 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbfJWDRO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 23:17:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 915C121249;
        Tue, 22 Oct 2019 23:17:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 22 Oct 2019 23:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        sB+FwMOb8WDwEChDGbsOssPSbm+0m2Ac8dmszzAgeQw=; b=dsKptBE7qKvjSF8z
        jSb1YEFaowBg4M+qHCwaD5Gii6LumY15/Gc8i98L1SZbKHHWNbxsl0+3RDCR/QMR
        atYeDWCdW2miiWRlq27hnSckugN1On6apsbvQkSbPXxZQUBJnt8E6OKVwU3Ypt6o
        4WsJZWtwpzUOCP/VARwuoOHKJ327pClYozRZbAbBe1m2B15ZDtFMtUXPl0N1pZcZ
        ZCcnDFND7wNB3mRfU1T44h/F8TrsccuADrFaieB0joQgHgNBG9+1Svv4S1/Tap3Y
        J5u9zWFgx8GQPFGXsK89640CiVZ17jQFoknrK3w4ZiVkK4bYL++KxvzTdZ3wabnZ
        6A2SKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=sB+FwMOb8WDwEChDGbsOssPSbm+0m2Ac8dmszzAge
        Qw=; b=HHZ51f2veOWCl36N2EjmFDqL6HIJPwi+WELYDyoyIPiUV8aEdhJnwEmHk
        PjZXA31fuyhXsdL2SD9UTWXjgif2NV7M/DHH6/Ft314QRt1Z8++OKLy0PIW4rvvw
        OchRqzc1Eu3rXWZui6plDt8cLq5vppL00uJUp5XBRjVDTedshqb9K/geVALGQ779
        Bli2/7iCOQ27x+awVKnEwORsGAjIfcfNEiSt8mA65nvo3JBC0+lRs0xOJTtgfwKZ
        tGSlrTNePvSr6ErDM2fdnrdWR5/VJLjMvp+b57oiP4A6MCj7IRNx3LBNZjpZvXeb
        VDx8sGWIV8KAJLF45bcVEv033vCUA==
X-ME-Sender: <xms:OcavXVpilRl8JMf8n23CmTyCGnh_g2nybYVTsO--Xz0anvnKisTmLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OcavXVkFyvkM552Ybzfj0bSpfGx7i-7C4mTEoN8yBVN0NlK1ZfHVlA>
    <xmx:OcavXZy6pOEG7zzIDdvU9qlwW0dvQPGcIRaG6-8nc7qN9jxkjX2qcQ>
    <xmx:OcavXdmHMwDn2lDSPX9Ky16Lm9HfchbWsOD4zIuR88BHQVqNVLLYCA>
    <xmx:OcavXakZvOchljAj47_VHbtM4nzIqCY5rNKlbI4y83eJnwtlc3y17g>
Received: from donald.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51E25D60057;
        Tue, 22 Oct 2019 23:17:10 -0400 (EDT)
Message-ID: <650c1c763cd29cabd5716c0f0e6fd7dc6fa6eaf1.camel@themaw.net>
Subject: Re: [PATCH v6 12/12] xfs: switch to use the new mount-api
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed, 23 Oct 2019 11:17:06 +0800
In-Reply-To: <20191016181829.GA4870@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
         <157118650856.9678.4798822571611205029.stgit@fedora-28>
         <20191016181829.GA4870@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-16 at 11:18 -0700, Christoph Hellwig wrote:
> 
> Btw, can we keep all the mount code together where most of it already
> is at the top of the file?  I know the existing version has some
> remount
> stuff at the bottom, but as that get entirely rewritten we might as
> well
> move it all up.

I like the recommendation to bring all the mounting code together.

I think that would mean also moving xfs_fs_fill_super() and that
would mean adding several forward declarations because the several
functions called by xfs_fs_fill_super() appear to have reasonably
sensible ordering already.

Personally I think adding the forward declarations is worthwhile
to get improved code order.

So I'll do that but thought I should mention it in case anyone
has a different POV.

Ian

