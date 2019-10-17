Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAA3ECE599
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 01:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D7A2082C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 01:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="vLVMeoaZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Smlz/qq0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404055AbfJQBNi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 21:13:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41697 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbfJQBNh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 21:13:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 70E0921F6D;
        Wed, 16 Oct 2019 21:13:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 16 Oct 2019 21:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        N2HOMSyQkEA2Flrc1Llng9wi6sq2xw5HX94d/953tp4=; b=vLVMeoaZ1zL1wjrm
        tn2QTKC5GdghwazZ0MWH/uO6+n1sjL/OqQbdqSulwIvsZnEdcSQyq9fwMqzmyH4r
        zKdp65Lmdjuj4i7hQ/R6VAYs7v+SOaDUDumf9DxmjrHwtiLhCUSNg+207GXnAM+a
        YRDcINtIE5RlcAgRtJ9LmWbe5Fn4UIWQxEPkqiGDHu9kENcoVPcKISWmToMFyCGm
        NAiWZtRHaV6jW3pC8Xa+H2amYCThoC1NZEandyQPjuz76jzEcHvP5xyBNcxWoMWM
        s6f6S1ht/Dqe1g9MBPlNw+Al8XgoCShQm1rpMExtsUc5Aqqy4pxKfA6yLwJTk7OC
        Pz9v1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=N2HOMSyQkEA2Flrc1Llng9wi6sq2xw5HX94d/953t
        p4=; b=Smlz/qq0xl//8yqM1lNQCfS6Hh4bs4pakX7BVZD8agdeggnLocnRp7/Gv
        hMB9LBKBPc09l6d3jYWpCLvHcY4wMVdYg117Z51OIbAc9VcwYU4ziiJHbo10wPam
        0e/zfB5E+V2Ibh/KtydHAwYbihqVzGDrNEKnmSmkQjbMPR0gPSpznykl0YiQZYYI
        P6/V1iTFVjVibUX/+MFuTKlDjizgMSEi5AGg9R2WwU1fGFxCQu4CyUFgkghpHcj9
        3lzbwyn9uEeP1GkD0IyPOaUKBKPCdrLOI3ArYnufX+sf/pGXRan1bGNeMzcnvMS7
        +xZ5wfm2WqP4jG+JZC1r6eoWPQ0og==
X-ME-Sender: <xms:P8CnXXm5mSeWzl6xDFdks3_ZRslj-qMFb6l6PJSAP9zmOmFjy6hTYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:P8CnXZTKkq7NffdIEEk7UouVLnDOatsuCvNdX6rVKeJBzNXhlun4UA>
    <xmx:P8CnXbCsa4xkDKM37e2C0GzkLxW4bVEcFYOTJDaXWUKcAlPOjBtf0Q>
    <xmx:P8CnXSws3w4KSTnNVNT0-EwYIrru2b8mW6LNk59J1is9uFWnHOdlRw>
    <xmx:QMCnXR29Uf5wPjhD5nn7CTu3GeZAbH-AqOy2mN9Q1fgiWZeBMS-9Pg>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF7FFD60057;
        Wed, 16 Oct 2019 21:13:32 -0400 (EDT)
Message-ID: <322766092bbf885ae17eee046c917937f9e76cfc.camel@themaw.net>
Subject: Re: [PATCH v6 12/12] xfs: switch to use the new mount-api
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 17 Oct 2019 09:13:29 +0800
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
> On Wed, Oct 16, 2019 at 08:41:48AM +0800, Ian Kent wrote:
> > +static const struct fs_parameter_description xfs_fs_parameters = {
> > +	.name		= "XFS",
> > +	.specs		= xfs_param_specs,
> > +};
> 
> Well spell xfs in lower case in the file system type, so I think we
> should
> spell it the same here.

The problem is that this will probably be used in logging later and
there's a lot of logging that uses the upper case variant.

OTOH if all the log messages were changed to use lower case "xfs" then
one of the problems I see with logging (that name inconsistency) would
go away.

So I'm not sure what I should do here.

> 
> Btw, can we keep all the mount code together where most of it already
> is at the top of the file?  I know the existing version has some
> remount
> stuff at the bottom, but as that get entirely rewritten we might as
> well
> move it all up.

Yep, sounds good.

> 
> > +	int			silent = fc->sb_flags & SB_SILENT;
> 
> The silent variable is only used once, so we might as well remove it.

And again.

> 
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +
> > +	/*
> > +	 * mp and ctx are stored in the fs_context when it is
> > +	 * initialized. mp is transferred to the superblock on
> > +	 * a successful mount, but if an error occurs before the
> > +	 * transfer we have to free it here.
> > +	 */
> > +	if (mp) {
> > +		xfs_free_names(mp);
> > +		kfree(mp);
> > +	}
> 
> We always pair xfs_free_names with freeing the mount structure.
> I think it would be nice to add an xfs_free_mount that does both
> as a refactoring at the beginning of the series. 

Ditto.

> 
> > +static const struct fs_context_operations xfs_context_ops = {
> > +	.parse_param = xfs_parse_param,
> > +	.get_tree    = xfs_get_tree,
> > +	.reconfigure = xfs_reconfigure,
> > +	.free        = xfs_fc_free,
> > +};
> 
> Should these all get a prefix like xfs_fc_free?  Maybe xfs_fsctx
> to be a little bit more descriptive?

Good point, since it's struct fs_context* I think an "xfs_fc_"
prefix on the context related structures and variables would make
the most sense.

I'll do that too.
Ian

