Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1ABC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 05:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F11217F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 05:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="CHtzDiyU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d+2Gbrz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411743AbfIYFVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 01:21:44 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53859 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411742AbfIYFVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 01:21:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 08A36479;
        Wed, 25 Sep 2019 01:21:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Sep 2019 01:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        cqQLvhxxTO0Qk9ma+IbiJ4RHyWgrrbpdPOOuSaCgTuQ=; b=CHtzDiyUPByjMiXM
        7k/Xyp9ZLHF6hfn8jXSV3Ly+c5SoJZVZmJz9uEObs2cBDbjN4fynOdPFLgHHB7hd
        uKLpMFuE2JgnkUvD7EqUL8V1xEhtozXLEMk7Eie2wRxLDp7ogNWdHjsYemeANJJX
        qM74w190HuavIK74/St2Mg7Hv2eTHmdWrVXkOH/g6k0J4F0c6uA+/swrCuFln1IL
        55Udj/ni1wUnveI6iv62pHTVQ7d8HRvBncFdbK2W5KeC22sjFdc4YICIHqOpcM9u
        ZOF2S6DTOFQCHeFA4d11ASQeVGMrNgHONR2hBnTsBv/LYGkBF3OXloZIlTc3NH2H
        vYHkWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=cqQLvhxxTO0Qk9ma+IbiJ4RHyWgrrbpdPOOuSaCgT
        uQ=; b=d+2Gbrz2QquZvYZ59DGYHLzONkWmPDZWtj/SuhlwwnDFR8NjlVlG2EJ1+
        XZpc447x9dBe0pNdJVyE0t2aW5bOrgtodgYOwtKL2TeYk6P/yrZzgPPWgob/rFK4
        lmqLXx1PXIYCNSWSTp50FWdITt4kyDe+/R4DG6KHvuAvoQSvpRksENZq1tzU7USz
        upGyAUKLdbGDun443wCEx9tF2L7r5MMXhwloqmtaEdRArZmjbsnvVSZRxYfeI3+C
        wUpJeN/y5w4qxvEigVhenOQfM7/CihJX4VGkaNTnMInGwsAMLqMFU452yQUSzVJL
        hA462DYtpkaDPW862heh88JQAbP/g==
X-ME-Sender: <xms:ZfmKXVVyQ0ihUYxu0VjVvLi93z4M9CAvcZj5ZThPBMwLSEv0JqEMqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ZfmKXT2SRNzjWHAFuJIinGLHjDGBWTne_-aTjxal-duodjqRPssJKw>
    <xmx:ZfmKXatVHxKMAymQmSiQ6EzLMTATRPdxR5-d2hDXsQQyiR2_HkaPbQ>
    <xmx:ZfmKXbXu1xjFkwRYLJaAOmoC5sAa4f6s2I7ZdC3eK3upwCkM7dUlaA>
    <xmx:ZvmKXQsRGCKTfzy_5nRCC7PPSO2LxCAUO1rfbUWB2FUO9-N83AYycA>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id EDAC78005B;
        Wed, 25 Sep 2019 01:21:38 -0400 (EDT)
Message-ID: <38c7427c7961481877059a9fbf578439279e71a7.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 12/16] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 13:21:35 +0800
In-Reply-To: <20190924143844.GF17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933138468.20933.1616184640263037904.stgit@fedora-28>
         <20190924143844.GF17688@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> On Tue, Sep 24, 2019 at 09:23:04PM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .reconfigure that performs
> > remount validation as previously done by the super_operations
> > .remount_fs method.
> > 
> > An attempt has also been made to update the comment about options
> > handling problems with mount(8) to reflect the current situation.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> 
> It doesn't look like this incorporated feedback from v2..

That's right.

I spoke about that in the series cover letter, I'm not sure
where to put this and I think there's useful information that
probably should be kept, somewhere.

> 
> Brian
> 
> >  fs/xfs/xfs_super.c |   84
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 84 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index de75891c5551..e7627f7ca7f2 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1552,6 +1552,89 @@ xfs_fs_remount(
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
> > @@ -2077,6 +2160,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> > +	.reconfigure = xfs_reconfigure,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

