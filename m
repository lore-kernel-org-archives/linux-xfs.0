Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BNxpgB014076 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 17:59:52 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C9C77BEE2
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 15:59:50 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	ls1tXpBoavjS1d1j for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 15:59:50 -0800 (PST)
Date: Mon, 12 Jan 2009 10:03:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: fix bad_features2 fixups for the root filesystem
Message-ID: <20090111230310.GC8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221301.289471000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109221301.289471000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Fri, Jan 09, 2009 at 05:11:10PM -0500, Christoph Hellwig wrote:
> Currently the bad_features2 fixup and the alignment updates in the superblock
> are skipped if we mount a filesystem read-only.  But for the root filesystem
> the typical case is to mount read-only first and only later remount writeable
> so we'll never perform this update at all.  It's not a big problem but means
> the logs of people needing the fixup get spammed at every boot because they
> never happen on disk.
> 
> Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane.

Reviewed-by: Dave Chinner <david@fromorbit.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
