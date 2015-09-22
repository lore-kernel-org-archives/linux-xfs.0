Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF4427F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 17:34:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB7EF8F8033
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 15:34:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	r0rXveA6Qy6Ird0Z for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 15:34:40 -0700 (PDT)
Date: Wed, 23 Sep 2015 08:34:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: option for using a pre-defined filesystem UUID
Message-ID: <20150922223402.GN19114@dastard>
References: <1442924691-42001-1-git-send-email-mel@ohmu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442924691-42001-1-git-send-email-mel@ohmu.fi>
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

On Tue, Sep 22, 2015 at 03:24:51PM +0300, Mika Eloranta wrote:
> Usage: mkfs.xfs -m uuid=<uuid> <device>
> 
> The filesystem UUID can now be optionally specified during filesystem
> creation. The default behavior is still to generate a random UUID.
> 
> Allows using pre-generated UUIDs for identifying a filesystem based
> on the metadata stored inside the filesystem. Filesystem labels can
> be used for the same purpose, but are limited by their length
> (12 chars in the case of xfs) whereas the UUID field can store an
> entire 128bit UUID, which is plenty for e.g. random ID collision
> avoidance.
> 
> Random UUID generated during the creation of the filesystem is not
> always feasible when an external DB or other system is used to track
> the created filesystem, e.g. in automated VM provisioning systems,
> as this would require a feedback mechanism which is not always
> available. In these cases the best approach often is to generate
> a random UUID for the filesystem before the filesystem even exists,
> store it in the tracking DB and later create the filesystem directly
> with the correct UUID (instead of "mkfs.xfs + xfs_admin -U <new_uuid>").

Much nicer! Just needs a signed-off-by tag now...

> @@ -948,6 +950,7 @@ main(
>  	bool			finobtflag;
>  	int			spinodes;
>  
> +	platform_uuid_clear(&uuid);
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
>  	bindtextdomain(PACKAGE, LOCALEDIR);

You can just call platform_uuid_generate(&uuid) here.

> @@ -1488,6 +1491,12 @@ main(
>  					finobt = c;
>  					finobtflag = true;
>  					break;
> +				case M_UUID:
> +					if (!value || *value == '\0')
> +						reqval('m', mopts, M_UUID);
> +					if (platform_uuid_parse(value, &uuid))
> +						illegal(optarg, "m uuid");
> +					break;

This will overwrite the pre-generated uuid if it is specified.

>  				default:
>  					unknown('m', value);
>  				}
> @@ -2550,7 +2559,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	sbp->sb_dblocks = dblocks;
>  	sbp->sb_rblocks = rtblocks;
>  	sbp->sb_rextents = rtextents;
> -	platform_uuid_generate(&uuid);
> +	if (platform_uuid_is_null(&uuid)) {
> +	    platform_uuid_generate(&uuid);
> +	}

And this code can go away completely as we are guaranteed to have a
valid uuid by this point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
