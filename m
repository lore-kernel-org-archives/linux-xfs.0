Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70F297F3F
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E448304039
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:31:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eliRcM5opp2kpRQL for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 03:31:40 -0700 (PDT)
Date: Tue, 12 Mar 2013 21:31:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ASSERT failure] transaction reservations changes bad?
Message-ID: <20130312103138.GN21651@dastard>
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513EE274.6090808@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 04:08:20PM +0800, Jeff Liu wrote:
> Hi Dave,
> 
> On 03/12/2013 02:25 PM, Dave Chinner wrote:
> > On Tue, Mar 12, 2013 at 05:20:02PM +1100, Dave Chinner wrote:
> >> Folks,
> >>
> >> I just got this ASSERT failure running xfstests on a 3.1.8 xfsprogs
> >> and a 3.9-rc1 kernel running test 297:
> > 
> > FYI, it's 100% reproducable here with:
> > 
> > # sudo MKFS_OPTIONS="-b size=512" ./check 297
> > 
> > (reproduced on multiple VMs now with the same command line)
....
> >> This implies that the permanent transaction reservation ended up
> >> larger than the log itself:
> >>
> >> $ sudo xfs_info /mnt/scratch/
> >> [sudo] password for dave: 
> >> meta-data=/dev/vdb               isize=256    agcount=16, agsize=1441792 blks
> >>          =                       sectsz=512   attr=2
> >> data     =                       bsize=512    blocks=23068672, imaxpct=25
> >>          =                       sunit=512    swidth=6144 blks
> >> naming   =version 2              bsize=4096   ascii-ci=0
> >> log      =internal               bsize=512    blocks=2560, version=2
> >>          =                       sectsz=512   sunit=512 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>
> >> Can someone please check that the before/after mkdir transaction
> >> reservation sizes are unchanged for such a configuration?
> I just did a quick verification. 
> 
> # mkfs.xfs -V
> mkfs.xfs version 3.1.8
> 
> # uname -a
> Linux koala 3.9.0-rc1 #80 SMP Tue Mar 12 15:06:39 CST 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> # mkfs.xfs -f -b size=512 /dev/sda6
> meta-data=/dev/sda6              isize=256    agcount=4, agsize=5242880 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=512    blocks=20971520, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=512    blocks=20480, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

That's a different mkfs.xfs config to what test 297 is using.
Different log size, different AG count, no log stripe unit, etc.
297 is using:

scratch_mkfs_xfs -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b <dev>

And when I add the extra MKFS_OPTIONS in it actually is:

# mkfs.xfs -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b <dev>

> The reservation size does not changed, both are 70072 bytes:
> 
> [  230.905092] xfs_calc_mkdir_reservation: res=70072 bytes.

And it's not just the calculation that I'm worried about here - it's
the actual reservation that ends up in the ticket that matters as
that is fed into the code that has triggered the assert. The value
in the ticket takes into account log stripe units and other
roundings, so it's typically much larger than just the reservation
calculation itself...

> However, I can always reproducing this issue with
> '"MKFS_OPTIONS=-b size=512" ./check 297' as well.

Can you check that it also fails on kernels prior to the reservation
changes? That will rule out it being a recent regression...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
