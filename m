Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA4L3ano116779 for <xfs@oss.sgi.com>; Fri, 4 Nov 2011 16:03:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DD9422247D
	for <xfs@oss.sgi.com>; Fri,  4 Nov 2011 14:03:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zAqa6iL8cYlOVkuC for <xfs@oss.sgi.com>;
	Fri, 04 Nov 2011 14:03:26 -0700 (PDT)
Date: Fri, 4 Nov 2011 17:03:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111104210324.GB14983@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
	<20111021202857.GB30100@hostway.ca>
	<20111024082219.GA19941@infradead.org>
	<20111025200748.GA25043@hostway.ca>
	<20111026112521.GA10432@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111026112521.GA10432@infradead.org>
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
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Sorry Simon,

I haven't really been able to get back to this as fast as I wanted to
do.  Can you do another run and check if the patch still helps your
issue even if you remove the xfs_log_force line?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
