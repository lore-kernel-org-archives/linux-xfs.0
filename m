Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9096C3A5A4
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 02:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9742184D
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 02:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="nSpKLtJ7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FIKKG3xN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfIBClo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 22:41:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36143 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729061AbfIBClo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 22:41:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D239121AF1;
        Sun,  1 Sep 2019 22:41:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 01 Sep 2019 22:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        cNERRUYFex8x+dQUJ3wdN9dnqGkSDy7nae3nuZVuoBA=; b=nSpKLtJ7asjU/1mL
        JCsKYXRneiInG9nSmukd9Y5a1payNljevF7ZIe/chZAdKQreAC98nnzBc4HDqe+7
        gSEjGhvssK+blkQ3Ie6LZdur1fY0YBeeG9ioGh8KYaZUK2fkX1+t3FGr6nmaHhlL
        09hyqbtgRKfVQ1Jxp0uzBlLxdyM1KSKkxuqQiAOJMyqRMa7+osTXDVTBUZcJ6gUi
        80z3YE32PshTkzFi8yLMT/n39rPvntnj5sASMcX+d2IVKbgYDsURrpykMv1mClk7
        xdPjzIglBYDBYKWB1WtDfghCCBmvJwXvnQME6oFjkCjq5e48sZx9pUAbLCuZiDJk
        mOor/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=cNERRUYFex8x+dQUJ3wdN9dnqGkSDy7nae3nuZVuo
        BA=; b=FIKKG3xNOuNRcDhSQmXmqczuL3IeJZMAraR2tHk7ZGqOyRGPSqAQfWeB8
        XNYqSOjZIv1RxhTgZcWvzpAnzTVt8X0ShJKb7vu8KSJaFvoI9VtNzBhs1GX8sizR
        FXpKv9O+XWY+uI2Qo6t8ZU56edSZqTjqE5tQ1Huc4ltBJ/urbBgF50ObE88be4lZ
        hrWJmcSILBKamPq3jN9sBV/IbObHEz9usgszsmQj1Tsxx+EBVL1v709lZ/0z1JcH
        Toee+cS5DeyUdtnFCPdWI7tHZE0Lh6Lyol61qaUbk48/zvE6Y7QFtHw3Z41/avvR
        mXlPI+qLjUA56ElFBs7P57WXs89jA==
X-ME-Sender: <xms:ZYFsXXvcoykbL_ElelV_HlWG7ccQBXUlHI1Kyz7E4h7Nks5J0M0VoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeiledgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudekfedrleefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ZYFsXUxP6p8M1ew4Pd4EOwOz9jCHsWtlWpsqHDvZOhffoli58AWHRA>
    <xmx:ZYFsXdgUEathzboL5B0nYm0WVIV2Viie6xWzH-cYVWezkbNvnbVinA>
    <xmx:ZYFsXYCPs46EZUC8CW-kPY_VKNxxDn-pdtMnnq2jR_EoEsp_3zF6zw>
    <xmx:ZoFsXS8GsZ__NmoaS2O1Dr4XAXqyopAziW9BL31ve6SyTkL_VeQBdg>
Received: from mickey.themaw.net (unknown [118.209.183.93])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6CBD80059;
        Sun,  1 Sep 2019 22:41:38 -0400 (EDT)
Message-ID: <aadd76d38b7153831c80b820b21984ed10d28eef.camel@themaw.net>
Subject: Re: [PATCH v2 11/15] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Mon, 02 Sep 2019 10:41:34 +0800
In-Reply-To: <20190830115650.GB25927@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652201687.2607.7837619342391140067.stgit@fedora-28>
         <20190828132803.GD16389@bfoster>
         <47ce837c1e282ca679678ef7aba3320e2a570555.camel@themaw.net>
         <20190830115650.GB25927@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-08-30 at 07:56 -0400, Brian Foster wrote:
> On Fri, Aug 30, 2019 at 07:10:44PM +0800, Ian Kent wrote:
> > On Wed, 2019-08-28 at 09:28 -0400, Brian Foster wrote:
> > > On Fri, Aug 23, 2019 at 09:00:16AM +0800, Ian Kent wrote:
> > > > Add the fs_context_operations method .reconfigure that performs
> > > > remount validation as previously done by the super_operations
> > > > .remount_fs method.
> > > > 
> > > > An attempt has also been made to update the comment about
> > > > options
> > > > handling problems with mount(8) to reflect the current
> > > > situation.
> > > > 
> > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > ---
> > > >  fs/xfs/xfs_super.c |   84
> > > > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 84 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index 76374d602257..aae0098fecab 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -1522,6 +1522,89 @@ xfs_fs_remount(
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/*
> > > > + * There have been problems in the past with options passed
> > > > from
> > > > mount(8).
> > > > + *
> > > > + * The problem being that options passed by mount(8) in the
> > > > case
> > > > where only
> > > > + * the the mount point path is given would consist of the
> > > > existing
> > > > fstab
> > > > + * options with the options from mtab for the current mount
> > > > merged
> > > > in and
> > > > + * the options given on the command line last. But the result
> > > > couldn't be
> > > > + * relied upon to accurately reflect the current mount options
> > > > so
> > > > that
> > > > + * rejecting options that can't be changed on reconfigure
> > > > could
> > > > erronously
> > > > + * cause mount failure.
> > > > + *
> > > > + * The mount-api uses a legacy mount options handler in the
> > > > VFS to
> > > > handle
> > > > + * mount(8) so these options will continue to be passed. Even
> > > > if
> > > > mount(8)
> > > > + * is updated to use fsopen()/fsconfig()/fsmount() it's likely
> > > > to
> > > > continue
> > > > + * to set the existing options so options problems with
> > > > reconfigure could
> > > > + * continue.
> > > > + *
> > > > + * For the longest time mtab locking was a problem and this
> > > > could
> > > > have been
> > > > + * one possible cause. It's also possible there could have
> > > > been
> > > > options
> > > > + * order problems.
> > > > + *
> > > > + * That has changed now as mtab is a link to the proc file
> > > > system
> > > > mount
> > > > + * table so mtab options should be always accurate.
> > > > + *
> > > > + * Consulting the util-linux maintainer (Karel Zak) he is
> > > > confident that,
> > > > + * in this case, the options passed by mount(8) will be those
> > > > of
> > > > the current
> > > > + * mount and the options order should be a correct merge of
> > > > fstab
> > > > and mtab
> > > > + * options, and new options given on the command line.
> > > > + *
> > > > + * So, in theory, it should be possible to compare incoming
> > > > options and
> > > > + * return an error for options that differ from the current
> > > > mount
> > > > and can't
> > > > + * be changed on reconfigure to prevent users from believing
> > > > they
> > > > might have
> > > > + * changed mount options using remount which can't be changed.
> > > > + *
> > > > + * But for now continue to return success for every
> > > > reconfigure
> > > > request, and
> > > > + * silently ignore all options that can't actually be changed.
> > > > + */
> > > 
> > > This seems like all good information for a commit log description
> > > or
> > > perhaps to land in a common header where some of these fs context
> > > bits
> > > are declared, but overly broad for a function header comment for
> > > an
> > > XFS
> > > callback. I'd more expect some information around the fundamental
> > > difference between 'mp' and 'new_mp,' where those come from, what
> > > they
> > > mean, etc. From the code, it seems like new_mp is transient and
> > > reflects
> > > changes that we need to incorporate in the original mp..?
> > 
> > The reason I looked into this is becuase of a fairly lengthy
> > comment in the original source and that lead to this rather
> > verbose tail about what I found.
> > 
> > It's not so much a mount context problem becuase it's due
> > to the way user space constructs the mount options from
> > various sources where options are present.
> > 
> > So I don't think it's something that the mount context
> > code can resolve.
> > 
> > Which leaves a bunch of (I think) useful information
> > without a palce to live so it can be referred to ...
> > suggestions?
> > 
> 
> I suppose there's always the commit log description if there isn't a
> suitable place in the code.

Ok, I'll try and cut it down to a more reasonable size while
keeping the gist of what it describes and move the detail
to the changelog entry.

> 
> Brian
> 
> > > Brian
> > > 
> > > > +STATIC int
> > > > +xfs_reconfigure(
> > > > +	struct fs_context *fc)
> > > > +{
> > > > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > > > +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> > > > +	struct xfs_mount        *new_mp = fc->s_fs_info;
> > > > +	xfs_sb_t		*sbp = &mp->m_sb;
> > > > +	int			flags = fc->sb_flags;
> > > > +	int			error;
> > > > +
> > > > +	error = xfs_validate_params(new_mp, ctx, false);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	/* inode32 -> inode64 */
> > > > +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > > > +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > > > +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > > > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > > > > sb_agcount);
> > > > +	}
> > > > +
> > > > +	/* inode64 -> inode32 */
> > > > +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > > > +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > > > +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > > > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > > > > sb_agcount);
> > > > +	}
> > > > +
> > > > +	/* ro -> rw */
> > > > +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags &
> > > > SB_RDONLY)) {
> > > > +		error = xfs_remount_rw(mp);
> > > > +		if (error)
> > > > +			return error;
> > > > +	}
> > > > +
> > > > +	/* rw -> ro */
> > > > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags &
> > > > SB_RDONLY)) {
> > > > +		error = xfs_remount_ro(mp);
> > > > +		if (error)
> > > > +			return error;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Second stage of a freeze. The data is already frozen so we
> > > > only
> > > >   * need to take care of the metadata. Once that's done sync
> > > > the
> > > > superblock
> > > > @@ -2049,6 +2132,7 @@ static const struct super_operations
> > > > xfs_super_operations = {
> > > >  static const struct fs_context_operations xfs_context_ops = {
> > > >  	.parse_param = xfs_parse_param,
> > > >  	.get_tree    = xfs_get_tree,
> > > > +	.reconfigure = xfs_reconfigure,
> > > >  };
> > > >  
> > > >  static struct file_system_type xfs_fs_type = {
> > > > 

