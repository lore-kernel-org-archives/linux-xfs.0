Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3F5wgUW046014 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:58:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0D4D1B7393C
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 23:02:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1g50yYhXU2H6KMEm for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2011 23:02:05 -0700 (PDT)
Date: Fri, 15 Apr 2011 02:02:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs stack overrun, unable to handle kernel paging request
Message-ID: <20110415060202.GA32250@infradead.org>
References: <201104150631.38169@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201104150631.38169@zmi.at>
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

On Fri, Apr 15, 2011 at 06:31:29AM +0200, Michael Monnerie wrote:
> Not sure if I didn't already post a similar crash once. This ist kernel
> 2.6.31.14-0.6-xen from openSUSE 11.2

That's still without the commits I pointed out to avoid direct reclaim
hitting the filesystem, right?  Unfortunately the stack trace is
truncate so it's not possible to spot where it originated, but I suspect
it's the cause for this one as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
