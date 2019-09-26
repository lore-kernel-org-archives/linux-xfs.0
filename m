Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718DFC432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 03:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B01221E6F
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 03:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="krPNUAlp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wB+gXQF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388044AbfIZD1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 23:27:50 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:56475 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733188AbfIZD1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 23:27:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6104865B;
        Wed, 25 Sep 2019 23:27:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Sep 2019 23:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        pgsuTVYqt/bu+w3T4QM4u58WWtbFDS1/Lm0xrLrW22w=; b=krPNUAlpmaMBeIRh
        l/58XpMqr4XEw+0/LaYJSisz68gu0K+v44LF7ACOPAapVKSs0dZ+r9BP9fripyXb
        6nueSIUrzVi6SlUy3J8vvZ7oYm1FUF23JXZ50bUTQ8P1UrK3gFdLKI/vX33gv5Oa
        5vY2pGyHnCkFIETAFFgbwkXsiRqpnv+DTO5A7seIHYiVOumFlkHDsX96XNlEQqMI
        B0GIc/9PEb4WaeRnA38KD/340lCs7Ig0zGQraL6TGc1sBLzxgrDwaBL7NlpnPc5J
        ZtFWBvkcH0LinCmW9TU/1Rx1npbyqI40fM8rw1yyj7SZVDoBgP7298Ey/V6wZd+Q
        zZbzOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=pgsuTVYqt/bu+w3T4QM4u58WWtbFDS1/Lm0xrLrW2
        2w=; b=wB+gXQF3Bb71AGQhBoXAikw2yXIIVF5RLvQIlxNBrV3MdpUgHT5Gn51TN
        bZUUa9QOSlk41YD7PRdhpUNAlo+3UyMKdy6KJ1kFj48gCSAMgEXN9Zw0eTy2B5GG
        M321Ej1MrEN9yVVwVapWGWhZucAqBBnJUrxYfoVwjyZSJbS1vElyzmjKpYlnpBb0
        hdhPJt6zEvRJk9NvoZw5E/Nq2wHTk9wjyL/+XMhgU8l+j98MBE173vZOIDaNV0V0
        10bA4a6RayLU1vMmMe0o0MFQGpsuq283ft6VfrdELWnRP42Zo4fQvo6ZOgi0QqA6
        GU9qKf1Us4Qb3bx1mMSB/SgLlsjxw==
X-ME-Sender: <xms:MzCMXV9uiAMt1XQmfs3IXoGdHbmHbRDmXcI0-q6Yzx7RzkEWzlccog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeefgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    duieekrddvieenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:MzCMXR-jUaSe66ggGI7GF887VhN5JtQeKAhRfZJX1k5nBAvKUa9U8g>
    <xmx:MzCMXY6ewY-An4vi14lJ_x1OaZhEszs8iGppJ-WkXIeJbicfZIyiiQ>
    <xmx:MzCMXbIyJvQQ_-mIVhg9Nuy0gmVyVf8XaU9U_inWHrhYD4EO1pPGbw>
    <xmx:MzCMXTIeMWK4dVIljrcCDqkHT4jlKE-RKSHY7xYfLyOS_v6oCbRdhw>
Received: from mickey.themaw.net (unknown [118.209.168.26])
        by mail.messagingengine.com (Postfix) with ESMTPA id A053C80059;
        Wed, 25 Sep 2019 23:27:44 -0400 (EDT)
Message-ID: <4f6baf799c38f83dbef45b555f9bebcdc5f4311b.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Thu, 26 Sep 2019 11:27:40 +0800
In-Reply-To: <20190925143414.GE21991@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933136908.20933.15050470634891698659.stgit@fedora-28>
         <20190924143823.GD17688@bfoster>
         <3eb80542b3a247173dcef4ddf5494daa3c90e72c.camel@themaw.net>
         <a55278f2167025451aa6092f3ad5fab8bbef967f.camel@themaw.net>
         <20190925143414.GE21991@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-09-25 at 10:34 -0400, Brian Foster wrote:
> On Wed, Sep 25, 2019 at 04:07:08PM +0800, Ian Kent wrote:
> > On Wed, 2019-09-25 at 15:42 +0800, Ian Kent wrote:
> > > On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> > > > On Tue, Sep 24, 2019 at 09:22:49PM +0800, Ian Kent wrote:
> > > > > Add the fs_context_operations method .get_tree that validates
> > > > > mount options and fills the super block as previously done
> > > > > by the file_system_type .mount method.
> > > > > 
> > > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > > ---
> > > > >  fs/xfs/xfs_super.c |   50
> > > > > ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 50 insertions(+)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > index ea3640ffd8f5..6f9fe92b4e21 100644
> > > > > --- a/fs/xfs/xfs_super.c
> > > > > +++ b/fs/xfs/xfs_super.c
> > > > > @@ -1933,6 +1933,51 @@ xfs_fs_fill_super(
> > > > >  	return error;
> > > > >  }
> > > > >  
> > > > > +STATIC int
> > > > > +xfs_fill_super(
> > > > > +	struct super_block	*sb,
> > > > > +	struct fs_context	*fc)
> > > > > +{
> > > > > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > > > > +	struct xfs_mount	*mp = sb->s_fs_info;
> > > > > +	int			silent = fc->sb_flags &
> > > > > SB_SILENT;
> > > > > +	int			error = -ENOMEM;
> > > > > +
> > > > > +	mp->m_super = sb;
> > > > > +
> > > > > +	/*
> > > > > +	 * set up the mount name first so all the errors will
> > > > > refer to
> > > > > the
> > > > > +	 * correct device.
> > > > > +	 */
> > > > > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN,
> > > > > GFP_KERNEL);
> > > > > +	if (!mp->m_fsname)
> > > > > +		return -ENOMEM;
> > > > > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > > > > +
> > > > > +	error = xfs_validate_params(mp, ctx, false);
> > > > > +	if (error)
> > > > > +		goto out_free_fsname;
> > > > > +
> > > > > +	error = __xfs_fs_fill_super(mp, silent);
> > > > > +	if (error)
> > > > > +		goto out_free_fsname;
> > > > > +
> > > > > +	return 0;
> > > > > +
> > > > > + out_free_fsname:
> > > > > +	sb->s_fs_info = NULL;
> > > > > +	xfs_free_fsname(mp);
> > > > > +
> > > > 
> > > > I'm still not following the (intended) lifecycle of mp here.
> > > > Looking
> > > > ahead in the series, we allocate mp in xfs_init_fs_context()
> > > > and
> > > > set
> > > > some state. It looks like at some point we grow an
> > > > xfs_fc_free()
> > > > callback that frees mp, but that doesn't exist as of yet. So is
> > > > that
> > > > a
> > > > memory leak as of this patch?
> > > > 
> > > > We also call xfs_free_fsname() here (which doesn't reset
> > > > pointers
> > > > to
> > > > NULL) and open-code kfree()'s of a couple of the same fields in
> > > > xfs_fc_free(). Those look like double frees to me.
> > > > 
> > > > Hmm.. I guess I'm kind of wondering why we lift the mp alloc
> > > > out of
> > > > the
> > > > fill super call in the first place. At a glance, it doesn't
> > > > look
> > > > like
> > > > we
> > > > do anything in that xfs_init_fs_context() call that we couldn't
> > > > do
> > > > a
> > > > bit
> > > > later..
> > > 
> > > Umm ... yes ...
> > > 
> > > I think I've got the active code path right ...
> > > 
> > > At this point .mount == xfs_fs_mount() which will calls
> > > xfs_fs_fill_super() to fill the super block.
> > > 
> > > xfs_fs_fill_super() allocates the super block info struct and
> > > sets
> > > it in the super block private info field, then calls
> > > xfs_parseargs()
> > > which still allocates mp->m_fsname at this point, to accomodate a
> > > similar free pattern in xfs_test_remount_options().
> > > 
> > > It then calls __xfs_fs_fill_super() which doesn't touch those
> > > fsname
> > > fields or mp to fit in with what will be done later.
> > > 
> > > If an error occurs both the fsname fields (xfs_free_fsname()) and
> > > mp
> > > are freed by the main caller, xfs_fs_fill_super().
> > > 
> > > I think that process is ok.
> > > 
> > > The mount api process that isn't active yet is a bit different.
> > > 
> > > The context (ctx), a temporary working space, is allocated then
> > > saved
> > > in the mount context (fc) and the super block info is also
> > > allocated
> > > and saved in the mount context in it's field of the same name as
> > > the
> > > private super block info field, s_fs_info.
> > > 
> > > The function xfs_fill_super() is called as a result of the
> > > .get_tree()
> > > mount context operation to fill the super block.
> > > 
> > > During this process, when the VFS successfully allocates the
> > > super
> > > block s_fs_info is set in the super block and the mount context
> > > field set to NULL. From this point freeing the private super
> > > block
> > > info becomes part of usual freeing of the super block with the
> > > super
> > > operation .kill_sb().
> > > 
> > > But if the super block allocation fails then the mount context
> > > s_fs_info field remains set and is the responsibility of the
> > > mount context operations .fc_free() method to clean up.
> > > 
> > > Now the VFS calls to xfs_fill_super() after this.
> > > 
> > > I should have been able to leave xfs_fill_super() it as it
> > > was with:
> > >         sb->s_fs_info = NULL;
> > >         xfs_free_fsname(mp);
> > >         kfree(mp);
> > > and that should have been ok but it wasn't, there was some sort
> > > of
> > > allocation problem, possibly a double free, causing a crash.
> > > 
> > > Strictly speaking this cleanup process should be carried out by
> > > either the mount context .fc_free() or super operation .kill_sb()
> > > and that's what I want to do.
> > 
> > Umm ... but I can't actually do that ...
> > 
> > Looking back at xfs I realize that the filling of the super
> > block is meant to leave nothing allocated and set
> > sb->s_fs_info = NULL on error so that ->put_super() won't try
> > and cleanup a whole bunch of stuff that hasn't been done.
> > 
> > Which brings me back to what I originally had above ... which
> > we believe doesn't work ?
> > 
> 
> It looks like perhaps the assignment of sb->s_fs_info was lost as
> well?
> Skipping to the end, I see xfs_init_fs_context() alloc mp and assign
> fc->s_fs_info. xfs_get_tree() leads to xfs_fill_super(), which
> somehow
> gets mp from sb->s_fs_info (not fc->...), but then resets sb-
> >s_fs_info
> on error and frees the names, leaving fs->s_fs_info so presumably
> xfs_fc_free() can free mp along with a couple of the names (again). I
> can't really make heads or tails of what this is even attempting to
> do.

Ha, it seems a bit mysterious, but it's actually much simpler
than it appears.

> 
> That aside, it's not clear to me why the new code can't follow a
> similar
> pattern as the old code with regard to allocation. Allocate mp in
> xfs_fill_super() and set up sb/fc pointers, reset pointers and free
> mp
> on error return. Otherwise, xfs_fc_free() checks for fc->s_fs_info !=
> NULL and frees mp from there. Is there some reason we can't continue
> to
> do that?

I think not without a fairly significant re-design.

The main difference is the mount-api will allocate the super
block later than the old mount code.

Basically, if file system parameter parsing fails the super
block won't get allocated.

So the super block isn't available during parameter parsing
but the file system private data structure may be needed for
it, so it comes from the file system context at that point.

When the super block is successfully allocated the file system
private data structure is set in the super block (and the field
NULLed in the context) and things progress much the same as
before from that point.

That's the essential difference in the process AFAICS.

By the time fill_super() is called everything is set and you
should be able to proceed almost the same as before.

Ian

> Brian
> 
> > > So I'm not sure the allocation time and the place this is done
> > > can (or should) be done differently.
> > > 
> > > And that freeing on error exit from xfs_fill_super() is
> > > definitely
> > > wrong now! Ha, and I didn't see any crashes myself when I tested
> > > it ... maybe I need a reproducer ...
> > > 
> > > Ian
> > > 
> > > > Brian
> > > > 
> > > > > +	return error;
> > > > > +}
> > > > > +
> > > > > +STATIC int
> > > > > +xfs_get_tree(
> > > > > +	struct fs_context	*fc)
> > > > > +{
> > > > > +	return vfs_get_block_super(fc, xfs_fill_super);
> > > > > +}
> > > > > +
> > > > >  STATIC void
> > > > >  xfs_fs_put_super(
> > > > >  	struct super_block	*sb)
> > > > > @@ -2003,6 +2048,11 @@ static const struct super_operations
> > > > > xfs_super_operations = {
> > > > >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> > > > >  };
> > > > >  
> > > > > +static const struct fs_context_operations xfs_context_ops =
> > > > > {
> > > > > +	.parse_param = xfs_parse_param,
> > > > > +	.get_tree    = xfs_get_tree,
> > > > > +};
> > > > > +
> > > > >  static struct file_system_type xfs_fs_type = {
> > > > >  	.owner			= THIS_MODULE,
> > > > >  	.name			= "xfs",
> > > > > 

