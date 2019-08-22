Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7928AC3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 09:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE65621655
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 09:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="NFpkNF6d";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YUiHZBHX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbfHVJFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 05:05:41 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37861 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732115AbfHVJFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 05:05:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C2ED168B;
        Thu, 22 Aug 2019 05:05:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 22 Aug 2019 05:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        8ItH7+wLJdfMcg37B7LjfBqBdJf1DCRWF8xxRifMaeM=; b=NFpkNF6dbTzU8rZ0
        Bibc/0HQkGzAix+FTsEBf8GQqmZ2RPXZHabNL22zbd4s1nbHpoV2RFx8KFzJRZBI
        aeWP0dYBpNwV/xrPV4qNPOSQDqmRh2Duj5dvBijzXp+oFceM9Xxk7Z0OF44B4eMG
        eB/B+mewmbfLkKlTmlMliSXUvuDnkA2HeU8BEGslEgBPArLpzGfgNkVOdOh2KO8n
        37hBq2iRgNNZfrUcdq3OwHsky2MhZKryEzw0E4eboRKsUy8zHr80hFPn+IhcZaCH
        NyYGAowDfZ1FivYwsO6nDQosaonijO6XvKzNxnghYQwPV0GD4/6JGrIT4YKfiY5V
        3yg6WQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=8ItH7+wLJdfMcg37B7LjfBqBdJf1DCRWF8xxRifMa
        eM=; b=YUiHZBHXAA78y/h9EwJsi5Fs5I3iN5z5751oGFPnhfnBSVMOHQDE+mKkw
        5urqF83JBE8wlOBmZ0CvdKplElHRfq9NzEEfC/AGyQPpzv2lTBFmIw37Q13iMYZT
        uC6AOHAHq564DxS4oWZkYyHhYpmoDA5DV91w2tf2vkSyrfBn2fNScnZLRsxtWn+n
        mL2SFKhJY0OUpIrCZ9bupnlJlIbiIwBIdF88ACQhSybxuQxoj7oBxFlizuF2Uz5A
        63ltZoTb6qPMrbdTpf76E8YM6i5ZAH1Q68ehLGoq/ZKcD7CbDgwoYIPuSRAgwm/f
        WCnMWaT3LtxerW/bKOUCrItEUJI8Q==
X-ME-Sender: <xms:4lpeXRAB373bTDucMKnJ4LwUqq4elFtocZu5qlhcC0KO_IAFWG1hkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeghedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudejiedrjedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4lpeXfG9YvJjXTTsdeg7vcNlyTNfQbHD6wTu9Ebl4wWxedRkXqW09g>
    <xmx:4lpeXV_pKH9geJqd5IJ8LWRIB9LmkaJALI1LtYjycRni8yNNJE20sw>
    <xmx:4lpeXUkfEJjWGhJqrbCPL5rYBo_e_OCVpvvJaff9DK2h7tW5Qoj7YA>
    <xmx:41peXWFCSGYhCJkClGFEoJrCrsYeQvHSruHWH1N6zXIF8RmuHgKHdw>
Received: from donald.themaw.net (unknown [118.208.176.70])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7047780060;
        Thu, 22 Aug 2019 05:05:36 -0400 (EDT)
Message-ID: <2324bb616a5308b18f9e4a303f29e4229f198da2.camel@themaw.net>
Subject: Re: [PATCH 01/10] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 22 Aug 2019 17:05:32 +0800
In-Reply-To: <a895b8c9-5a1c-b642-a7f3-2adc004351e6@sandeen.net>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <a895b8c9-5a1c-b642-a7f3-2adc004351e6@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-21 at 09:52 -0500, Eric Sandeen wrote:
> On 6/23/19 9:58 PM, Ian Kent wrote:
> > The new mount-api uses an array of struct fs_parameter_spec for
> > parameter parsing, create this table populated with the xfs mount
> > parameters.
> > 
> > The new mount-api table definition is wider than the token based
> > parameter table and interleaving the option description comments
> > between each table line is much less readable than adding them to
> > the end of each table entry. So add the option description comment
> > to each entry line even though it causes quite a few of the entries
> > to be longer than 80 characters.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> 
> Ian, I saw hints about a V2 in replies, is that still in the works?

I have a v2 that should address the comments made on the initial
post.

My reluctance to post the v2 is because the series uses a patch
that's currently sitting in linux-next and that will cause a
conflict if the series is accepted.

I'm thinking about doing an RFC post with that patch included
and a caution about the possible conflict.

Not sure yet, I've only just yesterday been able to successfully
run xfstests on a kernel with the changes so deciding what to do
next is upon me now, ;)

> 
> Thanks,
> -Eric
> 
> > ---
> >  fs/xfs/xfs_super.c |   48
> > +++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 45 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index a14d11d78bd8..ab8145bf6fff 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -51,6 +51,8 @@
> >  #include <linux/kthread.h>
> >  #include <linux/freezer.h>
> >  #include <linux/parser.h>
> > +#include <linux/fs_context.h>
> > +#include <linux/fs_parser.h>
> >  
> >  static const struct super_operations xfs_super_operations;
> >  struct bio_set xfs_ioend_bioset;
> > @@ -60,9 +62,6 @@ static struct kset *xfs_kset;		/* top-
> > level xfs sysfs dir */
> >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs
> > attrs */
> >  #endif
> >  
> > -/*
> > - * Table driven mount option parser.
> > - */
> >  enum {
> >  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
> >  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth,
> > Opt_nouuid,
> > @@ -122,6 +121,49 @@ static const match_table_t tokens = {
> >  	{Opt_err,	NULL},
> >  };
> >  
> > +static const struct fs_parameter_spec xfs_param_specs[] = {
> > + fsparam_u32	("logbufs",    Opt_logbufs),   /* number of XFS
> > log buffers */
> > + fsparam_string ("logbsize",   Opt_logbsize),  /* size of XFS log
> > buffers */
> > + fsparam_string ("logdev",     Opt_logdev),    /* log device */
> > + fsparam_string ("rtdev",      Opt_rtdev),     /* realtime I/O
> > device */
> > + fsparam_u32	("biosize",    Opt_biosize),   /* log2 of
> > preferred buffered io size */
> > + fsparam_flag	("wsync",      Opt_wsync),     /* safe-mode nfs
> > compatible mount */
> > + fsparam_flag	("noalign",    Opt_noalign),   /* turn off
> > stripe alignment */
> > + fsparam_flag	("swalloc",    Opt_swalloc),   /* turn on
> > stripe width allocation */
> > + fsparam_u32	("sunit",      Opt_sunit),     /* data volume
> > stripe unit */
> > + fsparam_u32	("swidth",     Opt_swidth),    /* data volume
> > stripe width */
> > + fsparam_flag	("nouuid",     Opt_nouuid),    /* ignore
> > filesystem UUID */
> > + fsparam_flag_no("grpid",      Opt_grpid),     /* group-ID from
> > parent directory (or not) */
> > + fsparam_flag	("bsdgroups",  Opt_bsdgroups), /* group-ID from
> > parent directory */
> > + fsparam_flag	("sysvgroups", Opt_sysvgroups),/* group-ID from
> > current process */
> > + fsparam_string ("allocsize",  Opt_allocsize), /* preferred
> > allocation size */
> > + fsparam_flag	("norecovery", Opt_norecovery),/* don't run XFS
> > recovery */
> > + fsparam_flag	("inode64",    Opt_inode64),   /* inodes can be
> > allocated anywhere */
> > + fsparam_flag	("inode32",    Opt_inode32),   /* inode
> > allocation limited to XFS_MAXINUMBER_32 */
> > + fsparam_flag_no("ikeep",      Opt_ikeep),     /* do not free (or
> > keep) empty inode clusters */
> > + fsparam_flag_no("largeio",    Opt_largeio),   /* report (or do
> > not report) large I/O sizes in stat() */
> > + fsparam_flag_no("attr2",      Opt_attr2),     /* do (or do not)
> > use attr2 attribute format */
> > + fsparam_flag	("filestreams",Opt_filestreams), /* use
> > filestreams allocator */
> > + fsparam_flag_no("quota",      Opt_quota),     /* disk quotas
> > (user) */
> > + fsparam_flag	("usrquota",   Opt_usrquota),  /* user quota
> > enabled */
> > + fsparam_flag	("grpquota",   Opt_grpquota),  /* group quota
> > enabled */
> > + fsparam_flag	("prjquota",   Opt_prjquota),  /* project quota
> > enabled */
> > + fsparam_flag	("uquota",     Opt_uquota),    /* user quota
> > (IRIX variant) */
> > + fsparam_flag	("gquota",     Opt_gquota),    /* group quota
> > (IRIX variant) */
> > + fsparam_flag	("pquota",     Opt_pquota),    /* project quota
> > (IRIX variant) */
> > + fsparam_flag	("uqnoenforce",Opt_uqnoenforce), /* user quota
> > limit enforcement */
> > + fsparam_flag	("gqnoenforce",Opt_gqnoenforce), /* group quota
> > limit enforcement */
> > + fsparam_flag	("pqnoenforce",Opt_pqnoenforce), /* project
> > quota limit enforcement */
> > + fsparam_flag	("qnoenforce", Opt_qnoenforce),  /* same as
> > uqnoenforce */
> > + fsparam_flag_no("discard",    Opt_discard),   /* Do (or do not)
> > not discard unused blocks */
> > + fsparam_flag	("dax",	       Opt_dax),       /* Enable
> > direct access to bdev pages */
> > + {}
> > +};
> > +
> > +static const struct fs_parameter_description xfs_fs_parameters = {
> > +	.name		= "xfs",
> > +	.specs		= xfs_param_specs,
> > +};
> >  
> >  STATIC int
> >  suffix_kstrtoint(const substring_t *s, unsigned int base, int
> > *res)
> > 

