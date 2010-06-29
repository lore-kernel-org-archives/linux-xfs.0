Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5T7uBcG067946 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 02:56:11 -0500
Date: Tue, 29 Jun 2010 03:58:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/15] xfs: rewrite XFS_SEND_NAMESP() as a function
Message-ID: <20100629075855.GB31118@infradead.org>
References: <201006282205.o5SM5qNZ018194@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201006282205.o5SM5qNZ018194@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

A lot of arguments for the namesp even are always NULL or use
defaults.  You'll make your life a simpler by just removing them.
This also applies to some of the other dmapi callout, but it's most
extreme here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
