Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C257FC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9466122CE3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Zg5KWpQg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XNBInWhj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfH3LU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:20:28 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51855 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbfH3LU2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 07:20:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8BED251E;
        Fri, 30 Aug 2019 07:20:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 07:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        m71ZnLgcV2sKd4B74MUstS7ZMkp+/n5YCvmlnzIlbPA=; b=Zg5KWpQgp2lwwmFp
        6i1wlj5SsMRDSD9bRQX3mS+OjxWTIzTEAEXX5wcp/dfE1inYKCidvbxAob6CiDbw
        WskUM38tDPVoBbvh9lkhcjM840TCp5niSdPvj1Yze8YLFKctBUedkBwE6sry0kPk
        yT1ymgrcewvItyxYUcHZE/kRopB9QfvWBhl3aK2YYXJAKaBsIvTycBUpAaJx0s+P
        YHQ029KB+Zwza92Ybjroep1N0u5uI/12QiiSTMa3Jqq85Xm4h9j+jiVu6O6FxxvR
        PIrG0RXtQ62KIcguOQJxUuXsVVbCgTBDHAIclLM17TNaUP0TAaDGribhY0rcV/HL
        AzGrvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=m71ZnLgcV2sKd4B74MUstS7ZMkp+/n5YCvmlnzIlb
        PA=; b=XNBInWhj31XQUdapcksZt8XDYD6P0KOlrM1/4pq0QLJAKaRiHXf/ZMjuV
        WcdNwJHCiB0YEI8hVj9HvBCc8tc2n6/MWM3UsEPzn7s+94dGXCH2KROgJVSlKmUe
        fz/yJTMFRRDXPiPWutc2E+mBkISZ81cy31epewnhoQcswZ4d0I9Mo3bnDLLRyUxu
        FKVcFB8QQ2ZGeVxfx3Xmiu+Voe7k/8lcF0QA290hnhTloAYyOPGcpF+k/pYxzm1D
        BRsCQBD4MlpTXCs1MK9d8dRoy3TyQogq7N+x331YwKpaVNIlKTm5/27PxhGkqPIT
        FFVvnf0As+GaMQR8Wud/yoVWg8wFg==
X-ME-Sender: <xms:egZpXZLt9jmjAG0XG4KMxI1s7Qm7DW-7Urb-CIIXqUBjtVY8rM05rw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:egZpXXCr8FCGxUg6-qCzJk0hx8WTkxnAvgeT_YPolHeIsKsUbRzPFg>
    <xmx:egZpXW3QHc2Qo6zOABEla06gQib8S5gseih73KpUTwdP3qBSoVhyqw>
    <xmx:egZpXakVQRNwPK_b_hazBIDjKvKPeZdLF4OhULPvTNHnDb8ORrq3uA>
    <xmx:egZpXRqGdku0eVa9pUVQjeebR_sDRBa1ESIaGqnJ6XzAtqUf5nS4bA>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77D0080059;
        Fri, 30 Aug 2019 07:20:23 -0400 (EDT)
Message-ID: <460f56fe87c595aa2d9c7c305ae2ea3438ba3b34.camel@themaw.net>
Subject: Re: [PATCH v2 12/15] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 19:20:20 +0800
In-Reply-To: <20190828132822.GE16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652202212.2607.8621137631843273531.stgit@fedora-28>
         <20190828132822.GE16389@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-28 at 09:28 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 09:00:22AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .free that performs fs
> > context cleanup on context release.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index aae0098fecab..9976163dc537 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2129,10 +2129,32 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static void xfs_fc_free(struct fs_context *fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +
> > +	if (mp) {
> > +		/*
> > +		 * If an error occurs before ownership the xfs_mount
> > +		 * info struct is passed to xfs by the VFS (by
> > assigning
> > +		 * it to sb->s_fs_info and clearing the corresponding
> > +		 * fs_context field, which is done before calling fill
> > +		 * super via .get_tree()) there may be some strings to
> > +		 * cleanup.
> > +		 */
> 
> The code looks straightforward but I find the comment confusing. How
> can
> the VFS pass ownership of the xfs_mount if it's an XFS private data
> structure?
> 
> > +		kfree(mp->m_logname);
> > +		kfree(mp->m_rtname);
> > +		kfree(mp);
> > +	}
> > +	kfree(ctx);
> 
> Also, should we at least reassign associated fc pointers to NULL if
> we
> have multiple places to free things like ctx or mp?

Not sure about that, I think the next thing to happen
here is the mount context is freed by the VFS.

I'll check.

> 
> Brian
> 
> > +}
> > +
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> >  	.reconfigure = xfs_reconfigure,
> > +	.free	     = xfs_fc_free,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

