Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA98Jl3065212 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 03:08:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5717A1948CCD
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 01:08:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DBc9ZNpgmqPwMqS1 for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 01:08:54 -0800 (PST)
Date: Thu, 10 Dec 2009 04:08:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_fsr: don't create ag temp subdirs with mode 0777
Message-ID: <20091210090854.GA29653@infradead.org>
References: <4B2073D1.1040809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B2073D1.1040809@sandeen.net>
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

On Wed, Dec 09, 2009 at 10:06:41PM -0600, Eric Sandeen wrote:
> This addresses Debian bug #559490 - xfsdump: fsr creates files mode 666
> 
> I think that this mode is left over from when xfs_fsr used to
> fork into the uid of the file's owner, and so needed somewhere
> it was guaranteed to be able to write.
> 
> This behavior was removed in commit d51b892411c8d33374a02e20c5888df280811549
> (in the xfsdump tree, before xfs_fsr got moved) and so these
> wide-open permissions should no longer be needed.

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
