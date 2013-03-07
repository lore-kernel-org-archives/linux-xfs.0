Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B2E157FA5
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 21:57:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CB448F8073
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 19:57:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PbOWtQ47Azbrt4CM for <xfs@oss.sgi.com>;
	Wed, 06 Mar 2013 19:57:39 -0800 (PST)
Date: Thu, 7 Mar 2013 14:57:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
Message-ID: <20130307035737.GC6369@dastard>
References: <1362060736.1247.30.camel@seahawk> <20130228194023.GQ5551@dastard>
	<1362577992.1247.84.camel@seahawk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1362577992.1247.84.camel@seahawk>
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
To: Dennis Kaarsemaker <dennis.kaarsemaker@booking.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 06, 2013 at 02:53:12PM +0100, Dennis Kaarsemaker wrote:
> On Fri, 2013-03-01 at 06:40 +1100, Dave Chinner wrote:
> > On Thu, Feb 28, 2013 at 03:12:16PM +0100, Dennis Kaarsemaker wrote:
> > > Hello XFS developers,
> > > 
> > > I have a problem as described in the subject. If I read the xfs website
> > > correctly, this would be a place to ask for support with that problem.
> > > Before I spam you all with details, please confirm if this is true or
> > > direct me to a better place. Thanks!
> > 
> > CentOS/RHEL problems can be triaged up to a point here. i.e. we will
> > make an effort to pinpoint the problem, but we give no guarantees
> > and we definitely can't fix it. If you want a btter triage guarantee
> > and to talk to someone who is able to fix the problem, you need to
> > work through the problem with your RHEL support contact.
> 
> Hi Dave,
> 
> Thanks for responding. We have filed support tickets with HP and Red Hat
> as well, I was trying to parallelize the search for an answer as the
> problem is really getting in the way here. So much so that I've offered
> a bottle of $favourite_drink on a serverfault question to the one who
> solves it, that offer applies here too :)
> 
> > Either way:
> > 
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> A summary of the problem is this:
> 
> [root@bc290bprdb-01 ~]# collectl
> #<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
> #cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
>    1   0  1636   4219     16      1   2336    313    184    195     12     133 
>    1   0  1654   2804     64      3   2919    432    391    352     20     208 
> 
> [root@bc291bprdb-01 ~]# collectl
> #<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
> #cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
>    1   0  2220   3691    332     13  39992    331    112    122      6      92 
>    0   0  1354   2708      0      0  39836    335    103    125      9      99 
>    0   0  1563   3023    120      6  44036    369    399    317     13     188 
> 
> Notice the KBWrit difference. These are two identical hp gen 8 machines,
> doing the same thing (replicating the same mysql schema). The one
> writing ten times as many bytes in the same amount of transactions is
> running centos 6 (and was running rhel 6).

So what is the problem? it is writing too much on the on the centos
6 machine? Either way, this doesn't sound like a filesystem problem
- the size and amount of data writes is entirely determined by the
application.


> /dev/mapper/sysvm-mysqlVol /mysql/bp xfs rw,relatime,attr2,delaylog,allocsize=1024k,logbsize=256k,sunit=512,swidth=1536,noquota 0 0

What is the reason for using allocsize, sunit/swidth? Are you using
them on other machines?

And if you remove the allocsize mount option, does the behaviour on
centos6.3 change? What happens if you set allocsize=4k?

> xfs_info:
> 
> [root@bc291bprdb-01 ~]# xfs_info /mysql/bp/
> meta-data=/dev/mapper/sysvm-mysqlVol isize=256    agcount=16, agsize=4915136 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=78642176, imaxpct=25
>          =                       sunit=64     swidth=192 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=38400, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> And for reference, xfs_info on centos 5:
> 
> [root@bc290bprdb-01 ~]# xfs_info /mysql/bp/
> meta-data=/dev/sysvm/mysqlVol    isize=256    agcount=22, agsize=4915200 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=104857600, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

The only difference is that the centos 6 filesystem is configured
with sunit/swidth. That affects allocation alignment, but nothing
else. It won't affect IO sizes.

> Linux 2.6.18-308.el5 (bc290bprdb-01.lhr4.prod.booking.com) 	03/06/2013
> 
> Device:         rrqm/s   wrqm/s   r/s   w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> cciss/c0d0        6.95    27.09  7.72 270.96     0.19     2.90    22.71     0.07    0.25   0.22   6.00
> cciss/c0d0p1      0.00     0.00  0.00  0.00     0.00     0.00    47.62     0.00    1.69   1.61   0.00
> cciss/c0d0p2      0.00     0.00  0.00  0.00     0.00     0.00    14.40     0.00    4.07   4.06   0.00
> cciss/c0d0p3      6.94    27.09  7.72 270.96     0.19     2.90    22.71     0.07    0.25   0.22   6.00
> dm-0              0.00     0.00  0.45 32.85     0.01     0.13     8.34     0.02    0.49   0.07   0.24
> dm-1              0.00     0.00  6.97 264.13     0.15     2.77    22.10     0.07    0.24   0.22   5.93

So, 8k IOs on centos 5...

> Linux 2.6.32-279.1.1.el6.x86_64 (bc291bprdb-01.lhr4.prod.booking.com) 	03/06/2013 	_x86_64_	(32 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00     3.60    6.00  374.40     0.06    44.18   238.17     0.11    0.28   0.16   6.08
> dm-0              0.00     0.00    0.00    4.40     0.00     0.02     8.00     0.00    0.27   0.18   0.08
> dm-1              0.00     0.00    6.00  373.20     0.06    44.11   238.56     0.11    0.28   0.16   6.04

And 128k IOs on centos 6. Unless there's a massive difference in
file layouts, nothing in the filesystem would cause such a
dramatic change in IO size or thoughput.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
