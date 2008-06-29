Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 15:08:02 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5TM80w4026073
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 15:08:00 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67E73184E657
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 15:09:01 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id EIELMah3L0c57opM for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 15:09:01 -0700 (PDT)
Date: Mon, 30 Jun 2008 08:08:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Give a transaction to xfs_attr_set_int
Message-ID: <20080629220859.GL29319@disturbed>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com> <1214196150-5427-4-git-send-email-xaiki@sgi.com> <1214196150-5427-5-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214196150-5427-5-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com, Niv Sardi <xaiki@debian.org>

On Mon, Jun 23, 2008 at 02:42:30PM +1000, Niv Sardi wrote:
> From: Niv Sardi <xaiki@debian.org>
> 
> We introduce xfs_trans_attr_set_int that takes a transaction pointer
> as an argument (or creates one if NULL) and only finishes the
> transaction if it has created it. We use xfs_attr_rolltrans to do the
> tranS_dup dance.
> 
> xfs_attr_set_int is changed to a wrapper that will only call
> xfs_trans_attr_set_int with a NULL transaction.

As a general comment to the entire patch set, I dislike the
namespace pollution caused by changing xfs_attr_...  to
xfs_trans_attr...

The xfs_trans_... namespace is used for stuff inside xfs_trans*[ch],
not for attr code. I'd suggest making the "trans" a suffix rather
than a prefix, or something similar, so that these attr functions
are not easily confused with core transaction code....

BTW:

> @@ -356,6 +381,8 @@ xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
>  			if (!error && (flags & ATTR_KERNOTIME) == 0) {
>  				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
>  			}
> +			if (tpp)
> +				tpp = &args.trans;

That's busted too. Can you please review all the places where you
return transactio pointers to the caller via a function parameterrr
for this bug as you've made in at least a couple of places.

> +	if (tpp)
> +		tpp = &args.trans;

Here as well.

>  	return(error);
>  
>  out:
> @@ -434,10 +467,25 @@ out:
>  		xfs_trans_cancel(args.trans,
>  			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +	if (tpp)
> +		tpp = &args.trans;

And again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
