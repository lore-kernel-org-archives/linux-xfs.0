Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2DFLfha102268 for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 09:21:42 -0600
Received: from procyon.opentrend.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 136DC23BAD1
	for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 07:23:14 -0800 (PST)
Received: from procyon.opentrend.net (li144-209.members.linode.com
	[109.74.197.209]) by cuda.sgi.com with ESMTP id
	2iz4SuBzeyGck5m1 for <xfs@oss.sgi.com>;
	Sat, 13 Mar 2010 07:23:14 -0800 (PST)
Received: from castor.opentrend.net (unknown [192.168.120.16])
	by procyon.opentrend.net (Postfix) with ESMTP id 4CC10CE69
	for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 10:23:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
	by castor.opentrend.net (Postfix) with ESMTP id 1F548401E0937
	for <xfs@oss.sgi.com>; Sat, 13 Mar 2010 10:24:02 -0500 (EST)
Date: Sat, 13 Mar 2010 10:24:02 -0500 (EST)
From: Robert Brockway <robert@timetraveller.org>
Subject: Re: XFS buffered sequential read performance low after kernel upgrade
In-Reply-To: <20100313001626.GE4732@dastard>
Message-ID: <alpine.DEB.1.10.1003131015150.11921@castor.opentrend.net>
References: <4B9A2A00.1050304@hardwarefreak.com>
	<20100313001626.GE4732@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Sat, 13 Mar 2010, Dave Chinner wrote:

> Also, the XFS partitions are on the inner edge of the disk, so they
> are always going to be slower (can be as low as half the speed) than
> partitions on the outer edge of the disk for sequential access...

Hi Dave.  Hasn't it been the case for a long time that the sectors on the 
HDD are no long necessarily numbered from the outside in?  I understood 
some HDD are numbered in the opposite direction and some are striped and 
that HDD manufacturers tend not to release this info.  Short of timing 
tests I believe there is no easy easy way to figure out the sequence 
anymore.

This has tended to nullify the old wisdom of putting the root filesystem 
at the beginning of the disk[1].

[1] Which was done in the past because it was faster.

Cheers,

Rob

-- 
Email: robert@timetraveller.org
IRC: Solver
Web: http://www.practicalsysadmin.com
Open Source: The revolution that silently changed the world

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
