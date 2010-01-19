Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0JBAxxo187443 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 05:10:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72A1E173E8F
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:11:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	D5JCkrqCKbrkTAf7 for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 03:11:57 -0800 (PST)
Date: Tue, 19 Jan 2010 22:11:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: rearrange xfs_mod_sb() to avoid array
	subscript warning
Message-ID: <20100119111155.GB14035@discord.disaster>
References: <1263861711-13900-1-git-send-email-david@fromorbit.com>
	<1263861711-13900-3-git-send-email-david@fromorbit.com>
	<20100119092320.GD1784@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100119092320.GD1784@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 19, 2010 at 04:23:20AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 19, 2010 at 11:41:51AM +1100, Dave Chinner wrote:
> > gcc warns of an array subscript out of bounds in xfs_mod_sb().
> > The code is written in such a way that if the array subscript is
> > out of bounds, then it will assert fail. Rearrange the code to
> > avoid the bounds check warning.
> 
> Does it avoid the warning also for non-debug builds where the assert
> goes away?  Anyway, the reordering is correct, so:

Yes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
