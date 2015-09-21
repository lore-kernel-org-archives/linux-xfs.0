Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDE0E7F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 17:18:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC4688F8040
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 15:18:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kzGYied6f1869cEQ for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 15:18:41 -0700 (PDT)
Date: Tue, 22 Sep 2015 08:18:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: add [-U uuid] option
Message-ID: <20150921221839.GC19114@dastard>
References: <1442855060-38259-1-git-send-email-mel@ohmu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442855060-38259-1-git-send-email-mel@ohmu.fi>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mika Eloranta <mel@ohmu.fi>
Cc: xfs@oss.sgi.com

On Mon, Sep 21, 2015 at 08:04:20PM +0300, Mika Eloranta wrote:
> The UUID can now be optionally specified during filesystem
> creation.

Which UUID are you wanting to set - the metadata uuid or the user
visible UUID label? Or both? Can you explain the use case for this?
i.e. I'm trying to work out why Why doesn't mkfs.xfs +
xfs_admin -U <uuid> doesn't work for you?

We need some explaination in the commit message so that when we look
at this in a couple of years time we know why we added this to
mkfs...

> @@ -948,6 +948,7 @@ main(
>  	bool			finobtflag;
>  	int			spinodes;
>  
> +	platform_uuid_clear(&uuid);
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
>  	bindtextdomain(PACKAGE, LOCALEDIR);
> @@ -990,7 +991,7 @@ main(
>  	xi.isdirect = LIBXFS_DIRECT;
>  	xi.isreadonly = LIBXFS_EXCLUSIVELY;
>  
> -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:d:i:l:L:U:m:n:KNp:qr:s:CfV")) != EOF) {
>  		switch (c) {
>  		case 'C':
>  		case 'f':
> @@ -1465,6 +1466,10 @@ main(
>  				illegal(optarg, "L");
>  			label = optarg;
>  			break;
> +		case 'U':
> +			if (platform_uuid_parse(optarg, &uuid))
> +				illegal(optarg, "U");
> +			break;

I'd prefer not to introduce new top level options if possible - this
seems to fit under the -m (global metadata options) option subgroup
(i.e. -m uuid=<UUID>).

>  		case 'm':
>  			p = optarg;
>  			while (*p != '\0') {
> @@ -2550,7 +2555,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	sbp->sb_dblocks = dblocks;
>  	sbp->sb_rblocks = rtblocks;
>  	sbp->sb_rextents = rtextents;
> -	platform_uuid_generate(&uuid);
> +	if (platform_uuid_is_null(&uuid)) {
> +	    platform_uuid_generate(&uuid);
> +	}

Just generate the uuid initially and then it gets overwritten by the
CLI option if it is set. No need for null detection and generation
here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
