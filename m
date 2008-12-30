Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUBqOcB008179 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 05:52:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA9AE1796304
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 03:52:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r9hXw6AS4Lkvq4QA for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 03:52:24 -0800 (PST)
Date: Tue, 30 Dec 2008 06:52:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
Message-ID: <20081230115224.GA24210@infradead.org>
References: <49594CD9.3010402@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49594CD9.3010402@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Dec 29, 2008 at 04:19:05PM -0600, Eric Sandeen wrote:
> This is for http://oss.sgi.com/bugzilla/show_bug.cgi?id=759
> "fix parallel issue with include/ symlinks"
> 
> Doing something like "make -j2 install install-dev" would lead
> to a race of removing & creating symlinks in include/
> 
> Thanks to Mike for reporting & suggesting the fix.

Looks good and I've put in in my queue.  Any chance I could motivate
you to look over Mike's other build system changes in bugzilla?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
