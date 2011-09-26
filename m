Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8Q0pGbw093796 for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 19:51:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60E9B4CFC69
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 17:51:13 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dtE0nQEvNICv12lv for <xfs@oss.sgi.com>;
	Sun, 25 Sep 2011 17:51:13 -0700 (PDT)
Date: Sun, 25 Sep 2011 20:51:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Directory fsync
Message-ID: <20110926005107.GA12341@infradead.org>
References: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
	<20110923163354.GA24319@infradead.org> <201109240109.45532@zmi.at>
	<20110926002811.GA3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110926002811.GA3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.org>, Zhu Han <schumi.han@gmail.com>, xfs@oss.sgi.com

On Mon, Sep 26, 2011 at 10:28:11AM +1000, Dave Chinner wrote:
> All it means is that the directory fsync() is a no-op that only
> costs CPU time.

Currently it also causes a superflous cache flush, but I have a patch
in my QA queue to fix that and reduce the (already tiny) CPU overhead a
bit more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
