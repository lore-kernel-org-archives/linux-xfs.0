Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2U9KBOT028459
	for <linux-xfs@oss.sgi.com>; Wed, 30 Mar 2011 04:20:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B44C1167231
	for <linux-xfs@oss.sgi.com>; Wed, 30 Mar 2011 02:23:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KizbwBYlHVl5pdoX for
	<linux-xfs@oss.sgi.com>; Wed, 30 Mar 2011 02:23:22 -0700 (PDT)
Date: Wed, 30 Mar 2011 05:23:17 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110330092316.GA21819@infradead.org>
References: <20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
	<081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
	<20110329200256.GA6019@infradead.org>
	<20110329224230.GH3008@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110329224230.GH3008@dastard>
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
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Sean Noonan <Sean.Noonan@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

On Wed, Mar 30, 2011 at 09:42:30AM +1100, Dave Chinner wrote:
> > +#define MAX_VMALLOCS	6
> > +#define MAX_SLAB_SIZE	0x20000
> 
> Why those values for the magic numbers?

Ask the person who added it originall, it's just a revert to the
code before my commit to clean up our vmalloc usage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
