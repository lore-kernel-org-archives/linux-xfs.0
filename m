Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o77A84Pd192929 for <xfs@oss.sgi.com>; Sat, 7 Aug 2010 05:08:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBDEE16C4101
	for <xfs@oss.sgi.com>; Sat,  7 Aug 2010 03:08:24 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	WjmLDeXAHhV1IrsT for <xfs@oss.sgi.com>;
	Sat, 07 Aug 2010 03:08:24 -0700 (PDT)
Date: Sat, 7 Aug 2010 20:08:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100807100821.GC7362@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
	<20100805062541.GC26402@dastard>
	<AANLkTinhwA1greZdCnoDvd9ieYinhjv0M07sNkbVdy3_@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTinhwA1greZdCnoDvd9ieYinhjv0M07sNkbVdy3_@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: xfs@oss.sgi.com

On Thu, Aug 05, 2010 at 02:42:38AM -0400, Ilia Mirkin wrote:
> On Thu, Aug 5, 2010 at 2:25 AM, Dave Chinner <david@fromorbit.com> wrote:
> > a couple of things to see if the hang can be caused faster? Maybe
> > trying these different initial conditions:
> =

> Together or independently?

independently first - then if that does't work, maybe together?

> > =A0 =A0 =A0 =A0- allocate the file with worst case fragmentation by
> > =A0 =A0 =A0 =A0 =A0writing it backwards in synchronous 4k blocks before
> > =A0 =A0 =A0 =A0 =A0running the test
> =

> I created the file with
> =

> dd if=3D/dev/zero of=3D... bs=3D1M count=3D...
> =

> How would I "write backwards"? Like truncate and then seek to the end,
> write, seek back, write, etc? Is there a utility that might do it
> already?

For a 1GB file:

$ for i in `seq 256000 1 0`; do
> dd if=3D/dev/zero of=3Dtestfile bs=3D4k count=3D1 seek=3D$i conv=3Dnotrun=
c,sync
> done

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
