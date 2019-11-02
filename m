Return-Path: <SRS0=21/y=Y2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D45CA9EC7
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 04:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E4020650
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Nov 2019 04:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="ze1KJfqx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JeNwIU6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKBElt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Nov 2019 00:41:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36473 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfKBElt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Nov 2019 00:41:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 67F5121240;
        Sat,  2 Nov 2019 00:41:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 02 Nov 2019 00:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        4WtfJ0PqM4tAuXuRKJ4rYqrxapsfM2UpghpKCD4iXD8=; b=ze1KJfqxZ8L01DMM
        2lk2fM/x0UYfPFFZK9LiIdOGCaaxgOUMlDGnfgnqu2Au/a5t3q7gtE0F8V2DMjqJ
        s+72HzmsWYxuEyB6hMOHNqyjHWyyZkLY+MTHCAPcXIT0v2PT8e7yfJmQOyX42lHV
        RFU/bQbwMA6+n5aYTwkfw6LN8YtfPA8S3txoc/PduAnixyWJIJaqkfCXRFq/zpGB
        WT4P6LcMyfvq6dhNYSbJRiK1kZfWkdn9uzOz4I54ik7qfuSHALOdUOsre7nl+Iea
        8nwEd4155ONQZyksYp/E/MRj4/0tCSTJDx67PSwFJYTNimPA+wbkNvEv94JJGURI
        IPCGcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=4WtfJ0PqM4tAuXuRKJ4rYqrxapsfM2UpghpKCD4iX
        D8=; b=JeNwIU6wnvFKtwROkrOSE79kt4bC8C6lpmxwDUS2+4+lPqvVoEaS8zJPc
        NyUiEq+eJes8P9XbHHBTfd9GmSchId+mkXaB9T/JjnvhVL7uE/+0hCiyRhFnu8YX
        iWyYRke2P3HUA0VgJIHmdtK5bSBwIhnTyMdcBoQATEG9hPCkol8a7uLE4zAhbL33
        ISB1PahyVtVaT+J+Pu0hziic3uTZazfSruaYBSmn3OsPK9v/uS4TC2D5NgD4vCbw
        NUqAZkyNO6lJPGq9C6wow7mUBgvAlKybz62fScRvQrnV0GiQxO6LRQUUage2ZBmx
        NezYjCnCwnJ91wIvG18uc+O4L8Ppw==
X-ME-Sender: <xms:Cwm9XV4BDwbTz0oDv2H21MVRbaM_7zPLrniXiTei8-nG7CEWM9y8kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtkedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekledrudeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Cwm9XeZSFQu20Rrc5RT-IdN30arq6zU3cNxvyzOt-rTh3MYHuGD0WA>
    <xmx:Cwm9XTczaxBqliTMfc-MDpAF6ejqZCB_Lqnc-zay2m2vBCKjVTYEpA>
    <xmx:Cwm9XXE-Ma8dfTC3z-2L2n2LIgCYZtp7U8V37iUER2Pe-LCBICRbDA>
    <xmx:DAm9XW_Ex_b-P-VJYZSPzr5XJfyElcwI7oZ-OOT8WxuUq1igZOjDXg>
Received: from mickey.themaw.net (unknown [118.208.189.18])
        by mail.messagingengine.com (Postfix) with ESMTPA id C20E7306005E;
        Sat,  2 Nov 2019 00:41:43 -0400 (EDT)
Message-ID: <ae8c1a5f4c357c6c9060f09b374bad472b422ebf.camel@themaw.net>
Subject: Re: [PATCH v8 12/16] xfs: dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sat, 02 Nov 2019 12:41:39 +0800
In-Reply-To: <20191101201536.GG15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
         <157259466607.28278.4456308072088112584.stgit@fedora-28>
         <20191101201536.GG15222@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-11-01 at 13:15 -0700, Darrick J. Wong wrote:
> On Fri, Nov 01, 2019 at 03:51:06PM +0800, Ian Kent wrote:
> > When changing to use the new mount api the super block won't be
> > available when the xfs_mount struct is allocated so move setting
> > the
> > super block in xfs_mount to xfs_fs_fill_super().
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_super.c |    7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 4b570ba3456a..62dfc678c415 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1560,8 +1560,7 @@ xfs_destroy_percpu_counters(
> >  }
> >  
> >  static struct xfs_mount *
> > -xfs_mount_alloc(
> > -	struct super_block	*sb)
> > +xfs_mount_alloc(void)
> >  {
> >  	struct xfs_mount	*mp;
> >  
> > @@ -1569,7 +1568,6 @@ xfs_mount_alloc(
> >  	if (!mp)
> >  		return NULL;
> >  
> > -	mp->m_super = sb;
> 
> Just out of curiosity, is there any place where we need m_super in
> between here...
> 
> >  	spin_lock_init(&mp->m_sb_lock);
> >  	spin_lock_init(&mp->m_agirotor_lock);
> >  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
> > @@ -1605,9 +1603,10 @@ xfs_fs_fill_super(
> >  	 * allocate mp and do all low-level struct initializations
> > before we
> >  	 * attach it to the super
> >  	 */
> > -	mp = xfs_mount_alloc(sb);
> > +	mp = xfs_mount_alloc();
> >  	if (!mp)
> >  		goto out;
> > +	mp->m_super = sb;
> 
> ...and here?  For example, logging errors?  AFAICT the only thing
> that
> goes on between these two points is option parsing, right?  (And the
> parsing has its own prefixed logging, etc.)

Yes, only option parsing is going on between these two points.

And, for now, the error reporting is caught by the VFS.

There is one location in xfs_fc_parse_param() where an xfs log
message could be emitted although it's never reached (because of
the return if the fs_parse() call fails).

If log messages were issued in between these two points the consequence
is a missing block device name in the message. You remember, a check on
mp->m_super was added to __xfs_printk() to cover this case when struct
xfs_mount field m_fsname was eliminated.

This potential lack of device name in log messages is a problem I can't
fix because the block device isn't obtained until after parameter
parsing, just before the super block is acquired. Changing that in the
VFS would be quite significant so I'm stuck!

> 
> --D
> 
> >  	sb->s_fs_info = mp;
> >  
> >  	error = xfs_parseargs(mp, (char *)data);
> > 

