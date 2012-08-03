Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7343I83025513 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 23:03:19 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id O59SCDUviQWzaCyn for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 21:03:11 -0700 (PDT)
Message-ID: <501B4D7E.1000303@sandeen.net>
Date: Thu, 02 Aug 2012 23:03:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs / planned resize / performance impact
References: <5017E426.2040709@profihost.ag>
In-Reply-To: <5017E426.2040709@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/31/12 8:56 AM, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> i'm planning to create a couple of VMs with just 30GB of space while using xfs as the main filesystem.
> 
> Now i alreay know that some of the VMs will grow up to 250GB while resizing the block device and using xfs_growfs.
> 
> Should i take care of that and format these disks with special parameters?
> 
> I've discovered that a 500GB volume has agcount=4 and 64000 blocks of internal log - while a 300GB volume resized to 500GB has agcount 7 ad only 40960 blocks of internal log.
> 
> Is it a problem if this grow will happen in small portions (30GB => 50GB => 75GB => 100GB => ... 300GB)?

This incremental part doesn't matter a bit.  The first mkfs will choose the AG count & size according to defaults; further growth after this will add new (possibly partial) AGs of that pre-chosen size.

-Eric

> Thanks!
> 
> Greets,
> Stefan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
