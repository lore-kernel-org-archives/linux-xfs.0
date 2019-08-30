Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C4DC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C03321726
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="mN+BZNZ3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="R1GSqBN9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfH3K47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:56:59 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:60147 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfH3K47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:56:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9A2E04FF;
        Fri, 30 Aug 2019 06:56:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 06:56:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        jiwG1LAZqeNTYAz2ejCCur7O8o6uv6jaTcxfNZn1tVg=; b=mN+BZNZ3YpLtiaZm
        FCstkyMHFoHXM4UIqrbXeRthgL7JpD18VIiQMswG+ZDiW2B0/HAcOO+LUZiA1cap
        fapNo+UebftXRpZ08QiXilewu+zwx0ecU5JjghlnOXH+eR5gMexxQ4FXX1rjqTX1
        SFGP+N4cthjCH+kAktnLBCqdreECsbEmzA3H6/kYUbo3tpkQCqpMUjgyHHxsb1b+
        Skmj0J+qsBPyg50JhQD9PW8/aTYtuqUmDX78P7PSbSi5eIukWZTPJH5P2p/D7H5S
        t1M+lACyUntyezZH+gXE5Hw/mnOR6AVyUZZO0Yj0xLktbQGfqayuBcsNA2t6CgXx
        rjrQ7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=jiwG1LAZqeNTYAz2ejCCur7O8o6uv6jaTcxfNZn1t
        Vg=; b=R1GSqBN9OgGebnY9+I2IiJQ1iKy0TXlvA+LhPcapygmFuObt+fLWYWas/
        UCf83FpPVTaE5QzByQ3opmjQ0g+uDq/8RZgmvxxUpC+XM55tKRlmvn1q/ml2zsYG
        ThiB3uo7ibny2SsJCUfAvr7MAOVI3xayyVDu9T4fhQF0AAzheeOH9hjOW7bcJ+34
        v3g2XeRAOGqs5a9S3dCP0Sua6Etv52gU9kHv67ClaWbMoH6iVARiNK1ShIiBXlbQ
        qyp1OA5YBDFovKdRvAkOYrlFW0aeaLTkIDyUkn/5QLxABa1+ThXFR5JR/7Eq+xkN
        XiOw3Zm/aPHVQFUByiNx6zdnaPa/Q==
X-ME-Sender: <xms:-ABpXdVBKQ_JyXk9J-lMHYFG3ikRYgFU05wACAa-nXMuYLOcuK5SxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:-ABpXSgbn_mER5wMIFr7M0fMBZTtAFklBnY7SxItojkbNtuLNw9rHA>
    <xmx:-ABpXdqvhHVdd8nSvQLoOrFHvMeNonLhwZsgeyd7k7OHxeq3AzaDkw>
    <xmx:-ABpXQFyFnpXgMHcIedWchjm8ubk6j2LJ4PlzNsE2A0a4wh7aj6sDg>
    <xmx:-QBpXf56s7sV6KmJQRnLbmOYqTKUmFGoU4h0lGtv29cmIY61mVbBJA>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7146ED60057;
        Fri, 30 Aug 2019 06:56:54 -0400 (EDT)
Message-ID: <888e5ab2a91cb614cd8be462f5a879797233acd2.camel@themaw.net>
Subject: Re: [PATCH v2 07/15] xfs: mount-api - refactor xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 18:56:50 +0800
In-Reply-To: <20190827124224.GF10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652199438.2607.11044864070510345078.stgit@fedora-28>
         <20190827124224.GF10636@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-08-27 at 08:42 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:59:54AM +0800, Ian Kent wrote:
> > Much of the code in xfs_fs_fill_super() will be used by the fill
> > super
> > function of the new mount-api.
> > 
> > So refactor the common code into a helper in an attempt to show
> > what's
> > actually changed.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   65 ++++++++++++++++++++++++++++++++++----
> > --------------
> >  1 file changed, 42 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 7cdda17ee0ff..d3fc9938987d 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -1885,6 +1868,42 @@ xfs_fs_fill_super(
> >  	goto out_free_sb;
> >  }
> >  
> > +STATIC int
> > +xfs_fs_fill_super(
> > +	struct super_block	*sb,
> > +	void			*data,
> > +	int			silent)
> > +{
> > +	struct xfs_mount	*mp = NULL;
> > +	int			error = -ENOMEM;
> > +
> > +	/*
> > +	 * allocate mp and do all low-level struct initializations
> > before we
> > +	 * attach it to the super
> > +	 */
> > +	mp = xfs_mount_alloc(sb);
> > +	if (!mp)
> > +		goto out;
> > +	sb->s_fs_info = mp;
> > +
> > +	error = xfs_parseargs(mp, (char *)data);
> > +	if (error)
> > +		goto out_free_fsname;
> > +
> > +	error = __xfs_fs_fill_super(mp, silent);
> > +	if (error)
> > +		goto out_free_fsname;
> > +
> > +	return 0;
> > +
> > + out_free_fsname:
> > +	sb->s_fs_info = NULL;
> > +	xfs_free_fsname(mp);
> > +	kfree(mp);
> > +out:
> > +	return error;
> 
> I know this is copied from the existing function, but there's really
> no
> need for an out label here. We can just return -ENOMEM in the one
> user
> above. Aside from that nit the rest looks fine to me.

That's sensible, I'll do that.

And btw, thanks for spending the time to look at the patches.

Ian
> 
> Brian
> 
> > +}
> > +
> >  STATIC void
> >  xfs_fs_put_super(
> >  	struct super_block	*sb)
> > 

