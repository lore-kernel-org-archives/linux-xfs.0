Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1JATIBp126281 for <xfs@oss.sgi.com>; Fri, 19 Feb 2010 04:29:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C71F1E0FC1
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2010 02:30:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XTXwOQtufT98JqWK for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2010 02:30:38 -0800 (PST)
Date: Fri, 19 Feb 2010 05:30:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: don't delete scratch loop device w/ umount -d
Message-ID: <20100219103037.GA21674@infradead.org>
References: <4B7C51B2.9080908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B7C51B2.9080908@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Feb 17, 2010 at 02:29:38PM -0600, Eric Sandeen wrote:
> Recent fixes to 073 added umount -d, but if we happen
> to be using a scratch device on loopback, subsequent
> tests get very, very unhappy when their loopback block
> device goes away!

True, we only need -d for the loop devices created in the test.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
