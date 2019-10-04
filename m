Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11173C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 23:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCA87222BE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 23:16:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="afgYepB4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="enZqRZCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfJDXQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 19:16:27 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39967 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728913AbfJDXQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 19:16:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D7DE3431;
        Fri,  4 Oct 2019 19:16:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 19:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        +03vUfZ26+PM7BBCCIoygp/r1MBbtrV3NmRyXDhPJnM=; b=afgYepB4RwsfOBSK
        ectPJRg9IqIY1XtngfUKc7J1mwVCQTmbd8AMVJve8MNwBjOa5x1dxcgwo4/7Xh6q
        i7NYsOREM21y3G06xASBLiX2fz4s32VxkuTcy9uRgBphREYZ3/dGY+hdzl+Rhmch
        9viQgG9IVrwd13MKFO1l0C4HWYRrBduFOui569srQpiYNKobrKSVvpHzLJ7j8w2o
        GKwwJlmxdQmrEqlJp9sQ/xnAGhGwYfGR4BY7NY8eHOQnDLyz7ARLnMnjTmS2adD2
        ym7h1GLYEltGXjcxPu1cDdAxZwDEnnelLNilGV2WrAZDMwX80iqXQBPubc0wdGco
        w93a8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=+03vUfZ26+PM7BBCCIoygp/r1MBbtrV3NmRyXDhPJ
        nM=; b=enZqRZCitQ8+MvVOYkVRyOO9uPstjKy+o96hbe3sM95wr5BvoCGvqJGRR
        anOXIOTEgnRP4GzJ4lfiEWK+YsrtQFQ8nQMQL1H3el5puiLsyf+NNklWe6TWCbkP
        Xp0gQOlBX+dtHaSMyGhknjBNqeecEzmJ+AdUfZbr/nKfMNzb/ZqLCPwTjxdFx68G
        rvXBmZyT57nRIRRxDL+1ThdMAt2vVLQyu6y27wHH+7WepoUuGXLSOull+Pg1gY++
        D6pbFRJ57n7ih7XJd41923jmCDZq1cP4K4tz5pgTpTFHBEfRZuztikOVsDpRvhI+
        xJAh2+D9h/b2IPCL7kq1atr5sw52w==
X-ME-Sender: <xms:ydKXXaMFRlHhNRv3maXjAQ4NCYqesoWeBuYXGRDlruOyMs0urbq7nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpeguvghstg
    hrihhpthhiohhnrdhhmhenucfkphepuddukedrvddtkedrudekjedrudekieenucfrrghr
    rghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:ydKXXaNM-rtmRAnLc2-9vl_NXjyYmjUMkvM5gwqpbEIl5aooqzW70g>
    <xmx:ydKXXeVww4Xcs5CYR2AAoQFVrR8ZMVUUXcBp1mBa81gwneqxh2e-xw>
    <xmx:ydKXXdvR5AdH_cNgMCeFhDRv3Dk0guQSCrUWBu0-SYx3UomBUjFNZA>
    <xmx:ydKXXbeVOFdLWteDEQrOFaFvY1cK1fm_wDDLQk1WubOqBAS7vgULFw>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 606CD80059;
        Fri,  4 Oct 2019 19:16:22 -0400 (EDT)
Message-ID: <65ceea4be3da919a0194e66e27eaf49692d26e38.camel@themaw.net>
Subject: Re: [PATCH v4 13/17] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat, 05 Oct 2019 07:16:17 +0800
In-Reply-To: <20191004155321.GE7208@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <157009838772.13858.3951542955676751036.stgit@fedora-28>
         <20191004155321.GE7208@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-10-04 at 11:53 -0400, Brian Foster wrote:
> On Thu, Oct 03, 2019 at 06:26:27PM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .reconfigure that performs
> > remount validation as previously done by the super_operations
> > .remount_fs method.
> > 
> > An attempt has also been made to update the comment about options
> > handling problems with mount(8) to reflect the current situation.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   68
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 68 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index ddcf030cca7c..06f650fb3a8c 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1544,6 +1544,73 @@ xfs_fs_remount(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * There can be problems with options passed from mount(8) when
> > + * only the mount point path is given. The options are a merge
> > + * of options from the fstab, mtab of the current mount and
> > options
> > + * given on the command line.
> > + *
> > + * But this can't be relied upon to accurately reflect the current
> > + * mount options. Consequently rejecting options that can't be
> > + * changed on reconfigure could erronously cause a mount failure.
> > + *
> > + * Nowadays it should be possible to compare incoming options
> > + * and return an error for options that differ from the current
> > + * mount and can't be changed on reconfigure.
> > + *
> > + * But this still might not always be the case so for now continue
> > + * to return success for every reconfigure request, and silently
> > + * ignore all options that can't actually be changed.
> > + *
> > + * See the commit log entry of this change for a more detailed
> > + * desription of the problem.
> > + */
> 
> But the commit log entry doesn't include any new info..?

I thought I did, honest, ;)

> 
> How about this.. we already have a similar comment in
> xfs_fs_remount()
> that I happen to find a bit more clear. It also obviously has
> precedent.
> How about we copy that one to the top of this function verbatim, and
> whatever extra you want to get across can be added to the commit log
> description. Hm?

Trying to understand that comment and whether it was still needed
is what lead to this.

It is still relevant and IIRC the only extra info. needed is that
the mount-api implementation can't help with the problem because
it's what's given to the kernel via. mount(8) and that must continue
to be supported.

I'll re-read the original message, maybe retaining it is sufficient
to imply the above.

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
> > @@ -2069,6 +2136,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> > +	.reconfigure = xfs_reconfigure,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

