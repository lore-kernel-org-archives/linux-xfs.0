Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 15:01:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5TM1N1l025265
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 15:01:23 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCB13184E5AC
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 15:02:24 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id FS48DM1lgyjFvL0m for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 15:02:24 -0700 (PDT)
Date: Mon, 30 Jun 2008 08:02:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Introduce xfs_trans_bmap_add_attrfork.
Message-ID: <20080629220221.GK29319@disturbed>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com> <1214196150-5427-4-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214196150-5427-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 23, 2008 at 02:42:29PM +1000, Niv Sardi wrote:
> That takes a transaction and doesn't require everything to be locked
> anymore.  this uses the roll trans call.
.....
>  error2:
> +	if (tpp)
> +		tpp = &tp;

That's clearly busted.

	if (tpp)
		*tpp = tp;

>  	xfs_bmap_cancel(&flist);
>  error1:
>  	ASSERT(ismrlocked(&ip->i_lock,MR_UPDATE));
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	if (tpp)
> +		tpp = &tp;

ditto.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
