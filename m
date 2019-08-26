Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F383CC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD63921872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfHZTTu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 15:19:50 -0400
Received: from sandeen.net ([63.231.237.45]:38342 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfHZTTt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Aug 2019 15:19:49 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BEECB4CDD33;
        Mon, 26 Aug 2019 14:19:47 -0500 (CDT)
Subject: Re: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
To:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652198391.2607.14772471190581142304.stgit@fedora-28>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4fcd7f09-88d9-35c7-d6f3-2c6407260fee@sandeen.net>
Date:   Mon, 26 Aug 2019 14:19:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156652198391.2607.14772471190581142304.stgit@fedora-28>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/22/19 7:59 PM, Ian Kent wrote:
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
>  fs/xfs/xfs_super.c |  187 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 108 insertions(+), 79 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3ae29938dd89..754d2ccfd960 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -184,64 +184,62 @@ suffix_kstrtoint(const char *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> -STATIC int
> -match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> -{
> -	const char	*value;
> -	int ret;
> -
> -	value = match_strdup(s);
> -	if (!value)
> -		return -ENOMEM;
> -	ret = suffix_kstrtoint(value, base, res);
> -	kfree(value);
> -	return ret;
> -}
> +struct xfs_fs_context {
> +	int	dsunit;
> +	int	dswidth;
> +	uint8_t	iosizelog;
> +};
>  
>  STATIC int
>  xfs_parse_param(
> -	int 			token,
> -	char			*p,
> -	substring_t		*args,
> -	struct xfs_mount	*mp,
> -	int			*dsunit,
> -	int			*dswidth,
> -	uint8_t			*iosizelog)
> +	struct fs_context	*fc,
> +	struct fs_parameter	*param)
>  {
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = fc->s_fs_info;
> +	struct fs_parse_result	result;
>  	int			iosize = 0;
> +	int			opt;
>  
> -	switch (token) {
> +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> +	if (opt < 0)
> +		return opt;
> +
> +	switch (opt) {
>  	case Opt_logbufs:
> -		if (match_int(args, &mp->m_logbufs))
> -			return -EINVAL;
> +		mp->m_logbufs = result.uint_32;
>  		break;

I'm not all that excited about how xfs_fs_parameters defines Opt_logbufs
as a u32 result, but we still have to hard-code the grabbing of the u32
result after fs_parse().  I know that's a core API thing but I wonder if
there's any way to connect it more strongly so they don't have to stay in
sync.

Perhaps a new function,

   mp->m_logbufs = fs_parse_result(&xfs_fs_parameters, &result);

and let fs_parse_result() pick the right part of the union?

Would be an api enhancement not for this patch I guess.

>  	case Opt_logbsize:
> -		if (match_kstrtoint(args, 10, &mp->m_logbsize))
> +		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
>  			return -EINVAL;
>  		break;
>  	case Opt_logdev:
>  		kfree(mp->m_logname);
> -		mp->m_logname = match_strdup(args);
> +		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
>  		if (!mp->m_logname)
>  			return -ENOMEM;
>  		break;
>  	case Opt_rtdev:
>  		kfree(mp->m_rtname);
> -		mp->m_rtname = match_strdup(args);
> +		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
>  		if (!mp->m_rtname)
>  			return -ENOMEM;
>  		break;
>  	case Opt_allocsize:
>  	case Opt_biosize:
> -		if (match_kstrtoint(args, 10, &iosize))
> +		if (suffix_kstrtoint(param->string, 10, &iosize))
>  			return -EINVAL;
> -		*iosizelog = ffs(iosize) - 1;
> +		ctx->iosizelog = ffs(iosize) - 1;
>  		break;
>  	case Opt_grpid:
> +		if (result.negated)
> +			mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		else
> +			mp->m_flags |= XFS_MOUNT_GRPID;
> +		break;

Is there any real advantage to this "fsparam_flag_no" / negated stuff?
I don't see any other filesystem using it (yet) and I'm not totally convinced
that this is any better, more readable, or more efficient than just keeping
the "Opt_nogrpid" stuff around.  Not a dealbreaker but just thinking out
loud... seems like this interface was a solution in search of a problem?

>  	case Opt_bsdgroups:
>  		mp->m_flags |= XFS_MOUNT_GRPID;
>  		break;
> -	case Opt_nogrpid:
>  	case Opt_sysvgroups:
>  		mp->m_flags &= ~XFS_MOUNT_GRPID;
>  		break;
> @@ -258,12 +256,10 @@ xfs_parse_param(
>  		mp->m_flags |= XFS_MOUNT_SWALLOC;
>  		break;
>  	case Opt_sunit:
> -		if (match_int(args, dsunit))
> -			return -EINVAL;
> +		ctx->dsunit = result.uint_32;
>  		break;
>  	case Opt_swidth:
> -		if (match_int(args, dswidth))
> -			return -EINVAL;
> +		ctx->dswidth = result.uint_32;
>  		break;
>  	case Opt_inode32:
>  		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
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
>  		break
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
> @@ -331,10 +332,10 @@ xfs_parse_param(
>  		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
>  		break;
>  	case Opt_discard:
> -		mp->m_flags |= XFS_MOUNT_DISCARD;
> -		break;
> -	case Opt_nodiscard:
> -		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		if (result.negated)
> +			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		else
> +			mp->m_flags |= XFS_MOUNT_DISCARD;
>  		break;
>  #ifdef CONFIG_FS_DAX
>  	case Opt_dax:
> @@ -342,7 +343,7 @@ xfs_parse_param(
>  		break;
>  #endif
>  	default:
> -		xfs_warn(mp, "unknown mount option [%s].", p);
> +		xfs_warn(mp, "unknown mount option [%s].", param->key);

Hm, we don't ever seem to get here:

# mount -o fweeeep /dev/pmem0p1 /mnt/test
mount: mount /dev/pmem0p1 on /mnt/test failed: Unknown error 519
# 

and nothing in dmesg.

we never get a default because fs_parse() returns an error and
we never drop into the case statement at all.

(again maybe this all goes away by the last patch...)

<and now after testing this, the kernel paniced.... :( >

>  		return -EINVAL;
>  	}
>  
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
>  
>  	/*
>  	 * set up the mount name first so all the errors will refer to the
> @@ -406,17 +407,41 @@ xfs_parseargs(
>  	if (!options)
>  		goto done;
>  
> +	memset(&fc, 0, sizeof(fc));
> +	memset(&ctx, 0, sizeof(ctx));

I think you mean:

+	memset(ctx, 0, sizeof(*ctx));

or maybe better, just:

+ memset(&context, 0, sizeof(context));

here? Otherwise you're essentially just doing ctx = NULL (thanks djwong
for looking over my shoulder there) which then means fs_private is NULL,
and ...

Well, I was going to demonstrate that it probably oopses with certain mount
options, but actually I couldn't boot with patches applied up to this point:

[   18.491901] SGI XFS with ACLs, security attributes, realtime, scrub, repair, debug enabled
[   18.502444] XFS (dm-0): invalid log iosize: 184 [not 12-30]

Fixing up the problem above (which I thought would lead to a null ptr deref
but did not ...) I still fail to boot with:

[   18.191504] XFS (dm-0): alignment check failed: sunit/swidth vs. blocksize(4096)

This is because if you goto done on no options you do it before you've
initialized the context structure, so it grabs uninitialized values for all
the context fields.  Probably best to move the structure init right to the top
for clarity.

I think this all goes away by the last patch but we still want to make it
bisectable...

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
> @@ -429,7 +454,7 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
> +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx->dswidth)) {

it'd be nice to reflow this to 80 cols or less
(maybe just drop the last space, or break the line at the &&)

>  		xfs_warn(mp,
>  	"sunit and swidth options incompatible with the noalign option");
>  		return -EINVAL;
> @@ -442,28 +467,28 @@ xfs_parseargs(
>  	}
>  #endif
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
> +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
>  		xfs_warn(mp, "sunit and swidth must be specified together");
>  		return -EINVAL;
>  	}
>  
> -	if (dsunit && (dswidth % dsunit != 0)) {
> +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
>  		xfs_warn(mp,
>  	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> -			dswidth, dsunit);
> +			ctx->dswidth, ctx->dsunit);
>  		return -EINVAL;
>  	}
>  
>  done:
> -	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
>  		/*
>  		 * At this point the superblock has not been read
>  		 * in, therefore we do not know the block size.
>  		 * Before the mount call ends we will convert
>  		 * these to FSBs.
>  		 */
> -		mp->m_dalign = dsunit;
> -		mp->m_swidth = dswidth;
> +		mp->m_dalign = ctx->dsunit;
> +		mp->m_swidth = ctx->dswidth;
>  	}
>  
>  	if (mp->m_logbufs != -1 &&
> @@ -485,18 +510,18 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  
> -	if (iosizelog) {
> -		if (iosizelog > XFS_MAX_IO_LOG ||
> -		    iosizelog < XFS_MIN_IO_LOG) {
> +	if (ctx->iosizelog) {
> +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
>  			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> -				iosizelog, XFS_MIN_IO_LOG,
> +				ctx->iosizelog, XFS_MIN_IO_LOG,
>  				XFS_MAX_IO_LOG);
>  			return -EINVAL;
>  		}
>  
>  		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> -		mp->m_readio_log = iosizelog;
> -		mp->m_writeio_log = iosizelog;
> +		mp->m_readio_log = ctx->iosizelog;
> +		mp->m_writeio_log = ctx->iosizelog;
>  	}
>  
>  	return 0;
> @@ -1914,6 +1939,10 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static const struct fs_context_operations xfs_context_ops = {
> +	.parse_param = xfs_parse_param,
> +};

This seems weird in this patch, it's not used until
"xfs: mount-api - switch to new mount-api" so might want to move it there?


ok after testing a little I paniced the box, gonna go off and see what that's
all about now.

-Eric

> +
>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> 
