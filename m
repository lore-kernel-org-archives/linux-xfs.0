Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PDhptt234929 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:43:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3937A197B1FB
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:45:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id W7mGSmZsTl9khei2 for
	<xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:45:08 -0700 (PDT)
Date: Mon, 25 Oct 2010 09:45:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Implementing checksums in XFS
Message-ID: <20101025134507.GB4235@infradead.org>
References: <4CC14C1B.5060409@ics.forth.gr>
	<20101022124928.GA16437@infradead.org> <201010222255.40861@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010222255.40861@zmi.at>
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

On Fri, Oct 22, 2010 at 10:55:40PM +0200, Michael Monnerie wrote:
> Oh that would be very welcome. A "secure" filesystem sounds really good, 
> especially if it's fast as XFS is :-)
> I'd implement it everywhere immediately as soon as it's available. Will 
> existing XFS's be upgradeable in some way other that backup/restore?

checksumming inodes and btree nodes means larger data structures for
those, so no there's no upgrade path available.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
