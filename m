Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6PFUfCb065930 for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 10:30:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96A9CC1FEDF
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 08:40:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zJ0Xq8y2O24GQBz9 for
	<xfs@oss.sgi.com>; Sun, 25 Jul 2010 08:40:55 -0700 (PDT)
Date: Sun, 25 Jul 2010 11:33:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4k sector drives
Message-ID: <20100725153342.GA31260@infradead.org>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<20100724084751.GA32006@infradead.org>
	<4C4B55F7.2090501@sandeen.net> <201007250035.25946@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007250035.25946@zmi.at>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sun, Jul 25, 2010 at 12:35:21AM +0200, Michael Monnerie wrote:
> Thank you Christoph for clarification, also thanks to Eric - I've been 
> aligning all partitions to a multiple of 512 sectors since a long time, 
> which fits all stripe set sizes up to 256k. Too bad that even Linux 
> fdisk and parted

Current fdisk, and with some limitations parted do the right thing
and align partitions on at least a 1MB boundary.  parted unfortunately
lowers alignment again when any kind of optimal I/O size hint is set,
but I'm still hoping for that bug to get fix in a new release.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
