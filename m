Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p282MA0i196495 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 20:22:10 -0600
Received: from act-ironport-ext.csiro.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33AA831C7F7
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2011 18:25:02 -0800 (PST)
Received: from act-ironport-ext.csiro.au (act-mx-ext.csiro.au [150.229.7.36])
	by cuda.sgi.com with ESMTP id C3oUhtw8RseyU4TR for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2011 18:25:02 -0800 (PST)
Received: (from daemon@localhost)
	by crux.tip.CSIRO.AU (8.9.3/8.9.3/CIPAT-2.1a) id NAA13309
	for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 13:25:00 +1100 (EST)
Received: from mci156 by mayhem.atnf.CSIRO.AU with local (Exim 4.69)
	(envelope-from <mci156@mayhem.atnf.csiro.au>) id 1PwmbT-0000T8-Pc
	for xfs@oss.sgi.com; Tue, 08 Mar 2011 13:24:51 +1100
Date: Tue, 8 Mar 2011 13:24:51 +1100
From: Vincent McIntyre <vincent.mcintyre@csiro.au>
Subject: correct procedure for mismatched UUIDs (error 117)
Message-ID: <20110308022451.GC32056@mayhem.atnf.CSIRO.AU>
MIME-Version: 1.0
Content-Disposition: inline
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

I had a problem with an xfs filesystem that somehow ended up with
a mismatch between the UUID recorded in the superblock and the log.

My question is - what would have been the correct procedure here?
I know this should "never happen". But it has, in an extreme corner
case, and I'd be interested to know if there was anything different
we could have done. (Besides mounting by UUID in the first place...)

Here's what we did.

The platform is Debian Lenny, 64-bit.
% uname -a
Linux debian 2.6.26-2-amd64 #1 SMP Tue Jan 25 05:59:43 UTC 2011 x86_64 GNU/Linux
% dpkg -l|grep xfs
ii  xfsdump                              2.2.48-1                    Administrative utilities for the XFS filesystem
ii  xfsprogs                             2.9.8-1lenny1               Utilities for managing the XFS filesystem

We are using multipath-tools to address the storage.
% dpkg -l |grep multipath
ii  multipath-tools                      0.4.8-14+lenny2             maintain multipath block device access
ii  multipath-tools-boot                 0.4.8-14+lenny2             Support booting from multipath devices

We've used this successfully before, with the same combination
of storage (Promise Vtrak E610f) and fibre channel switch (QLogic SB5202).
The filesystems were both whole-disk partitions on 9.6Tb disks.

What we think caused the problem was:
 * we are using the user-friendly names feature of multipath-tools
 * we changed the binding between userfriendly name and WWN
   for two filesystems - just swapped the mapping of two
 * we omitted to also change the mount path in /etc/fstab.
Silly us.

Things seemed ok until we tried to 'ls' one of the filesystems;
then we got a stack trace:
 Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa027c48b
 Pid: 8687, comm: ls Not tainted 2.6.26-2-amd64 #1

 Call Trace:
  [<ffffffffa027c48b>] :xfs:xfs_da_read_buf+0x24/0x29
  [<ffffffffa027c339>] :xfs:xfs_da_do_buf+0x54e/0x636
  [<ffffffffa027c48b>] :xfs:xfs_da_read_buf+0x24/0x29
  [<ffffffff80276543>] get_page_from_freelist+0x45a/0x606
  [<ffffffffa027c48b>] :xfs:xfs_da_read_buf+0x24/0x29
  [<ffffffffa027f471>] :xfs:xfs_dir2_block_getdents+0x77/0x1b6
  [<ffffffffa027f471>] :xfs:xfs_dir2_block_getdents+0x77/0x1b6
  [<ffffffffa02abf88>] :xfs:xfs_hack_filldir+0x0/0x5b
  [<ffffffffa02abf88>] :xfs:xfs_hack_filldir+0x0/0x5b
  [<ffffffffa027e5ae>] :xfs:xfs_readdir+0x90/0xb5
  [<ffffffff802a6ed4>] filldir+0x0/0xb7
  [<ffffffffa02abf3b>] :xfs:xfs_file_readdir+0xff/0x14c
  [<ffffffff802a6ed4>] filldir+0x0/0xb7
  [<ffffffff802a6ed4>] filldir+0x0/0xb7
  [<ffffffff802a7000>] vfs_readdir+0x75/0xa7
  [<ffffffff802a7250>] sys_getdents+0x75/0xbd
  [<ffffffff8042ab79>] error_exit+0x0/0x60
  [<ffffffff8020beda>] system_call_after_swapgs+0x8a/0x8f

Syslog shows that before that the device mounted cleanly:
 Filesystem "dm-20": Disabling barriers, not supported by the underlying device
 XFS mounting filesystem dm-20
 Ending clean XFS mount for filesystem: dm-20
We only saw a problem when we tried to access it.

Once we saw the ls failure we stopped and changed the mount paths for
the affected filesystems in fstab, then rebooted.
During boot, we got:
 XFS mounting filesystem dm-13
 XFS: log has mismatched uuid - can't recover
 XFS: failed to find log head
 XFS: log mount/recovery failed: error 117
 XFS: log mount failed

for both of the filesystems.

We tried to revert the binding change but that didn't get us out of jail.
First we commented out the affected filesystems in /etc/fstab, rebooted.
When we tried to mount manually after checking the /dev/mapper paths
were what we thought they should be, we still got complaints about
mismatching UUIDs.

We ran xfs_check on both filesystems in turn.

We ran xfs_metadump, which ran w/o errors but did not seem to help us much.

Then we ran xfs_repair in -n mode on each filesystem.
Looked a bit scary, so we deferred using it.

We ran xfs_admin -u on each filesystem, which told us what we already knew:
 # xfs_admin -u /dev/mapper/mpath0-part1
 warning: UUID in AG 1 differs to the primary SB
 UUID = bd57b07f-2f07-4cb3-a641-9f3ecf72ce26
 # xfs_admin -u /dev/mapper/mpath1-part1
 warning: UUID in AG 1 differs to the primary SB
 UUID = 118e731c-aca8-4c78-99d4-df297258dd63

We tried mounting with -oro,nouuid,norecovery, but that didn't help:
 # mount -oro,nouuid,norecovery /dev/mapper/mpath0-part1 /recover
 # ls /recover/
 # ls: reading directory /recover/: Structure needs cleaning
 # umount /recover

We tried xfs_logprint - the log had the same uuid in all the entries
that were printed out. This did not match the uuid of the SB.

By now we were running low on time, so we tried xfs_repair.
We tried one filesystem with -L and one without.
The former produced the expected jumble of inode-numbered files,
which we are in the process of piecing together.
The latter seemed to preserve the directory structure a bit better,
though there was still some jumbling-up.
I won't tax you with the full logs.

That's the story. Opinions?
Vince

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
