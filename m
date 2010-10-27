Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9REUsqd174121 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 09:30:54 -0500
Received: from procyon.opentrend.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4FB01C03F85
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 07:32:12 -0700 (PDT)
Received: from procyon.opentrend.net (li144-209.members.linode.com
	[109.74.197.209]) by cuda.sgi.com with ESMTP id
	HcaoDaQmcoInCPYJ for <xfs@oss.sgi.com>;
	Wed, 27 Oct 2010 07:32:12 -0700 (PDT)
Received: from castor.opentrend.net (unknown [192.168.120.16])
	by procyon.opentrend.net (Postfix) with ESMTP id C7036C858
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 14:32:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by castor.opentrend.net (Postfix) with ESMTP id 6596D6780AF
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 10:32:11 -0400 (EDT)
Date: Wed, 27 Oct 2010 10:32:11 -0400 (EDT)
From: Robert Brockway <robert@timetraveller.org>
Subject: Re: XFS journaling position
In-Reply-To: <alpine.DEB.1.10.1010271011510.27409@castor.opentrend.net>
Message-ID: <alpine.DEB.1.10.1010271027511.27409@castor.opentrend.net>
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
	<20101025161052.GC19425@sgi.com> <201010270027.26687@zmi.at>
	<alpine.DEB.1.10.1010271011510.27409@castor.opentrend.net>
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

On Wed, 27 Oct 2010, Robert Brockway wrote:

> On Wed, 27 Oct 2010, Michael Monnerie wrote:
>
>> in an area where disks are slower than on the outside. And if you fill
>> only half of the partition, it means your log is totally on the end of
>> the disk, access-wise.
>
> Hi Michael.  Ignoring LVM for a moment...

*Sigh*.  I meant to go on to point out that LVM further abstracts away the 
hardware making it even harder to establish where the fastest part of the 
physical disk is.

Similarly virtual hosts have little chance of trying to establish the 
physical nature of the device holding their filesystems.

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
