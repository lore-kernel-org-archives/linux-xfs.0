Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2CD9C7F4E
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 17:42:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A33C6AC001
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 15:42:01 -0800 (PST)
Received: from mail-qg0-f54.google.com (mail-qg0-f54.google.com
	[209.85.192.54]) by cuda.sgi.com with ESMTP id KCdP4aor3rH9Ie8F
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Dec 2014 15:41:57 -0800 (PST)
Received: by mail-qg0-f54.google.com with SMTP id l89so2782340qgf.27
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 15:41:56 -0800 (PST)
Message-ID: <54975ABF.2030102@gmail.com>
Date: Sun, 21 Dec 2014 18:41:51 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Disconnected inodes after test xfs/261
References: <20141217193535.GA8231@quack.suse.cz>	<20141217210226.GY24183@dastard>	<20141218103642.GB13705@quack.suse.cz>	<20141218135555.GH13705@quack.suse.cz>
	<20141219020327.GD24183@dastard>
In-Reply-To: <20141219020327.GD24183@dastard>
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
Cc: xfs@oss.sgi.com

On 12/18/14 21:03, Dave Chinner wrote:
> On Thu, Dec 18, 2014 at 02:55:55PM +0100, Jan Kara wrote:
>> On Thu 18-12-14 11:36:42, Jan Kara wrote:
>>> On Thu 18-12-14 08:02:26, Dave Chinner wrote:
>>>> On Wed, Dec 17, 2014 at 08:35:35PM +0100, Jan Kara wrote:
>>>>>   Hello,
>>>>>
>>>>>   in my test KVM with today's Linus' kernel I'm getting xfs_repair
>>>>> complaint about disconnected inodes after the test xfs/261 finishes
>>>>> (with success). xfs_repair output is like:
>>>>> xfs_repair -n /dev/vdb2
>>>>> Phase 1 - find and verify superblock...
>>>>> Phase 2 - using internal log
>>>>>         - scan filesystem freespace and inode maps...
>>>>>         - found root inode chunk
>>>>> Phase 3 - for each AG...
>>>>>         - scan (but don't clear) agi unlinked lists...
>>>>>         - process known inodes and perform inode discovery...
>>>>>         - agno = 0
>>>>>         - agno = 1
>>>>>         - agno = 2
>>>>>         - agno = 3
>>>>>         - process newly discovered inodes...
>>>>> Phase 4 - check for duplicate blocks...
>>>>>         - setting up duplicate extent list...
>>>>>         - check for inodes claiming duplicate blocks...
>>>>>         - agno = 0
>>>>>         - agno = 1
>>>>>         - agno = 2
>>>>>         - agno = 3
>>>>> No modify flag set, skipping phase 5
>>>>> Phase 6 - check inode connectivity...
>>>>>         - traversing filesystem ...
>>>>>         - traversal finished ...
>>>>>         - moving disconnected inodes to lost+found ...
>>>>> disconnected inode 132, would move to lost+found
>>>>> disconnected inode 133, would move to lost+found
>>>>> Phase 7 - verify link counts...
>>>>> No modify flag set, skipping filesystem flush and exiting.
>>>>> ---
>>>>> Given how trivial test xfs/261 is, it seems like created private mtab files
>>>>> that also get unlinked don't get added to AGI unlinked list before umount.
>>>>> I didn't have a detailed look whether that's possible or not and probably
>>>>> won't get to it before Christmas. So I'm sending this just in case someone
>>>>> more knowledgeable has ideas earlier...
>>>>
>>>> I don't see that here. If you mount/unmount the filesystem, does the
>>>> warning go away? i.e. xfs_repair -n ignores the contents of
>>>> the log, so if the unlinked list transactions are in the log then
>>>> log recovery will make everything good again.
>>>   No, the problem is still there after mounting and unmounting the
>>> filesystem.
>>>
>>> Given what Michael wrote: I'm running xfs_repair version 3.2.1, filesystem
>>> is V4.
>>>
>>> When I look via xfs_db at the inode I can see nlink is 1 which looks
>>> strange. So maybe the problem is somewhere else than I thought:
>>> xfs_db> inode 132
>>> xfs_db> p
>>> core.magic = 0x494e
>>> core.mode = 0100000
>>> core.version = 2
>>> core.format = 2 (extents)
>>> core.nlinkv2 = 1
>>> core.onlink = 0
>>> core.projid_lo = 0
>>> core.projid_hi = 0
>>> core.uid = 0
>>> core.gid = 0
>>> core.flushiter = 1
>>> core.atime.sec = Thu Dec 18 11:08:55 2014
>>> core.atime.nsec = 510013169
>>> core.mtime.sec = Thu Dec 18 11:08:55 2014
>>> core.mtime.nsec = 510013169
>>> core.ctime.sec = Thu Dec 18 11:08:55 2014
>>> core.ctime.nsec = 510013169
>>> core.size = 0
>>> core.nblocks = 1
>>> core.extsize = 0
>>> core.nextents = 1
>>> core.naextents = 0
>>> core.forkoff = 0
>>> core.aformat = 2 (extents)
>>> core.dmevmask = 0
>>> core.dmstate = 0
>>> core.newrtbm = 0
>>> core.prealloc = 0
>>> core.realtime = 0
>>> core.immutable = 0
>>> core.append = 0
>>> core.sync = 0
>>> core.noatime = 0
>>> core.nodump = 0
>>> core.rtinherit = 0
>>> core.projinherit = 0
>>> core.nosymlinks = 0
>>> core.extsz = 0
>>> core.extszinherit = 0
>>> core.nodefrag = 0
>>> core.filestream = 0
>>> core.gen = 0
>>> next_unlinked = null
>>> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,13,1,0]
>>>
>>> I have taken xfs_metadump just after test xfs/261 completed and xfs_repair
>>> reported error. It is attached.
>>   OK, so I understand better what's going on. The detached inodes are
>> actually inodes from quota files being created by quotacheck on mount. Test
>> xfs/261 first mounts with uquota - that adds user quota ino and quota
>> feature just fine. But then it mounts with gquota - now we go through
>> different path since xfs_sb_version_hasquota() is already true. We find
>> that group quota isn't initialized though and thus we still need to
>> allocate inode for group quota file. However the change to sb_gquotaino
>> isn't written out because the following test in xfs_sb_quota_to_disk()
>> fails:
>>
>> 	if ((*fields & XFS_SB_GQUOTINO) &&
>>                                 (from->sb_qflags & XFS_GQUOTA_ACCT))
>>                 to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
>>
>> because from->sb_qflags doesn't have XFS_GQUOTA_ACCT set (only
>> mp->m_qflags has XFS_GQUOTA_ACCT set).
> 
> I think you've got that wrong, but at the same time got it right. ;)
> 
> That is, we get there through xfs_qm_mount_quotas(), which does this
> in the the write_changes section:
> 
>         spin_lock(&mp->m_sb_lock);
>         sbf = mp->m_sb.sb_qflags;
>         mp->m_sb.sb_qflags = mp->m_qflags & XFS_MOUNT_QUOTA_ALL;
>         spin_unlock(&mp->m_sb_lock);
> 
>         if (sbf != (mp->m_qflags & XFS_MOUNT_QUOTA_ALL)) {
>                 if (xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)) {
> 
> Hence (from->sb_qflags & XFS_GQUOTA_ACCT) evaluates are true because
> we've copied mp->m_qflags into from->sb_qflags before logging the
> change. that's the bit you got wrong.
> 
> However, the code there only passes XFS_SB_QFLAGS to xfs_log_sb(),
> and that means (*fileds & XFS_SB_GQUOTINO) evaluates as false, and
> we fail to write the new group quota inode. SO you are right in that
> this is the check that is failing. :)
> 
> And, again, the reason I wasn't able to reproduce it is that I
> tested on a kernel running that "get rid of field based superblock
> logging", which meant the above check was simply:
> 
> 	if (from->sb_qflags & XFS_GQUOTA_ACCT)
> 		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> 
> and, from above, we know that this is set appropriately. Hence the
> group quota inode was updated and the test did not fail.
> 
> FYI, I noticed a bunch of these sb logging field bugs a while back, which
> is why I wrote the patch to simply get rid of it. You've found two
> of those bugs in the past few days....

And I didn't do very well in hunting things down.  Bisect took me 
back to "xfs: Start using pquotaino from the superblock", but that 
first bisect step took me to 3.14 and probably over the recent 
fixes.  Just chiming in to note that even before then, the new 
xfsprogs is needed for xfs/261 to pass outright.  Also, the patches 
cited elsewhere in this thread didn't seem to solve matters...but 
the second patch had to be placed in by hand.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
