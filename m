Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB52AC4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9580521D81
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="UOe5Jsdw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GKxq3Stz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfJDW4k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 18:56:40 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:56447 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfJDW4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 18:56:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id CA0D543E;
        Fri,  4 Oct 2019 18:56:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 18:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        Vo4MN3cd3s/RXQ7XiqfqvqMdE3LkED1ATMAm6pQsoxM=; b=UOe5Jsdw/ri0H0XV
        chRd4acNlFz73s4IKZgUy5BPLd3jTX4W9PunHSFw6GaALA/eQ8wKpD8a3aLSQJ8f
        8LITvlud3+5bR14bqYabkuq/RmpBFja8WJz4hm+XkLdTI7vrW8zOxeCfXnrZBClg
        ilCdhocb/iiShfRQFtIN7D7WxX8GWy2I5K2e8V+WO+YsdalvyywoREbIETWaIoA3
        DgkiRFrQ1b/g47MDUPwT2NaTSv041/9c0Cj/yR7Rql1gH1lTisj6Ncuz8rI9+KLo
        EOhnigVp1HwzWDN5ymlv3mvzoD3uTcVd2hIJt1UDBW8ejkxCFJU5uB/z+MI5UkFF
        ppekJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=Vo4MN3cd3s/RXQ7XiqfqvqMdE3LkED1ATMAm6pQso
        xM=; b=GKxq3StzrSNB0QG7TS+TgURBI9V3gHHR6QjpAzEJfY+NezqXzKekO0yHT
        pz1pL9atlHqny+zN75t1XLoj7pZwfhs9uiGXTl9Fq9rOq1uOink45OBOuM2frpxh
        T5Uwgmv+ASkfUgROkuoHCINAdod7TbwKYVLTTIPqDszjw6FHS+r0nyl0FaXJ8Q5C
        /cb4gLRCB+NqL/kDGXr9LXbytX3CPOiUoaA7RETv+RB7xtQTHaLcPxOVp6DU+wiV
        0dwXdT3Wa1Mj36+00sR2RDMd71U0oMgNhbu49OFRcYe7Zg3ftkusPXh9GnA5hTBQ
        Dn1xx+mHcFN3LB0+yQpRDIJIKbP8w==
X-ME-Sender: <xms:Jc6XXUmYNYFOdj1Fy3a37y3wjSkIDKrArU7uZljeCj_JYuyeHVV-hA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedvgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dukeejrddukeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Jc6XXYv8YY9ZD2UmQBJuV6vd7oVzXeyRKH4yllT7kMU4u06UGx0CIQ>
    <xmx:Jc6XXYj_au-6nOUtMn9Ts_fVTSis3eoe1OndUJkYow6cI5b6f7_N4g>
    <xmx:Jc6XXTDDH1cQmKyKCygrqfcnSrdlmmEuSaa9zfXnJK_ZPm5Ef3ZWsg>
    <xmx:Js6XXXYufVcIaRq0-d1qMNLvRUQQATNWcJhM0qabRMTh59hkypn7EQ>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10B9F8005A;
        Fri,  4 Oct 2019 18:56:34 -0400 (EDT)
Message-ID: <962b6ae811edec0dc50e3e98c0a7aa44251ea67f.camel@themaw.net>
Subject: Re: [PATCH v4 10/17] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat, 05 Oct 2019 06:56:30 +0800
In-Reply-To: <20191004155242.GD7208@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <157009837210.13858.11725663486459207040.stgit@fedora-28>
         <20191004155242.GD7208@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-10-04 at 11:52 -0400, Brian Foster wrote:
> On Thu, Oct 03, 2019 at 06:26:12PM +0800, Ian Kent wrote:
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
> > index cc2da9093e34..b984120667da 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1925,6 +1925,51 @@ xfs_fs_fill_super(
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
> > +		goto out_free_fsname;
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
> > +	kfree(mp);
> > +	return error;
> 
> Ok, I think I have a better understanding of how this is supposed to
> work with the background context. mp starts off in fc->s_fs_info,
> ends
> up transferred to sb->s_fs_info and passed into here. We allocate
> ->m_fsname and carry on from here with ownership of mp.
> 
> The only thing I'll note is that the out_free_fsname label is
> misnamed
> and probably could be out_free or out_free_mp or something. With that
> nit addressed:

Or out_error perhaps, IIRC I remember thinking I needed to do that but
it slipped my mind?

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +}
> > +
> > +STATIC int
> > +xfs_get_tree(
> > +	struct fs_context	*fc)
> > +{
> > +	return get_tree_bdev(fc, xfs_fill_super);
> > +}
> > +
> >  STATIC void
> >  xfs_fs_put_super(
> >  	struct super_block	*sb)
> > @@ -1995,6 +2040,11 @@ static const struct super_operations
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

