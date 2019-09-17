Return-Path: <SRS0=2RH+=XM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C55C49ED7
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 03:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B12B206A1
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 03:13:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="h5m6sXeH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pYgBBiXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfIQDNa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 23:13:30 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58927 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728579AbfIQDN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 23:13:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 416BE719;
        Mon, 16 Sep 2019 23:13:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Sep 2019 23:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        iSBAoALdCGAmBxoiU33/Ufe+OZBf1lueEpjBlZzLEe0=; b=h5m6sXeHh5S01Mq6
        yNnWG7ppcI7SyaMA2VeR0auPIasA0+XcH78mQeRVjFPqsFWhBxNh9A+Q3Q7EQ5D9
        ReuiRemBoXZsumO/Zr2yj84PP9nNTj7kTXh89sHSQphuXrbQreBH6p6LwRtC7pBP
        pUST6oA3geKdUqgLKVpZughJkvxnSYz+ZmPI7oqNaTE745oh7UZJ25sqEYzydyDA
        6YasdOf9c/JJMdclPvRpWp3cNnH40eesJpHdxsG5LiywVUNNoYu4DvRLbqeq9phG
        LYEPXhB+odoFDxzow4odj7a9mptfP8CK8avC9epN7VQlomUr0Bs2PCM0NBYsXJWe
        +eo8hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=iSBAoALdCGAmBxoiU33/Ufe+OZBf1lueEpjBlZzLE
        e0=; b=pYgBBiXQuxWjTSc1ieuwk/k3O0p71kID1yHSiUJuGNZkw9zo5evD2lZe+
        +qrK03Oa/pV1UAH0J9G9tUDXFD4M0gZu6cGDnftFAuXyYdNoSt1kFn3mOyy95gmf
        8YRycNQL+RfV0qffzxOMX7YaIQyfa34fhLFlAWhbQ1hcBIVzffbdJP4VgzgyxBvd
        zRtKQpyi/A2UN99Bdl1ksjytvopph8VOPpEZuT0OkRXgzx+1buCnwmoOdCziGKWo
        hZWdh0ZVaK36luIaRcC5eSZffZSogRbIbmYzsoxAd13AjlelhfEayi5Rs6iKf+gw
        7qnolxhoX4dkuRC69CNI3VcBZNseA==
X-ME-Sender: <xms:V0-AXbU9abR-YEvZDemS770NSaSX1fvWz8pRXJp__Q7u9hP80YcgmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujedurdehjeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:V0-AXY3tGkavQmambpaGYYM61OT1Ryf4IwE25QSeNZXcaZd3OJS_Rw>
    <xmx:V0-AXZFycyfJk5BLwJ2Z17sIHGXPmy1x5lKVOP7w8YXU5DdObB3TEA>
    <xmx:V0-AXegDCxVUz0DHtoHMg2eJGWAD9DGPvOTikG9PBIB1i5GaDoAvPA>
    <xmx:V0-AXXa2pf66g9soYzrf-RMMKn24yiyjml-lpjWA4KkP8eDyTyPSLQ>
Received: from mickey.themaw.net (unknown [118.208.171.57])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE10A8005B;
        Mon, 16 Sep 2019 23:13:24 -0400 (EDT)
Message-ID: <86f52d0f5a4ec86fee70ff39d55b3b2a1813a555.camel@themaw.net>
Subject: Re: [PATCH v2 02/15] xfs: mount-api - add fs parameter description
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 17 Sep 2019 11:13:20 +0800
In-Reply-To: <20190827123945.GA10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652196787.2607.5728754014477374931.stgit@fedora-28>
         <20190827123945.GA10636@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-08-27 at 08:39 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:59:27AM +0800, Ian Kent wrote:
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
> > ---
> >  fs/xfs/xfs_super.c |   48
> > +++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 45 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index f9450235533c..74c88b92ce22 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -38,6 +38,8 @@
> >  
> >  #include <linux/magic.h>
> >  #include <linux/parser.h>
> > +#include <linux/fs_context.h>
> > +#include <linux/fs_parser.h>
> >  
> >  static const struct super_operations xfs_super_operations;
> >  struct bio_set xfs_ioend_bioset;
> > @@ -47,9 +49,6 @@ static struct kset *xfs_kset;		/* top-
> > level xfs sysfs dir */
> >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs
> > attrs */
> >  #endif
> >  
> > -/*
> > - * Table driven mount option parser.
> > - */
> 
> Not sure why this is comment is removed here if the associated code
> is
> staying put in this patch..?
> 
> >  enum {
> >  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
> >  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth,
> > Opt_nouuid,
> > @@ -109,6 +108,49 @@ static const match_table_t tokens = {
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
> 
> Hmm.. it looks like the difference between numerical values as
> strings
> vs. numeric types is whether we support things like unit suffixes
> (i.e.
> "64k"). That said, Opt_biosize uses suffix_kstrtoint() similar to
> Opt_logbsize yet is defined here as a u32 (and Opt_allocsize falls
> into
> the same parsing code but is a string). Is that wrong or am I just
> missing something wrt to the type specifiers here?

Right, the distinction appeared to be between those that use a human
unit (like 64k etc.) and those that don't.

Opt_biosize looked different in that it's described to be "log2 of
preferred buffered io size" so I don't think it can be given as a
human unit and that also appeared to be the case from the original
options table.

Do I need to change this somehow?

> 
> Brian
> 
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
> > +	.name		= "XFS",
> > +	.specs		= xfs_param_specs,
> > +};
> >  
> >  STATIC int
> >  suffix_kstrtoint(const substring_t *s, unsigned int base, int
> > *res)
> > 

