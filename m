Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89DkrVp159575 for <xfs@OSS.SGI.com>; Wed, 9 Sep 2009 08:47:14 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C78E64395FA
	for <xfs@OSS.SGI.com>; Wed,  9 Sep 2009 06:47:43 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id wAdEt4SRh1C8UZ0e
	for <xfs@OSS.SGI.com>; Wed, 09 Sep 2009 06:47:43 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1MkOqF-0002IH-Hd
	for <xfs@OSS.SGI.com>; Sun, 06 Sep 2009 21:00:07 +0000
MIME-Version: 1.0
Message-ID: <19108.8919.46775.810693@tree.ty.sabi.co.uk>
Date: Sun, 6 Sep 2009 21:00:07 +0000
Subject: Re: xfs data loss
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308D8CAB6D@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308D8CAB6D@DU-EXC-MAIL.empa.emp-eaw.ch>
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

>> The original 20 devices or did you put in 2 new blank hard
>> drives? I feel like that 2 blank drives went in, but then
>> later I read that all [original] 20 drives could be read for
>> a few MB at the beginning.

> No. No blank drives went in. And I always used the original 20
> devices.

That may be very good news (or not if some are partially
damaged).

[ ... ]

> I therefore suspect that the "broken devices" indication,
> since it is repeatedly found in the last weeks, and always for
> different devices/filesystems, has to do with the RAID
> controller, and not with a specific device failure-.

But a broken RAID host adapter can write random stuff to
some/most disks and can continue to do so. Unless the RAID host
adapter had a temporary failure. But who knows?

>> * Somehow 'xfs_repair' managed to rebuild the metadata of
>> '/dev/md5' despite a loss of 5-6% of it, so it looks
>> "consistent" as far as XFS is concerned, but up to 5-6% of
>> each file is essentially random, and it is very difficult to
>> know where the random part are.

> I don't see any element to support this - at present.

Well, the only thing is known for sure at this point is that an
event happened that physically damaged some parts of the system,
this damage includes some drives out of the 48 that died, and
there was huge data loss *apparently* without cause, as in the
arrays where data loss happened all drives are at least
partially working, but some have been failing afterwards,
and anyhow the arrays would not resync afterwards.

Given this background, I would not assume *anything* really
works unless it is proven to work with fairly challenging
testing.

Thus the repeated advice to do a thorough read check of all
drives. I would also check the error log of all drives with
'smartctl -l error' but if there was an electric shock the drive
might not have been able to log anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
