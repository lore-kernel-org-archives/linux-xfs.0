Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6FC36D232953 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:12:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CA591A31300
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 07:12:03 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	grijvJagVpyR8gEV for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 07:12:03 -0800 (PST)
Date: Tue, 6 Dec 2011 10:12:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: ln failure output has changed again
Message-ID: <20111206151202.GB11833@infradead.org>
References: <1323170219-16080-1-git-send-email-david@fromorbit.com>
	<1323170219-16080-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323170219-16080-3-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 10:16:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recent coreutils packages have changed the failure output of ln(1)
> (again!) to be more verbose, breaking the filter in test 103:

Great..

> 
> -ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
> +ln: failed to create symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
> 
> Fix it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
