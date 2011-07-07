Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67KkPif194445 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 15:46:26 -0500
Received: from mole.comp.uvic.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19A5B1BF9C75
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 13:46:24 -0700 (PDT)
Received: from mole.comp.uvic.ca (mole.comp.uvic.ca [142.104.5.70]) by
	cuda.sgi.com with ESMTP id 6H5nHTspGeazwfLY for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2011 13:46:24 -0700 (PDT)
Received: from frankenbrick.pcic.uvic.ca (frankenbrick.pcic.uvic.ca
	[142.104.194.114])
	by mole.comp.uvic.ca (8.14.4/8.14.4) with ESMTP id p67KkLeE005474
	for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 13:46:22 -0700
Message-ID: <4E161B1D.90301@uvic.ca>
Date: Thu, 07 Jul 2011 13:46:21 -0700
From: Paul Nienaber <phox@uvic.ca>
MIME-Version: 1.0
Subject: xfs_quota: bug: traverses bind mountpoints
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

So, much like coreutils' du (which also shouldn't), xfs_quota traverses 
bind mountpoints both when doing 'project -s' and 'project -C', and 
probably also 'project -c' although I haven't tested it.  Testcase and 
output follows.

cheers
~Paul

# dd if=/dev/zero of=./xfstestfs bs=1M count=512
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 0.402579 s, 1.3 GB/s
# mkfs.xfs xfstestfs
meta-data=xfstestfs              isize=256    agcount=4, agsize=32768 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=131072, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mkdir /mnt/xfstestfs
# mount -t xfs -o loop,prjquota xfstestfs /mnt/xfstestfs/
# mkdir -p /mnt/xfstestfs/projects/foo/chroot/xfstestfs
# mkdir -p /mnt/xfstestfs/projects/bar
****This is here so we get spew about where it's traversing later on:
# ln -s /mnt/xfstestfs/projects/foo /mnt/xfstestfs/projects/bar/
# echo 12345:/mnt/xfstestfs/projects/foo >> /etc/projects
# echo foo:12345 >> /etc/projid
# mount -t none -o bind /mnt/xfstestfs 
/mnt/xfstestfs/projects/foo/chroot/xfstestfs
# dd if=/dev/zero of=/mnt/xfstestfs/projects/foo/100M bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.0815913 s, 1.3 GB/s
# dd if=/dev/zero of=/mnt/xfstestfs/projects/bar/100M bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.0806148 s, 1.3 GB/s
# xfs_quota -x -c 'project -s foo' /mnt/xfstestfs
Setting up project foo (path /mnt/xfstestfs/projects/foo)...
****Oops, why are we here:
xfs_quota: skipping special file 
/mnt/xfstestfs/projects/foo/chroot/xfstestfs/projects/bar/foo
Processed 1 (/etc/projects and cmdline) paths for project foo with 
recursion depth infinite (-1).
# xfs_quota -x -c 'report -p -h' /mnt/xfstestfs
Project quota on /mnt/xfstestfs (/dev/loop0)
                         Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
foo          200M      0      0  00 [------]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
