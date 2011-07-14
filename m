Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EEwEjG142240 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 09:58:15 -0500
Date: Thu, 14 Jul 2011 10:58:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Fix the ltp Makefile to allow for installation of
	all non-c (scripts) files
Message-ID: <20110714145809.GB23587@infradead.org>
References: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
	<20110713121320.GA28126@infradead.org>
	<1310581564.1998.38.camel@doink>
	<20110714034336.GA30541@infradead.org>
	<20110714040326.GB31294@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714040326.GB31294@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, alal@google.com, Alex Elder <aelder@sgi.com>

On Thu, Jul 14, 2011 at 02:03:26PM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2011 at 11:43:36PM -0400, Christoph Hellwig wrote:
> > I'm fine with enabling 080 by default, it passes for me.
> 
> It needs /bin/sh -> /bin/bash conversion first - the current version
> fails miserably without that on all my test systems....

Does the simple s/sh/bash/ fix it for you?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
