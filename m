Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5BA957F3F
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 18:46:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A6BF30406B
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 16:46:39 -0800 (PST)
Received: from mail-qa0-f49.google.com (mail-qa0-f49.google.com
	[209.85.216.49]) by cuda.sgi.com with ESMTP id SzlZO9zD3zGzKuty
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Dec 2014 16:46:37 -0800 (PST)
Received: by mail-qa0-f49.google.com with SMTP id s7so132110qap.22
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2014 16:46:37 -0800 (PST)
Message-ID: <549223D9.5020202@gmail.com>
Date: Wed, 17 Dec 2014 19:46:17 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Disconnected inodes after test xfs/261
References: <20141217193535.GA8231@quack.suse.cz>
	<20141217210226.GY24183@dastard>
In-Reply-To: <20141217210226.GY24183@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On 12/17/14 16:02, Dave Chinner wrote:
> On Wed, Dec 17, 2014 at 08:35:35PM +0100, Jan Kara wrote:
>>   Hello,
>>
>>   in my test KVM with today's Linus' kernel I'm getting xfs_repair
>> complaint about disconnected inodes after the test xfs/261 finishes
>> (with success). xfs_repair output is like:
>> xfs_repair -n /dev/vdb2
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>>         - agno = 1
>>         - agno = 2
>>         - agno = 3
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> disconnected inode 132, would move to lost+found
>> disconnected inode 133, would move to lost+found
>> Phase 7 - verify link counts...
>> No modify flag set, skipping filesystem flush and exiting.
>> ---
>> Given how trivial test xfs/261 is, it seems like created private mtab files
>> that also get unlinked don't get added to AGI unlinked list before umount.
>> I didn't have a detailed look whether that's possible or not and probably
>> won't get to it before Christmas. So I'm sending this just in case someone
>> more knowledgeable has ideas earlier...
> 
> I don't see that here. If you mount/unmount the filesystem, does the
> warning go away? i.e. xfs_repair -n ignores the contents of
> the log, so if the unlinked list transactions are in the log then
> log recovery will make everything good again.
> 
> That said, if unmount is not leaving the log clean, then we've still
> got an issue we need to get to the bottom of.
> 
> Cheers,
> 
> Dave.

I've seen this but seemingly only on v4-superblock XFS and only with Dave's 
xfsprogs RFC libxfs patches applied.  [Nice patchset, BTW.]  Will `git pull` 
everything again, then take it home to the x86 dungeon and test it again.

Good luck!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
