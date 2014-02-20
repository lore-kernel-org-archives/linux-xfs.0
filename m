Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65A0E7FAD
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 12:31:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F32C304053
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 10:31:31 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id 3RvXpYcdCSqjBLi3
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 20 Feb 2014 10:31:26 -0800 (PST)
Received: from localhost (al.wesleyan.edu [129.133.22.76])
	(authenticated bits=0)
	by msa.wesleyan.edu (8.14.4/8.14.4) with ESMTP id s1KIVPd9021231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 13:31:25 -0500
MIME-Version: 1.0
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
References: <52E91923.4070706@sandeen.net> <52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
	<20140202212152.GP2212@dastard> <1391443675-sup-1730@al.wesleyan.edu>
	<20140203214128.GR13997@dastard> <52F09E36.8050606@hardwarefreak.com>
	<1392748390-sup-1943@al.wesleyan.edu>
	<5303E7AC.50903@hardwarefreak.com>
In-Reply-To: <5303E7AC.50903@hardwarefreak.com>
Message-ID: <20140220183125.29149.64880@al.wesleyan.edu>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
Date: Thu, 20 Feb 2014 13:31:25 -0500
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
To: xfs@oss.sgi.com

Quoting Stan Hoeppner (2014-02-18 18:07:24)
> Create each LV starting on a stripe boundary.  There will be some
> unallocated space between LVs.  Use the mkfs.xfs -d size= option to
> create your filesystems inside of each LV such that the filesystem total
> size is evenly divisible by the stripe width.  This results in an
> additional small amount of unallocated space within, and at the end of,
> each LV.

Of course, this occurred to me just after sending the message... ;)

> It's nice if you can line everything up, but when using RAID6 and one or
> two bays for hot spares, one rarely ends up with 8 or 16 data spindles.
> 
> > If not, I'll tweak things to ensure my stripe width is a power of 2.
> 
> That's not possible with 12 data spindles per RAID, not possible with 42
> drives in 3 chassis.  Not without a bunch of idle drives.

The closest I can come is with 4 RAID 6 arrays of 10 disks each, then
striped over:

8 * 128k = 1024k
1024k * 4 = 4096k

Which leaves me with 5 disks unused.  I might be able to live with that
if it makes things work better.  Sounds like I won't have to.


> I still don't understand why you believe you need LVM in the mix, and
> more than one filesystem.

> Backup software is unaware of mount points.  It uses paths just like
> every other program.  The number of XFS filesystems is irrelevant to
> "minimizing the effects of the archive maintenance jobs".  You cannot
> bog down XFS.  You will bog down the drives no matter how many
> filesystems when using RAID60.

A limitation of the software in question is that placing multiple
archive paths onto a single filesystem is a bit ugly: the software does
not let you specifiy a maximum size for the archive paths, and so will
think all of them are the size of the filesystem.  This isn't an issue
in isolation, but we need to make use of a data-balancing feature the
software has, which will not work if we place multiple archive paths on
a single filesystem.  It's a stupid issue to have, but it is what it is.

> Here is what you should do:
> 
> Format the RAID60 directly with XFS.  Create 3 or 4 directories for
> CrashPlan to use as its "store points".  If you need to expand in the
> future, as I said previously, simply add another 14 drive RAID6 chassis,
> format it directly with XFS, mount it at an appropriate place in the
> directory tree and give that path to CrashPlan.  Does it have a limit on
> the number of "store points"?

Yes, this is what I *want* to do.  There's a limit to the number of
store points, but it's large, so this would work fine if not for the
multiple-stores-on-one-filesystem issue.  Which is frustrating.

The *only* reason for LVM in the middle is to allow some flexibility of
sizing without dealing with the annoyances of the partition table.
I want to intentionally under-provision to start with because we are
using a small corner of this storage for a separate purpose but do not
know precisely how much yet.  LVM lets me leave, say, 10TB empty, until
I know exactly how big things are going to be.

It's a pile of little annoyances, but so it goes with these kinds of things.

It sounds like the little empty spots method will be fine though.

Thanks, yet again, for all your help.
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
