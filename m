Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CD9B7F76
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 16:02:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F0CBAC001
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 14:02:36 -0700 (PDT)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	1rRBeMAeqnyHr5fM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 14:02:34 -0700 (PDT)
Received: by iedfl3 with SMTP id fl3so2865559ied.1
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2015 14:02:34 -0700 (PDT)
Message-ID: <5526E8E9.3030805@gmail.com>
Date: Thu, 09 Apr 2015 17:02:33 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: interesting MD-xfs bug
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>, linux-raid <linux-raid@vger.kernel.org>

If I build an MD raid0 with a non power of 2 chunk size, it appears that 
I can mkfs.xfs a file system, but it doesn't show up in blkid and is not 
mountable.  Yet, using a power of 2 chunk size, this does work 
correctly.   This is kernel 3.18.9.


For example, non-power of 2 chunk:

root@unison:~# wipefs -a /dev/sdb
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# wipefs -a /dev/sda
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# mdadm --create /dev/md20 --level=0 --metadata=1.2 
--chunk=1152 --auto=yes --raid-disks=2 /dev/sd[ab]
mdadm: array /dev/md20 started.

root@unison:~# mkfs.xfs /dev/md20
log stripe unit (1179648 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md20              isize=256    agcount=50, 
agsize=268435296 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=13164865984, imaxpct=5
          =                       sunit=288    swidth=576 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@unison:~# blkid | grep xfs
root@unison:~#


Same system, with power of 2 chunk size:

root@unison:~# mdadm -S /dev/md20
mdadm: stopped /dev/md20
root@unison:~# wipefs -a /dev/sda
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# wipefs -a /dev/sdb
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# mdadm --create /dev/md20 --level=0 --metadata=1.2 
--chunk=1024 --auto=yes --raid-disks=2 /dev/sd[ab]
mdadm: array /dev/md20 started.
root@unison:~# mkfs.xfs /dev/md20
log stripe unit (1048576 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md20              isize=256    agcount=50, 
agsize=268435200 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=13164866048, imaxpct=5
          =                       sunit=256    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@unison:~# blkid | grep xfs
/dev/md20: UUID="5e965ae7-198e-4e58-8920-a65c4b6bbe60" TYPE="xfs"

I am not sure which code base might be at "fault" or even if there is a 
"fault" (beyond simply saying "don't do non-power-of-two chunks").  If 
its the latter, happy to work on a warning message patch for mdadm if 
needed.  If it should work, then happy to poke around if someone can 
give me a pointer where something might be relevant.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
