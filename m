Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAEBC4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 01:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B640208C3
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 01:16:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="TQLC3lc0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qMTt+bad"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfI0BQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 21:16:39 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37619 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbfI0BQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 21:16:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8B95E572;
        Thu, 26 Sep 2019 21:16:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 26 Sep 2019 21:16:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        vyifXvTTaIoxUGEnaj40qpo5cC/OQP5lCMlGy2PUiis=; b=TQLC3lc0UuFvyzII
        TdYP7E+jZEJAKwDuwVeBhDzMxn7nBxX8bT6zaN5iKRxNvARVg2Gn2BuibvAVWuC8
        /SZ1u4E2dT0COKGn1bu3vyFl0UDbZSU2dsJwfDKXNGsYhWJ62LQqvzdefB0KEkxL
        cHvw1dL3wLuoznHBR9rJZGPrHj25gZQCXEtQ1GZslnCfefPY7x1pdRsmXoELPMhX
        7rzZJDRqGKILwnV2+g69TJaw1d0cKIUfplknkwwT4hv1Qyu3QqerSvi1DYl6Co/R
        aIGYoSveSjoTYrutxZWWeW9J1G6E6r4AyRpxMPeHVEtG5w3tAZVGZdBH/PGX1CLf
        sP8kmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=vyifXvTTaIoxUGEnaj40qpo5cC/OQP5lCMlGy2PUi
        is=; b=qMTt+badxXZVtyzCjE2xyKZ0uV5etjWCOM7CnbMmnQPVLWNW1ZGGYwwMi
        2lj2TX1lZ8esr/YP8fH4dppzdiMAtd8m39XI6dWRIYsx/Z+U5WEHcqsWy2qacD1J
        vEYigbo8nWZukmsxRjOIR01TBgSUYDD6yArPos8+EKs8TofC2LTweQLqD/LSz4Ka
        Cy42gUPhHJUoC5OfZFnSqf7G5a8f+NY5C5gGfpp6qpnP8pdgzW9iDQt6lz/p7Zcw
        4OX92nNPfJAhkknPBUHeOIG6dkR++LRMcXqsJSqMPVnk7rW1Idq15PuAxJ9AXBEA
        FSpMT6dPli0b250N7zZR3+wCfPyrw==
X-ME-Sender: <xms:82KNXdb946gDxaK2_Y7ZaG0JJKpwNF8MbYZAtIZhfMHScV_xKtQdfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeehgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    duieekrddvieenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:82KNXZhMyG67ggo3qmT9EOj-44Uob3ORMrVhY-s5Yx4ogJl_RCgRkQ>
    <xmx:82KNXS4ECwm8DZPthlbetbBwFYUGGLAZP40TSzvt-hSrkYsYTe4t0Q>
    <xmx:82KNXRpkJrGTABccYn4E1lgkVwfFnGChuyLpHDGuajiq04pmVCQxCA>
    <xmx:9GKNXWv9uTgmrlKJXuTkOVq4x0_H07MvonON5di2NwlebFhOrz3jKw>
Received: from mickey.themaw.net (unknown [118.209.168.26])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1694D6005A;
        Thu, 26 Sep 2019 21:16:32 -0400 (EDT)
Message-ID: <00a6e88abe1b3d60b104f592df75270febae493a.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 09/16] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 27 Sep 2019 09:16:28 +0800
In-Reply-To: <20190926111416.GA26363@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933136908.20933.15050470634891698659.stgit@fedora-28>
         <20190924143823.GD17688@bfoster>
         <3eb80542b3a247173dcef4ddf5494daa3c90e72c.camel@themaw.net>
         <a55278f2167025451aa6092f3ad5fab8bbef967f.camel@themaw.net>
         <20190925143414.GE21991@bfoster>
         <4f6baf799c38f83dbef45b555f9bebcdc5f4311b.camel@themaw.net>
         <20190926111416.GA26363@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-09-26 at 07:14 -0400, Brian Foster wrote:
> On Thu, Sep 26, 2019 at 11:27:40AM +0800, Ian Kent wrote:
> > On Wed, 2019-09-25 at 10:34 -0400, Brian Foster wrote:
> > > On Wed, Sep 25, 2019 at 04:07:08PM +0800, Ian Kent wrote:
> > > > On Wed, 2019-09-25 at 15:42 +0800, Ian Kent wrote:
> > > > > On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> > > > > > On Tue, Sep 24, 2019 at 09:22:49PM +0800, Ian Kent wrote:
> > > > > > > Add the fs_context_operations method .get_tree that
> > > > > > > validates
> > > > > > > mount options and fills the super block as previously
> > > > > > > done
> > > > > > > by the file_system_type .mount method.
> > > > > > > 
> > > > > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > > > > ---
> > > > > > >  fs/xfs/xfs_super.c |   50
> > > > > > > ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > > > >  1 file changed, 50 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > > > index ea3640ffd8f5..6f9fe92b4e21 100644
> > > > > > > --- a/fs/xfs/xfs_super.c
> > > > > > > +++ b/fs/xfs/xfs_super.c
> > > > > > > @@ -1933,6 +1933,51 @@ xfs_fs_fill_super(
> > > > > > >  	return error;
> > > > > > >  }
> > > > > > >  
> > > > > > > +STATIC int
> > > > > > > +xfs_fill_super(
> > > > > > > +	struct super_block	*sb,
> > > > > > > +	struct fs_context	*fc)
> > > > > > > +{
> > > > > > > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > > > > > > +	struct xfs_mount	*mp = sb->s_fs_info;
> > > > > > > +	int			silent = fc->sb_flags &
> > > > > > > SB_SILENT;
> > > > > > > +	int			error = -ENOMEM;
> > > > > > > +
> > > > > > > +	mp->m_super = sb;
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * set up the mount name first so all the errors will
> > > > > > > refer to
> > > > > > > the
> > > > > > > +	 * correct device.
> > > > > > > +	 */
> > > > > > > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN,
> > > > > > > GFP_KERNEL);
> > > > > > > +	if (!mp->m_fsname)
> > > > > > > +		return -ENOMEM;
> > > > > > > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > > > > > > +
> > > > > > > +	error = xfs_validate_params(mp, ctx, false);
> > > > > > > +	if (error)
> > > > > > > +		goto out_free_fsname;
> > > > > > > +
> > > > > > > +	error = __xfs_fs_fill_super(mp, silent);
> > > > > > > +	if (error)
> > > > > > > +		goto out_free_fsname;
> > > > > > > +
> > > > > > > +	return 0;
> > > > > > > +
> > > > > > > + out_free_fsname:
> > > > > > > +	sb->s_fs_info = NULL;
> > > > > > > +	xfs_free_fsname(mp);
> > > > > > > +
> > > > > > 
> > > > > > I'm still not following the (intended) lifecycle of mp
> > > > > > here.
> > > > > > Looking
> > > > > > ahead in the series, we allocate mp in
> > > > > > xfs_init_fs_context()
> > > > > > and
> > > > > > set
> > > > > > some state. It looks like at some point we grow an
> > > > > > xfs_fc_free()
> > > > > > callback that frees mp, but that doesn't exist as of yet.
> > > > > > So is
> > > > > > that
> > > > > > a
> > > > > > memory leak as of this patch?
> > > > > > 
> > > > > > We also call xfs_free_fsname() here (which doesn't reset
> > > > > > pointers
> > > > > > to
> > > > > > NULL) and open-code kfree()'s of a couple of the same
> > > > > > fields in
> > > > > > xfs_fc_free(). Those look like double frees to me.
> > > > > > 
> > > > > > Hmm.. I guess I'm kind of wondering why we lift the mp
> > > > > > alloc
> > > > > > out of
> > > > > > the
> > > > > > fill super call in the first place. At a glance, it doesn't
> > > > > > look
> > > > > > like
> > > > > > we
> > > > > > do anything in that xfs_init_fs_context() call that we
> > > > > > couldn't
> > > > > > do
> > > > > > a
> > > > > > bit
> > > > > > later..
> > > > > 
> > > > > Umm ... yes ...
> > > > > 
> > > > > I think I've got the active code path right ...
> > > > > 
> > > > > At this point .mount == xfs_fs_mount() which will calls
> > > > > xfs_fs_fill_super() to fill the super block.
> > > > > 
> > > > > xfs_fs_fill_super() allocates the super block info struct and
> > > > > sets
> > > > > it in the super block private info field, then calls
> > > > > xfs_parseargs()
> > > > > which still allocates mp->m_fsname at this point, to
> > > > > accomodate a
> > > > > similar free pattern in xfs_test_remount_options().
> > > > > 
> > > > > It then calls __xfs_fs_fill_super() which doesn't touch those
> > > > > fsname
> > > > > fields or mp to fit in with what will be done later.
> > > > > 
> > > > > If an error occurs both the fsname fields (xfs_free_fsname())
> > > > > and
> > > > > mp
> > > > > are freed by the main caller, xfs_fs_fill_super().
> > > > > 
> > > > > I think that process is ok.
> > > > > 
> > > > > The mount api process that isn't active yet is a bit
> > > > > different.
> > > > > 
> > > > > The context (ctx), a temporary working space, is allocated
> > > > > then
> > > > > saved
> > > > > in the mount context (fc) and the super block info is also
> > > > > allocated
> > > > > and saved in the mount context in it's field of the same name
> > > > > as
> > > > > the
> > > > > private super block info field, s_fs_info.
> > > > > 
> > > > > The function xfs_fill_super() is called as a result of the
> > > > > .get_tree()
> > > > > mount context operation to fill the super block.
> > > > > 
> > > > > During this process, when the VFS successfully allocates the
> > > > > super
> > > > > block s_fs_info is set in the super block and the mount
> > > > > context
> > > > > field set to NULL. From this point freeing the private super
> > > > > block
> > > > > info becomes part of usual freeing of the super block with
> > > > > the
> > > > > super
> > > > > operation .kill_sb().
> > > > > 
> > > > > But if the super block allocation fails then the mount
> > > > > context
> > > > > s_fs_info field remains set and is the responsibility of the
> > > > > mount context operations .fc_free() method to clean up.
> > > > > 
> > > > > Now the VFS calls to xfs_fill_super() after this.
> > > > > 
> > > > > I should have been able to leave xfs_fill_super() it as it
> > > > > was with:
> > > > >         sb->s_fs_info = NULL;
> > > > >         xfs_free_fsname(mp);
> > > > >         kfree(mp);
> > > > > and that should have been ok but it wasn't, there was some
> > > > > sort
> > > > > of
> > > > > allocation problem, possibly a double free, causing a crash.
> > > > > 
> > > > > Strictly speaking this cleanup process should be carried out
> > > > > by
> > > > > either the mount context .fc_free() or super operation
> > > > > .kill_sb()
> > > > > and that's what I want to do.
> > > > 
> > > > Umm ... but I can't actually do that ...
> > > > 
> > > > Looking back at xfs I realize that the filling of the super
> > > > block is meant to leave nothing allocated and set
> > > > sb->s_fs_info = NULL on error so that ->put_super() won't try
> > > > and cleanup a whole bunch of stuff that hasn't been done.
> > > > 
> > > > Which brings me back to what I originally had above ... which
> > > > we believe doesn't work ?
> > > > 
> > > 
> > > It looks like perhaps the assignment of sb->s_fs_info was lost as
> > > well?
> > > Skipping to the end, I see xfs_init_fs_context() alloc mp and
> > > assign
> > > fc->s_fs_info. xfs_get_tree() leads to xfs_fill_super(), which
> > > somehow
> > > gets mp from sb->s_fs_info (not fc->...), but then resets sb-
> > > > s_fs_info
> > > on error and frees the names, leaving fs->s_fs_info so presumably
> > > xfs_fc_free() can free mp along with a couple of the names
> > > (again). I
> > > can't really make heads or tails of what this is even attempting
> > > to
> > > do.
> > 
> > Ha, it seems a bit mysterious, but it's actually much simpler
> > than it appears.
> > 
> 
> Feel free to explain any of the above..? Where do you currently
> assign
> sb->s_fs_info, for example?

The VFS does the assignment, see below.

> 
> > > That aside, it's not clear to me why the new code can't follow a
> > > similar
> > > pattern as the old code with regard to allocation. Allocate mp in
> > > xfs_fill_super() and set up sb/fc pointers, reset pointers and
> > > free
> > > mp
> > > on error return. Otherwise, xfs_fc_free() checks for fc-
> > > >s_fs_info !=
> > > NULL and frees mp from there. Is there some reason we can't
> > > continue
> > > to
> > > do that?
> > 
> > I think not without a fairly significant re-design.
> > 
> > The main difference is the mount-api will allocate the super
> > block later than the old mount code.
> > 
> > Basically, if file system parameter parsing fails the super
> > block won't get allocated.
> > 
> > So the super block isn't available during parameter parsing
> > but the file system private data structure may be needed for
> > it, so it comes from the file system context at that point.
> > 
> > When the super block is successfully allocated the file system
> > private data structure is set in the super block (and the field
> > NULLed in the context) and things progress much the same as
> > before from that point.
> > 
> > That's the essential difference in the process AFAICS.
> > 
> 
> I see. This is probably something that should be noted in the commit
> log (that the ordering changes from before such that we need to
> allocate
> mp a bit earlier). This is reasonable because even though the current
> code allocs mp in the fill_super callback, we parse arguments
> immediately after the mp allocation and don't otherwise rely on the
> sb
> in that code.
> 
> If I follow correctly, it sounds like perhaps we need to separate the
> management of sb->s_fs_info from the "ownership" of mp. For example,
> allocate mp, assign fc->s_fs_info and free via xfs_fc_free() as you
> do
> now. In the xfs_fill_super() callback, pull mp from fc->s_fs_info and
> assign it to sb->s_fs_info. If we fail at this point, reset
> sb->s_fs_info to NULL and let the fc infrastructure deal with freeing
> mp
> in its own callback.

The mount api callbacks are for use during setup and don't really
apply once that's done by the mount api.

Lets describe the life cycle of s_fs_info by going through the call
path from the xfs_get_tree() fs context operation.

At this point the context has been setup by .init_fs_context ( aka.
xfs_init_fs_context()), and fc->s_fs_info == mp and parameter parsing
has been done.

Then the .get_tree() method gets called (aka. fs_get_tree) and all
this does (now) is call get_tree_bdev() as Al requested.

Even though that's changed it still ends up calling similar VFS
functions to what it did before.

Now:
int get_tree_bdev(struct fs_context *fc,
                int (*fill_super)(struct super_block *,
                                  struct fs_context *))
{

skip ... (the usual stuff until we get to)

        fc->sb_flags |= SB_NOSEC;
        fc->sget_key = bdev;
        s = sget_fc(fc, test_bdev_super_fc, set_bdev_super_fc);
        mutex_unlock(&bdev->bd_fsfreeze_mutex);
        if (IS_ERR(s))
                return PTR_ERR(s);

        if (s->s_root) {
		snip ... (mount root already exists)
	} else {
                s->s_mode = mode;
                snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
                sb_set_blocksize(s, block_size(bdev));
                error = fill_super(s, fc);
                if (error) {
                        deactivate_locked_super(s);
                        return error;
                }

                s->s_flags |= SB_ACTIVE;
                bdev->bd_super = s;
        }

        BUG_ON(fc->root);
        fc->root = dget(s->s_root);
	return 0;
}

This is to establish the order of what's done.

The thing we want to look at is the sget_fc() function.

struct super_block *sget_fc(struct fs_context *fc,
           int (*test)(struct super_block *, struct fs_context *),
           int (*set)(struct super_block *, struct fs_context *))
{
	snip ... (usual stuff that finds or allocates a super block)

        s->s_fs_info = fc->s_fs_info;
        err = set(s, fc);
        if (err) {
                s->s_fs_info = NULL;
                spin_unlock(&sb_lock);
                destroy_unused_super(s);
                return ERR_PTR(err);
        }
        fc->s_fs_info = NULL;

	snip ... (remaining setup stuff)

	return s;
}

This is where the s_fs_info changes from being the responsibility
of the fs context to being the responsibility of the super block.

And you can see that this is done before fill_super() is called.

Finally, fill_super() in xfs will do all the fs specific setup
and either return success or it will undo anything it has done
when returning an error, just as it did previously.

Specifically, it must set sb->s_fs_info == NULL on failure so
that when the VFS puts the super block xfs doesn't try and
release a whole bunch of stuff that wasn't setup. Consequently
mp must also be freed on error return from fill_super().

What I'm saying is that by the time fill_super() is called
everything is is a state where things need to be done pretty
much as though the mount api context isn't present, the only
thing that muddies the order of things is the calling of
.fc_free() that happens a bit later but isn't relevant to
this ordering of operations.

So I'm not sure there needs to be (or can be) changes to
the way s_fs_info is handled in the implementation.

We can go into more detail if it's needed, I am trying to
explain my motivations for doing what I've done, ;)

> 
> What I'm not clear on is whether something like xfs_fs_put_super()
> should still free mp as well. Once the filesystem successfully
> mounts,
> are we still going to see an xfs_fc_free() callback, or is this all
> just
> transient mount path stuff? If the former, perhaps put_super() should
> also not free mp and just reset its own ->s_fs_info reference. If the
> latter, then I guess we just need to understand at what point during
> a
> successful mount responsibility to free transfers from one place to
> the
> other. Thoughts?

put_super() should continue to function the same way it does
now provided fill_super() does the right thing, which I'm
pretty sure it (the mount api version) does now .

xfs_fs_put_super() won't need to free mp if an error occurs,
s_fs_info needs to be NULL in that case as has always been the
case.

And realize xfs_fc_free() (aka. .fc_free()) is largely irrelevant
from the POV of xfs once we get to fill_super().

> 
> Brian
> 
> > By the time fill_super() is called everything is set and you
> > should be able to proceed almost the same as before.
> > 
> > Ian
> > 
> > > Brian
> > > 
> > > > > So I'm not sure the allocation time and the place this is
> > > > > done
> > > > > can (or should) be done differently.
> > > > > 
> > > > > And that freeing on error exit from xfs_fill_super() is
> > > > > definitely
> > > > > wrong now! Ha, and I didn't see any crashes myself when I
> > > > > tested
> > > > > it ... maybe I need a reproducer ...
> > > > > 
> > > > > Ian
> > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > +	return error;
> > > > > > > +}
> > > > > > > +
> > > > > > > +STATIC int
> > > > > > > +xfs_get_tree(
> > > > > > > +	struct fs_context	*fc)
> > > > > > > +{
> > > > > > > +	return vfs_get_block_super(fc, xfs_fill_super);
> > > > > > > +}
> > > > > > > +
> > > > > > >  STATIC void
> > > > > > >  xfs_fs_put_super(
> > > > > > >  	struct super_block	*sb)
> > > > > > > @@ -2003,6 +2048,11 @@ static const struct
> > > > > > > super_operations
> > > > > > > xfs_super_operations = {
> > > > > > >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> > > > > > >  };
> > > > > > >  
> > > > > > > +static const struct fs_context_operations
> > > > > > > xfs_context_ops =
> > > > > > > {
> > > > > > > +	.parse_param = xfs_parse_param,
> > > > > > > +	.get_tree    = xfs_get_tree,
> > > > > > > +};
> > > > > > > +
> > > > > > >  static struct file_system_type xfs_fs_type = {
> > > > > > >  	.owner			= THIS_MODULE,
> > > > > > >  	.name			= "xfs",
> > > > > > > 

