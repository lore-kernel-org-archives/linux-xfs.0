Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5NGJ5nx031157 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 11:19:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 340FB152DC16
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 09:21:46 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ZPFkqxaLTzRAvvxN for
	<xfs@oss.sgi.com>; Wed, 23 Jun 2010 09:21:46 -0700 (PDT)
Message-ID: <4C223499.4050502@sandeen.net>
Date: Wed, 23 Jun 2010 11:21:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS peculiar behavior
References: <4C21B9AF.9010307@ics.forth.gr>
In-Reply-To: <4C21B9AF.9010307@ics.forth.gr>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: xfs@oss.sgi.com

Yannis Klonatos wrote:
> Hi all!
> 
>         I have come across the following peculiar behavior in XFS and i
> would appreciate any information anyone
> could provide.
>         In our lab we have a system that has twelve 500GByte hard disks
> (total capacity 6TByte), connected to an
> Areca (ARC-1680D-IX-12) SAS storage controller. The disks are configured
> as a RAID-0 device. Then I create
> a clean XFS filesystem on top of the raid volume, using the whole
> capacity. We use this test-setup to measure
> performance improvement for a TPC-H experiment. We copy the database
> over the clean XFS filesystem using the
> cp utility. The database used in our experiments is 56GBytes in size
> (data + indices).
>         The problem is that i have noticed that XFS may - not all times
> - split a table over a large disk distance. For
> example in one run i have noticed that a file of 13GByte is split over a
> 4,7TByte distance (I calculate this distance
> by subtracting the final block used for the file with the first one. The
> two disk blocks values are acquired using the
> FIBMAP ioctl).

xfs_bmap output would be a lot nicer.  Maybe you can paste that here to
show exactly what the layout is.

-Eric

>         Is there some reasoning behind this (peculiar) behavior? I would
> expect that since the underlying storage is so
> large, and the dataset is so small, XFS would try to minimize disk seeks
> and thus place the file sequentially in disk.
> Furthermore, I understand that there may be some blocks left unused by
> XFS between subsequent file blocks used
> in order to handle any write appends that may come afterward. But i
> wouldn't expect such a large splitting of a single
> file.
>         Any help?
> 
> Thanks in advance,
> Yannis Klonatos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
