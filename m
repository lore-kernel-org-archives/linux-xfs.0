Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53NUUbh202044 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 18:30:30 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8135610522FC
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 16:37:23 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id sTwwYQuDIEezvBzM for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 16:37:23 -0700 (PDT)
Date: Wed, 3 Jun 2009 19:30:47 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 8/7] xfs: remove SYNC_IOWAIT
Message-ID: <20090603233047.GD9167@josefsipek.net>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090528121915.GA30037@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090528121915.GA30037@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, May 28, 2009 at 08:19:16AM -0400, Christoph Hellwig wrote:
> We want to wait for all I/O to finish when we do data integrity syncs.  So
> there is no reason to keep SYNC_WAIT separate from SYNC_IOWAIT.  This
> causes a little change in behaviour for the ENOSPC flushing code which no
                                                                         ^^

Typo, otherwise good.

Jeff.

-- 
My public GPG key can be found at
http://www.josefsipek.net/gpg/public-0xC7958FFE.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
