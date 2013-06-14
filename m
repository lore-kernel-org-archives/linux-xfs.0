Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C47F47CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 21:18:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E5BAAC003
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:17:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DGKg3Ts4vrJFOPmR for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 19:17:55 -0700 (PDT)
Date: Fri, 14 Jun 2013 12:17:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: Correct spelling error in xfs_db for CRC
Message-ID: <20130614021754.GS29338@dastard>
References: <51BA1CD2.5070306@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BA1CD2.5070306@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 03:26:10PM -0400, Michael L. Semon wrote:
> Hi!  This is a simple spelling fix made for the xfsprogs crc-dev 
> branch, in case it hasn't been fixed already.
> 
> Thanks!
> 
> Michael
> 
> From 68dad8f59987198abe34c9ae5ea48ac6af532819 Mon Sep 17 00:00:00 2001
> From: "Michael L. Semon" <mlsemon35@gmail.com>
> Date: Wed, 12 Jun 2013 17:27:44 -0400
> Subject: [PATCH] xfsprogs: Correct spelling error in xfs_db for CRC
>  filesystems
> 
> Change "thi version" to "this version".
> 
> Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
> ---
>  db/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/init.c b/db/init.c
> index 2932e51..77be286 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -141,7 +141,7 @@ init(
>  	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5 &&
>  	    !(x.isreadonly & LIBXFS_ISREADONLY)) {
>  		fprintf(stderr, 
> -	_("%s: modifications to %s are not supported in thi version.\n"
> +	_("%s: modifications to %s are not supported in this version.\n"
>  	"Use \"-r\" to run %s in read-only mode on this filesystem .\n"),
>  			progname, fsdevice, progname);
>  		if (!force)

Good catch. Added to my series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
