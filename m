Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3D627F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 14:24:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D6B9304048
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 12:24:42 -0700 (PDT)
Received: from mrout4.yahoo.com (mrout4.yahoo.com [216.145.54.109]) by
	cuda.sgi.com with ESMTP id 4Bx2dX2HYLjVjagg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 12:24:39 -0700 (PDT)
Received: from omp1069.mail.ne1.yahoo.com (omp1069.mail.ne1.yahoo.com
	[98.138.226.168])
	by mrout4.yahoo.com (8.14.9/8.14.9/y.out) with ESMTP id t69JNt1B040198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 9 Jul 2015 12:23:55 -0700 (PDT)
Date: Thu, 9 Jul 2015 19:23:54 +0000 (UTC)
From: Hogan Whittall <whittalh@yahoo-inc.com>
Message-ID: <50338734.2095398.1436469834143.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <20150709190511.GH63282@bfoster.bfoster>
References: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
	<20150709190511.GH63282@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Apologies for top-posting, our mail UI makes inline replies virtually impossible.

I will see if I can start with the good XFS settings and change them one at a time to see exactly which setting triggers the issue.  The other issue, which I forgot to mention, is that mkfs.xfs 3.1.1 (shipped with RHEL6) will not let me set -d sunit=0,swidth=0.  No errors, it simply ignores those values and uses the values calculated based on minimum_io_size and optimal_io_size, so the only way that I have any chance of doing this test is by using the same version of mkfs.xfs that doesn't cause a problem in the first place.  It seems that mkfs.xfs 3.1.1 and 3.2.3 (pulled from git) function the same way, ignore 0 and only allow values that fall within a range that it deems acceptable.  Also, specifying those values at mount time, either in fstab or via the mount command, changes nothing.  No errors, just simply ignores them and uses the values set when mkfs.xfs ran.

Thanks for the suggestions, I'll see what I can make happen.  Honestly, I'd be perfectly happy if we could simply replicate the same values with the RHEL6 version of mkfs.xfs since those values work just fine for our various workloads.  3.x resulting in different parameters and being unable to set the same parameters as 2.x just smells like a bug.  Since "0" is a perfectly valid setting when minimum_io_size is 0 and/or optimal_io_size is 512 there really should be a way to manually set 0 as well.

-Hogan

________________________________
From: Brian Foster <bfoster@redhat.com>
To: Hogan Whittall <whittalh@yahoo-inc.com> 
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com> 
Sent: Thursday, July 9, 2015 2:05 PM
Subject: Re: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL replication


On Thu, Jul 09, 2015 at 05:32:50PM +0000, Hogan Whittall wrote:
> Hello,
> Recently we encountered a previously-reported issue regarding write amplification with MySQL replication and XFS when used with certain RAID controllers (In our case, HP P420).  That issue exactly matches our issue and was documented by someone else here - http://oss.sgi.com/archives/xfs/2013-03/msg00133.html - but I don't see any resolution.  I will say that the problem *does not* exist when mkfs.xfs 2.9.6 is used to format the filesystem on RHEL6 as that sets sunit=0 and swidth=0 instead of setting based on minimum_io_size and optimal_io_size.

I'm not very familiar with MySQL and thus not sure what your workload
is, but either version of mkfs.xfs should support setting options such
that the fs is formatted as with the defaults of another version...

> We have systems that are identical in how they are built and configured, we can take a RHEL6 box that has the MySQL partition formatted with mkfs.xfs v3.1.1 and reproduce the write amplification problem with MySQL replication every single time.  If we take the same box and format the MySQL partition with mkfs.xfs 2.9.6, then bring up MySQL with the exact same configuration there is no problem.  I've included the working and broken settings below.  If it's not the sunit/swidth settings then what will cause 7-10MB/s worth of writes to the XFS partition to become over 200MB/s downstream?  The actual data change on the disks is not 200MB/s, but because the write ops are truly being amplified and not just being misreported our MySQL slaves with the bad XFS settings cannot keep up and the lag steadily increases with no hope of ever becoming current.

It would be nice to somehow see what requests are being made at the
application level. Perhaps via strace or something of that nature if you
can demonstrate a relatively isolated operation at the app. level
resulting in the same I/O requests to the kernel but different I/O out
of the filesystem..?

> I am happy to try some other settings/options with the RHEL6 mkfs.xfs to see if replication performance is able to match that of systems formatted with mkfs.xfs 2.9.6, but the values set by 3.1.1 with the P420 RAID do not work for MySQL replication.  We have ruled out everything else as a possible cause, the absolute only difference on these systems is what values are set by mkfs.xfs.
> ============================================================ Working RHEL6 XFS partition:
> meta-data=/dev/mapper/sys-home   isize=256    agcount=4, agsize=71271680 blks         =                       sectsz=512   attr=2, projid32bit=0data     =                       bsize=4096   blocks=285086720, imaxpct=5         =                       sunit=0      swidth=0 blksnaming   =version 2              bsize=4096   ascii-ci=0log      =internal               bsize=4096   blocks=32768, version=2         =                       sectsz=512   sunit=0 blks, lazy-count=0realtime =none                   extsz=4096   blocks=0, rtextents=0
> ============================================================ 
> Broken RHEL6 XFS partition:
> meta-data=/dev/mapper/sys-home   isize=256    agcount=32, agsize=8908992 blks         =                       sectsz=512   attr=2, projid32bit=0data     =                       bsize=4096   blocks=285086720, imaxpct=5         =                       sunit=64     swidth=128 blksnaming   =version 2              bsize=4096   ascii-ci=0log      =internal               bsize=4096   blocks=139264, version=2         =                       sectsz=512   sunit=64 blks, lazy-count=1realtime =none                   extsz=4096   blocks=0, rtextents=0
> ============================================================ 
> 

The differences I see for the second mkfs:

- agcount of 32 instead of 4
- sunit/swidth of 64/128 rather than 0/0
- log size of 139264 blocks rather than 32768
- lazy-count=1 rather than lazy-count=0

As mentioned above, I would take the "broken" mkfs.xfs and add options
one at a time that format the fs as the previous version did and try to
identify what leads to the behavior. E.g., maybe first use '-d
su=0,sw=0' to reset the stripe unit, then try adding '-l
size=<32768*blksize>' to set the log size, '-d agcount=N' to set the
allocation group count, etc.

Brian




> Thanks!
> -Hogan

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
