Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54LIAST001045 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 16:18:11 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1D7588C57D
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 14:25:07 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id iPpyBvRCtOBOrvCu for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 14:25:07 -0700 (PDT)
Message-ID: <4A283A22.8050003@sandeen.net>
Date: Thu, 04 Jun 2009 16:18:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repairing large partition
References: <dc64e7230906041213s2bb9d67fj2df0b3db4ca37704@mail.gmail.com>
In-Reply-To: <dc64e7230906041213s2bb9d67fj2df0b3db4ca37704@mail.gmail.com>
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
To: maillists0@gmail.com
Cc: xfs@oss.sgi.com

maillists0@gmail.com wrote:
> Pardon if this is the wrong list for this question.
> 
> I had a 50T xfs partition, spread across 3 storage devices which were
> lvm'd. After a power failure, 2 disks on one device failed. It was
> raid5, so that data is unrecoverable.
> 
> I replaced the failed disks and rebuilt that array. I can mount the
> partition and see data on the first 2 devices. 'I ran xfs_repair -n' to
> see what might be done a couple of days ago and it still hasn't
> finished.  Does anyone know how I could recreate the partition to
> include the third device without losing data from the first two devices?
> Any help will be greatly appreciated, including a pointer to the
> appropriate docs. Thanks.

so was it a concat of 3 raid5s?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
