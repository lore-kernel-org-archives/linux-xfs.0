Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26BD87F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:30:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03D8D304053
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 13:30:49 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PCQ7kJyKkF3vc8tp for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 13:30:47 -0800 (PST)
Date: Wed, 4 Mar 2015 08:30:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't release NULL pip in xfs_filestream_lookup_ag()
Message-ID: <20150303213035.GO18360@dastard>
References: <54F61641.1010708@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F61641.1010708@redhat.com>
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
Cc: Adrien Nader <adrien@notk.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 03, 2015 at 02:14:57PM -0600, Eric Sandeen wrote:
> If xfs_filestream_get_parent() fails, we have a null pip,
> goto out, and attempt to IRELE(NULL).  This causes a null
> pointer dereference and BUG().
> 
> Fix this by testing for pip before trying to release it.
> 
> Reported-by: Adrien Nader <adrien@notk.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index a2e86e8..fb09a63 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -348,7 +348,8 @@ xfs_filestream_lookup_ag(
>  	if (xfs_filestream_pick_ag(pip, startag, &ag, 0, 0))
>  		ag = NULLAGNUMBER;
>  out:
> -	IRELE(pip);
> +	if (pip)
> +		IRELE(pip);
>  	return ag;
>  }
>  

I'd just convert the error case when get_parent fails to:

	if (!pip)
		return NULLAGNUMBER;

rather than using the goto and adding conditional cleanup for this
case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
