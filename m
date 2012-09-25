Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P9cw80038397 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 04:38:58 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JWtdwTiPxTYwe2z6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 02:40:15 -0700 (PDT)
Date: Tue, 25 Sep 2012 05:40:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20120925094013.GI9189@infradead.org>
References: <143becf0f8266fbc8025ec97c8f44476d8fcafc5.1348203015.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <143becf0f8266fbc8025ec97c8f44476d8fcafc5.1348203015.git.rprabhu@wnohang.net>
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
To: raghu.prabhu13@gmail.com
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

Looks good, but one thing I'd love here is to actually print a useful
error for the typical EIO case, as the "error 5 occured" message just
confuses the heck out of people.  What it means is that we got an
EIO error from the block device, and that's what we should print.

Probably worth doing in a separate patch, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
