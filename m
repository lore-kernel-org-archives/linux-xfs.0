Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ED8C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4AF622CE3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="W3V8VVQ8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YExsiiHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfH3Kvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:51:36 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34477 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbfH3Kvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:51:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9EC573BA;
        Fri, 30 Aug 2019 06:51:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 06:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        0sVf877k9jkRf/J7eUi/ONPGPehrSYYAi/5rFGOtdmc=; b=W3V8VVQ86ZdLmsSZ
        sR9JDSguUC1qXVmu8AJk1gnD62bjZB1ugpzL4LUf6sh2kEMDDzvoqa7QuFJEcj5x
        9LPkMYYGj7QmgJlYaKhXw5h2FrKqLmPozU0Pk/Zmxi9vSa0mOzaZP/5ePEVEwMuW
        GTpdflGnfB/U7nu7dU37as72OMuOWDh5WbVOx0je/2L52fTTpsO79EVZtoe0pTTP
        1nYo6WIUvOF5j+XBJcIYF9AUX5RXY0k3JEAYWX5Q3zV0HufoKfJBkBlzhmgojcWt
        B9fDjgg8cn+M/J2NkNZaE+k19J0lPbgXB6A04cKzNJ/mi22npnLR9cwotytWgFQQ
        vcd6eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=0sVf877k9jkRf/J7eUi/ONPGPehrSYYAi/5rFGOtd
        mc=; b=YExsiiHo1hJiFDNFlFh5a9N1TdBWLfoCdn7YC/ivXVxxuzRPBrIAfRcxr
        Xi1+jMz46Hfk3eCJ1jcdFq3lpoiFyUmDolQW+U/0YCWZIEampsjOc8oiD+U02Ozm
        JBLrOrTNw0fr0QHRNS6C4Or9DH6lPVpn4NS2nrPXjrdST9MWYNEqXcNlIU03sjG6
        /4SDwjDNcu9WCCD9QQOuk6vIzhgN+VNpiDRheAv8OIMDNb4vuJ/Oce93OfMqqfel
        Nzo5+wOgS0xh8EzVByUKnkX4zxfk5X8WOS+i9ys/yQs1qj47I8UN9xZ3Dbo88pgc
        HSN2OB0dVLOyqsldFtzDj+mUk/i3w==
X-ME-Sender: <xms:tf9oXe0KFVT9u_XeHYjaSM0X6twc8y-aq6L-fymwoklFFb2spgdO9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:tf9oXaCJ9DIw0bhBeY85xqp7klhVvYbRxVM_sISFXYftOlG036ceNA>
    <xmx:tf9oXfp-wGvBIQS0QqSNORJBUUXw-tlm-Kb5LoUEtjaPWR4ypQuJyw>
    <xmx:tf9oXS_HDNhu8cwT8Xzm18RCWbdnBZ51DRtDcZDW8vLERrulnqm8Hg>
    <xmx:tv9oXfOgY2Hode5FBbeJmNpFhTJjPpsIA02BwaOAJymG5R0HnDWxrQ>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 759F78005B;
        Fri, 30 Aug 2019 06:51:30 -0400 (EDT)
Message-ID: <1364106c4f6b0558d4701d585355550de358cf14.camel@themaw.net>
Subject: Re: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 18:51:26 +0800
In-Reply-To: <20190827124120.GD10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652198391.2607.14772471190581142304.stgit@fedora-28>
         <20190827124120.GD10636@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-08-27 at 08:41 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:59:43AM +0800, Ian Kent wrote:
> > Make xfs_parse_param() take arguments of the fs context operation
> > .parse_param() in preperation for switching to use the file system
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
> I see Eric had some feedback on this patch already. Some additional
> notes (which may overlap)...
> 
> >  fs/xfs/xfs_super.c |  187 ++++++++++++++++++++++++++++++--------
> > --------------
> >  1 file changed, 108 insertions(+), 79 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 3ae29938dd89..754d2ccfd960 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -275,33 +271,38 @@ xfs_parse_param(
> >  		mp->m_flags |= XFS_MOUNT_NOUUID;
> >  		break;
> >  	case Opt_ikeep:
> > -		mp->m_flags |= XFS_MOUNT_IKEEP;
> > -		break;
> > -	case Opt_noikeep:
> > -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> > +		if (result.negated)
> > +			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> > +		else
> > +			mp->m_flags |= XFS_MOUNT_IKEEP;
> >  		break;
> >  	case Opt_largeio:
> > -		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> > -		break;
> > -	case Opt_nolargeio:
> > -		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> > +		if (result.negated)
> > +			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> > +		else
> > +			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> >  		break;
> >  	case Opt_attr2:
> > -		mp->m_flags |= XFS_MOUNT_ATTR2;
> > -		break;
> > -	case Opt_noattr2:
> > -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> > -		mp->m_flags |= XFS_MOUNT_NOATTR2;
> > +		if (!result.negated) {
> > +			mp->m_flags |= XFS_MOUNT_ATTR2;
> > +		} else {
> > +			mp->m_flags &= ~XFS_MOUNT_ATTR2;
> > +			mp->m_flags |= XFS_MOUNT_NOATTR2;
> > +		}
> 
> Eric's comments aside, it would be nice to have some consistency
> between
> the various result.negated checks (i.e. 'if (negated)' vs 'if
> (!negated)').

Right, that's my "the smallest block must always be first 'ism"
cutting in there. I always feel that a larger block before a
smaller block makes the later (partially) invisible in reading
the code. But the fact is that seeing this annoys me so I always
see the hanging code so what I'm saying is kind-off nonsence!

I'll try and overcome my 'ism and make this consistent, ;)

> 
> >  		break;
> >  	case Opt_filestreams:
> >  		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> >  		break;
> > -	case Opt_noquota:
> > -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> > -		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> > -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> > -		break;
> >  	case Opt_quota:
> > +		if (!result.negated) {
> > +			mp->m_qflags |= (XFS_UQUOTA_ACCT |
> > XFS_UQUOTA_ACTIVE |
> > +					 XFS_UQUOTA_ENFD);
> > +		} else {
> > +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> > +			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> > +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> > +		}
> > +		break;
> >  	case Opt_uquota:
> >  	case Opt_usrquota:
> >  		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> ...
> > @@ -367,10 +368,10 @@ xfs_parseargs(
> >  {
> >  	const struct super_block *sb = mp->m_super;
> >  	char			*p;
> > -	substring_t		args[MAX_OPT_ARGS];
> > -	int			dsunit = 0;
> > -	int			dswidth = 0;
> > -	uint8_t			iosizelog = 0;
> > +
> > +	struct fs_context	fc;
> > +	struct xfs_fs_context	context;
> > +	struct xfs_fs_context	*ctx = &context;
> 
> I don't really see the point for having a separate pointer variable
> based on the code so far. Why not just do:
> 
> 	struct xfs_fs_context	ctx = {0,};
> 
> ... and pass by reference where necessary?

Yep, it was a stupid mistake to begin with.
I'm using only the context variable now.

> 
> >  
> >  	/*
> >  	 * set up the mount name first so all the errors will refer to
> > the
> > @@ -406,17 +407,41 @@ xfs_parseargs(
> >  	if (!options)
> >  		goto done;
> >  
> > +	memset(&fc, 0, sizeof(fc));
> > +	memset(&ctx, 0, sizeof(ctx));
> > +	fc.fs_private = ctx;
> > +	fc.s_fs_info = mp;
> > +
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
> > +		param.size = 0;
> > +
> > +		value = strchr(p, '=');
> > +		if (value) {
> > +			if (value == p)
> > +				continue;
> 
> What's the purpose of the above check? Why do we skip the param as
> opposed to return an error or something?

Well, that's a good question, there's a thought in the back
of my mind that if the char isn't found the whole string
is returned but that's not the way strchr(3) works so I was
thinking of something different.

Maybe I'm not the only one to think this way because it looks
like the VFS code does the same thing (and that's where this
came from altough I think it was slightly different when I
did that).

But I'm probably miss-reading the VFS code ...
I'll need to look closer at it.

> 
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
> ...
> > @@ -1914,6 +1939,10 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static const struct fs_context_operations xfs_context_ops = {
> > +	.parse_param = xfs_parse_param,
> > +};
> > +
> 
> It's probably better to introduce this in the first patch where it's
> used.

Either or, I thought that building up the operations structure
as we go gave insight into the context of where the change is
headed.

But if doing this irritates your sensibilities I can change
it as long as no-one else has strong preferences against it.
 
> 
> Brian
> 
> >  static struct file_system_type xfs_fs_type = {
> >  	.owner			= THIS_MODULE,
> >  	.name			= "xfs",
> > 

