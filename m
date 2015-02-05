Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 990D17F58
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 16:05:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 78F9B8F8059
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 14:05:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pIomQjPGpqN5uo4H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 14:05:55 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t15M5sJ3024407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 17:05:55 -0500
Date: Thu, 5 Feb 2015 17:05:50 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: fix panic_mask documentation
Message-ID: <20150205220550.GL31625@laptop.bfoster>
References: <54D0F858.5010804@redhat.com>
 <54D39E01.3000108@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54D39E01.3000108@redhat.com>
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

On Thu, Feb 05, 2015 at 10:44:49AM -0600, Eric Sandeen wrote:
> This bit of the docs didn't quite reflect reality.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: s/AND/OR/
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 5be51fd..2e56845 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -287,9 +287,9 @@ The following sysctls are available for the XFS filesystem:
>  		XFS_ERRLEVEL_LOW:       1
>  		XFS_ERRLEVEL_HIGH:      5
>  
> -  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 127)
> +  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 255)
>  	Causes certain error conditions to call BUG(). Value is a bitmask;
> -	AND together the tags which represent errors which should cause panics:
> +	OR together the tags which represent errors which should cause panics:
>  
>  		XFS_NO_PTAG                     0
>  		XFS_PTAG_IFLUSH                 0x00000001
> @@ -299,6 +299,7 @@ The following sysctls are available for the XFS filesystem:
>  		XFS_PTAG_SHUTDOWN_CORRUPT       0x00000010
>  		XFS_PTAG_SHUTDOWN_IOERROR       0x00000020
>  		XFS_PTAG_SHUTDOWN_LOGERROR      0x00000040
> +		XFS_PTAG_FSBLOCK_ZERO           0x00000080
>  
>  	This option is intended for debugging only.
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
