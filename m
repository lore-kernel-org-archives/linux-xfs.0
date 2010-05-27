Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RBjFlK130603 for <xfs@oss.sgi.com>; Thu, 27 May 2010 06:45:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99F7F157B50C
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 04:49:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GOPxVlydcJ3PiNtz for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 04:49:29 -0700 (PDT)
Date: Thu, 27 May 2010 07:47:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: NOW: o_direct   --  WAS: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100527114736.GA13112@infradead.org>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<4BF9FCA8.8090906@hardwarefreak.com>
	<20100524143428.6f3a117c@abend.internal.xtremedata.com>
	<20100526070620.GT2150@dastard>
	<4BFD3926.6040208@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BFD3926.6040208@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

O_DIRECT is not a Posix standard and not very portable.  It originated
on IRIX, and Linux inherited it during the 2.4 kernel series days.
These days FreeBSD/NetBSD and AIX support it as well, but for example
Solaris, HP-UX and OpenBSD don't, nevermind Windows or Mac OS.

I have no idea why the MTAs don't want to use it - it's generally easier
to use then memory mapped I/O, and has much more deterministic
performance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
