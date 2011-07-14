Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E43VWr113650 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:03:32 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16C051D857C9
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 21:03:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Sqepw8D7WwJDmgZH for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 21:03:30 -0700 (PDT)
Date: Thu, 14 Jul 2011 14:03:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] Fix the ltp Makefile to allow for installation of
	all non-c (scripts) files
Message-ID: <20110714040326.GB31294@dastard>
References: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
	<20110713121320.GA28126@infradead.org>
	<1310581564.1998.38.camel@doink>
	<20110714034336.GA30541@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714034336.GA30541@infradead.org>
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
Cc: alal@google.com, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 13, 2011 at 11:43:36PM -0400, Christoph Hellwig wrote:
> I'm fine with enabling 080 by default, it passes for me.

It needs /bin/sh -> /bin/bash conversion first - the current version
fails miserably without that on all my test systems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
