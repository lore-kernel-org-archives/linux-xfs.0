Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 23:00:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m315xdEH006595
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 22:59:40 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D36671D0EB
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 23:00:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id C0Nb4JtgNDG0SCv8 for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 23:00:14 -0700 (PDT)
Message-ID: <47F1CF6D.2040103@sandeen.net>
Date: Tue, 01 Apr 2008 01:00:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Does XFS prevent disk spindown?
References: <m2tzimbvif.fsf@getmail.no> <20080401003005.GJ103491721@sgi.com>
In-Reply-To: <20080401003005.GJ103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Thor Kristoffersen <thorkr@gmail.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Mon, Mar 31, 2008 at 08:26:00PM +0200, Thor Kristoffersen wrote:
>> I've noticed that when I spin down XFS-mounted disks they spin up again
>> shortly afterwards.  I used iostat to monitor disk accesses to a mounted
>> partition (with noatime) in single user mode.  Apparently there is a write
>> access to the partition approximately every 35 seconds, even if the
>> partition is idle.  As far as I can understand, since there is no data that
>> needs to be flushed this must be done by an XFS daemon for some purpose.

Use blktrace, or echo 1 > /proc/sys/vm/block_dump to see what block and
who's writing it...  it's probably the superblock?  what kernel?

On an idle-in-gdm 2.6.25 system, xfs root, I see something like this
from block_dump... it does settle out after a while:

# while true
> do
> date
> sleep 5
> dmesg -c
> done

bash(2986): READ block 448128 on sda2
bash(2986): dirtied inode 820453 (date) on sda2
date(2986): READ block 448160 on sda2
bash(2987): READ block 449736 on sda2
bash(2987): dirtied inode 820470 (sleep) on sda2
sleep(2987): READ block 449768 on sda2
Tue Apr  1 00:24:12 CDT 2008
xfssyncd(465): dirtied inode 128 (/) on sda2
xfssyncd(465): WRITE block 10246607 on sda2
Tue Apr  1 00:24:17 CDT 2008
Tue Apr  1 00:24:22 CDT 2008
Tue Apr  1 00:24:27 CDT 2008
Tue Apr  1 00:24:32 CDT 2008
Tue Apr  1 00:24:37 CDT 2008
Tue Apr  1 00:24:42 CDT 2008
pdflush(178): WRITE block 64 on sda2
Tue Apr  1 00:24:47 CDT 2008
Tue Apr  1 00:24:52 CDT 2008
Tue Apr  1 00:24:57 CDT 2008
Tue Apr  1 00:25:02 CDT 2008
Tue Apr  1 00:25:07 CDT 2008
Tue Apr  1 00:25:12 CDT 2008
xfssyncd(465): dirtied inode 128 (/) on sda2
xfssyncd(465): WRITE block 10246609 on sda2
Tue Apr  1 00:25:17 CDT 2008
Tue Apr  1 00:25:22 CDT 2008
Tue Apr  1 00:25:27 CDT 2008
Tue Apr  1 00:25:32 CDT 2008
Tue Apr  1 00:25:37 CDT 2008
Tue Apr  1 00:25:42 CDT 2008
pdflush(178): WRITE block 64 on sda2
Tue Apr  1 00:25:47 CDT 2008
Tue Apr  1 00:25:52 CDT 2008
Tue Apr  1 00:25:57 CDT 2008
Tue Apr  1 00:26:02 CDT 2008
Tue Apr  1 00:26:07 CDT 2008
Tue Apr  1 00:26:12 CDT 2008
Tue Apr  1 00:26:17 CDT 2008
Tue Apr  1 00:26:22 CDT 2008
Tue Apr  1 00:26:27 CDT 2008
Tue Apr  1 00:26:32 CDT 2008
Tue Apr  1 00:26:37 CDT 2008
Tue Apr  1 00:26:42 CDT 2008
Tue Apr  1 00:26:47 CDT 2008
Tue Apr  1 00:26:52 CDT 2008
Tue Apr  1 00:26:57 CDT 2008
Tue Apr  1 00:27:02 CDT 2008
Tue Apr  1 00:27:07 CDT 2008
Tue Apr  1 00:27:12 CDT 2008
Tue Apr  1 00:27:17 CDT 2008
Tue Apr  1 00:27:22 CDT 2008
Tue Apr  1 00:27:27 CDT 2008
Tue Apr  1 00:27:32 CDT 2008
Tue Apr  1 00:27:37 CDT 2008
Tue Apr  1 00:27:42 CDT 2008
Tue Apr  1 00:27:47 CDT 2008
Tue Apr  1 00:27:52 CDT 2008
Tue Apr  1 00:27:57 CDT 2008
Tue Apr  1 00:28:02 CDT 2008
Tue Apr  1 00:28:07 CDT 2008
Tue Apr  1 00:28:12 CDT 2008
Tue Apr  1 00:28:17 CDT 2008
Tue Apr  1 00:28:22 CDT 2008
Tue Apr  1 00:28:27 CDT 2008
Tue Apr  1 00:28:32 CDT 2008
Tue Apr  1 00:28:37 CDT 2008
Tue Apr  1 00:28:42 CDT 2008
Tue Apr  1 00:28:47 CDT 2008
Tue Apr  1 00:28:52 CDT 2008
Tue Apr  1 00:28:57 CDT 2008
Tue Apr  1 00:29:02 CDT 2008
Tue Apr  1 00:29:07 CDT 2008
Tue Apr  1 00:29:12 CDT 2008
Tue Apr  1 00:29:17 CDT 2008
Tue Apr  1 00:29:22 CDT 2008
Tue Apr  1 00:29:27 CDT 2008
Tue Apr  1 00:29:32 CDT 2008
Tue Apr  1 00:29:37 CDT 2008
Tue Apr  1 00:29:42 CDT 2008
Tue Apr  1 00:29:47 CDT 2008
Tue Apr  1 00:29:52 CDT 2008
Tue Apr  1 00:29:57 CDT 2008
....


-Eric

>> Is there any setting or mount option I can use to get rid of this behavior?
>> I know I can freeze the filesystem, but then I have to remember to unfreeze
>> it every time I need to write to it, so it's not an ideal solution.
> 
> Turn on laptop mode?
> 
> Cheers,
> 
> Dave.
