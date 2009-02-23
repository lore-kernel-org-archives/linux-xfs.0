Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NDVdes094359 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 07:31:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 844A71BC1094
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 05:31:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rMDHSjAvw5rShuNZ for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 05:31:09 -0800 (PST)
Date: Mon, 23 Feb 2009 08:31:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix tolower issue in xfsprogs
Message-ID: <20090223133109.GB15948@infradead.org>
References: <200902221355.44626.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902221355.44626.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 22, 2009 at 01:55:40PM -0500, Mike Frysinger wrote:
> the xfsprogs uses tolower() in xfs_dir2.c but doesnt include ctype.h for the 
> definition

In 3.0.0 and current git <ctype.h> is include in platform_defs.h, so it
should also be around in xfs_dir2.c.

What xfsprogs tree and what glibc/gcc combination do you see this with?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
