Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229EAC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E841C21726
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="on1/gSyV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZfQrBpd3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfH3LBR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:01:17 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58753 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbfH3LBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 07:01:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0481B3D4;
        Fri, 30 Aug 2019 07:01:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 07:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        kWVDfj9YD9joQFTbEcnIrgogabVCHrMEZCv34MxeHOc=; b=on1/gSyVdyV+v1Tn
        KVvwVYnGGHX//H0fUB+qN+uX1y8/oQVdV2DH/D4fe93zN+efbPQLgcVhLfwXUlIb
        D31ORZhI2peqdoanbVu6vw0UDgagZQK8VjANv8mI/Z4UGbBh8XbkHqd28VeMIIbQ
        8o2ivo/147APY0BhT3FiZ16jaFxmaKYZU9KEz0rGVGiLmsNMrqjNlKdIpGweih+3
        igpWLZep89xxqh5h/1ZaTQRlV15c359J/bwFo70BlewDfBCCIxNZSOgquRjym7rA
        e240EXf3lWSry16XKNsehenFeQPWuzrMfWrp1MBv1gWX1AJI2oMzRmmkEqtyCK8q
        Ptp7aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=kWVDfj9YD9joQFTbEcnIrgogabVCHrMEZCv34MxeH
        Oc=; b=ZfQrBpd3dl1QZIbUFUDAQpt4aPif6QobjOaJkhTdv68wce9zpyuFUju3n
        KOISBuGdaLNgvoEfz/GubSwsS9682BBYz9iRLTXclJVX1t0mB2pHu7clRnkZ80n7
        m+UuC8ScVcgKdVMA99nHo6hPiXbzUVQRqjGsTU3Y+QzEuWkkRAZSMTfgniMbLV7L
        KZYOTUzXz6Kt8+AD3xI2k1Bs990GAxz98S8n7r4Q3dUCVdqtBkmKw9SELAU0aEiJ
        gnlg4IKooCZgeGYEEbdkolSg3Vv2a3Z4/UyBJs7wvPgc2yED5R6PKKCNNLp9A/cm
        EZmk8OUl6j9DqijhBcq4QxG0V+T0A==
X-ME-Sender: <xms:-wFpXcWmuIozyiNBUwXqW2TdYMlz5-Z9YXq6HkKeOmrVIU-nvo5ooA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:-wFpXU31NCsEFlzOjZA7VC6aBMJ2FsebTHcYBDXvZTcELYPbeaAySw>
    <xmx:-wFpXbaMlqRkKqaLqejDFiyvPAeiq_ABqV8YVl13qVPcCx2LJR5uWA>
    <xmx:-wFpXfp2TPE76i-7sTzLPyL3YFGXD5bawLSDH1XAO1sWij1dhJVqCA>
    <xmx:-wFpXTmWX24BQ6OmGZGvyT8hlWcGieQ62sw_mdwqYGI6XvmvC9sFPA>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91924D6005E;
        Fri, 30 Aug 2019 07:01:12 -0400 (EDT)
Message-ID: <27e6eb5eb43a5bf0cef4db7036429cc7b522d437.camel@themaw.net>
Subject: Re: [PATCH v2 08/15] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 19:01:09 +0800
In-Reply-To: <20190828132724.GA16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652199954.2607.8863934346265980917.stgit@fedora-28>
         <20190828132724.GA16389@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-28 at 09:27 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:59:59AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .get_tree that validates
> > mount options and fills the super block as previously done
> > by the file_system_type .mount method.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   47
> > +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d3fc9938987d..7de64808eb00 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1904,6 +1904,52 @@ xfs_fs_fill_super(
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
> > +	kfree(mp);
> 
> So where is mp allocated in the updated mount sequence? Has that code
> been added yet or does this tie into the existing fill_super
> sequence?
> It's hard to tell because xfs_context_ops is still unused. It looks a
> little strange to free mp here when it's presumably been allocated
> somewhere else. If that is separate code, perhaps some of the patches
> should be combined (i.e. even if just setup/teardown bits) for easier
> review.

Umm, good question, and good suggestion.

I haven't looked at what I'm doing there so I'll keep your
suggestion in mind when I'm working through it.

> 
> Brian
> 
> > +
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
> > @@ -1976,6 +2022,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> > +	.get_tree    = xfs_get_tree,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

