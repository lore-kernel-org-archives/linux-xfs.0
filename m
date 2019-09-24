Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8440AC432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 11:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B7C214D9
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 11:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="O/6ilwXl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MY0aS6WG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389536AbfIXLAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 07:00:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55759 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389414AbfIXLAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 07:00:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D32921B81;
        Tue, 24 Sep 2019 07:00:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Sep 2019 07:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        2YzO7cTJTla8yLdbBxQ6Q+3L5N16SMst9gjcFXtKCks=; b=O/6ilwXltwef4UsJ
        OO44qt4qw++Y8pSIItCe3wzfcduLBzwDKVh3sX8arHRIS/Ck3Ccr6XwqEz7dkuel
        OjrHJuO5TWirI66Y3hO6fzhDRWRuacwIXSwtny/uNqv5XG3qLJtluW9+NiEKnnk+
        YXqlCjxyK7FaCCpBC1VLGOdbCbeR13ni5wZmgh7PLUCNyi23/muqqMbtigaBtpfF
        IQDmwJnGf0JcWVkrTW4fUVnKMtgNtnVkd9VfxjTZa7eeVnMgTHj7Jk7mRVTHtKCH
        j9T5wGcYK8Y0qLN7+lxZZlIUkHNAsbrA7CwaXdgno0pWBuk11c2pLjnFvXCeHvSo
        lft6Jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=2YzO7cTJTla8yLdbBxQ6Q+3L5N16SMst9gjcFXtKC
        ks=; b=MY0aS6WGC21mruCjDV0Web59eUvbPjb+4fgP1Ae6gL9m5FEQfNumKrb8t
        RgbqgfhoEGcN/6hyfQwpkKopD3t7hpT+X/ko31pBj0Yti6p1VoAX8Bgs2P9/bFqC
        UHpBkSXv3BSvRnqFg4Sk9BIAcE9XSa1pBjwnexPE/ERGgboEml89azRhlpnO1ify
        KKDVSe+XxDLNMZPd9zzjDH5dZlVM01LYVkydxRRIqKv/Ca5+014pk3ohZR852DXc
        k8zo3Yn2sEnyztCx+cNvMIwjlpJxJsiMR/gVm+rHBwGn3zQu6EM3yBy1P9hDEzNh
        kJgcAA+UmnVsrZlROvuoYEAmjqmBg==
X-ME-Sender: <xms:QveJXYIwFAOWQmS18IIda00QrMP9hH1Z74Po0oHlg4zCrncgKIKS3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedtgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtkeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:QveJXcZoKoiY2FGiNvFzm3XgP-6E14C-ge_dCT8l-7Zt7DsbX87WTA>
    <xmx:QveJXTttYyB4lIKcIEY3K3Kd2BqusxjPcfdZeXEScbOsiyUxWaKUTA>
    <xmx:QveJXZuN2wmn4tUlSIKjxTlfHYj4n1j1LWd1KIS5p2OYvLs5oTZ47w>
    <xmx:QveJXfp_JLxkRyflDjTE54OsFZZcdXVmfjrCA-XXEjdHJ1iofUlAmA>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 81C708006A;
        Tue, 24 Sep 2019 07:00:14 -0400 (EDT)
Message-ID: <66d05b19a5929825cf611209391f4db167344d66.camel@themaw.net>
Subject: Re: [PATCH v3 06/16] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 24 Sep 2019 19:00:07 +0800
In-Reply-To: <20190924105422.GH13820@bfoster>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
         <156897336458.20210.16236394963116388337.stgit@fedora-28>
         <20190924105422.GH13820@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 06:54 -0400, Brian Foster wrote:
> On Fri, Sep 20, 2019 at 05:56:04PM +0800, Ian Kent wrote:
> > Make xfs_parse_param() take arguments of the fs context operation
> > .parse_param() in preparation for switching to use the file system
> > mount context for mount.
> > 
> > The function fc_parse() only uses the file system context (fc here)
> > when calling log macros warnf() and invalf() which in turn check
> > only the fc->log field to determine if the message should be saved
> > to a context buffer (for later retrival by userspace) or logged
> > using printk().
> > 
> > Also the temporary function match_kstrtoint() is now unused, remove
> > it.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> 
> This fails to compile:
> 
> $ make -j 8 M=fs/xfs
>   CC [M]  fs/xfs/xfs_super.o
> fs/xfs/xfs_super.c: In function ‘xfs_parseargs’:
> fs/xfs/xfs_super.c:461:7: error: ‘ctx’ undeclared (first use in this
> function)
>       (ctx->dsunit || ctx->dswidth)) {
>        ^~~
> fs/xfs/xfs_super.c:461:7: note: each undeclared identifier is
> reported only once for each function it appears in
> make[1]: *** [scripts/Makefile.build:280: fs/xfs/xfs_super.o] Error 1
> make: *** [Makefile:1624: _module_fs/xfs] Error 2

No!

Arrgh, I must have mixed up my patch series.

This was a mistake I fixed when I went through and compiled with
each patch just before posting.

Looks like I'll need to post a v4 then with this fixed, *sigh*.

> 
> >  fs/xfs/xfs_super.c |  135 ++++++++++++++++++++++++++++++--------
> > --------------
> >  1 file changed, 79 insertions(+), 56 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index b04aebab69ab..041ab8b52a7d 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -191,57 +191,60 @@ suffix_kstrtoint(const char *s, unsigned int
> > base, int *res)
> >  	return ret;
> >  }
> >  
> ...
> >  STATIC int
> >  xfs_parse_param(
> ...
> >  
> > -	switch (token) {
> > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > +	if (opt < 0) {
> > +		/*
> > +		 * If fs_parse() returns -ENOPARAM and the parameter
> > +		 * is "source" the VFS needs to handle this option
> > +		 * in order to boot otherwise use the default case
> > +		 * below to handle invalid options.
> > +		 */
> > +		if (opt != -ENOPARAM ||
> > +		    strcmp(param->key, "source") == 0)
> > +			return opt;
> 
> Why is this not something that is handled in core mount-api code?
> Every
> filesystem needs this logic in order to be a rootfs..?
> 
> Brian
> 
> > +	}
> > +
> > +	switch (opt) {
> >  	case Opt_logbufs:
> > -		if (match_int(args, &mp->m_logbufs))
> > -			return -EINVAL;
> > +		mp->m_logbufs = result.uint_32;
> >  		break;
> >  	case Opt_logbsize:
> > -		if (match_kstrtoint(args, 10, &mp->m_logbsize))
> > +		if (suffix_kstrtoint(param->string, 10, &mp-
> > >m_logbsize))
> >  			return -EINVAL;
> >  		break;
> >  	case Opt_logdev:
> >  		kfree(mp->m_logname);
> > -		mp->m_logname = match_strdup(args);
> > +		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> >  		if (!mp->m_logname)
> >  			return -ENOMEM;
> >  		break;
> >  	case Opt_rtdev:
> >  		kfree(mp->m_rtname);
> > -		mp->m_rtname = match_strdup(args);
> > +		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> >  		if (!mp->m_rtname)
> >  			return -ENOMEM;
> >  		break;
> >  	case Opt_allocsize:
> > -		if (match_kstrtoint(args, 10, &iosize))
> > +		if (suffix_kstrtoint(param->string, 10, &iosize))
> >  			return -EINVAL;
> > -		*iosizelog = ffs(iosize) - 1;
> > +		ctx->iosizelog = ffs(iosize) - 1;
> >  		break;
> >  	case Opt_grpid:
> >  	case Opt_bsdgroups:
> > @@ -264,12 +267,10 @@ xfs_parse_param(
> >  		mp->m_flags |= XFS_MOUNT_SWALLOC;
> >  		break;
> >  	case Opt_sunit:
> > -		if (match_int(args, dsunit))
> > -			return -EINVAL;
> > +		ctx->dsunit = result.uint_32;
> >  		break;
> >  	case Opt_swidth:
> > -		if (match_int(args, dswidth))
> > -			return -EINVAL;
> > +		ctx->dswidth = result.uint_32;
> >  		break;
> >  	case Opt_inode32:
> >  		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > @@ -348,7 +349,7 @@ xfs_parse_param(
> >  		break;
> >  #endif
> >  	default:
> > -		xfs_warn(mp, "unknown mount option [%s].", p);
> > +		xfs_warn(mp, "unknown mount option [%s].", param->key);
> >  		return -EINVAL;
> >  	}
> >  
> > @@ -373,10 +374,13 @@ xfs_parseargs(
> >  {
> >  	const struct super_block *sb = mp->m_super;
> >  	char			*p;
> > -	substring_t		args[MAX_OPT_ARGS];
> > -	int			dsunit = 0;
> > -	int			dswidth = 0;
> > -	uint8_t			iosizelog = 0;
> > +	struct fs_context	fc;
> > +	struct xfs_fs_context	context;
> > +
> > +	memset(&fc, 0, sizeof(fc));
> > +	memset(&context, 0, sizeof(context));
> > +	fc.fs_private = &context;
> > +	fc.s_fs_info = mp;
> >  
> >  	/*
> >  	 * set up the mount name first so all the errors will refer to
> > the
> > @@ -413,16 +417,34 @@ xfs_parseargs(
> >  		goto done;
> >  
> >  	while ((p = strsep(&options, ",")) != NULL) {
> > -		int		token;
> > -		int		ret;
> > +		struct fs_parameter	param;
> > +		char			*value;
> > +		int			ret;
> >  
> >  		if (!*p)
> >  			continue;
> >  
> > -		token = match_token(p, tokens, args);
> > -		ret = xfs_parse_param(token, p, args, mp,
> > -				      &dsunit, &dswidth, &iosizelog);
> > -		if (ret)
> > +		param.key = p;
> > +		param.type = fs_value_is_string;
> > +		param.string = NULL;
> > +		param.size = 0;
> > +
> > +		value = strchr(p, '=');
> > +		if (value) {
> > +			*value++ = 0;
> > +			param.size = strlen(value);
> > +			if (param.size > 0) {
> > +				param.string = kmemdup_nul(value,
> > +							   param.size,
> > +							   GFP_KERNEL);
> > +				if (!param.string)
> > +					return -ENOMEM;
> > +			}
> > +		}
> > +
> > +		ret = xfs_parse_param(&fc, &param);
> > +		kfree(param.string);
> > +		if (ret < 0)
> >  			return ret;
> >  	}
> >  
> > @@ -435,7 +457,8 @@ xfs_parseargs(
> >  		return -EINVAL;
> >  	}
> >  
> > -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
> > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > +	    (ctx->dsunit || ctx->dswidth)) {
> >  		xfs_warn(mp,
> >  	"sunit and swidth options incompatible with the noalign
> > option");
> >  		return -EINVAL;
> > @@ -448,28 +471,28 @@ xfs_parseargs(
> >  	}
> >  #endif
> >  
> > -	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
> > +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx-
> > >dswidth)) {
> >  		xfs_warn(mp, "sunit and swidth must be specified
> > together");
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (dsunit && (dswidth % dsunit != 0)) {
> > +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> >  		xfs_warn(mp,
> >  	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> > -			dswidth, dsunit);
> > +			ctx->dswidth, ctx->dsunit);
> >  		return -EINVAL;
> >  	}
> >  
> >  done:
> > -	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> >  		/*
> >  		 * At this point the superblock has not been read
> >  		 * in, therefore we do not know the block size.
> >  		 * Before the mount call ends we will convert
> >  		 * these to FSBs.
> >  		 */
> > -		mp->m_dalign = dsunit;
> > -		mp->m_swidth = dswidth;
> > +		mp->m_dalign = ctx->dsunit;
> > +		mp->m_swidth = ctx->dswidth;
> >  	}
> >  
> >  	if (mp->m_logbufs != -1 &&
> > @@ -491,18 +514,18 @@ xfs_parseargs(
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (iosizelog) {
> > -		if (iosizelog > XFS_MAX_IO_LOG ||
> > -		    iosizelog < XFS_MIN_IO_LOG) {
> > +	if (ctx->iosizelog) {
> > +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> >  			xfs_warn(mp, "invalid log iosize: %d [not %d-
> > %d]",
> > -				iosizelog, XFS_MIN_IO_LOG,
> > +				ctx->iosizelog, XFS_MIN_IO_LOG,
> >  				XFS_MAX_IO_LOG);
> >  			return -EINVAL;
> >  		}
> >  
> >  		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > -		mp->m_readio_log = iosizelog;
> > -		mp->m_writeio_log = iosizelog;
> > +		mp->m_readio_log = ctx->iosizelog;
> > +		mp->m_writeio_log = ctx->iosizelog;
> >  	}
> >  
> >  	return 0;
> > 

