Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20D9D7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 19:23:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88FACAC005
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:23:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	P3puvC4QRg2DZNLV for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 17:23:46 -0700 (PDT)
Date: Fri, 8 Apr 2016 10:09:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
Message-ID: <20160408000910.GB21804@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458818136-56043-18-git-send-email-jtulak@redhat.com>
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
To: jtulak@redhat.com
Cc: xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 12:15:34PM +0100, jtulak@redhat.com wrote:
> From: Jan Tulak <jtulak@redhat.com>
> 
> Unify mkfs.xfs behaviour a bit and never truncate files. If the user
> is trying to mkfs an existing file, we don't want to destroy anything
> he did with the file before (sparse file, allocations...)

Why not? We do that with discard-by-default to block devices,
O_TRUNC is exactly the same situation with a file - we completely
re-initialise the file from a known state if mkfs has been asked to
create the file.


> @@ -1059,9 +1063,9 @@ check_device_type(
>  	}
>  
>  	/*
> -	 * We only want to completely truncate and recreate an existing file if
> -	 * we were specifically told it was a file. Set the create flag only in
> -	 * this case to trigger that behaviour.
> +	 * We only want to create a file only if we were specifically told
> +	 * we want a file. Set the create flag only in this case to trigger
> +	 * that behaviour.
>  	 */
>  	if (S_ISREG(statbuf.st_mode)) {
>  		if (!*isfile)

i.e. this situation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
