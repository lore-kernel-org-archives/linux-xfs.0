Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MEZY8I071816
	for <linux-xfs@oss.sgi.com>; Mon, 22 Aug 2011 09:35:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7F3A54011B
	for <linux-xfs@oss.sgi.com>; Mon, 22 Aug 2011 07:35:33 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SIf29kg2yQCWOGmF for <linux-xfs@oss.sgi.com>;
	Mon, 22 Aug 2011 07:35:33 -0700 (PDT)
Date: Mon, 22 Aug 2011 10:35:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deleting files with extended attributes is dead slow
Message-ID: <20110822143529.GA31034@infradead.org>
References: <j23qs9$1c3$1@dough.gmane.org>
	<20110812204746.GB30615@infradead.org>
	<20110816161357.GA18201@infradead.org>
	<4E4BBC98.7020501@itwm.fraunhofer.de>
	<20110817170251.GB28650@infradead.org>
	<4E4BFCB5.4010808@itwm.fraunhofer.de>
	<20110818020848.GO26978@dastard> <20110818030519.GP26978@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110818030519.GP26978@dastard>
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
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-xfs@oss.sgi.com

Btw, one interesting thing I noticed is that xfs_attr_leaf_create always
zeroes and logs whe whole attr block.  I'll need to audit this a bit
more, but from the highlevel POV I don't see why we can't simply just
logs the bits we actually added.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
