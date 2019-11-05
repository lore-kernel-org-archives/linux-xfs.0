Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47016CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 03:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8AE9206B8
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 03:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="sICl3D6O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CgYR1Pay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfKEDAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 22:00:48 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59843 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727861AbfKEDAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 22:00:48 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1F9AC21ACF;
        Mon,  4 Nov 2019 22:00:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 Nov 2019 22:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        Q/3mi26KPKqV1Jf1ePrITcKhGLkBJQ+ijsTqh55IVfw=; b=sICl3D6O39+dwEw0
        I5ODAib5bjjaP5WwMN5/MM4iqOvkn0+8c30eBrlK+a7i1zj4ucmXzvIgBLQKoC1b
        MZSIkNOZ//oAFZ1FNg3dCVVA31/P0jf0phEk46dFBhM7zu1024W9PYTLTZ3GO0AQ
        UH+22JD1o/O8f+aV6Vly3Gix23IIkjB33GFYhXO0bCaI6hSCpMebV7xRq6dDIHZV
        +FaH+Ny3dnB5QVdUDpYhQJyCy5oFyn8N9vVm/Yx1tqymMBIxLAcArC/YFqHkzQyB
        Tdh7aBMInbCdH/NO+bdPpCn1dMWGXNH+wLXcqAPWQSRJ9X4YjjQEaOBzFqkSiY8a
        KiTIEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=Q/3mi26KPKqV1Jf1ePrITcKhGLkBJQ+ijsTqh55IV
        fw=; b=CgYR1PayRwEiUfWLxHZxu/h76OE7BpNsbLs5zlr1NkNGdUopEUPjSCQfF
        a5y3z7+z9n8NQiRwKU2E8HIxaDZ2iDtOtsnqBh9NyRLjejeK8FPXcOniOXjWZpNW
        6hpqYi0n+UKFwgmCSadK7BZT3v+dZDm4Zl7styRBw0N/iGayAMCsgnoOOYM2KKru
        XDw3G0gHY5pphg331NNhWncovx8rm9YNtbVumQZbvPTH1I4oEzIXGcJwSIaMDfFR
        UJp7sX+y5L7sLmMQKVGpbuSZXvzEJZzcJJuUB/9hdv0p+LzkzBumpqO9p+YL8WBA
        2UXNBQAE2UJ/wZDyysc7Q1F34+jmQ==
X-ME-Sender: <xms:2-XAXTSFf9R8sTuDXgOxebwRaz9SW30xRfmj0wY6AQhY4OGcK5NbEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekledrudeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:2-XAXcIv1T0MAPuldxWy43FY1xZ6zZNUAEn-SM1220qbsRXIua7QvA>
    <xmx:2-XAXTLJdUbOMedeRqG_-l2wLK1G8lPdRPVao8u2X_yDbAizRI5q7w>
    <xmx:2-XAXZDTbcZSduYIRkFUY5n5cJomMVCjkiKmYb5LQOEVqwo6Y_ZR_w>
    <xmx:3eXAXZZhFyBX73e4abHu17616lH94Y-Ah0C4_g9cIgjzw0ujwTZXDA>
Received: from mickey.themaw.net (unknown [118.208.189.18])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0EDE080064;
        Mon,  4 Nov 2019 22:00:39 -0500 (EST)
Message-ID: <befb9f60e51ca786c97a00731c91c6483ca604d1.camel@themaw.net>
Subject: Re: [PATCH v9 13/17] xfs: switch to use the new mount-api
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Tue, 05 Nov 2019 11:00:36 +0800
In-Reply-To: <20191104225331.GN4153244@magnolia>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
         <157286494412.18393.789343157630779200.stgit@fedora-28>
         <20191104225331.GN4153244@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-11-04 at 14:53 -0800, Darrick J. Wong wrote:
> On Mon, Nov 04, 2019 at 06:55:44PM +0800, Ian Kent wrote:
> > Define the struct fs_parameter_spec table that's used by the new
> > mount-api for options parsing.
> > 
> > Create the various fs context operations methods and define the
> > fs_context_operations struct.
> > 
> > Create the fs context initialization method and update the struct
> > file_system_type to utilize it. The initialization function is
> > responsible for working storage initialization, allocation and
> > initialization of file system private information storage and for
> > setting the operations in the fs context.
> > 
> > Also set struct file_system_type .parameters to the newly defined
> > struct fs_parameter_spec options parsing table for use by the fs
> > context methods and remove unused code.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  408 ++++++++++++++++++++++----------------
> > --------------
> >  1 file changed, 171 insertions(+), 237 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 62dfc678c415..2d4edaaf934e 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -37,7 +37,8 @@
> >  #include "xfs_reflink.h"
> >  
> >  #include <linux/magic.h>
> > -#include <linux/parser.h>
> > +#include <linux/fs_context.h>
> > +#include <linux/fs_parser.h>
> >  
> >  static const struct super_operations xfs_super_operations;
> >  
> > @@ -58,55 +59,57 @@ enum {
> >  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota,
> > Opt_grpquota,
> >  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
> >  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce,
> > Opt_qnoenforce,
> > -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
> > +	Opt_discard, Opt_nodiscard, Opt_dax,
> >  };
> >  
> > -static const match_table_t tokens = {
> > -	{Opt_logbufs,	"logbufs=%u"},	/* number of XFS log
> > buffers */
> > -	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers
> > */
> > -	{Opt_logdev,	"logdev=%s"},	/* log device */
> > -	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
> > -	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount
> > */
> > -	{Opt_noalign,	"noalign"},	/* turn off stripe
> > alignment */
> > -	{Opt_swalloc,	"swalloc"},	/* turn on stripe width
> > allocation */
> > -	{Opt_sunit,	"sunit=%u"},	/* data volume stripe unit */
> > -	{Opt_swidth,	"swidth=%u"},	/* data volume stripe width
> > */
> > -	{Opt_nouuid,	"nouuid"},	/* ignore filesystem UUID
> > */
> > -	{Opt_grpid,	"grpid"},	/* group-ID from parent directory
> > */
> > -	{Opt_nogrpid,	"nogrpid"},	/* group-ID from current
> > process */
> > -	{Opt_bsdgroups,	"bsdgroups"},	/* group-ID from parent
> > directory */
> > -	{Opt_sysvgroups,"sysvgroups"},	/* group-ID from current
> > process */
> > -	{Opt_allocsize,	"allocsize=%s"},/* preferred allocation
> > size */
> > -	{Opt_norecovery,"norecovery"},	/* don't run XFS recovery
> > */
> > -	{Opt_inode64,	"inode64"},	/* inodes can be allocated
> > anywhere */
> > -	{Opt_inode32,   "inode32"},	/* inode allocation limited to
> > -					 * XFS_MAXINUMBER_32 */
> > -	{Opt_ikeep,	"ikeep"},	/* do not free empty inode clusters
> > */
> > -	{Opt_noikeep,	"noikeep"},	/* free empty inode
> > clusters */
> > -	{Opt_largeio,	"largeio"},	/* report large I/O sizes
> > in stat() */
> > -	{Opt_nolargeio,	"nolargeio"},	/* do not report large I/O
> > sizes
> > -					 * in stat(). */
> > -	{Opt_attr2,	"attr2"},	/* do use attr2 attribute format */
> > -	{Opt_noattr2,	"noattr2"},	/* do not use attr2
> > attribute format */
> > -	{Opt_filestreams,"filestreams"},/* use filestreams allocator */
> > -	{Opt_quota,	"quota"},	/* disk quotas (user) */
> > -	{Opt_noquota,	"noquota"},	/* no quotas */
> > -	{Opt_usrquota,	"usrquota"},	/* user quota enabled */
> > -	{Opt_grpquota,	"grpquota"},	/* group quota enabled */
> > -	{Opt_prjquota,	"prjquota"},	/* project quota enabled */
> > -	{Opt_uquota,	"uquota"},	/* user quota (IRIX
> > variant) */
> > -	{Opt_gquota,	"gquota"},	/* group quota (IRIX
> > variant) */
> > -	{Opt_pquota,	"pquota"},	/* project quota (IRIX
> > variant) */
> > -	{Opt_uqnoenforce,"uqnoenforce"},/* user quota limit enforcement
> > */
> > -	{Opt_gqnoenforce,"gqnoenforce"},/* group quota limit
> > enforcement */
> > -	{Opt_pqnoenforce,"pqnoenforce"},/* project quota limit
> > enforcement */
> > -	{Opt_qnoenforce, "qnoenforce"},	/* same as uqnoenforce */
> > -	{Opt_discard,	"discard"},	/* Discard unused blocks */
> > -	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused
> > blocks */
> > -	{Opt_dax,	"dax"},		/* Enable direct access to bdev
> > pages */
> > -	{Opt_err,	NULL},
> > +static const struct fs_parameter_spec xfs_param_specs[] = {
> > +	fsparam_u32("logbufs",		Opt_logbufs),
> > +	fsparam_string("logbsize",	Opt_logbsize),
> > +	fsparam_string("logdev",	Opt_logdev),
> > +	fsparam_string("rtdev",		Opt_rtdev),
> > +	fsparam_flag("wsync",		Opt_wsync),
> > +	fsparam_flag("noalign",		Opt_noalign),
> > +	fsparam_flag("swalloc",		Opt_swalloc),
> > +	fsparam_u32("sunit",		Opt_sunit),
> > +	fsparam_u32("swidth",		Opt_swidth),
> > +	fsparam_flag("nouuid",		Opt_nouuid),
> > +	fsparam_flag("grpid",		Opt_grpid),
> > +	fsparam_flag("nogrpid",		Opt_nogrpid),
> > +	fsparam_flag("bsdgroups",	Opt_bsdgroups),
> > +	fsparam_flag("sysvgroups",	Opt_sysvgroups),
> > +	fsparam_string("allocsize",	Opt_allocsize),
> > +	fsparam_flag("norecovery",	Opt_norecovery),
> > +	fsparam_flag("inode64",		Opt_inode64),
> > +	fsparam_flag("inode32",		Opt_inode32),
> > +	fsparam_flag("ikeep",		Opt_ikeep),
> > +	fsparam_flag("noikeep",		Opt_noikeep),
> > +	fsparam_flag("largeio",		Opt_largeio),
> > +	fsparam_flag("nolargeio",	Opt_nolargeio),
> > +	fsparam_flag("attr2",		Opt_attr2),
> > +	fsparam_flag("noattr2",		Opt_noattr2),
> > +	fsparam_flag("filestreams",	Opt_filestreams),
> > +	fsparam_flag("quota",		Opt_quota),
> > +	fsparam_flag("noquota",		Opt_noquota),
> > +	fsparam_flag("usrquota",	Opt_usrquota),
> > +	fsparam_flag("grpquota",	Opt_grpquota),
> > +	fsparam_flag("prjquota",	Opt_prjquota),
> > +	fsparam_flag("uquota",		Opt_uquota),
> > +	fsparam_flag("gquota",		Opt_gquota),
> > +	fsparam_flag("pquota",		Opt_pquota),
> > +	fsparam_flag("uqnoenforce",	Opt_uqnoenforce),
> > +	fsparam_flag("gqnoenforce",	Opt_gqnoenforce),
> > +	fsparam_flag("pqnoenforce",	Opt_pqnoenforce),
> > +	fsparam_flag("qnoenforce",	Opt_qnoenforce),
> > +	fsparam_flag("discard",		Opt_discard),
> > +	fsparam_flag("nodiscard",	Opt_nodiscard),
> > +	fsparam_flag("dax",		Opt_dax),
> > +	{}
> >  };
> >  
> > +static const struct fs_parameter_description xfs_fs_parameters = {
> > +	.name		= "xfs",
> > +	.specs		= xfs_param_specs,
> > +};
> >  
> >  static int
> >  suffix_kstrtoint(
> > @@ -143,55 +146,42 @@ suffix_kstrtoint(
> >  	return ret;
> >  }
> >  
> > -static int
> > -match_kstrtoint(
> > -	const substring_t	*s,
> > -	unsigned int		base,
> > -	int			*res)
> > -{
> > -	const char		*value;
> > -	int			ret;
> > -
> > -	value = match_strdup(s);
> > -	if (!value)
> > -		return -ENOMEM;
> > -	ret = suffix_kstrtoint(value, base, res);
> > -	kfree(value);
> > -	return ret;
> > -}
> > -
> >  static int
> >  xfs_fc_parse_param(
> 
> This is the only function where mp->m_super can be NULL, correct?

Yep.

> 
> If so, I'll add a comment to that effect, and,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, much appreciated.

> 
> (for this and patch 12.)
> 
> Will throw this at a testing cloud and see what happens...

It's seems ok when I run it against xfstests but I'm not as familiar
with what to expect as you would be, I'm interested to hear how it
goes, ;)

I noticed a significant change in test run times with the latest
for-next but there was also an xfstests update so I'm not sure
what caused it. Some test run times went up by 8 to 10 or more
times, which seemed like a big change, possibly a regression.

Ian

> 
> --D
> 
> > -	int			token,
> > -	char			*p,
> > -	substring_t		*args,
> > -	struct xfs_mount	*mp)
> > +	struct fs_context	*fc,
> > +	struct fs_parameter	*param)
> >  {
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +	struct fs_parse_result	result;
> >  	int			size = 0;
> > +	int			opt;
> > +
> > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > +	if (opt < 0)
> > +		return opt;
> >  
> > -	switch (token) {
> > +	switch (opt) {
> >  	case Opt_logbufs:
> > -		if (match_int(args, &mp->m_logbufs))
> > -			return -EINVAL;
> > +		mp->m_logbufs = result.uint_32;
> >  		return 0;
> >  	case Opt_logbsize:
> > -		if (match_kstrtoint(args, 10, &mp->m_logbsize))
> > +		if (suffix_kstrtoint(param->string, 10, &mp-
> > >m_logbsize))
> >  			return -EINVAL;
> >  		return 0;
> >  	case Opt_logdev:
> >  		kfree(mp->m_logname);
> > -		mp->m_logname = match_strdup(args);
> > +		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> >  		if (!mp->m_logname)
> >  			return -ENOMEM;
> >  		return 0;
> >  	case Opt_rtdev:
> >  		kfree(mp->m_rtname);
> > -		mp->m_rtname = match_strdup(args);
> > +		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> >  		if (!mp->m_rtname)
> >  			return -ENOMEM;
> >  		return 0;
> >  	case Opt_allocsize:
> > -		if (match_kstrtoint(args, 10, &size))
> > +		if (suffix_kstrtoint(param->string, 10, &size))
> >  			return -EINVAL;
> >  		mp->m_allocsize_log = ffs(size) - 1;
> >  		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
> > @@ -217,12 +207,10 @@ xfs_fc_parse_param(
> >  		mp->m_flags |= XFS_MOUNT_SWALLOC;
> >  		return 0;
> >  	case Opt_sunit:
> > -		if (match_int(args, &mp->m_dalign))
> > -			return -EINVAL;
> > +		mp->m_dalign = result.uint_32;
> >  		return 0;
> >  	case Opt_swidth:
> > -		if (match_int(args, &mp->m_swidth))
> > -			return -EINVAL;
> > +		mp->m_swidth = result.uint_32;
> >  		return 0;
> >  	case Opt_inode32:
> >  		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > @@ -301,7 +289,7 @@ xfs_fc_parse_param(
> >  		return 0;
> >  #endif
> >  	default:
> > -		xfs_warn(mp, "unknown mount option [%s].", p);
> > +		xfs_warn(mp, "unknown mount option [%s].", param->key);
> >  		return -EINVAL;
> >  	}
> >  
> > @@ -376,62 +364,6 @@ xfs_fc_validate_params(
> >  	return 0;
> >  }
> >  
> > -/*
> > - * This function fills in xfs_mount_t fields based on mount args.
> > - * Note: the superblock has _not_ yet been read in.
> > - *
> > - * Note that this function leaks the various device name
> > allocations on
> > - * failure.  The caller takes care of them.
> > - *
> > - * *sb is const because this is also used to test options on the
> > remount
> > - * path, and we don't want this to have any side effects at
> > remount time.
> > - * Today this function does not change *sb, but just to future-
> > proof...
> > - */
> > -static int
> > -xfs_parseargs(
> > -	struct xfs_mount	*mp,
> > -	char			*options)
> > -{
> > -	const struct super_block *sb = mp->m_super;
> > -	char			*p;
> > -	substring_t		args[MAX_OPT_ARGS];
> > -
> > -	/*
> > -	 * Copy binary VFS mount flags we are interested in.
> > -	 */
> > -	if (sb_rdonly(sb))
> > -		mp->m_flags |= XFS_MOUNT_RDONLY;
> > -	if (sb->s_flags & SB_DIRSYNC)
> > -		mp->m_flags |= XFS_MOUNT_DIRSYNC;
> > -	if (sb->s_flags & SB_SYNCHRONOUS)
> > -		mp->m_flags |= XFS_MOUNT_WSYNC;
> > -
> > -	/*
> > -	 * These can be overridden by the mount option parsing.
> > -	 */
> > -	mp->m_logbufs = -1;
> > -	mp->m_logbsize = -1;
> > -	mp->m_allocsize_log = 16; /* 64k */
> > -
> > -	if (!options)
> > -		return 0;
> > -
> > -	while ((p = strsep(&options, ",")) != NULL) {
> > -		int		token;
> > -		int		ret;
> > -
> > -		if (!*p)
> > -			continue;
> > -
> > -		token = match_token(p, tokens, args);
> > -		ret = xfs_fc_parse_param(token, p, args, mp);
> > -		if (ret)
> > -			return ret;
> > -	}
> > -
> > -	return xfs_fc_validate_params(mp);
> > -}
> > -
> >  struct proc_xfs_info {
> >  	uint64_t	flag;
> >  	char		*str;
> > @@ -1207,25 +1139,6 @@ xfs_quiesce_attr(
> >  	xfs_log_quiesce(mp);
> >  }
> >  
> > -STATIC int
> > -xfs_test_remount_options(
> > -	struct super_block	*sb,
> > -	char			*options)
> > -{
> > -	int			error = 0;
> > -	struct xfs_mount	*tmp_mp;
> > -
> > -	tmp_mp = kmem_zalloc(sizeof(*tmp_mp), KM_MAYFAIL);
> > -	if (!tmp_mp)
> > -		return -ENOMEM;
> > -
> > -	tmp_mp->m_super = sb;
> > -	error = xfs_parseargs(tmp_mp, options);
> > -	xfs_mount_free(tmp_mp);
> > -
> > -	return error;
> > -}
> > -
> >  static int
> >  xfs_remount_rw(
> >  	struct xfs_mount	*mp)
> > @@ -1329,76 +1242,57 @@ xfs_remount_ro(
> >  	return 0;
> >  }
> >  
> > -STATIC int
> > -xfs_fs_remount(
> > -	struct super_block	*sb,
> > -	int			*flags,
> > -	char			*options)
> > +/*
> > + * Logically we would return an error here to prevent users from
> > believing
> > + * they might have changed mount options using remount which can't
> > be changed.
> > + *
> > + * But unfortunately mount(8) adds all options from mtab and fstab
> > to the mount
> > + * arguments in some cases so we can't blindly reject options, but
> > have to
> > + * check for each specified option if it actually differs from the
> > currently
> > + * set option and only reject it if that's the case.
> > + *
> > + * Until that is implemented we return success for every remount
> > request, and
> > + * silently ignore all options that we can't actually change.
> > + */
> > +static int
> > +xfs_fc_reconfigure(
> > +	struct fs_context	*fc)
> >  {
> > -	struct xfs_mount	*mp = XFS_M(sb);
> > +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> > +	struct xfs_mount        *new_mp = fc->s_fs_info;
> >  	xfs_sb_t		*sbp = &mp->m_sb;
> > -	substring_t		args[MAX_OPT_ARGS];
> > -	char			*p;
> > +	int			flags = fc->sb_flags;
> >  	int			error;
> >  
> > -	/* First, check for complete junk; i.e. invalid options */
> > -	error = xfs_test_remount_options(sb, options);
> > +	error = xfs_fc_validate_params(new_mp);
> >  	if (error)
> >  		return error;
> >  
> > -	sync_filesystem(sb);
> > -	while ((p = strsep(&options, ",")) != NULL) {
> > -		int token;
> > -
> > -		if (!*p)
> > -			continue;
> > -
> > -		token = match_token(p, tokens, args);
> > -		switch (token) {
> > -		case Opt_inode64:
> > -			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > -			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > -			break;
> > -		case Opt_inode32:
> > -			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > -			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp-
> > >sb_agcount);
> > -			break;
> > -		default:
> > -			/*
> > -			 * Logically we would return an error here to
> > prevent
> > -			 * users from believing they might have changed
> > -			 * mount options using remount which can't be
> > changed.
> > -			 *
> > -			 * But unfortunately mount(8) adds all options
> > from
> > -			 * mtab and fstab to the mount arguments in
> > some cases
> > -			 * so we can't blindly reject options, but have
> > to
> > -			 * check for each specified option if it
> > actually
> > -			 * differs from the currently set option and
> > only
> > -			 * reject it if that's the case.
> > -			 *
> > -			 * Until that is implemented we return success
> > for
> > -			 * every remount request, and silently ignore
> > all
> > -			 * options that we can't actually change.
> > -			 */
> > -#if 0
> > -			xfs_info(mp,
> > -		"mount option \"%s\" not supported for remount", p);
> > -			return -EINVAL;
> > -#else
> > -			break;
> > -#endif
> > -		}
> > +	sync_filesystem(mp->m_super);
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
> >  	}
> >  
> >  	/* ro -> rw */
> > -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY))
> > {
> > +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> >  		error = xfs_remount_rw(mp);
> >  		if (error)
> >  			return error;
> >  	}
> >  
> >  	/* rw -> ro */
> > -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY))
> > {
> > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> >  		error = xfs_remount_ro(mp);
> >  		if (error)
> >  			return error;
> > @@ -1588,28 +1482,18 @@ xfs_mount_alloc(void)
> >  	return mp;
> >  }
> >  
> > -
> > -STATIC int
> > -xfs_fs_fill_super(
> > +static int
> > +xfs_fc_fill_super(
> >  	struct super_block	*sb,
> > -	void			*data,
> > -	int			silent)
> > +	struct fs_context	*fc)
> >  {
> > +	struct xfs_mount	*mp = sb->s_fs_info;
> >  	struct inode		*root;
> > -	struct xfs_mount	*mp = NULL;
> >  	int			flags = 0, error = -ENOMEM;
> >  
> > -	/*
> > -	 * allocate mp and do all low-level struct initializations
> > before we
> > -	 * attach it to the super
> > -	 */
> > -	mp = xfs_mount_alloc();
> > -	if (!mp)
> > -		goto out;
> >  	mp->m_super = sb;
> > -	sb->s_fs_info = mp;
> >  
> > -	error = xfs_parseargs(mp, (char *)data);
> > +	error = xfs_fc_validate_params(mp);
> >  	if (error)
> >  		goto out_free_names;
> >  
> > @@ -1633,7 +1517,7 @@ xfs_fs_fill_super(
> >  		msleep(xfs_globals.mount_delay * 1000);
> >  	}
> >  
> > -	if (silent)
> > +	if (fc->sb_flags & SB_SILENT)
> >  		flags |= XFS_MFSI_QUIET;
> >  
> >  	error = xfs_open_devices(mp);
> > @@ -1778,7 +1662,6 @@ xfs_fs_fill_super(
> >   out_free_names:
> >  	sb->s_fs_info = NULL;
> >  	xfs_mount_free(mp);
> > - out:
> >  	return error;
> >  
> >   out_unmount:
> > @@ -1787,6 +1670,13 @@ xfs_fs_fill_super(
> >  	goto out_free_sb;
> >  }
> >  
> > +static int
> > +xfs_fc_get_tree(
> > +	struct fs_context	*fc)
> > +{
> > +	return get_tree_bdev(fc, xfs_fc_fill_super);
> > +}
> > +
> >  STATIC void
> >  xfs_fs_put_super(
> >  	struct super_block	*sb)
> > @@ -1811,16 +1701,6 @@ xfs_fs_put_super(
> >  	xfs_mount_free(mp);
> >  }
> >  
> > -STATIC struct dentry *
> > -xfs_fs_mount(
> > -	struct file_system_type	*fs_type,
> > -	int			flags,
> > -	const char		*dev_name,
> > -	void			*data)
> > -{
> > -	return mount_bdev(fs_type, flags, dev_name, data,
> > xfs_fs_fill_super);
> > -}
> > -
> >  static long
> >  xfs_fs_nr_cached_objects(
> >  	struct super_block	*sb,
> > @@ -1850,16 +1730,70 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.freeze_fs		= xfs_fs_freeze,
> >  	.unfreeze_fs		= xfs_fs_unfreeze,
> >  	.statfs			= xfs_fs_statfs,
> > -	.remount_fs		= xfs_fs_remount,
> >  	.show_options		= xfs_fs_show_options,
> >  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static void xfs_fc_free(
> > +	struct fs_context	*fc)
> > +{
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +
> > +	/*
> > +	 * mp is stored in the fs_context when it is initialized.
> > +	 * mp is transferred to the superblock on a successful mount,
> > +	 * but if an error occurs before the transfer we have to free
> > +	 * it here.
> > +	 */
> > +	if (mp)
> > +		xfs_mount_free(mp);
> > +}
> > +
> > +static const struct fs_context_operations xfs_context_ops = {
> > +	.parse_param = xfs_fc_parse_param,
> > +	.get_tree    = xfs_fc_get_tree,
> > +	.reconfigure = xfs_fc_reconfigure,
> > +	.free        = xfs_fc_free,
> > +};
> > +
> > +static int xfs_init_fs_context(
> > +	struct fs_context	*fc)
> > +{
> > +	struct xfs_mount	*mp;
> > +
> > +	mp = xfs_mount_alloc();
> > +	if (!mp)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * These can be overridden by the mount option parsing.
> > +	 */
> > +	mp->m_logbufs = -1;
> > +	mp->m_logbsize = -1;
> > +	mp->m_allocsize_log = 16; /* 64k */
> > +
> > +	/*
> > +	 * Copy binary VFS mount flags we are interested in.
> > +	 */
> > +	if (fc->sb_flags & SB_RDONLY)
> > +		mp->m_flags |= XFS_MOUNT_RDONLY;
> > +	if (fc->sb_flags & SB_DIRSYNC)
> > +		mp->m_flags |= XFS_MOUNT_DIRSYNC;
> > +	if (fc->sb_flags & SB_SYNCHRONOUS)
> > +		mp->m_flags |= XFS_MOUNT_WSYNC;
> > +
> > +	fc->s_fs_info = mp;
> > +	fc->ops = &xfs_context_ops;
> > +
> > +	return 0;
> > +}
> > +
> >  static struct file_system_type xfs_fs_type = {
> >  	.owner			= THIS_MODULE,
> >  	.name			= "xfs",
> > -	.mount			= xfs_fs_mount,
> > +	.init_fs_context	= xfs_init_fs_context,
> > +	.parameters		= &xfs_fs_parameters,
> >  	.kill_sb		= kill_block_super,
> >  	.fs_flags		= FS_REQUIRES_DEV,
> >  };
> > 

