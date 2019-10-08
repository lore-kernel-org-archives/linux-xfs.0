Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7DFC47404
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 00:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09E6420835
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 00:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="NO3Iw2yM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RE4MQqPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfJHAft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 20:35:49 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56391 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729285AbfJHAft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 20:35:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 371814E3;
        Mon,  7 Oct 2019 20:35:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 07 Oct 2019 20:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        kT2MNt9VdegzYp4I69cfvgwmtRao92T5oblO1pRok5A=; b=NO3Iw2yMTI5kLcxT
        jj57yo3vrts12+xJgfIrtzUFMjXCKpY45k1PmQQdIaIDKuGdbHGy3saoyDAKR3BX
        CtRKfxpdzmOY0En9FNT8HF8p6fmcH6K1xDPOCOqtqC5BSWv52MJQGL5wadapcNv8
        eKw9lpE1WdeKdAK0R3SXQ15lkJ+J/9+h4ssbQLL41KXf0BjWn0Zezx8vwweIwHdx
        9P0NERdzycBI7jnvQQqOT8bz9BQe2yoiQn2Cu0PIL2oZcnnUDQLaJCtzkyKuloe/
        xuGRMz7cp1ZPp91zAP8OAyxjI8/G8Qs5q5oN1pEwsAm42jlyF/TZyOPKpPHy3OFA
        TIMumQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=kT2MNt9VdegzYp4I69cfvgwmtRao92T5oblO1pRok
        5A=; b=RE4MQqPWBV9gFtKc5Cd+xmWZxfSPLchkZzPNAmZAbz9VuVIwdarE2pu/S
        1LOIqXkQNOYja83M4ay6gsUZHno9zQszaxScl24HWx/wufT4FU2aeF/BupZ12LAx
        Sbj5TniFCnLKJPo2xETGdAKoUEl3APhCNYQ2zd85HHti/vily7BSFhPRyoJTuEUY
        PBRGG9ZXUyioLWSbxjifablfowbE9JQNDnWmDiPGxVOXbmJAdqDmxD6Xzt9kM0Mx
        0r95SZWo03391Z3oJt0uyP+UEAuwnNtPUVlkA1ALEDk9wwTulr7tDnZ/BJddf/Zc
        +I6nymbh+R9j4/FKNCprbElbCbxkw==
X-ME-Sender: <xms:4tmbXa4fToSHy9xRojHFFn2pE4MKOMMY-uSFTm3hb8e3dvn_wHx_sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:49mbXaxMgwjTxeASqmZOtI4iEL8qvsOpwpqQ3oUBj5QHPfcgdeeM4g>
    <xmx:49mbXWau63fzrm31ZMHfijO8TaCZpO6oKg7vx2qi2Rost4g_SMbf2w>
    <xmx:49mbXUTv43WX34HdefwwMMEiKWXP7odAAX9FOjofuBSWa4lw9vhhyw>
    <xmx:49mbXfxp2_DeXT6H_341yHNNwI6y2gcbp5awKJsn60nbi7G-CHjy8g>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D1CC80064;
        Mon,  7 Oct 2019 20:35:43 -0400 (EDT)
Message-ID: <838877f42553f0a6156bce92ce164f4c9922d3f8.camel@themaw.net>
Subject: Re: [PATCH v4 14/17] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue, 08 Oct 2019 08:35:40 +0800
In-Reply-To: <20191007115155.GB22140@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <157009839296.13858.9863401564865806171.stgit@fedora-28>
         <20191007115155.GB22140@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-10-07 at 07:51 -0400, Brian Foster wrote:
> On Thu, Oct 03, 2019 at 06:26:32PM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .free that performs fs
> > context cleanup on context release.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 06f650fb3a8c..4f2963ff9e06 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2133,10 +2133,36 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static void xfs_fc_free(struct fs_context *fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +
> > +	/*
> > +	 * When the mount context is initialized the private
> > +	 * struct xfs_mount info (mp) is allocated and stored in
> > +	 * the fs context along with the struct xfs_fs_context
> > +	 * (ctx) mount context working working storage.
> > +	 *
> 
> "working working storage" ?

Oops!

> 
> > +	 * On super block allocation the mount info struct, mp,
> > +	 * is moved into private super block info field ->s_fs_info
> > +	 * of the newly allocated super block. But if an error occurs
> > +	 * before this happens it's the responsibility of the fs
> > +	 * context to release the mount info struct.
> > +	 */
> 
> I like the comment here, but it seems it could be simplified. E.g:
> 
> 	/*
> 	 * mp and ctx are stored in the fs_context when it is
> initialized. mp is
> 	 * transferred to the superblock on a successful mount, but if
> an error
> 	 * occurs before the transfer we have to free it here.
> 	 */

I like this, I'll use it thanks.

> 
> > +	if (mp) {
> > +		kfree(mp->m_logname);
> > +		kfree(mp->m_rtname);
> 
> Also, can we just call xfs_free_fsname() here to be safe/consisent?
> With
> those nits fixed up, this seems fine to me.

I think so, I'll check.

> 
> Brian
> 
> > +		kfree(mp);
> > +	}
> > +	kfree(ctx);
> > +}
> > +
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> >  	.reconfigure = xfs_reconfigure,
> > +	.free        = xfs_fc_free,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

