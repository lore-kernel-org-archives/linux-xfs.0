Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F54AC432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 08:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB23A2082F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 08:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="eAYThpo7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Q95b0CAI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404849AbfIYIH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 04:07:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53993 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406488AbfIYIHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 04:07:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E154223DB;
        Wed, 25 Sep 2019 04:07:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Sep 2019 04:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        Toyi/h3qZZlvG8IWGlkkBfimo87fu/hEOMe6UpAwgNA=; b=eAYThpo7XQal1J2+
        O8twot3mv9jAziPA+xrhWcXEeMzbGCWpC+bGNxz9YY+p4h1Z3+Yayc6fv5wkz7jX
        vKlH4kCrrWtQW6o0VUT6PdvJwRcttQLNHvIr7C2/ML7lzq1v/DGBLeuKVUM9JzM8
        WLmONgHnxOCo0gMEz3lCKRAZoW7OLQCS4azMeH6FjEtkxAuI/88JwMS9HDQXM+et
        JZuGJxmyRtlV3WxJB25qF9qYXvTpo+NvvqWrko1FISWFS8J5AsW30/7F5QLOCAct
        DdiXM20mZ/I6LVY31crtcuQZWu2adWJwnpv4Ce4ok7s2I+s24oEw3+zJ3ySjinRQ
        b+DkAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=Toyi/h3qZZlvG8IWGlkkBfimo87fu/hEOMe6UpAwg
        NA=; b=Q95b0CAIIKApgwx/NJLbktDTwX4i3RRvA5Py0htyRYCBnFT9199wjnaFe
        WTa6GkPpOYQmPCd+tuTN2a17Pt4AI6TMLk1xzN7RHGIFVCr2LaI2tkEKu2Ak20BY
        DXTv8wicbFiCghrmsL+GQIaX8qs5VFY7Y5lOXXb9f6A8Vi4F9/HsDKugWvx8jaj4
        EQrICv5581xwSxa5BOump3lo7owqj4vKM7LeHZkwy+vGVN23YsCTtxGlI77n0C+G
        OwvOXoybc6Ds1cdFIqmlDvLieTAMdw9bJKX1jCjsNKWW1v8SWzGErej9z3ZYQHB5
        SfepK7SPKDF9FGmwJUY9azmEJ+0+Q==
X-ME-Sender: <xms:MyCLXV0VYvX8XFtxD1fymsguQ_Vnc70lNlA9LWmEC0_RJSoQcBMujg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudeifedrvddvfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:NCCLXXTkr8F5OHKbidJsUMi6tDvzazkv8pLC1-prKDiJrdgp75AX4Q>
    <xmx:NCCLXZv7TO5Uonq2VZ2iOLKCkEiKt4R_NJCEPVI-n2-72clF8kMGZg>
    <xmx:NCCLXdJoZdxDmsHA61IQJqRroUGlwVilDSKGQZrtwlm6rUl2gIFjdA>
    <xmx:NCCLXRfIq18ND0nmHnrAUrD4GJ6XWiIyLYN8bTG-3q1WTNVCkqQeiw>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C5DF80060;
        Wed, 25 Sep 2019 04:07:13 -0400 (EDT)
Message-ID: <a55278f2167025451aa6092f3ad5fab8bbef967f.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 16:07:08 +0800
In-Reply-To: <3eb80542b3a247173dcef4ddf5494daa3c90e72c.camel@themaw.net>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933136908.20933.15050470634891698659.stgit@fedora-28>
         <20190924143823.GD17688@bfoster>
         <3eb80542b3a247173dcef4ddf5494daa3c90e72c.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-09-25 at 15:42 +0800, Ian Kent wrote:
> On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> > On Tue, Sep 24, 2019 at 09:22:49PM +0800, Ian Kent wrote:
> > > Add the fs_context_operations method .get_tree that validates
> > > mount options and fills the super block as previously done
> > > by the file_system_type .mount method.
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > ---
> > >  fs/xfs/xfs_super.c |   50
> > > ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 50 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index ea3640ffd8f5..6f9fe92b4e21 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -1933,6 +1933,51 @@ xfs_fs_fill_super(
> > >  	return error;
> > >  }
> > >  
> > > +STATIC int
> > > +xfs_fill_super(
> > > +	struct super_block	*sb,
> > > +	struct fs_context	*fc)
> > > +{
> > > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > > +	struct xfs_mount	*mp = sb->s_fs_info;
> > > +	int			silent = fc->sb_flags & SB_SILENT;
> > > +	int			error = -ENOMEM;
> > > +
> > > +	mp->m_super = sb;
> > > +
> > > +	/*
> > > +	 * set up the mount name first so all the errors will refer to
> > > the
> > > +	 * correct device.
> > > +	 */
> > > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> > > +	if (!mp->m_fsname)
> > > +		return -ENOMEM;
> > > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > > +
> > > +	error = xfs_validate_params(mp, ctx, false);
> > > +	if (error)
> > > +		goto out_free_fsname;
> > > +
> > > +	error = __xfs_fs_fill_super(mp, silent);
> > > +	if (error)
> > > +		goto out_free_fsname;
> > > +
> > > +	return 0;
> > > +
> > > + out_free_fsname:
> > > +	sb->s_fs_info = NULL;
> > > +	xfs_free_fsname(mp);
> > > +
> > 
> > I'm still not following the (intended) lifecycle of mp here.
> > Looking
> > ahead in the series, we allocate mp in xfs_init_fs_context() and
> > set
> > some state. It looks like at some point we grow an xfs_fc_free()
> > callback that frees mp, but that doesn't exist as of yet. So is
> > that
> > a
> > memory leak as of this patch?
> > 
> > We also call xfs_free_fsname() here (which doesn't reset pointers
> > to
> > NULL) and open-code kfree()'s of a couple of the same fields in
> > xfs_fc_free(). Those look like double frees to me.
> > 
> > Hmm.. I guess I'm kind of wondering why we lift the mp alloc out of
> > the
> > fill super call in the first place. At a glance, it doesn't look
> > like
> > we
> > do anything in that xfs_init_fs_context() call that we couldn't do
> > a
> > bit
> > later..
> 
> Umm ... yes ...
> 
> I think I've got the active code path right ...
> 
> At this point .mount == xfs_fs_mount() which will calls
> xfs_fs_fill_super() to fill the super block.
> 
> xfs_fs_fill_super() allocates the super block info struct and sets
> it in the super block private info field, then calls xfs_parseargs()
> which still allocates mp->m_fsname at this point, to accomodate a
> similar free pattern in xfs_test_remount_options().
> 
> It then calls __xfs_fs_fill_super() which doesn't touch those fsname
> fields or mp to fit in with what will be done later.
> 
> If an error occurs both the fsname fields (xfs_free_fsname()) and mp
> are freed by the main caller, xfs_fs_fill_super().
> 
> I think that process is ok.
> 
> The mount api process that isn't active yet is a bit different.
> 
> The context (ctx), a temporary working space, is allocated then saved
> in the mount context (fc) and the super block info is also allocated
> and saved in the mount context in it's field of the same name as the
> private super block info field, s_fs_info.
> 
> The function xfs_fill_super() is called as a result of the
> .get_tree()
> mount context operation to fill the super block.
> 
> During this process, when the VFS successfully allocates the super
> block s_fs_info is set in the super block and the mount context
> field set to NULL. From this point freeing the private super block
> info becomes part of usual freeing of the super block with the super
> operation .kill_sb().
> 
> But if the super block allocation fails then the mount context
> s_fs_info field remains set and is the responsibility of the
> mount context operations .fc_free() method to clean up.
> 
> Now the VFS calls to xfs_fill_super() after this.
> 
> I should have been able to leave xfs_fill_super() it as it
> was with:
>         sb->s_fs_info = NULL;
>         xfs_free_fsname(mp);
>         kfree(mp);
> and that should have been ok but it wasn't, there was some sort of
> allocation problem, possibly a double free, causing a crash.
> 
> Strictly speaking this cleanup process should be carried out by
> either the mount context .fc_free() or super operation .kill_sb()
> and that's what I want to do.

Umm ... but I can't actually do that ...

Looking back at xfs I realize that the filling of the super
block is meant to leave nothing allocated and set
sb->s_fs_info = NULL on error so that ->put_super() won't try
and cleanup a whole bunch of stuff that hasn't been done.

Which brings me back to what I originally had above ... which
we believe doesn't work ?

> 
> So I'm not sure the allocation time and the place this is done
> can (or should) be done differently.
> 
> And that freeing on error exit from xfs_fill_super() is definitely
> wrong now! Ha, and I didn't see any crashes myself when I tested
> it ... maybe I need a reproducer ...
> 
> Ian
> 
> > Brian
> > 
> > > +	return error;
> > > +}
> > > +
> > > +STATIC int
> > > +xfs_get_tree(
> > > +	struct fs_context	*fc)
> > > +{
> > > +	return vfs_get_block_super(fc, xfs_fill_super);
> > > +}
> > > +
> > >  STATIC void
> > >  xfs_fs_put_super(
> > >  	struct super_block	*sb)
> > > @@ -2003,6 +2048,11 @@ static const struct super_operations
> > > xfs_super_operations = {
> > >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> > >  };
> > >  
> > > +static const struct fs_context_operations xfs_context_ops = {
> > > +	.parse_param = xfs_parse_param,
> > > +	.get_tree    = xfs_get_tree,
> > > +};
> > > +
> > >  static struct file_system_type xfs_fs_type = {
> > >  	.owner			= THIS_MODULE,
> > >  	.name			= "xfs",
> > > 

