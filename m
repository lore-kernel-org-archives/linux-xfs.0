Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GMMj4K023584 for <xfs@OSS.SGI.com>; Thu, 16 Feb 2012 16:22:50 -0600
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	sHZKA5DFFYJHYtn4 for <xfs@OSS.SGI.com>;
	Thu, 16 Feb 2012 14:22:42 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4F3C660E00045B3C for xfs@OSS.SGI.com; Thu, 16 Feb 2012 22:22:42 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1Ry9Wt-0006Gx-4x
	for <xfs@OSS.SGI.com>; Thu, 16 Feb 2012 22:10:19 +0000
MIME-Version: 1.0
Message-ID: <20285.32459.17959.50223@tree.ty.sabi.co.UK>
Date: Thu, 16 Feb 2012 22:10:19 +0000
Subject: Re: Transactional XFS?
In-Reply-To: <20120216014338.GX14132@dastard>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
	<20120216002237.GW14132@dastard> <87k43nzj5e.fsf@flamingspork.com>
	<20120216014338.GX14132@dastard>
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

[ ... ]

> Oh, so making some set of random user changes to random user data
> have ACID properties? That's what databases are for, isn't it?  :P

I am going to use this and in particular "That's what databases
are for, isn't it?" as a quote to throw at people who try to use
filesystems as database managers, usually with very many very
small files (also known as "records" to database people), but
not only.

>> I think it'd be possible to do.. you know, if you lock a
>> number of FS and VFS devs in a room with database people for
>> a month or so we may theoritically solve nearly all the
>> problems....

The DBMS people have given up long, long ago. At least since
the article by Stonebraker mentioned here:

  http://WWW.sabi.co.UK/blog/anno05-4th.html#051012d

Anyhow Oracle has sponsored two filesystem designs, one being
OCFS2, which is pretty decent, targeted at DBMS storage and does
not have ACID as such, and one being BTRFS which is not targeted
at DBMS storage and that has snapshots for rollback of failed
transactions.

> Sure, Microsoft have been trying to make their filesystem a
> database for years. It's theoretically possible, but in
> practice they've fallen short in every attempt in the past 15
> years.

I think it would be easier to do the opposite, and there have
been indeed filesystems implemented on top of DBMSes (with the
DBMS storing their data directly on top of block devices).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
