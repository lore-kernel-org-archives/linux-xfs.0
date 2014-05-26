Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DB1C7F3F
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 00:19:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47C9E8F8037
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 22:19:04 -0700 (PDT)
Received: from mail-yh0-f45.google.com (mail-yh0-f45.google.com
	[209.85.213.45]) by cuda.sgi.com with ESMTP id iEbGyiH3CfPw8oi9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 25 May 2014 22:18:59 -0700 (PDT)
Received: by mail-yh0-f45.google.com with SMTP id b6so6029506yha.4
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 22:18:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140526041958.GV8554@dastard>
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
	<CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
	<20140526000813.GS8554@dastard> <20140526011904.GT8554@dastard>
	<20140526041958.GV8554@dastard>
Date: Mon, 26 May 2014 08:18:59 +0300
Message-ID: <CALkh-HgGuGaR3rimNeCgRUexU1LgKMbSZ+WcPMmzD6UwtVC7pQ@mail.gmail.com>
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
From: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?= <plamen.sisi@gmail.com>
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
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

2014-05-26 7:19 GMT+03:00 Dave Chinner <david@fromorbit.com>:
> On Mon, May 26, 2014 at 11:19:04AM +1000, Dave Chinner wrote:
>> On Mon, May 26, 2014 at 10:08:13AM +1000, Dave Chinner wrote:
>> > On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
>> > > On Mon, May 5, 2014 at 11:34 AM, Plamen Petrov <plamen.sisi@gmail.com> wrote:
>> > > >
>> > > > The story short: on systems with btrfs root I have a kernel .config with ext4,
>> > > > xfs and btrfs built-in which works fine with 3.13.x, but 3.14.x panics. After
>> > > > inserting some debug printks, I got this info from mount_block_root:
>> > > >
>> > > > ---> EACCESS=13, EINVAL=22, Available filesystems: ext3 ext2 ext4 fuseblk xfs btrfs
>> > > > -----> Tried ext3, error code is -22.
>> > > > -----> Tried ext2, error code is -22.
>> > > > -----> Tried ext4, error code is -22.
>> > > > -----> Tried fuseblk, error code is -22.
>> > > > -----> Tried xfs, error code is -38.
>> > > > VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
>> > > > Please append a correct "root=" boot option; here are the available partitions:
>>
>> BTW, This is the original thread with lots of triage in it:
>>
>> http://www.spinics.net/lists/linux-btrfs/msg33455.html
>>
>> But that doesn't reach any conclusion. I suspect that the
>> change of btrfs init (from very early (@~1.8s into the boot) until a
>> few milliseconds before the root mount is changing the order in
>> which the filesystem type list is traversed by the mount, resulting
>> in XFS being used to probe the device before btrfs.
>
> On that point, on 3.15-rc6:
>
> $ tail -1 /proc/filesystems
>         btrfs
> $
>
>> Why XFS is seeing /dev/sda2 as containing an XFS filesystem is not
>> yet clear, but perhaps once you've dumped the the first sector of
>> the btrfs partition all will become clear....
>
> No need, I found the regression. Plamen, can you please try the
> patch below?
>

Yes, Dave. I applied your patch on top of linux 3.15-rc5. I tried the patch
you sent in a VM I used for tests.

With only your patch applied - the system boots up normally.

Thanks for the different perspectives, guys! Always a pleasure
communicating with you. After a month or so waiting - definetly worth it!

Thanks a lot!
-- 
Plamen Petrov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
