Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ENMFer006129 for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 18:22:15 -0500
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	Y61I5Uxsz8rFy54y for <xfs@OSS.SGI.com>;
	Wed, 14 Mar 2012 16:22:13 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB6474058C589E for xfs@OSS.SGI.com; Wed, 14 Mar 2012 23:22:11 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S7xW7-00035y-Nj
	for <xfs@OSS.SGI.com>; Wed, 14 Mar 2012 23:22:03 +0000
MIME-Version: 1.0
Message-ID: <20321.10266.203843.396041@tree.ty.sabi.co.UK>
Date: Wed, 14 Mar 2012 23:22:02 +0000
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <33498437.post@talk.nabble.com>
References: <33498437.post@talk.nabble.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> I have a 30TB XFS filesystem created on CentOS 5.4 X86_64,
> kernel 2.6.39, using xfsprogs 2.9.4. [ ... ] The filesystem
> contains a MongoDB installation consisting of roughly 13000
> 2GB files which are already allocated. [ ... ]

BTW, while 30TB is probably still in the real of the plausible
if excessively large, and this is a 64b system, this is a good
example of a gratuitously large filetree and an excessively wide
RAID set under it.

  http://www.sabi.co.uk/blog/0805may.html#080516

A large single filetree only makes sense if one need a large and
unified free space pool... But in this application all files are
essentially independent and preallocated.

A more manageable setup might have been a set of 4-8TB
filetrees, for example on a group of 3TBx 2+1 or even 4+1 (split
in two partitions) RAID5 sets.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
