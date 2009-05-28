Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SA2WTe247218 for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:02:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 822C81A313EF
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 03:02:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gFFTAEjTtLv7fwTw for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 03:02:47 -0700 (PDT)
Date: Thu, 28 May 2009 06:02:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] Set default extN mount options
Message-ID: <20090528100246.GH651@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-8-git-send-email-sandeen@sandeen.net>
	<200905281111.32011@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200905281111.32011@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, May 28, 2009 at 11:11:31AM +0200, Michael Monnerie wrote:
> On Mittwoch 27 Mai 2009 Eric Sandeen wrote:
> > ext2/3/4 don't support acls & attrs w/o specific mount
> > options, so make those the default whenever we mount
> > these filesystems.
> 
> The same for reiserfs, but I don't know if that is wanted/needed.

>From a look at the point option parser it would need the same
options.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
