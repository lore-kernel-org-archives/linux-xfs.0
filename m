Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GKY5hV140741 for <xfs@oss.sgi.com>; Sat, 16 May 2009 15:34:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DDA628ECA1
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 13:34:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XpE9bpFDodJGl2CP for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 13:34:14 -0700 (PDT)
Date: Sat, 16 May 2009 16:34:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix readline/editline for xfs_io and xfs_quota
Message-ID: <20090516203413.GB28186@infradead.org>
References: <4A0E177C.7070902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A0E177C.7070902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, May 15, 2009 at 08:31:40PM -0500, Eric Sandeen wrote:
> It looks like libxcmd wasn't ever being built with -DENABLE_READLINE
> even when it was asked for by configure --enable-readline=yes
> so xfs_io & xfs_quota didn't get the functionality.
> 
> This seems to fix it up for me (fixes editline too while we're
> at it).

I've also been wondering for quite some while why xfs_io didn't have
working readline support.

This patch makes it work for me and looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>

(btw, any reason we don't enable readline support by default if
we find the headers installed?)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
