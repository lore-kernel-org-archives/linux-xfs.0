Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 87D297F50
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2015 23:00:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FA10304032
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2015 21:00:43 -0700 (PDT)
Received: from mrout6.yahoo.com (mrout6.yahoo.com [216.145.54.155]) by
	cuda.sgi.com with ESMTP id IgkPOX1bD0ltqJxV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jul 2015 21:00:40 -0700 (PDT)
Received: from omp1053.mail.ne1.yahoo.com (omp1053.mail.ne1.yahoo.com
	[98.138.89.195])
	by mrout6.yahoo.com (8.14.9/8.14.9/y.out) with ESMTP id t6D40NnS064197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2015 21:00:23 -0700 (PDT)
Date: Mon, 13 Jul 2015 03:59:21 +0000 (UTC)
From: Hogan Whittall <whittalh@yahoo-inc.com>
Message-ID: <1930601174.877676.1436759961508.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <20150713001303.GH7943@dastard>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
	<20150709230222.GD7943@dastard>
	<1741803883.2585541.1436543988567.JavaMail.yahoo@mail.yahoo.com>
	<20150710224231.GL3902@dastard>
	<1598282205.117137.1436570104177.JavaMail.yahoo@mail.yahoo.com>
	<20150713001303.GH7943@dastard>
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

It's also missing from the command help output as well, but does seem to be there.  So, yeah, no man page or command output updates made me think that it was missing completely.  Thanks!  This makes things much easier.  :)


[root ~]# mkfs.xfs -V
mkfs.xfs version 3.1.1


[root ~]# mkfs.xfs
no device name given in argument list
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
/* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
(sunit=value,swidth=value|su=num,sw=num),
sectlog=n|sectsize=num
/* inode size */        [-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,
projid32bit=0|1]
/* log subvol */        [-l agnum=n,internal,size=num,logdev=xxx,version=n
sunit=value|su=num,sectlog=n|sectsize=num,
lazy-count=0|1]
/* label */             [-L label (maximum 12 characters)]
/* naming */            [-n log=n|size=num,version=2|ci]
/* prototype file */    [-p fname]
/* quiet */             [-q]
/* realtime subvol */   [-r extsize=num,size=num,rtdev=xxx]
/* sectorsize */        [-s log=n|size=num]
/* version */           [-V]
devicename
<devicename> is required unless -d name=xxx is given.
<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
<value> is xxx (512 byte blocks).
[root@ ~]# mkfs.xfs -N -f /dev/mapper/sys-home -d noalign
meta-data=/dev/mapper/sys-home   isize=256    agcount=4, agsize=71271680 blks
=                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=285086720, imaxpct=5
=                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=139202, version=2
=                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


-Hogan


----- Original Message -----
From: Dave Chinner <david@fromorbit.com>
To: Hogan Whittall <whittalh@yahoo-inc.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Sent: Sunday, July 12, 2015 7:13 PM
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL replication

On Fri, Jul 10, 2015 at 11:15:04PM +0000, Hogan Whittall wrote:
> As for the noalign option, that would be great to have but it does
> not exist in version 3.1.1 which RHEL6 uses.  It sounds like not

$ gl -n 1 63a6384
commit 63a63844f8a02f34cbb724086a1f0bac492f25b3
Author: Nathan Scott <nathans@sgi.com>
Date:   Wed Mar 23 02:56:17 2005 +0000

    Add noalign suboptions to -d and -r to allow auto-stripe-alignment to be switched off.
    Merge of master-melb:xfs-cmds:21924a by kenmcd.
$

The noalign option has been in mkfs since 2005, so it's most
certainly supported on RHEL6.

Looking at the man page history, I forgot that it wasn't documented
until 2013 and hence is missing from the RHEL6 man page, so I can
understand why you might be saying this.


-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
