Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69520C432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 00:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D62820872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 00:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="I/Hs9K0S";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aIpsPp04"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfIYAUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 20:20:34 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50597 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729147AbfIYAUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 20:20:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 59C184D9;
        Tue, 24 Sep 2019 20:20:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 24 Sep 2019 20:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        EdM3spOqrZGVKwLZdkf6C66aebWZzKvoQHQ3HUH/2fU=; b=I/Hs9K0SfhXTpS3w
        /Ndr2HC4eQkIZlqIWhzZxNCle57gBPKnlr6yFbCJV/RUgLcCKa+5lhs8V+KvJve5
        wn7/4wH9FE460SiTM/m/Y5ztsOZGpKPaSIOTtrmutB08g+pQwMuC61V/Oj+ik8BU
        gCrha3U3HXGx6GQVC8RoKKGkUlSMTcQyKJj4AZIWw4kOlZl7jQ8/3lWmkepkCHCb
        me8GV1lYKS3L1tnE6mQZy+mSD5rn/AzVENLGhE+FrGazA+wRAllyxSVn3zrw9aI5
        Zyba6mdw8FjIOc9qNNFdkKnvcx6z8M8S2lBBc8dclnekOjwz7IRhyNNq+jSG8INK
        BtJ1KA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=EdM3spOqrZGVKwLZdkf6C66aebWZzKvoQHQ3HUH/2
        fU=; b=aIpsPp04xImefrfKvuYb+TieJGOmBFBbVK4nosMemsHPw0XLYIQnm/Ycn
        +dbMQ+F5Eoi9bqjhwaVm0ryORi4fUBMtk/NoWW+Fw4h64Fdc9KqYEhVNwWQeRxce
        nmx9UtZcaH9F+ZP65qQcuGwpzF6A+RUzaWAScofZAza5PSmgU0sEJGZQ096R0f+Y
        2Rpm9OIXTgPSX7RtLrV8Wb/tYj3uqac5mH93l3PoQHu1tKbrY5VaQtVYVk1AZ+ew
        grRmpC5noXUNlXXH97DUGso4n/EB/1w5mJc9GYfxi1/+R4VZJEZxf0IoI3b3zIYx
        supZPH/64H6O2bulKzvbBvPkkMXJw==
X-ME-Sender: <xms:z7KKXefhq_8Rw4z0hdBS5qIHem_k7Dh5adRSBOnbwl0HFgvu__WOlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:z7KKXZtV-p4iVh3aFS0lxF7t8VJFjr9HQmMwL-nV_dg7cXXGS-mx5A>
    <xmx:z7KKXdKNCRGM0bkJY6zBJC0kBEjUl1PWxTKohN4k1Ce4YZry2t_JyQ>
    <xmx:z7KKXTbB07yd-hb4Ea3utNRInJEOPU05d9_Ov7RMvGNQN3_iQm9rXg>
    <xmx:z7KKXa0A4XCDH3R-bz0vnNBErfUqWGy6rNPl1Dq0Z7l5Z-Dj3hcUgg>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id D94C3D60067;
        Tue, 24 Sep 2019 20:20:28 -0400 (EDT)
Message-ID: <b9906ced64736b043b6537c61ce60182d92d63e8.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 08:20:25 +0800
In-Reply-To: <20190924143725.GA17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933135322.20933.2166438700224340142.stgit@fedora-28>
         <20190924143725.GA17688@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 10:37 -0400, Brian Foster wrote:
> On Tue, Sep 24, 2019 at 09:22:33PM +0800, Ian Kent wrote:
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
> >  fs/xfs/xfs_super.c |  137 +++++++++++++++++++++++++++++++---------
> > ------------
> >  1 file changed, 81 insertions(+), 56 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index b04aebab69ab..6792d46fa0be 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -191,57 +191,60 @@ suffix_kstrtoint(const char *s, unsigned int
> > base, int *res)
> >  	return ret;
> >  }
> >  
> ...
> >  
> >  STATIC int
> >  xfs_parse_param(
> ...
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
> Same question as before on this bit..

Your comment was:
Why is this not something that is handled in core mount-api code? Every
filesystem needs this logic in order to be a rootfs..?

I looked at the VFS code and was tempted to change it but it's all too
easy to prevent the system from booting.

The way the VFS looks to me it needs to give the file system a chance
to handle the "source" option, if the file system ->parse_param()
doesn't handle the option it "must" return -ENOPARAM so the VFS will
test for and handle the "source" option.

Having returned -ENOPARAM either the option is "source" or it's a
real unknown option.

The choices are:
1) If it is the "source" option we will get a false positive unknown
parameter message logged by our ->parse_param().
2) if it isn't the "source" option we will get an unknown parameter
message from our ->parse_param() and an additional inconsistent
format unknown parameter message from the VFS.
3) Check for the "source" parameter in our ->parse_param() and
return without issuing a message so the VFS can handle the option,
no duplicate message and no inconsistent logging.

Suggestions on how to handle this better, a VFS patch perhaps?
Suggestions David, Al?

> ...
> > @@ -373,10 +374,16 @@ xfs_parseargs(
> >  {
> >  	const struct super_block *sb = mp->m_super;
> >  	char			*p;
> > -	substring_t		args[MAX_OPT_ARGS];
> > -	int			dsunit = 0;
> > -	int			dswidth = 0;
> > -	uint8_t			iosizelog = 0;
> > +	struct fs_context	fc;
> > +	struct xfs_fs_context	context;
> > +	struct xfs_fs_context	*ctx;
> > +	int			ret;
> > +
> > +	memset(&fc, 0, sizeof(fc));
> > +	memset(&context, 0, sizeof(context));
> > +	fc.fs_private = &context;
> > +	ctx = &context;
> 
> I think you mentioned this ctx/context pattern would be removed from
> v2..?

Except that, to minimise code churn the ctx variable is needed
because it will be used in the end result.

I don't much like prefixing those references with &context even
if some happen to go away later on, the additional local variable
is clearer to read and provides usage consistency for the reader
over the changes.

Ian
> 
> Brian
> 
> > +	fc.s_fs_info = mp;
> >  
> >  	/*
> >  	 * set up the mount name first so all the errors will refer to
> > the
> > @@ -413,16 +420,33 @@ xfs_parseargs(
> >  		goto done;
> >  
> >  	while ((p = strsep(&options, ",")) != NULL) {
> > -		int		token;
> > -		int		ret;
> > +		struct fs_parameter	param;
> > +		char			*value;
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
> > @@ -435,7 +459,8 @@ xfs_parseargs(
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
> > @@ -448,28 +473,28 @@ xfs_parseargs(
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
> > @@ -491,18 +516,18 @@ xfs_parseargs(
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

