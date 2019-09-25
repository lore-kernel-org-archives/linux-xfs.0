Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD961C432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 07:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990742054F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 07:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="UvNUzOMC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="p44OcWPt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437122AbfIYHmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 03:42:12 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36933 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391084AbfIYHmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 03:42:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 825AE220E7;
        Wed, 25 Sep 2019 03:42:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Sep 2019 03:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        7ro3bPk6jZkNMo+AXTvFoEdIT0fV5ly45dbA/PNQUFA=; b=UvNUzOMCNS/ynJ4F
        SwhY8c08Vgmu9q3q4B23s4J55seg7Rug69gfi161GhOiRMApQ395Gh7xYysSFM2T
        nCKYd+CThVcX/BZAh2q5x+B1Au51Ib2uMbY4MUzAMjSBIEmdh/sTG84f4czl0dgQ
        UE/nOyYYS9JfeHnTiRwRPCgqyPQBwDYpIaYdkYqECzS4AiuDjKkqSQAmdTT1Gvmi
        oTnzleZO/DV/sd9+zko1SfcJjeSf+bGGdVFpN7XLhg/jP6MQEPfFRdm3y1UBWEoA
        TDT9pFy1Tgt49IlwngeC4T2hLlaXClAa+8s1F+4UiUCINoMqBJnuSb4TFWzUs5U2
        xKpE9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=7ro3bPk6jZkNMo+AXTvFoEdIT0fV5ly45dbA/PNQU
        FA=; b=p44OcWPtGx2dMmSbdQAkMXRJyRXyXjzmJlGU0K0U7xf30B092OsMoHmjM
        dVdbBBFVvY4mMb8N4m20noBW8pYXlCzU2xa1t03uxpJzSXhpV4+fnPZFsj/lYc8t
        D2H7oRgueGUj6k2i/b0L04WkP9ZJgPOEKA5ky7pt1memcVVUtxyR2QOQJAMMHeyX
        /uagAu1M4Dd80CUOCydLt/WQ6PLcvicy0o5Gvng592+fjfi5Uaozf1OhQOOHExaD
        nHybTxu+FsJwqIj6hByzPpimSwioqR7aH3B/jZjbCgulOYG0KRGVTMLsVcFSrcx+
        LCE8m7RtM3qffT42Y7Tt1ESjI3oIg==
X-ME-Sender: <xms:URqLXQf0cMBatBOLbh78kK4A8QNYy9xMjPl3-LlXbjWiOh5vcMtoiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudeifedrvddvfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:URqLXT7MJgcrFvLgMheGWyZIRTU4fNF3yyz0TUSMJ7rJ9TW6OCs-BQ>
    <xmx:URqLXU9bK_GfsOvJEfa4egLGK_uzePFV8wde340DTEEKGzQn7NwMLg>
    <xmx:URqLXVzQwascrDGqDoeO3rcFKYVt506YSYQLLv5BQD_24aZEZI39ZA>
    <xmx:UhqLXVlIRk89jLy7y5uAo2-y-i1MESbKmWuacdfw0qbv_iA0wAjfZQ>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id D64538005A;
        Wed, 25 Sep 2019 03:42:06 -0400 (EDT)
Message-ID: <3eb80542b3a247173dcef4ddf5494daa3c90e72c.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 15:42:02 +0800
In-Reply-To: <20190924143823.GD17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933136908.20933.15050470634891698659.stgit@fedora-28>
         <20190924143823.GD17688@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> On Tue, Sep 24, 2019 at 09:22:49PM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .get_tree that validates
> > mount options and fills the super block as previously done
> > by the file_system_type .mount method.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   50
> > ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 50 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index ea3640ffd8f5..6f9fe92b4e21 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1933,6 +1933,51 @@ xfs_fs_fill_super(
> >  	return error;
> >  }
> >  
> > +STATIC int
> > +xfs_fill_super(
> > +	struct super_block	*sb,
> > +	struct fs_context	*fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = sb->s_fs_info;
> > +	int			silent = fc->sb_flags & SB_SILENT;
> > +	int			error = -ENOMEM;
> > +
> > +	mp->m_super = sb;
> > +
> > +	/*
> > +	 * set up the mount name first so all the errors will refer to
> > the
> > +	 * correct device.
> > +	 */
> > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> > +	if (!mp->m_fsname)
> > +		return -ENOMEM;
> > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > +
> > +	error = xfs_validate_params(mp, ctx, false);
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
> > +
> 
> I'm still not following the (intended) lifecycle of mp here. Looking
> ahead in the series, we allocate mp in xfs_init_fs_context() and set
> some state. It looks like at some point we grow an xfs_fc_free()
> callback that frees mp, but that doesn't exist as of yet. So is that
> a
> memory leak as of this patch?
> 
> We also call xfs_free_fsname() here (which doesn't reset pointers to
> NULL) and open-code kfree()'s of a couple of the same fields in
> xfs_fc_free(). Those look like double frees to me.
> 
> Hmm.. I guess I'm kind of wondering why we lift the mp alloc out of
> the
> fill super call in the first place. At a glance, it doesn't look like
> we
> do anything in that xfs_init_fs_context() call that we couldn't do a
> bit
> later..

Umm ... yes ...

I think I've got the active code path right ...

At this point .mount == xfs_fs_mount() which will calls
xfs_fs_fill_super() to fill the super block.

xfs_fs_fill_super() allocates the super block info struct and sets
it in the super block private info field, then calls xfs_parseargs()
which still allocates mp->m_fsname at this point, to accomodate a
similar free pattern in xfs_test_remount_options().

It then calls __xfs_fs_fill_super() which doesn't touch those fsname
fields or mp to fit in with what will be done later.

If an error occurs both the fsname fields (xfs_free_fsname()) and mp
are freed by the main caller, xfs_fs_fill_super().

I think that process is ok.

The mount api process that isn't active yet is a bit different.

The context (ctx), a temporary working space, is allocated then saved
in the mount context (fc) and the super block info is also allocated
and saved in the mount context in it's field of the same name as the
private super block info field, s_fs_info.

The function xfs_fill_super() is called as a result of the .get_tree()
mount context operation to fill the super block.

During this process, when the VFS successfully allocates the super
block s_fs_info is set in the super block and the mount context
field set to NULL. From this point freeing the private super block
info becomes part of usual freeing of the super block with the super
operation .kill_sb().

But if the super block allocation fails then the mount context
s_fs_info field remains set and is the responsibility of the
mount context operations .fc_free() method to clean up.

Now the VFS calls to xfs_fill_super() after this.

I should have been able to leave xfs_fill_super() it as it
was with:
        sb->s_fs_info = NULL;
        xfs_free_fsname(mp);
        kfree(mp);
and that should have been ok but it wasn't, there was some sort of
allocation problem, possibly a double free, causing a crash.

Strictly speaking this cleanup process should be carried out by
either the mount context .fc_free() or super operation .kill_sb()
and that's what I want to do.

So I'm not sure the allocation time and the place this is done
can (or should) be done differently.

And that freeing on error exit from xfs_fill_super() is definitely
wrong now! Ha, and I didn't see any crashes myself when I tested
it ... maybe I need a reproducer ...

Ian

> 
> Brian
> 
> > +	return error;
> > +}
> > +
> > +STATIC int
> > +xfs_get_tree(
> > +	struct fs_context	*fc)
> > +{
> > +	return vfs_get_block_super(fc, xfs_fill_super);
> > +}
> > +
> >  STATIC void
> >  xfs_fs_put_super(
> >  	struct super_block	*sb)
> > @@ -2003,6 +2048,11 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static const struct fs_context_operations xfs_context_ops = {
> > +	.parse_param = xfs_parse_param,
> > +	.get_tree    = xfs_get_tree,
> > +};
> > +
> >  static struct file_system_type xfs_fs_type = {
> >  	.owner			= THIS_MODULE,
> >  	.name			= "xfs",
> > 

