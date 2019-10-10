Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6EEC47404
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 00:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 147C7206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 00:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="zt7HhYpl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="anAN8YgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfJJA4k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 20:56:40 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42939 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731553AbfJJA4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 20:56:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 032D75ED;
        Wed,  9 Oct 2019 20:56:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 20:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        MTB3tbOgvl8Yl9d3lGS9pd/NxzKnWtpRa2su3lK2RZw=; b=zt7HhYplU/LD0Wzb
        Ek/0TnLD1J/q4ktgAczvVJX+00FiPz2b/Wr6QgkWtDnlsE+vwoTIlNSM4+EJ7jM+
        cesP+y6gQGqXE6RycdbdKY5eHhAEwWCUDarwcvhmU1HYo1UV0SiJqTfXsidacmpb
        EjSobYmmNv2VQTxkYKXuGDTO4YzaBe+hxxEEZjU0aCKtUrRo/3bfvdQZMOh7tupG
        U8y55Qqez2mkgdD3EqE582cgSJ6x5cj91v/tzqWwMgYNGNVBVFKae0MrCrdkPIJf
        kW9kF/trtdAxvZItB1oU/AHG7TgQ1+yrhh+GRF0nFMddP7G0448lt28/VWuepToI
        2DmcQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=MTB3tbOgvl8Yl9d3lGS9pd/NxzKnWtpRa2su3lK2R
        Zw=; b=anAN8YgJgnzPVbi+wtY8LPx43RYxmIxWhkYZ+CSgy8cnW4S5eu2qkRBgP
        fGMJlwKYgsEMQf6mRYlmiE3u1EiuKaxwIdECcul8irBtMX+t8yAKvNkxOMfONiWv
        EWWiMUH19r8JLSNgelYSEg4byuGRPTD/1RplaK6ERPdwF/kn8HXrvVeMYtzz2753
        A/4brbiLmWyjmEVvoYQfd8WPFanFGjwvcrFARNznD0eWCALa93X6C1krJQ3u5MKO
        xiCsO5TbvY+QTKYoauJMl0FHpsAjKu7EXQQvcGmnH6XFOQM4wUA+Rdr4kQycrJy3
        /p/Pp4kzvt2aKETOHq9MEOEdpAb/g==
X-ME-Sender: <xms:xoGeXdB7DRS60duhVNhTmfZuus8B5PNNrelS42pyUJP41ZOgifLqPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xoGeXQgC0Pf_iij6LzGiTef3q2lt2BiTDe5y15DSqqLX1ukvO0oKJg>
    <xmx:xoGeXQdbmnF_yal5GUI8vQXvry1pFdhS2B_ZWuqb0a8LaVWTK_e4Ww>
    <xmx:xoGeXVlg-JXfJViVQSehwRIZ3uhub-sqiE6-byGOWdNEH2YtySZIXw>
    <xmx:xoGeXTsw85j1PtMlDdH7vNQOzYOTHae3x6A8G5mqgNJp1Yn7yxQ1Jw>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46BC0D60057;
        Wed,  9 Oct 2019 20:56:34 -0400 (EDT)
Message-ID: <1a612dc55f81e2dbde1b72994399bdcbaee5b2d2.camel@themaw.net>
Subject: Re: [PATCH v5 04/17] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 08:56:31 +0800
In-Reply-To: <20191009144817.GA10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062063161.32346.15357252773768069084.stgit@fedora-28>
         <20191009144817.GA10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Wed, 2019-10-09 at 07:48 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:31PM +0800, Ian Kent wrote:
> > +static const struct fs_parameter_spec xfs_param_specs[] = {
> > + fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS
> > log buffers */
> > + fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log
> > buffers */
> 
> This has really weird indentation, and a couple overly long lines
> below.
> I'm also not really sure the comments are all that useful here vs in
> the actual parser.
> 
> Why not:
> 
> static const struct fs_parameter_spec xfs_param_specs[] = {
> 	fsparam_u32("logbufs", Opt_logbufs),
> 	fsparam_string("logbsize", Opt_logbsize),
> 	..
> };
> 
> ?

The indentation is purely an effort to preserve the comments.

I originally interleaved them in the structure declaration but
that was even uglier and naturally attracted comments.

I can't remember now if there was a specific request to preserve
the comments.

You suggestion is to add these comments to the case handling in
xfs_parse_param(), correct?

I can do that if there are no other suggestions.

Ian

