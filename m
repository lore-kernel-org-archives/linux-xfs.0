Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5NALqj0019189 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 05:21:54 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA78214AE670
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 03:28:47 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id KINHPGOSIWM65yr0 for
	<xfs@oss.sgi.com>; Wed, 23 Jun 2010 03:28:47 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS peculiar behavior
References: <4C21B9AF.9010307@ics.forth.gr>
Date: Wed, 23 Jun 2010 12:24:27 +0200
In-Reply-To: <4C21B9AF.9010307@ics.forth.gr> (Yannis Klonatos's message of
	"Wed, 23 Jun 2010 10:37:19 +0300")
Message-ID: <87bpb2avxg.fsf@basil.nowhere.org>
MIME-Version: 1.0
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

Yannis Klonatos <klonatos@ics.forth.gr> writes:

>         The problem is that i have noticed that XFS may - not all

Why is that a problem?

> times - split a table over a large disk distance. For
> example in one run i have noticed that a file of 13GByte is split over
> a 4,7TByte distance (I calculate this distance
> by subtracting the final block used for the file with the first
> one. The two disk blocks values are acquired using the
> FIBMAP ioctl).

I don't know if it's the only reason, but XFS does a lot of data
structure locking and updates per allocation group, so spreading
to multiple AGs gives better scalability to many CPUs.

Also I suppose it's good to avoid hot spots on the underlying 
device.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
