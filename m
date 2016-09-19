Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B89957CA4
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2016 21:16:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A8F3304032
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2016 19:16:10 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yNCC5G4Wdl3OYmL4 for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2016 19:16:08 -0700 (PDT)
Date: Mon, 19 Sep 2016 12:16:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: clarify ftype defaults in manpage
Message-ID: <20160919021604.GA340@dastard>
References: <1f98ea1d-893c-d1c0-2307-3f5a9b478238@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1f98ea1d-893c-d1c0-2307-3f5a9b478238@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, Chris Murphy <chris@cmurf.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 16, 2016 at 03:48:14PM -0500, Eric Sandeen wrote:
> When CRCs were made default, a few leftovers related to its
> prior non-default status remained in the manpage, in the ftype
> section.  Clean those up.
> 
> Reported-by: Chris Murphy <chris@cmurf.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 9578c4d..033bc36 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -636,13 +636,13 @@ do not need to look up the inode to determine the inode type.
>  
>  The
>  .I value
> -is either 0 or 1, with 1 signifiying that filetype information
> -will be stored in the directory structure. The default value is 0.
> +is either 0 or 1, with 1 signifying that filetype information
> +will be stored in the directory structure.
>  
> -When CRCs are enabled via
> -.B \-m crc=1,
> -the ftype functionality is always enabled. This feature can not be turned
> -off for such filesystem configurations.
> +When CRCs are enabled (the default), the ftype functionality is always
> +enabled, and cannot be turned off. If CRCs are disabled with
> +.B \-m crc=0,
> +the ftype functionality is disabled by default.

I think that's wrong:

$ sudo mkfs.xfs -f -m crc=0 /dev/vda
....
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
                                                         ^^^^^^^

i.e. ftype is enabled by default for all configurations these days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
