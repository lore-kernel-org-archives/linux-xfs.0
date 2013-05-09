Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E893B29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 17:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63C91AC00C
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 15:37:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2G1RFxC6VbwYJinz for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 15:37:25 -0700 (PDT)
Date: Fri, 10 May 2013 08:37:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs_repair segfaults.
Message-ID: <20130509223724.GS24635@dastard>
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
	<5187BF8A.2040303@sandeen.net>
	<CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
	<CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
	<5188FF88.6000508@sandeen.net>
	<CADNx=KvmA7jgqBUO0YvKddHvFaqxHNZKfF3eWajOW8GWKwNhbA@mail.gmail.com>
	<CADNx=Kv=7TFkJKom6_JM8B+A6YRckj175TbCcHrTWYL_N-qkYw@mail.gmail.com>
	<CADNx=KvxtCHEk9G07yS88-casVAXBxRTghV5nGKd_0LtcqpYpQ@mail.gmail.com>
	<20130508233910.GL24635@dastard>
	<CADNx=KuvQ1u+i+PgaCUqLbeGA0-8yfaCP=pez7ptGdm2pL_oGw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADNx=KuvQ1u+i+PgaCUqLbeGA0-8yfaCP=pez7ptGdm2pL_oGw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Filippo Stenico <filippo.stenico@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, May 09, 2013 at 05:11:13PM +0200, Filippo Stenico wrote:
> On Thu, May 9, 2013 at 1:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, May 08, 2013 at 07:30:05PM +0200, Filippo Stenico wrote:
> > > Hello,
> > > -m option seems not to handle the excessive memory consumption I ran
> > into.
> > > I actually ran xfs_repair -vv -m1750 and  looking into kern.log it  seems
> > > that xfs_repair invoked oom killer, but was killed itself ( !! )
> >
> > That's exactly what the oom killer is supposed to do.
> >
> > Yeah, some sacrifice needed.
> 
> 
> > > This is last try to reproduce segfault:
> > > xfs_repair -vv -P -m1750
> >
> > I know your filesystem is around 7TB in size, but how much RAM do
> > you have? It's not unusual for xfs_repair to require many GB of
> > memory to run succesfully on filesystems of this size...
> >
> > it is around 11 TB, 7.2 used.
> I have 4 G ram, but xfs_repair -vv -m1 says I need 1558
> root@ws1000:~# xfs_repair -vv -P -m 1 /dev/mapper/vg0-lv0
> Phase 1 - find and verify superblock...
>         - max_mem = 1024, icount = 29711040, imem = 116058, dblock =
> 2927886336, dmem = 1429632
> Required memory for repair is greater that the maximum specified
> with the -m option. Please increase it to at least 1558.

That's the minimum it requires to run in prefetch mode, not the
maximum it will use.

4GB RAM on a badly corrupted 7TB filesystem is almost certainly not
enough memory to track all the broken bits that need tracking. Add
20-30GB of swap space and see how it goes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
