Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ED1C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 14:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09432146E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 14:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbfIYOdN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 10:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43439 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfIYOdN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Sep 2019 10:33:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F0A62107;
        Wed, 25 Sep 2019 14:33:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C1FD600C8;
        Wed, 25 Sep 2019 14:33:11 +0000 (UTC)
Date:   Wed, 25 Sep 2019 10:33:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
Message-ID: <20190925143309.GD21991@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933135322.20933.2166438700224340142.stgit@fedora-28>
 <20190924143725.GA17688@bfoster>
 <b9906ced64736b043b6537c61ce60182d92d63e8.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9906ced64736b043b6537c61ce60182d92d63e8.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 25 Sep 2019 14:33:12 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 08:20:25AM +0800, Ian Kent wrote:
> On Tue, 2019-09-24 at 10:37 -0400, Brian Foster wrote:
> > On Tue, Sep 24, 2019 at 09:22:33PM +0800, Ian Kent wrote:
> > > Make xfs_parse_param() take arguments of the fs context operation
> > > .parse_param() in preparation for switching to use the file system
> > > mount context for mount.
> > > 
> > > The function fc_parse() only uses the file system context (fc here)
> > > when calling log macros warnf() and invalf() which in turn check
> > > only the fc->log field to determine if the message should be saved
> > > to a context buffer (for later retrival by userspace) or logged
> > > using printk().
> > > 
> > > Also the temporary function match_kstrtoint() is now unused, remove
> > > it.
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > ---
> > >  fs/xfs/xfs_super.c |  137 +++++++++++++++++++++++++++++++---------
> > > ------------
> > >  1 file changed, 81 insertions(+), 56 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index b04aebab69ab..6792d46fa0be 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -191,57 +191,60 @@ suffix_kstrtoint(const char *s, unsigned int
> > > base, int *res)
> > >  	return ret;
> > >  }
> > >  
> > ...
> > >  
> > >  STATIC int
> > >  xfs_parse_param(
> > ...
> > > -	switch (token) {
> > > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > > +	if (opt < 0) {
> > > +		/*
> > > +		 * If fs_parse() returns -ENOPARAM and the parameter
> > > +		 * is "source" the VFS needs to handle this option
> > > +		 * in order to boot otherwise use the default case
> > > +		 * below to handle invalid options.
> > > +		 */
> > > +		if (opt != -ENOPARAM ||
> > > +		    strcmp(param->key, "source") == 0)
> > > +			return opt;
> > 
> > Same question as before on this bit..
> 
> Your comment was:
> Why is this not something that is handled in core mount-api code? Every
> filesystem needs this logic in order to be a rootfs..?
> 
> I looked at the VFS code and was tempted to change it but it's all too
> easy to prevent the system from booting.
> 

Ok, so I'm not terribly familiar with the core mount code in the first
place. Can you elaborate a bit on the where the whole "source" thing
comes from and why/how it's necessary to boot?

> The way the VFS looks to me it needs to give the file system a chance
> to handle the "source" option, if the file system ->parse_param()
> doesn't handle the option it "must" return -ENOPARAM so the VFS will
> test for and handle the "source" option.
> 

Do any existing filesystems handle this option? By handle, I mean
actually have to make some change, set some option, etc.

> Having returned -ENOPARAM either the option is "source" or it's a
> real unknown option.
> 
> The choices are:
> 1) If it is the "source" option we will get a false positive unknown
> parameter message logged by our ->parse_param().
> 2) if it isn't the "source" option we will get an unknown parameter
> message from our ->parse_param() and an additional inconsistent
> format unknown parameter message from the VFS.
> 3) Check for the "source" parameter in our ->parse_param() and
> return without issuing a message so the VFS can handle the option,
> no duplicate message and no inconsistent logging.
> 

Hmm.. so we definitely don't want spurious unknown parameter messages,
but I don't see how that leaves #3 as the only other option.

Is param-key already filled in at that point? If so, couldn't we set a
flag or something on the context structure to signal that we don't care
about the source option, so let the vfs handle it however it needs to?
If not, another option could be to define a helper function or something
that the fs can call to determine whether an -ENOPARAM key is some
global option to be handled by a higher layer and so to not throw a
warning or whatever. That has the same logic as this patch, but is still
better than open-coding "source" key checks all over the place IMO. 

BTW, this all implies there is some reason for an fs to handle the
"source" option, so what happens if one actually does? ISTM the
->parse_param() callout would return 0 and vfs_parse_fs_param() would
skip its own update of fc->source. Hm?

Brian

> Suggestions on how to handle this better, a VFS patch perhaps?
> Suggestions David, Al?
> 
> > ...
> > > @@ -373,10 +374,16 @@ xfs_parseargs(
> > >  {
> > >  	const struct super_block *sb = mp->m_super;
> > >  	char			*p;
> > > -	substring_t		args[MAX_OPT_ARGS];
> > > -	int			dsunit = 0;
> > > -	int			dswidth = 0;
> > > -	uint8_t			iosizelog = 0;
> > > +	struct fs_context	fc;
> > > +	struct xfs_fs_context	context;
> > > +	struct xfs_fs_context	*ctx;
> > > +	int			ret;
> > > +
> > > +	memset(&fc, 0, sizeof(fc));
> > > +	memset(&context, 0, sizeof(context));
> > > +	fc.fs_private = &context;
> > > +	ctx = &context;
> > 
> > I think you mentioned this ctx/context pattern would be removed from
> > v2..?
> 
> Except that, to minimise code churn the ctx variable is needed
> because it will be used in the end result.
> 
> I don't much like prefixing those references with &context even
> if some happen to go away later on, the additional local variable
> is clearer to read and provides usage consistency for the reader
> over the changes.
> 
> Ian
> > 
> > Brian
> > 
> > > +	fc.s_fs_info = mp;
> > >  
> > >  	/*
> > >  	 * set up the mount name first so all the errors will refer to
> > > the
> > > @@ -413,16 +420,33 @@ xfs_parseargs(
> > >  		goto done;
> > >  
> > >  	while ((p = strsep(&options, ",")) != NULL) {
> > > -		int		token;
> > > -		int		ret;
> > > +		struct fs_parameter	param;
> > > +		char			*value;
> > >  
> > >  		if (!*p)
> > >  			continue;
> > >  
> > > -		token = match_token(p, tokens, args);
> > > -		ret = xfs_parse_param(token, p, args, mp,
> > > -				      &dsunit, &dswidth, &iosizelog);
> > > -		if (ret)
> > > +		param.key = p;
> > > +		param.type = fs_value_is_string;
> > > +		param.string = NULL;
> > > +		param.size = 0;
> > > +
> > > +		value = strchr(p, '=');
> > > +		if (value) {
> > > +			*value++ = 0;
> > > +			param.size = strlen(value);
> > > +			if (param.size > 0) {
> > > +				param.string = kmemdup_nul(value,
> > > +							   param.size,
> > > +							   GFP_KERNEL);
> > > +				if (!param.string)
> > > +					return -ENOMEM;
> > > +			}
> > > +		}
> > > +
> > > +		ret = xfs_parse_param(&fc, &param);
> > > +		kfree(param.string);
> > > +		if (ret < 0)
> > >  			return ret;
> > >  	}
> > >  
> > > @@ -435,7 +459,8 @@ xfs_parseargs(
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
> > > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > > +	    (ctx->dsunit || ctx->dswidth)) {
> > >  		xfs_warn(mp,
> > >  	"sunit and swidth options incompatible with the noalign
> > > option");
> > >  		return -EINVAL;
> > > @@ -448,28 +473,28 @@ xfs_parseargs(
> > >  	}
> > >  #endif
> > >  
> > > -	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
> > > +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx-
> > > >dswidth)) {
> > >  		xfs_warn(mp, "sunit and swidth must be specified
> > > together");
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > -	if (dsunit && (dswidth % dsunit != 0)) {
> > > +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> > >  		xfs_warn(mp,
> > >  	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> > > -			dswidth, dsunit);
> > > +			ctx->dswidth, ctx->dsunit);
> > >  		return -EINVAL;
> > >  	}
> > >  
> > >  done:
> > > -	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > > +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > >  		/*
> > >  		 * At this point the superblock has not been read
> > >  		 * in, therefore we do not know the block size.
> > >  		 * Before the mount call ends we will convert
> > >  		 * these to FSBs.
> > >  		 */
> > > -		mp->m_dalign = dsunit;
> > > -		mp->m_swidth = dswidth;
> > > +		mp->m_dalign = ctx->dsunit;
> > > +		mp->m_swidth = ctx->dswidth;
> > >  	}
> > >  
> > >  	if (mp->m_logbufs != -1 &&
> > > @@ -491,18 +516,18 @@ xfs_parseargs(
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > -	if (iosizelog) {
> > > -		if (iosizelog > XFS_MAX_IO_LOG ||
> > > -		    iosizelog < XFS_MIN_IO_LOG) {
> > > +	if (ctx->iosizelog) {
> > > +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > > +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > >  			xfs_warn(mp, "invalid log iosize: %d [not %d-
> > > %d]",
> > > -				iosizelog, XFS_MIN_IO_LOG,
> > > +				ctx->iosizelog, XFS_MIN_IO_LOG,
> > >  				XFS_MAX_IO_LOG);
> > >  			return -EINVAL;
> > >  		}
> > >  
> > >  		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > > -		mp->m_readio_log = iosizelog;
> > > -		mp->m_writeio_log = iosizelog;
> > > +		mp->m_readio_log = ctx->iosizelog;
> > > +		mp->m_writeio_log = ctx->iosizelog;
> > >  	}
> > >  
> > >  	return 0;
> > > 
> 
