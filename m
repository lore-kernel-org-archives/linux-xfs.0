Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o756gJTX070349 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 01:42:19 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1087711CDF24
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 23:50:46 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id ymBwEeYHQeEjRdRR
	for <xfs@oss.sgi.com>; Wed, 04 Aug 2010 23:50:46 -0700 (PDT)
Received: by vws15 with SMTP id 15so4885786vws.26
	for <xfs@oss.sgi.com>; Wed, 04 Aug 2010 23:42:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100805062541.GC26402@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
	<20100805062541.GC26402@dastard>
Date: Thu, 5 Aug 2010 02:42:38 -0400
Message-ID: <AANLkTinhwA1greZdCnoDvd9ieYinhjv0M07sNkbVdy3_@mail.gmail.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 5, 2010 at 2:25 AM, Dave Chinner <david@fromorbit.com> wrote:
> a couple of things to see if the hang can be caused faster? Maybe
> trying these different initial conditions:

Together or independently?

>
> =A0 =A0 =A0 =A0- use a smaller test file

OK. My theory [based on no evidence] was that it had to be bigger than
RAM size. I'll try less though.

> =A0 =A0 =A0 =A0- allocate the file with worst case fragmentation by
> =A0 =A0 =A0 =A0 =A0writing it backwards in synchronous 4k blocks before
> =A0 =A0 =A0 =A0 =A0running the test

I created the file with

dd if=3D/dev/zero of=3D... bs=3D1M count=3D...

How would I "write backwards"? Like truncate and then seek to the end,
write, seek back, write, etc? Is there a utility that might do it
already?

> =A0 =A0 =A0 =A0- preallocating the test file with fallocate()

Sure.

>
> Also, it woul dbe interesting to find out if a newer kernel also
> hangs in a similar manner, say 2.6.35?

Will do.

-- =

Ilia Mirkin
imirkin@alum.mit.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
