Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20685C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3EE21897
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="HMBFKSgH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="F0JXAmtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfH3LKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:10:54 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41359 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726902AbfH3LKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 07:10:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9E37751C;
        Fri, 30 Aug 2019 07:10:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 07:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        A96OFP1y5veSsW2QjqBuy7qzCesSYeToEfgqT6eZmWo=; b=HMBFKSgHO/RGhCia
        uyLi077+EDTqgd9YLI1TrzRmxuIRaS5FTTYplFwPSqHMuS/t/srBX4p3BU/3+qOo
        7uK1GQilvaBC4DHxVeF+FB9wQl/7wjlj6ya1zn5s1N9Cw1OJNfLhwm1L+n4Aoc3L
        lMf7jriBZGq6fuc8w0pf98f6ArtX3u9LwQjEn11RcbpovPkbEULA6IuAovrnG4Ra
        buARVRo/1elk6fHuSSXYQRpncNxbZsFGdncDd+sMt1p1CvgFJSrm0AA6paKGYdXx
        4ScZVoYje2wRmpfH3iU/yavLalECxjH0iCuwYA1zC5d2akoElxL3TEtZswoTxORg
        2rxzaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=A96OFP1y5veSsW2QjqBuy7qzCesSYeToEfgqT6eZm
        Wo=; b=F0JXAmtL0djkae3kd1AL2/U6uQY930lEWNrYK/nU9Kn4fywcYp0jnvg/o
        hCuh+fxUKnovmjHVB0/bzSR4wAAfZEzHPjw/KlCW2UCz/4moS0ZmoaeegmW0KTzK
        BCcwX43q881gSPt5Q2TzocSE3rq56REVvOxAWIQA4UZbdgi3p9ujzhloiw9FhSax
        8y7/N55ly1jTKkd9W36/wvmqyXyPVM5aJP8YsSh5axH3Pmj9bunrjtyxMLJKvqP4
        ygnrJf2PfWCYBDrm1LZ9D7kzhtzpLn/dVWXtybURDgvxq7m7+EEoSfX9O0e8FWFT
        2hff8WhKxr/jE759ySnOgaeL4yg2Q==
X-ME-Sender: <xms:OwRpXUspHtaIsSMyIdOY4jWI1vY2dIArj97wJH6cUkoA8j96Zc-ocQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OwRpXX9soVDNWBgl5mQA4fq5tMO-bDyqO3VRnW4W_DklQXA0x_umMA>
    <xmx:OwRpXS_tReLidPKxMuMfRSN311TsBUfGm8QLUT7jcKwJuogcPfy5Fg>
    <xmx:OwRpXRPMktKUBAGo_yJuTNfQwU0IJJouNgVnW9cQ2kQ8Sg0wvzDxfw>
    <xmx:PARpXeJk3KjLOpbtLjqMYrfalGwfZGMbCFIQzq10GXP3luWqWe6FgA>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A75CD6005B;
        Fri, 30 Aug 2019 07:10:48 -0400 (EDT)
Message-ID: <47ce837c1e282ca679678ef7aba3320e2a570555.camel@themaw.net>
Subject: Re: [PATCH v2 11/15] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 19:10:44 +0800
In-Reply-To: <20190828132803.GD16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652201687.2607.7837619342391140067.stgit@fedora-28>
         <20190828132803.GD16389@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-28 at 09:28 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 09:00:16AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .reconfigure that performs
> > remount validation as previously done by the super_operations
> > .remount_fs method.
> > 
> > An attempt has also been made to update the comment about options
> > handling problems with mount(8) to reflect the current situation.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   84
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 84 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 76374d602257..aae0098fecab 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1522,6 +1522,89 @@ xfs_fs_remount(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * There have been problems in the past with options passed from
> > mount(8).
> > + *
> > + * The problem being that options passed by mount(8) in the case
> > where only
> > + * the the mount point path is given would consist of the existing
> > fstab
> > + * options with the options from mtab for the current mount merged
> > in and
> > + * the options given on the command line last. But the result
> > couldn't be
> > + * relied upon to accurately reflect the current mount options so
> > that
> > + * rejecting options that can't be changed on reconfigure could
> > erronously
> > + * cause mount failure.
> > + *
> > + * The mount-api uses a legacy mount options handler in the VFS to
> > handle
> > + * mount(8) so these options will continue to be passed. Even if
> > mount(8)
> > + * is updated to use fsopen()/fsconfig()/fsmount() it's likely to
> > continue
> > + * to set the existing options so options problems with
> > reconfigure could
> > + * continue.
> > + *
> > + * For the longest time mtab locking was a problem and this could
> > have been
> > + * one possible cause. It's also possible there could have been
> > options
> > + * order problems.
> > + *
> > + * That has changed now as mtab is a link to the proc file system
> > mount
> > + * table so mtab options should be always accurate.
> > + *
> > + * Consulting the util-linux maintainer (Karel Zak) he is
> > confident that,
> > + * in this case, the options passed by mount(8) will be those of
> > the current
> > + * mount and the options order should be a correct merge of fstab
> > and mtab
> > + * options, and new options given on the command line.
> > + *
> > + * So, in theory, it should be possible to compare incoming
> > options and
> > + * return an error for options that differ from the current mount
> > and can't
> > + * be changed on reconfigure to prevent users from believing they
> > might have
> > + * changed mount options using remount which can't be changed.
> > + *
> > + * But for now continue to return success for every reconfigure
> > request, and
> > + * silently ignore all options that can't actually be changed.
> > + */
> 
> This seems like all good information for a commit log description or
> perhaps to land in a common header where some of these fs context
> bits
> are declared, but overly broad for a function header comment for an
> XFS
> callback. I'd more expect some information around the fundamental
> difference between 'mp' and 'new_mp,' where those come from, what
> they
> mean, etc. From the code, it seems like new_mp is transient and
> reflects
> changes that we need to incorporate in the original mp..?

The reason I looked into this is becuase of a fairly lengthy
comment in the original source and that lead to this rather
verbose tail about what I found.

It's not so much a mount context problem becuase it's due
to the way user space constructs the mount options from
various sources where options are present.

So I don't think it's something that the mount context
code can resolve.

Which leaves a bunch of (I think) useful information
without a palce to live so it can be referred to ...
suggestions?

> 
> Brian
> 
> > +STATIC int
> > +xfs_reconfigure(
> > +	struct fs_context *fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> > +	struct xfs_mount        *new_mp = fc->s_fs_info;
> > +	xfs_sb_t		*sbp = &mp->m_sb;
> > +	int			flags = fc->sb_flags;
> > +	int			error;
> > +
> > +	error = xfs_validate_params(new_mp, ctx, false);
> > +	if (error)
> > +		return error;
> > +
> > +	/* inode32 -> inode64 */
> > +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > +	}
> > +
> > +	/* inode64 -> inode32 */
> > +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > +	}
> > +
> > +	/* ro -> rw */
> > +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> > +		error = xfs_remount_rw(mp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	/* rw -> ro */
> > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> > +		error = xfs_remount_ro(mp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Second stage of a freeze. The data is already frozen so we only
> >   * need to take care of the metadata. Once that's done sync the
> > superblock
> > @@ -2049,6 +2132,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> > +	.reconfigure = xfs_reconfigure,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

