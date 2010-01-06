Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06HZdtR098993 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 11:35:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D8BE146C2F
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 09:36:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LOCfJSbhC8hAOG1i for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 09:36:31 -0800 (PST)
Date: Wed, 6 Jan 2010 12:36:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lockdep: inconsistent lock state
Message-ID: <20100106173628.GA14148@infradead.org>
References: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
	<20091227212700.GA7613@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091227212700.GA7613@discord.disaster>
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
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Dec 28, 2009 at 08:27:00AM +1100, Dave Chinner wrote:
> This is the usual false positive that is detected - XFS takes locks in
> reclaim that it also takes in non-reclaim paths. The reclaim path
> from kswapd inverts lock ordering and so we get this report. This
> case has never been a deadlock case because an inode in reclaim
> cannot be referenced by any other path, so once again it is a
> false positive....

This should be gone in 2.6.33-rc as we now tell lockdep about resetting
the dependency graph for the iolock once entering the inode reclaim path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
