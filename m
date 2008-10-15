Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:28:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F2SAKL009463
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:28:11 -0700
Date: Tue, 14 Oct 2008 22:29:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: crash with latest code drop.
Message-ID: <20081015022948.GA20966@infradead.org>
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015011857.GS10716@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com

> +		 * in reclaim. Leave it for the reclaim code to flush.
>  		 */
>  		if (igrab(inode)) {
>  			read_unlock(&pag->pag_ici_lock);
>  			xfs_ilock(ip, lock_flags);
>  		} else {
> +			/* leave it to reclaim */
>  			read_unlock(&pag->pag_ici_lock);
> +			continue;
>  		}

Might be betters as

		if (!igrab(inode)) {
			/* leave it to reclaim */
			read_unlock(&pag->pag_ici_lock);
			continue;
		}

		read_unlock(&pag->pag_ici_lock);
		xfs_ilock(ip, lock_flags);

which then also shows that we could stop doing the ilock at all for
the DELWRI case, thas is after fixing the last caller doing
SYNC_ATTR|SYNC_DELWRI.  Well yeah, lots of things still to sort out in
this area.
