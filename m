Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 283557F66
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 08:37:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1793F3041F0
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 06:37:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aYk3pIL2NHCUd0ox (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 06:37:21 -0700 (PDT)
Date: Tue, 7 Apr 2015 09:37:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_db: disallow sb UUID write on v5 filesystems
Message-ID: <20150407133714.GE23208@bfoster.bfoster>
References: <5522A0DB.2010309@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5522A0DB.2010309@redhat.com>
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
Cc: 782012@bugs.debian.org, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 06, 2015 at 10:06:03AM -0500, Eric Sandeen wrote:
> Do not allow xfs_db (or the xfs_admin frontend) to change the UUID
> of a V5 filesystem; this will cause UUID mismatches across the
> filesystem, and we currently have no mechanism to update them all.
> Changing only the superblock UUID makes all other metadata look
> invalid, and xfs_repair reacts by junking everything.
> 
> Addresses-Debian-Bug: 782012
> Reported-by: F. Stoyan <fstoyan@swapon.de>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/sb.c b/db/sb.c
> index 6cb665d..f31f4a2 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -363,6 +363,18 @@ uuid_f(
>  			return 0;
>  		}
>  
> +		/*
> +		* For now, changing the UUID of V5 superblock filesystems is
> +		* not supported; we do not have the infrastructure to fix all
> +		* other metadata when a new superblock UUID is generated.
> +		*/

Unaligned start of comment above. :) Otherwise looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +		    strcasecmp(argv[1], "rewrite")) {
> +			dbprintf(_("%s: only 'rewrite' supported on V5 fs\n"),
> +				progname);
> +			return 0;
> +		}
> +
>  		if (!strcasecmp(argv[1], "generate")) {
>  			platform_uuid_generate(&uu);
>  		} else if (!strcasecmp(argv[1], "nil")) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
