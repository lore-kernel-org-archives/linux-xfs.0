Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 066E47F4E
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:38:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E79ED304048
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:38:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jKjbbnRn3GIcOBZL for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:38:35 -0700 (PDT)
Date: Tue, 8 Oct 2013 11:37:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix inadvertent mkfs default change for
	projid32bit
Message-ID: <20131008003713.GQ4446@dastard>
References: <5251C2F8.80009@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5251C2F8.80009@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Oct 06, 2013 at 03:07:20PM -0500, Eric Sandeen wrote:
> This commit:
> 
> f3edb66a mkfs.xfs: validate options for CRCs up front.
> 
> seems to have inadvertently switched to 32bit project IDs by default:
> 
> -       int                     projid32bit;
> +       int                     projid16bit;
> ...
> -       projid32bit = 0;
> +       projid16bit = 0;
> 
> Switch back to 16 bit project ID by default, at least until we
> intentionally make that change.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index eafbed3..ebab09d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -965,7 +965,7 @@ main(
>  	textdomain(PACKAGE);
>  
>  	attrversion = 2;
> -	projid16bit = 0;
> +	projid16bit = 1;
>  	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
>  	blocklog = blocksize = 0;
>  	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;

And so:

                /* 32 bit project quota always on */
                /* attr2 always on */
                if (projid16bit == 1) {
                        fprintf(stderr,
_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
                        usage();
                }

That will prevent mkfs from making a CRC enabled filesystem.

And, realistically, what's the problem with enabling 32 bit project
IDs by default for all new filesystems in 3.2.0? I'm of the opinion
we should just leave the code as it is because all kernels since
2.6.37 support 32 bit projid and any kernel picking up
xfsprogs-3.2.0 when it is released will have a kernel that supports
it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
