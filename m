Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9REQIei173959 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 09:26:18 -0500
Received: from procyon.opentrend.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC5001C03F16
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 07:27:33 -0700 (PDT)
Received: from procyon.opentrend.net (li144-209.members.linode.com
	[109.74.197.209]) by cuda.sgi.com with ESMTP id
	lff6MKS992xsqQI5 for <xfs@oss.sgi.com>;
	Wed, 27 Oct 2010 07:27:33 -0700 (PDT)
Received: from castor.opentrend.net (unknown [192.168.120.16])
	by procyon.opentrend.net (Postfix) with ESMTP id B9D17C858
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 14:27:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by castor.opentrend.net (Postfix) with ESMTP id 2DC4A6780AF
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 10:27:32 -0400 (EDT)
Date: Wed, 27 Oct 2010 10:27:32 -0400 (EDT)
From: Robert Brockway <robert@timetraveller.org>
Subject: Re: XFS journaling position
In-Reply-To: <201010270027.26687@zmi.at>
Message-ID: <alpine.DEB.1.10.1010271011510.27409@castor.opentrend.net>
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
	<20101025161052.GC19425@sgi.com> <201010270027.26687@zmi.at>
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

On Wed, 27 Oct 2010, Michael Monnerie wrote:

> in an area where disks are slower than on the outside. And if you fill
> only half of the partition, it means your log is totally on the end of
> the disk, access-wise.

Hi Michael.  Ignoring LVM for a moment...

My understanding is that the relationship between the physical cylinders 
and the logical cylinders software see is no longer necessarily linear - 
ie, the lower number logical cylinders aren't necessarily at the outer 
edge.

This article talks about this:

http://lissot.net/partition/mapping.html

Unless you know the underlying physical cylinder layout you can't reliably 
position the journal in the middle cylinder on the physical media.

I understand the disk drive manufacters aren't necessarily forthcoming 
with the necessary information although it could be established from 
timing tests.

Cheers,

Rob

-- 
Email: robert@timetraveller.org		Linux counter ID #16440
IRC: Solver (OFTC & Freenode)
Web: http://www.practicalsysadmin.com
Contributing member of Software in the Public Interest (http://spi-inc.org/)
Open Source: The revolution that silently changed the world

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
