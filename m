Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J00KXW133790 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:00:20 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D54079D90
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 17:00:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 5YXusD5OXXe5XL9S for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 17:00:19 -0700 (PDT)
Message-ID: <4E24C912.20003@sandeen.net>
Date: Mon, 18 Jul 2011 19:00:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 30 TB RAID6 + XFS slow write performance
References: <4E24907F.6020903@johnbokma.com>
In-Reply-To: <4E24907F.6020903@johnbokma.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Bokma <contact@johnbokma.com>
Cc: xfs@oss.sgi.com

On 7/18/11 2:58 PM, John Bokma wrote:
> Dear list members,
> =

> A customer of mine is currently struggling with the performance of a
> 30 TB RAID6 which uses XFS as the filing system. I am somewhat sure
> it's not XFS that's causing the performance issue but my expertise is
> not XFS nor RAID; I just wrote the software that after moving to the
> larger RAID (from a much smaller one, ~ 3TB, using ext3) suddenly
> seems to have a huge drop in write performance.
> =

> The software I wrote writes many small (50-150K) files in parallel
> (100+ processes), thousands of times per hour. Writing a file of
> 50-150K now and then seems to take between 30 and 90 seconds, and
> more rarely can take over 200 seconds (several times an hour).
> =

> When all processes are stopped and restarted again the 30-90 seconds
> delay start happening when about 16-20+ processes are running.
> =

> To me this sounds like something has been configured wrong. I already
> recommended my customer to find someone who is capable of configuring
> the RAID correctly; to me it sounds like a hardware/configuration
> issue.
> =

> Any insights are very welcome.
> =

> Hardware: card: MegaRAID SAS 9260-16i disks: 14x Barracuda=AE XT
> ST33000651AS 3TB (2 hot spares). RAID6 ~ 30TB

My first suggestion would be to check the partition alignment on the raid (=
if it is partitioned), and be sure it is aligned with the underlying raid g=
eometry.

And then make sure you give mkfs.xfs the proper geometry as well.

After that, does the raid card have a battery-backed write cache?  If so, y=
ou can safely disable barriers.

More info is always good too, for starters what kernel & what xfsprogs vers=
ion?

What mkfs & mount options?

-Eric

> Thanks for reading, John
> =

> _______________________________________________ xfs mailing list =

> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
