Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCC017F37
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 15:49:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59210AC001
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 13:49:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	c5QvQPT7Amp7jnvu for <xfs@oss.sgi.com>;
	Tue, 28 Apr 2015 13:49:33 -0700 (PDT)
Date: Wed, 29 Apr 2015 06:49:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/204 failure due to e88b64e xfs: use generic percpu
	counters for free inode counter
Message-ID: <20150428204925.GX21261@dastard>
References: <20150428165633.GI17534@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150428165633.GI17534@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xuw2015@gmail.com, xfs@oss.sgi.com

On Wed, Apr 29, 2015 at 12:56:34AM +0800, Eryu Guan wrote:
> Hi,
> 
> I was testing v4.1-rc1 kernel and hit generic/204 failure on 512b block
> size v4 xfs and 1k block size v5 xfs. And this seems to be a regression
> since v4.0

Firstly, knowing your exact test machine and xfstests configuration
is important here, so:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> [root@dhcp-66-86-11 xfstests]# MKFS_OPTIONS="-b size=512" ./check generic/204
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.0.0-rc1+
> MKFS_OPTIONS  -- -f -b size=512 /dev/sda6
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda6 /mnt/testarea/scratch
> 
> generic/204 8s ... - output mismatch (see /root/xfstests/results//generic/204.out.bad)
>     --- tests/generic/204.out   2014-12-11 00:28:13.409000000 +0800
>     +++ /root/xfstests/results//generic/204.out.bad     2015-04-29 00:36:43.232000000 +0800
>     @@ -1,2 +1,37664 @@
>      QA output created by 204
>     +./tests/generic/204: line 83: /mnt/testarea/scratch/108670: No space left on device
>     +./tests/generic/204: line 84: /mnt/testarea/scratch/108670: No space left on device
>     ...
> I bisected to this commit
>
> e88b64e xfs: use generic percpu counters for free inode counter

I don't think that this is the actual cause of the issue, because I
have records of generic/204 failing on 1k v5 filesystems every so
often going back to the start of the log file I have for my v5/1k
test config:

$ grep "Failures\|EST" results/check.log |grep -B 1 generic/204
Wed Jun 19 11:26:35 EST 2013
Failures: generic/204 generic/225 generic/231 generic/263 generic/306
Wed Jun 19 12:49:08 EST 2013
Failures: generic/204 generic/225 generic/231 generic/263 generic/270
--
Mon Jul  8 17:23:44 EST 2013
Failures: generic/204
Mon Jul  8 20:37:50 EST 2013
Failures: generic/204 generic/225 generic/231 generic/263 generic/306
--
Thu Jul 18 16:55:26 EST 2013
Failures: generic/015 generic/077 generic/193 generic/204
--
Mon Jul 29 19:42:49 EST 2013
Failures: generic/193 generic/204 generic/225 generic/230 generic/231
Mon Aug 12 19:40:53 EST 2013
Failures: generic/193 generic/204 generic/225 generic/230 generic/23
....

> Seems like the same issue this patch tries to fix, but test still fails
> after applying this patch.
> 
> [PATCH v2] xfs: use percpu_counter_read_positive for mp->m_icount
> http://oss.sgi.com/archives/xfs/2015-04/msg00195.html
> 
> Not sure if it's the expected behavior/a known issue, report it to the
> list anyway.

Repeating the test on v4/512b, I get the same result as you.

$ cat results/generic/204.full
files 127500, resvblks 1024
reserved blocks = 1024
available reserved blocks = 1024
$

Ok, those numbers add up to exactly 97,920,000 bytes, as per the
test config.

$ sudo mount /dev/vdb /mnt/scratch
$ df -h /mnt/scratch
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb         99M   87M   13M  88% /mnt/scratch
$ df -i /mnt/scratch
Filesystem     Inodes  IUsed  IFree IUse% Mounted on
/dev/vdb       108608 108608      0  100% /mnt/scratch
$

And for v5/1k:

$ sudo mkfs.xfs -f -m crc=1,finobt=1 -b size=1k -d size=$((106 * 1024 * 1024)) -l size=7m /dev/vdb
meta-data=/dev/vdb               isize=512    agcount=4, agsize=27136 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1
data     =                       bsize=1024   blocks=108544, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=1024   blocks=7168, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount /dev/vdb /mnt/scratch
$ df -i /mnt/scratch
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/vdb        54272     3 54269    1% /mnt/scratch
$ 

Yup, it's clear *why* it is failing, too. There aren't enough free
inodes configured by mkfs.  That means it's the mkfs imaxpct config
that is the issue here, not the commit that made the max inode
threshold more accurate...

Adding "-i maxpct=50" to the mkfs command allows the test to pass on
both v4/512 and v5/1k filesystems.  IOWs, it does not appear to be
code problem but is a test config problem...

Can you send a patch to fstests@vger.kernel.org that fixes the test
for these configs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
