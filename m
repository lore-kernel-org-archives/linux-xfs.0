Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GA27iV083231 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:02:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18B3419C544
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:01:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9MxphkuGDuNq32lR for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:01:46 -0700 (PDT)
Date: Mon, 16 Mar 2009 06:01:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] [XFS] introduce a AG inode tree walker
Message-ID: <20090316100116.GA16218@infradead.org>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
	<20090316075338.GA19858@infradead.org>
	<20090316094019.GD26138@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316094019.GD26138@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Mar 16, 2009 at 08:40:19PM +1100, Dave Chinner wrote:
> If you drop the last patch (the iterator patch) does it work
> ok?

No.  With patches 1-5 applied we deadlock early on because pag_ici_lock
never gets released in xfs_sync_inodes_ag for the normal non-error case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
