Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301B9C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 11:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D4221A4A
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 11:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbfIZLOU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 07:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfIZLOU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 07:14:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2905D309BF06;
        Thu, 26 Sep 2019 11:14:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 313F7608C2;
        Thu, 26 Sep 2019 11:14:18 +0000 (UTC)
Date:   Thu, 26 Sep 2019 07:14:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
Message-ID: <20190926111416.GA26363@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933136908.20933.15050470634891698659.stgit@fedora-28>
 <20190924143823.GD17688@bfoster>
 <3eb80542b3a247173dcef4ddf5494daa3c90e72c.camel@themaw.net>
 <a55278f2167025451aa6092f3ad5fab8bbef967f.camel@themaw.net>
 <20190925143414.GE21991@bfoster>
 <4f6baf799c38f83dbef45b555f9bebcdc5f4311b.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f6baf799c38f83dbef45b555f9bebcdc5f4311b.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 26 Sep 2019 11:14:19 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 11:27:40AM +0800, Ian Kent wrote:
> On Wed, 2019-09-25 at 10:34 -0400, Brian Foster wrote:
> > On Wed, Sep 25, 2019 at 04:07:08PM +0800, Ian Kent wrote:
> > > On Wed, 2019-09-25 at 15:42 +0800, Ian Kent wrote:
> > > > On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> > > > > On Tue, Sep 24, 2019 at 09:22:49PM +0800, Ian Kent wrote:
> > > > > > Add the fs_context_operations method .get_tree that validates
> > > > > > mount options and fills the super block as previously done
> > > > > > by the file_system_type .mount method.
> > > > > > 
> > > > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > > > ---
> > > > > >  fs/xfs/xfs_super.c |   50
> > > > > > ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  1 file changed, 50 insertions(+)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > > index ea3640ffd8f5..6f9fe92b4e21 100644
> > > > > > --- a/fs/xfs/xfs_super.c
> > > > > > +++ b/fs/xfs/xfs_super.c
> > > > > > @@ -1933,6 +1933,51 @@ xfs_fs_fill_super(
> > > > > >  	return error;
> > > > > >  }
> > > > > >  
> > > > > > +STATIC int
> > > > > > +xfs_fill_super(
> > > > > > +	struct super_block	*sb,
> > > > > > +	struct fs_context	*fc)
> > > > > > +{
> > > > > > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > > > > > +	struct xfs_mount	*mp = sb->s_fs_info;
> > > > > > +	int			silent = fc->sb_flags &
> > > > > > SB_SILENT;
> > > > > > +	int			error = -ENOMEM;
> > > > > > +
> > > > > > +	mp->m_super = sb;
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * set up the mount name first so all the errors will
> > > > > > refer to
> > > > > > the
> > > > > > +	 * correct device.
> > > > > > +	 */
> > > > > > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN,
> > > > > > GFP_KERNEL);
> > > > > > +	if (!mp->m_fsname)
> > > > > > +		return -ENOMEM;
> > > > > > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > > > > > +
> > > > > > +	error = xfs_validate_params(mp, ctx, false);
> > > > > > +	if (error)
> > > > > > +		goto out_free_fsname;
> > > > > > +
> > > > > > +	error = __xfs_fs_fill_super(mp, silent);
> > > > > > +	if (error)
> > > > > > +		goto out_free_fsname;
> > > > > > +
> > > > > > +	return 0;
> > > > > > +
> > > > > > + out_free_fsname:
> > > > > > +	sb->s_fs_info = NULL;
> > > > > > +	xfs_free_fsname(mp);
> > > > > > +
> > > > > 
> > > > > I'm still not following the (intended) lifecycle of mp here.
> > > > > Looking
> > > > > ahead in the series, we allocate mp in xfs_init_fs_context()
> > > > > and
> > > > > set
> > > > > some state. It looks like at some point we grow an
> > > > > xfs_fc_free()
> > > > > callback that frees mp, but that doesn't exist as of yet. So is
> > > > > that
> > > > > a
> > > > > memory leak as of this patch?
> > > > > 
> > > > > We also call xfs_free_fsname() here (which doesn't reset
> > > > > pointers
> > > > > to
> > > > > NULL) and open-code kfree()'s of a couple of the same fields in
> > > > > xfs_fc_free(). Those look like double frees to me.
> > > > > 
> > > > > Hmm.. I guess I'm kind of wondering why we lift the mp alloc
> > > > > out of
> > > > > the
> > > > > fill super call in the first place. At a glance, it doesn't
> > > > > look
> > > > > like
> > > > > we
> > > > > do anything in that xfs_init_fs_context() call that we couldn't
> > > > > do
> > > > > a
> > > > > bit
> > > > > later..
> > > > 
> > > > Umm ... yes ...
> > > > 
> > > > I think I've got the active code path right ...
> > > > 
> > > > At this point .mount == xfs_fs_mount() which will calls
> > > > xfs_fs_fill_super() to fill the super block.
> > > > 
> > > > xfs_fs_fill_super() allocates the super block info struct and
> > > > sets
> > > > it in the super block private info field, then calls
> > > > xfs_parseargs()
> > > > which still allocates mp->m_fsname at this point, to accomodate a
> > > > similar free pattern in xfs_test_remount_options().
> > > > 
> > > > It then calls __xfs_fs_fill_super() which doesn't touch those
> > > > fsname
> > > > fields or mp to fit in with what will be done later.
> > > > 
> > > > If an error occurs both the fsname fields (xfs_free_fsname()) and
> > > > mp
> > > > are freed by the main caller, xfs_fs_fill_super().
> > > > 
> > > > I think that process is ok.
> > > > 
> > > > The mount api process that isn't active yet is a bit different.
> > > > 
> > > > The context (ctx), a temporary working space, is allocated then
> > > > saved
> > > > in the mount context (fc) and the super block info is also
> > > > allocated
> > > > and saved in the mount context in it's field of the same name as
> > > > the
> > > > private super block info field, s_fs_info.
> > > > 
> > > > The function xfs_fill_super() is called as a result of the
> > > > .get_tree()
> > > > mount context operation to fill the super block.
> > > > 
> > > > During this process, when the VFS successfully allocates the
> > > > super
> > > > block s_fs_info is set in the super block and the mount context
> > > > field set to NULL. From this point freeing the private super
> > > > block
> > > > info becomes part of usual freeing of the super block with the
> > > > super
> > > > operation .kill_sb().
> > > > 
> > > > But if the super block allocation fails then the mount context
> > > > s_fs_info field remains set and is the responsibility of the
> > > > mount context operations .fc_free() method to clean up.
> > > > 
> > > > Now the VFS calls to xfs_fill_super() after this.
> > > > 
> > > > I should have been able to leave xfs_fill_super() it as it
> > > > was with:
> > > >         sb->s_fs_info = NULL;
> > > >         xfs_free_fsname(mp);
> > > >         kfree(mp);
> > > > and that should have been ok but it wasn't, there was some sort
> > > > of
> > > > allocation problem, possibly a double free, causing a crash.
> > > > 
> > > > Strictly speaking this cleanup process should be carried out by
> > > > either the mount context .fc_free() or super operation .kill_sb()
> > > > and that's what I want to do.
> > > 
> > > Umm ... but I can't actually do that ...
> > > 
> > > Looking back at xfs I realize that the filling of the super
> > > block is meant to leave nothing allocated and set
> > > sb->s_fs_info = NULL on error so that ->put_super() won't try
> > > and cleanup a whole bunch of stuff that hasn't been done.
> > > 
> > > Which brings me back to what I originally had above ... which
> > > we believe doesn't work ?
> > > 
> > 
> > It looks like perhaps the assignment of sb->s_fs_info was lost as
> > well?
> > Skipping to the end, I see xfs_init_fs_context() alloc mp and assign
> > fc->s_fs_info. xfs_get_tree() leads to xfs_fill_super(), which
> > somehow
> > gets mp from sb->s_fs_info (not fc->...), but then resets sb-
> > >s_fs_info
> > on error and frees the names, leaving fs->s_fs_info so presumably
> > xfs_fc_free() can free mp along with a couple of the names (again). I
> > can't really make heads or tails of what this is even attempting to
> > do.
> 
> Ha, it seems a bit mysterious, but it's actually much simpler
> than it appears.
> 

Feel free to explain any of the above..? Where do you currently assign
sb->s_fs_info, for example?

> > 
> > That aside, it's not clear to me why the new code can't follow a
> > similar
> > pattern as the old code with regard to allocation. Allocate mp in
> > xfs_fill_super() and set up sb/fc pointers, reset pointers and free
> > mp
> > on error return. Otherwise, xfs_fc_free() checks for fc->s_fs_info !=
> > NULL and frees mp from there. Is there some reason we can't continue
> > to
> > do that?
> 
> I think not without a fairly significant re-design.
> 
> The main difference is the mount-api will allocate the super
> block later than the old mount code.
> 
> Basically, if file system parameter parsing fails the super
> block won't get allocated.
> 
> So the super block isn't available during parameter parsing
> but the file system private data structure may be needed for
> it, so it comes from the file system context at that point.
> 
> When the super block is successfully allocated the file system
> private data structure is set in the super block (and the field
> NULLed in the context) and things progress much the same as
> before from that point.
> 
> That's the essential difference in the process AFAICS.
> 

I see. This is probably something that should be noted in the commit
log (that the ordering changes from before such that we need to allocate
mp a bit earlier). This is reasonable because even though the current
code allocs mp in the fill_super callback, we parse arguments
immediately after the mp allocation and don't otherwise rely on the sb
in that code.

If I follow correctly, it sounds like perhaps we need to separate the
management of sb->s_fs_info from the "ownership" of mp. For example,
allocate mp, assign fc->s_fs_info and free via xfs_fc_free() as you do
now. In the xfs_fill_super() callback, pull mp from fc->s_fs_info and
assign it to sb->s_fs_info. If we fail at this point, reset
sb->s_fs_info to NULL and let the fc infrastructure deal with freeing mp
in its own callback.

What I'm not clear on is whether something like xfs_fs_put_super()
should still free mp as well. Once the filesystem successfully mounts,
are we still going to see an xfs_fc_free() callback, or is this all just
transient mount path stuff? If the former, perhaps put_super() should
also not free mp and just reset its own ->s_fs_info reference. If the
latter, then I guess we just need to understand at what point during a
successful mount responsibility to free transfers from one place to the
other. Thoughts?

Brian

> By the time fill_super() is called everything is set and you
> should be able to proceed almost the same as before.
> 
> Ian
> 
> > Brian
> > 
> > > > So I'm not sure the allocation time and the place this is done
> > > > can (or should) be done differently.
> > > > 
> > > > And that freeing on error exit from xfs_fill_super() is
> > > > definitely
> > > > wrong now! Ha, and I didn't see any crashes myself when I tested
> > > > it ... maybe I need a reproducer ...
> > > > 
> > > > Ian
> > > > 
> > > > > Brian
> > > > > 
> > > > > > +	return error;
> > > > > > +}
> > > > > > +
> > > > > > +STATIC int
> > > > > > +xfs_get_tree(
> > > > > > +	struct fs_context	*fc)
> > > > > > +{
> > > > > > +	return vfs_get_block_super(fc, xfs_fill_super);
> > > > > > +}
> > > > > > +
> > > > > >  STATIC void
> > > > > >  xfs_fs_put_super(
> > > > > >  	struct super_block	*sb)
> > > > > > @@ -2003,6 +2048,11 @@ static const struct super_operations
> > > > > > xfs_super_operations = {
> > > > > >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> > > > > >  };
> > > > > >  
> > > > > > +static const struct fs_context_operations xfs_context_ops =
> > > > > > {
> > > > > > +	.parse_param = xfs_parse_param,
> > > > > > +	.get_tree    = xfs_get_tree,
> > > > > > +};
> > > > > > +
> > > > > >  static struct file_system_type xfs_fs_type = {
> > > > > >  	.owner			= THIS_MODULE,
> > > > > >  	.name			= "xfs",
> > > > > > 
> 
