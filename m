Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64CCA7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 16:43:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53967304066
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:43:52 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id xYB1kzawUaoGi9yF for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 14:43:50 -0800 (PST)
Date: Tue, 1 Dec 2015 15:43:46 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: xfstest failure with xfs, dax and v4.4-rc3
Message-ID: <20151201224346.GA15684@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

I'm seeing a new intermittent xfstests failure with v4.4-rc3 using XFS and
DAX.  The test that is failing is generic/083, and it fails about 50% of the
time in my setup.  Here's the output:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lorwyn 4.4.0-rc3
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2
/mnt/xfstests_scratch

generic/083 2s ... 2s
_check_xfs_filesystem: filesystem on /dev/pmem0p2 is inconsistent (r) (see
/root/xfstests/results//generic/083.full)
Ran: generic/083
Failures: generic/083
Failed 1 of 1 tests

The 083.full file is pretty short, and can be found at the end of this email.

My test setup is a pair of 4GiB PMEM partitions in a KVM virtual machine.

This test passes 100% of the time with v4.3 using DAX, and it passes 100% of
the time in my setup with DAX disabled using v4.4-rc3.

Please let me know if you have any other questions about how to reproduce the
failure.  I'm also happy to test patches.

Thanks,
- Ross

---
*** mkfs -dsize=104857600,agcount=6

meta-data=/dev/pmem0p2           isize=512    agcount=6, agsize=4267 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=25600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=1605, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
seed = 1448253989
_check_xfs_filesystem: filesystem on /dev/pmem0p2 is inconsistent
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
agi unlinked bucket 4 is 19780 in ag 3 (inode=216388)
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 216388, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 216388 nlinks from 0 to 2
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output
*** mount output ***
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=3752992k,nr_inodes=938248,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,seclabel,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime,seclabel)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/mapper/fedora-root on / type ext4 (rw,relatime,seclabel,data=ordered)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime,seclabel)
tmpfs on /tmp type tmpfs (rw,seclabel)
debugfs on /sys/kernel/debug type debugfs (rw,relatime,seclabel)
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,seclabel)
/dev/vda1 on /boot type ext4 (rw,relatime,seclabel,data=ordered)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
192.168.122.1:/home/rzwisler/project on /root/project type nfs4 (rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=192.168.122.101,local_lock=none,addr=192.168.122.1)
tmpfs on /run/user/42 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=814668k,mode=700,uid=42,gid=42)
gvfsd-fuse on /run/user/42/gvfs type fuse.gvfsd-fuse (rw,nosuid,nodev,relatime,user_id=42,group_id=42)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=814668k,mode=700)
/dev/pmem0p1 on /mnt/xfstests_test type xfs (rw,relatime,seclabel,attr2,dax,inode64,noquota)
*** end mount output

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
