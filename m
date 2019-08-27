Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F16AC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D45217F5
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfH0MlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfH0MlX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 08:41:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB34F8BA2DA;
        Tue, 27 Aug 2019 12:41:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 151F7194B2;
        Tue, 27 Aug 2019 12:41:22 +0000 (UTC)
Date:   Tue, 27 Aug 2019 08:41:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
Message-ID: <20190827124120.GD10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652198391.2607.14772471190581142304.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652198391.2607.14772471190581142304.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 27 Aug 2019 12:41:22 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:59:43AM +0800, Ian Kent wrote:
> Make xfs_parse_param() take arguments of the fs context operation
> .parse_param() in preperation for switching to use the file system
> mount context for mount.
> 
> The function fc_parse() only uses the file system context (fc here)
> when calling log macros warnf() and invalf() which in turn check
> only the fc->log field to determine if the message should be saved
> to a context buffer (for later retrival by userspace) or logged
> using printk().
> 
> Also the temporary function match_kstrtoint() is now unused, remove it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

I see Eric had some feedback on this patch already. Some additional
notes (which may overlap)...

>  fs/xfs/xfs_super.c |  187 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 108 insertions(+), 79 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3ae29938dd89..754d2ccfd960 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -275,33 +271,38 @@ xfs_parse_param(
>  		mp->m_flags |= XFS_MOUNT_NOUUID;
>  		break;
>  	case Opt_ikeep:
> -		mp->m_flags |= XFS_MOUNT_IKEEP;
> -		break;
> -	case Opt_noikeep:
> -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		if (result.negated)
> +			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		else
> +			mp->m_flags |= XFS_MOUNT_IKEEP;
>  		break;
>  	case Opt_largeio:
> -		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> -		break;
> -	case Opt_nolargeio:
> -		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +		if (result.negated)
> +			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +		else
> +			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
>  		break;
>  	case Opt_attr2:
> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> -		break;
> -	case Opt_noattr2:
> -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> -		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		if (!result.negated) {
> +			mp->m_flags |= XFS_MOUNT_ATTR2;
> +		} else {
> +			mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +			mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		}

Eric's comments aside, it would be nice to have some consistency between
the various result.negated checks (i.e. 'if (negated)' vs 'if
(!negated)').

>  		break;
>  	case Opt_filestreams:
>  		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
>  		break;
> -	case Opt_noquota:
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> -		break;
>  	case Opt_quota:
> +		if (!result.negated) {
> +			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +					 XFS_UQUOTA_ENFD);
> +		} else {
> +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		}
> +		break;
>  	case Opt_uquota:
>  	case Opt_usrquota:
>  		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
...
> @@ -367,10 +368,10 @@ xfs_parseargs(
>  {
>  	const struct super_block *sb = mp->m_super;
>  	char			*p;
> -	substring_t		args[MAX_OPT_ARGS];
> -	int			dsunit = 0;
> -	int			dswidth = 0;
> -	uint8_t			iosizelog = 0;
> +
> +	struct fs_context	fc;
> +	struct xfs_fs_context	context;
> +	struct xfs_fs_context	*ctx = &context;

I don't really see the point for having a separate pointer variable
based on the code so far. Why not just do:

	struct xfs_fs_context	ctx = {0,};

... and pass by reference where necessary?

>  
>  	/*
>  	 * set up the mount name first so all the errors will refer to the
> @@ -406,17 +407,41 @@ xfs_parseargs(
>  	if (!options)
>  		goto done;
>  
> +	memset(&fc, 0, sizeof(fc));
> +	memset(&ctx, 0, sizeof(ctx));
> +	fc.fs_private = ctx;
> +	fc.s_fs_info = mp;
> +
>  	while ((p = strsep(&options, ",")) != NULL) {
> -		int		token;
> -		int		ret;
> +		struct fs_parameter	param;
> +		char			*value;
> +		int			ret;
>  
>  		if (!*p)
>  			continue;
>  
> -		token = match_token(p, tokens, args);
> -		ret = xfs_parse_param(token, p, args, mp,
> -				      &dsunit, &dswidth, &iosizelog);
> -		if (ret)
> +		param.key = p;
> +		param.type = fs_value_is_string;
> +		param.size = 0;
> +
> +		value = strchr(p, '=');
> +		if (value) {
> +			if (value == p)
> +				continue;

What's the purpose of the above check? Why do we skip the param as
opposed to return an error or something?

> +			*value++ = 0;
> +			param.size = strlen(value);
> +			if (param.size > 0) {
> +				param.string = kmemdup_nul(value,
> +							   param.size,
> +							   GFP_KERNEL);
> +				if (!param.string)
> +					return -ENOMEM;
> +			}
> +		}
> +
> +		ret = xfs_parse_param(&fc, &param);
> +		kfree(param.string);
> +		if (ret < 0)
>  			return ret;
>  	}
>  
...
> @@ -1914,6 +1939,10 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static const struct fs_context_operations xfs_context_ops = {
> +	.parse_param = xfs_parse_param,
> +};
> +

It's probably better to introduce this in the first patch where it's used.

Brian

>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> 
