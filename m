Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p290lOjB006739 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 18:47:25 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 532C5133C2B5
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2011 16:50:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3xJUgJsVaW5Yp2fe for <xfs@oss.sgi.com>;
	Tue, 08 Mar 2011 16:50:16 -0800 (PST)
Date: Wed, 9 Mar 2011 11:50:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: correct procedure for mismatched UUIDs (error 117)
Message-ID: <20110309005013.GG1956@dastard>
References: <20110308022451.GC32056@mayhem.atnf.CSIRO.AU>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110308022451.GC32056@mayhem.atnf.CSIRO.AU>
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
To: Vincent McIntyre <vincent.mcintyre@csiro.au>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Mar 08, 2011 at 01:24:51PM +1100, Vincent McIntyre wrote:
> Hi,
> 
> I had a problem with an xfs filesystem that somehow ended up with
> a mismatch between the UUID recorded in the superblock and the log.
> 
> My question is - what would have been the correct procedure here?
> I know this should "never happen". But it has, in an extreme corner
> case, and I'd be interested to know if there was anything different
> we could have done. (Besides mounting by UUID in the first place...)
> 
> Here's what we did.
> 
> The platform is Debian Lenny, 64-bit.
> % uname -a
> Linux debian 2.6.26-2-amd64 #1 SMP Tue Jan 25 05:59:43 UTC 2011 x86_64 GNU/Linux
> % dpkg -l|grep xfs
> ii  xfsdump                              2.2.48-1                    Administrative utilities for the XFS filesystem
> ii  xfsprogs                             2.9.8-1lenny1               Utilities for managing the XFS filesystem
> 
> We are using multipath-tools to address the storage.
> % dpkg -l |grep multipath
> ii  multipath-tools                      0.4.8-14+lenny2             maintain multipath block device access
> ii  multipath-tools-boot                 0.4.8-14+lenny2             Support booting from multipath devices
> 
> We've used this successfully before, with the same combination
> of storage (Promise Vtrak E610f) and fibre channel switch (QLogic SB5202).
> The filesystems were both whole-disk partitions on 9.6Tb disks.
> 
> What we think caused the problem was:
>  * we are using the user-friendly names feature of multipath-tools
>  * we changed the binding between userfriendly name and WWN
>    for two filesystems - just swapped the mapping of two
>  * we omitted to also change the mount path in /etc/fstab.
> Silly us.

Did you change the mapping while the filesystems were mounted?

> Things seemed ok until we tried to 'ls' one of the filesystems;
> then we got a stack trace:
>  Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2085 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa027c48b

That indicates a block was read from disk that had an incorrect
magic number in it. i.e. it wasn't a directory block that the
directory extent map pointed to.

> Syslog shows that before that the device mounted cleanly:
>  Filesystem "dm-20": Disabling barriers, not supported by the underlying device
>  XFS mounting filesystem dm-20
>  Ending clean XFS mount for filesystem: dm-20
> We only saw a problem when we tried to access it.

OK.

> Once we saw the ls failure we stopped and changed the mount paths for
> the affected filesystems in fstab, then rebooted.
> During boot, we got:
>  XFS mounting filesystem dm-13
>  XFS: log has mismatched uuid - can't recover
>  XFS: failed to find log head
>  XFS: log mount/recovery failed: error 117
>  XFS: log mount failed
> 
> for both of the filesystems.

Which implies that the superblock was written to disk with the wrong
UUID in it. And the only way that can happen is if the superblock
for the wrong filesystem is written to the block device. Hence my
question of whether you swapped the paths while the filesystems were
mounted - the superblock is only read during mount time, and the
UUID is never modified, so the only way an incorrect UUID can be
written to the filesystem is if the block device changes underneath
the mounted filesystem.

> We tried to revert the binding change but that didn't get us out of jail.
> First we commented out the affected filesystems in /etc/fstab, rebooted.
> When we tried to mount manually after checking the /dev/mapper paths
> were what we thought they should be, we still got complaints about
> mismatching UUIDs.

Nope, once you've written a bad superblock, you're pretty much screwed

> We ran xfs_check on both filesystems in turn.
> 
> We ran xfs_metadump, which ran w/o errors but did not seem to help us much.
> 
> Then we ran xfs_repair in -n mode on each filesystem.
> Looked a bit scary, so we deferred using it.

Well, that's what you're going to have to do eventually (without the
-n) because it seems like you've written metadata from the
filesystems to the wrong block devices, thereby corrupting both
filesystems. Worse is the fact that you may have caused data
corruption as well (by writing metadata into the middle of data
extents) and there is no way to find that out short of checking all
you data file contents yourself (e.g. via md5sum and comparing them
to the files in your last backup)

> We ran xfs_admin -u on each filesystem, which told us what we already knew:
>  # xfs_admin -u /dev/mapper/mpath0-part1
>  warning: UUID in AG 1 differs to the primary SB
>  UUID = bd57b07f-2f07-4cb3-a641-9f3ecf72ce26
>  # xfs_admin -u /dev/mapper/mpath1-part1
>  warning: UUID in AG 1 differs to the primary SB
>  UUID = 118e731c-aca8-4c78-99d4-df297258dd63

OK, what you need to do is find out what the UUID in the secondary
SB in AG 1 is, and check that they are swapped. i.e:

# xfs_db -c "sb 0" -c "p uuid" /dev/mapper/mpath0-part1
UUID = <XXX>
# xfs_db -c "sb 1" -c "p uuid" /dev/mapper/mpath0-part1
UUID = <YYY>

And from the other block device, I'd expect you to see:

# xfs_db -c "sb 0" -c "p uuid" /dev/mapper/mpath1-part1
UUID = <YYY>
# xfs_db -c "sb 1" -c "p uuid" /dev/mapper/mpath1-part1
UUID = <XXX>

If that is the case, then you need to reconstruct the primary
superblock from the info in the secondary superblock using xfs_db,
and then you'll need to run xfs_repair to detect fix all the
inconsistencies that were introduced. You need to copy these fileds
from the secondary SB to the primary if they are different:

blocksize
dblocks
rblocks
rextents
uuid
logstart
rextsize
agblocks
agcount
rbmblocks
logblocks
versionnum
sectsize
inodesize
inopblock
blocklog
sectlog
inodelog
inopblog
agblklog
rextslog
imax_pct
inoalignmt
unit
width
dirblklog
logsectlog
logsectsize
logsunit
features2
bad_features2

Note that these are not all the fields in the superblock. You do not
want to copy the ones not mentioned, even if they are different in
value.

> 
> We tried mounting with -oro,nouuid,norecovery, but that didn't help:
>  # mount -oro,nouuid,norecovery /dev/mapper/mpath0-part1 /recover
>  # ls /recover/
>  # ls: reading directory /recover/: Structure needs cleaning
>  # umount /recover

No surprise there.

> We tried xfs_logprint - the log had the same uuid in all the entries
> that were printed out. This did not match the uuid of the SB.

Which means that you might be lucky and the only metadata written to
the wrong block device was the superblock.

> By now we were running low on time, so we tried xfs_repair.
> We tried one filesystem with -L and one without.
> The former produced the expected jumble of inode-numbered files,
> which we are in the process of piecing together.
> The latter seemed to preserve the directory structure a bit better,
> though there was still some jumbling-up.
> I won't tax you with the full logs.
> 
> That's the story. Opinions?

Well, seeing as you've already run repair, I think you've probably
made a mess that can't be cleaned up. I'd be checking all the data
is intact once you've cleaned up the messed up directory
structure.

Not much else I can suggest at this point apart from point out that
it is better to ask questions before trying to fix a screwup rather
than after attempting to undo the damage and making the situation
unrecoverable......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
