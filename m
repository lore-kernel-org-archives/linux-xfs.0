Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A626C47404
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 00:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1AD9206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 00:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="bwEtgVqW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Lw4/MOno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbfJJA7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 20:59:50 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59911 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731134AbfJJA7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 20:59:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1C9EB5FC;
        Wed,  9 Oct 2019 20:59:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 20:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        Q54T7x/C2yP+arxgoiY8lqQ1fmKmf19Sp9sCHUV+XZU=; b=bwEtgVqWvtnMYMDG
        Gw74NKMG7v5/U+Xslfif4KmvB0HIw0+ellZBO4gunNPNmoUJm1wAgdnTUoNewsuG
        flzAj46H0DwZq4TvqPdcJH0dsij/s2ZzVUDqP5pxp90Ag4WxzBUCKWrVyEyoW/Rb
        KrUTV21Ej3WQ09RB8hg3WYunrWUKs6ugopv1r8M4si9tFsa/NSH52gTiApxPo6vM
        CpOnVbEWW/44h81+/JeNEkz03780aZjWaO/uBfkyRuWZrf1Ekf4y+pZAFNhOnYol
        E1NMYZRF2B8ZsVfqLsMdr1ijEJoNl118uNSlt4dB2dIigufQcLtxU/r8eIGgGXo6
        YQZlrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=Q54T7x/C2yP+arxgoiY8lqQ1fmKmf19Sp9sCHUV+X
        ZU=; b=Lw4/MOnonwbZAFj8IWrM8HQLOQ6NHNgvjazoK2CCs6UrIvRgXe71mc3DX
        MZN9e7e3oXLg2wQ3Z3Ex+0eWeDjumAQh6ZC0GyhkE7QGWMDBJHAifY/6IL2rYHeu
        wumMW5KRR6ltlmPjW3BBy41rFF3XeNGKTJT78dwsexu71rA16+fihRepUyVcDLFn
        qVwuzKnMgpoweZiYOsNx5uKWT6HZrHheqI6N7XWhjck4lydwmAOepDFr1wO83sdk
        12vpQhalKuCRicb1T+6tijBHDYVY39LGWPag+bYzqbmybxCo1tnWNBfK2+r5QDhH
        3s8RmzsE19NbGZxTmklO+/k41I7rA==
X-ME-Sender: <xms:g4KeXYwVRFke3KtNctD8f0a2CIHQcjvrpzOjVteUH1Wwhly4hLZ30g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:g4KeXW5N5sKpHpDiJC6tnLsiuG6iu-czy5dwCNdBdnjLOVK8mp6-pg>
    <xmx:g4KeXea2bHS7o39Z3FY1jg0KvNzwoSJjh_I-FEjH-81DoqVlydwc4A>
    <xmx:g4KeXbwIG0Px8rfPh0wVbd6vAD7PA1ofAlLtREFSls3VYJTeTjxF8A>
    <xmx:hIKeXXwvCnLg7WubdDt3u2ARUqFQDpXwHDoJMm0a9U6Xmzr2mmr3JA>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77DDBD6005D;
        Wed,  9 Oct 2019 20:59:44 -0400 (EDT)
Message-ID: <82008f530e0aeb6774cfbd2c9a7f2153a0945ee8.camel@themaw.net>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 08:59:41 +0800
In-Reply-To: <20191009144859.GB10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062063684.32346.12253005903079702405.stgit@fedora-28>
         <20191009144859.GB10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 07:48 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:36PM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so
> > the options that have values like "10k" etc. still need to
> > be converted by the fs.
> 
> Any reason you don't lift it to the the core mount api code?

I talked to David about that and there were some patches but
I didn't see them posted.

But it seems there may have been a reason for that, based on
Al's comments.

I'll leave this as it is for now.

Ian

