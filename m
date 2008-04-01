Return-Path: <thorkr@gmail.com>
Date: Tue, 01 Apr 2008 20:20:19 +0200
From: Thor Kristoffersen <thorkr@gmail.com>
Subject: Re: Does XFS prevent disk spindown?
In-reply-to: <47F1CF6D.2040103@sandeen.net>
Message-id: <m2d4p9o2sc.fsf@getmail.no>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <m2tzimbvif.fsf@getmail.no> <20080401003005.GJ103491721@sgi.com>
 <47F1CF6D.2040103@sandeen.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com
List-ID: <xfs>

Eric Sandeen <sandeen@sandeen.net> writes:
> David Chinner wrote:
>> On Mon, Mar 31, 2008 at 08:26:00PM +0200, Thor Kristoffersen wrote:
>>> I've noticed that when I spin down XFS-mounted disks they spin up again
>>> shortly afterwards.  I used iostat to monitor disk accesses to a mounted
>>> partition (with noatime) in single user mode.  Apparently there is a write
>>> access to the partition approximately every 35 seconds, even if the
>>> partition is idle.  As far as I can understand, since there is no data that
>>> needs to be flushed this must be done by an XFS daemon for some purpose.
>
> Use blktrace, or echo 1 > /proc/sys/vm/block_dump to see what block and
> who's writing it...  it's probably the superblock?  what kernel?

This is kernel version 2.6.24.  More specifically it's a Debian kernel from
package linux-image-2.6.24-1-686 (2.6.24-4).

I put the system in runlevel 1 and executed the test as you suggested.  On
/dev/sda3 I have mounted (with noatime) an XFS filesystem that contains
data that is not supposed to be accessed by any process.  In the output
below I have filtered out all accesses to other partitions.  (BTW, this is
not actually the disk that I wanted to spin down, but I think the log
proves my point.)


Thor

------------------------------------------------------

Tue Apr  1 18:51:27 CEST 2008
xfssyncd(3426): WRITE block 682946473 on sda3
Tue Apr  1 18:51:32 CEST 2008
Tue Apr  1 18:51:37 CEST 2008
Tue Apr  1 18:51:42 CEST 2008
Tue Apr  1 18:51:47 CEST 2008
Tue Apr  1 18:51:52 CEST 2008
Tue Apr  1 18:51:57 CEST 2008
Tue Apr  1 18:52:02 CEST 2008
xfssyncd(3426): WRITE block 682946475 on sda3
Tue Apr  1 18:52:07 CEST 2008
Tue Apr  1 18:52:12 CEST 2008
Tue Apr  1 18:52:17 CEST 2008
Tue Apr  1 18:52:22 CEST 2008
Tue Apr  1 18:52:27 CEST 2008
Tue Apr  1 18:52:32 CEST 2008
Tue Apr  1 18:52:37 CEST 2008
Tue Apr  1 18:52:42 CEST 2008
xfssyncd(3426): WRITE block 682946477 on sda3
Tue Apr  1 18:52:47 CEST 2008
Tue Apr  1 18:52:52 CEST 2008
Tue Apr  1 18:52:57 CEST 2008
Tue Apr  1 18:53:02 CEST 2008
Tue Apr  1 18:53:07 CEST 2008
Tue Apr  1 18:53:12 CEST 2008
Tue Apr  1 18:53:17 CEST 2008
xfssyncd(3426): WRITE block 682946479 on sda3
Tue Apr  1 18:53:22 CEST 2008
Tue Apr  1 18:53:27 CEST 2008
Tue Apr  1 18:53:32 CEST 2008
Tue Apr  1 18:53:37 CEST 2008
Tue Apr  1 18:53:42 CEST 2008
Tue Apr  1 18:53:47 CEST 2008
Tue Apr  1 18:53:52 CEST 2008
xfssyncd(3426): WRITE block 682946481 on sda3
Tue Apr  1 18:53:57 CEST 2008
Tue Apr  1 18:54:02 CEST 2008
Tue Apr  1 18:54:07 CEST 2008
Tue Apr  1 18:54:12 CEST 2008
Tue Apr  1 18:54:17 CEST 2008
Tue Apr  1 18:54:22 CEST 2008
Tue Apr  1 18:54:27 CEST 2008
xfssyncd(3426): WRITE block 682946483 on sda3
Tue Apr  1 18:54:32 CEST 2008
Tue Apr  1 18:54:37 CEST 2008
Tue Apr  1 18:54:42 CEST 2008
Tue Apr  1 18:54:47 CEST 2008
Tue Apr  1 18:54:52 CEST 2008
Tue Apr  1 18:54:57 CEST 2008
Tue Apr  1 18:55:02 CEST 2008
xfssyncd(3426): WRITE block 682946485 on sda3
Tue Apr  1 18:55:07 CEST 2008
Tue Apr  1 18:55:12 CEST 2008
Tue Apr  1 18:55:17 CEST 2008
Tue Apr  1 18:55:22 CEST 2008
Tue Apr  1 18:55:27 CEST 2008
Tue Apr  1 18:55:32 CEST 2008
Tue Apr  1 18:55:37 CEST 2008
xfssyncd(3426): WRITE block 682946487 on sda3
Tue Apr  1 18:55:42 CEST 2008
Tue Apr  1 18:55:47 CEST 2008
Tue Apr  1 18:55:52 CEST 2008
Tue Apr  1 18:55:57 CEST 2008
Tue Apr  1 18:56:02 CEST 2008
Tue Apr  1 18:56:07 CEST 2008
Tue Apr  1 18:56:12 CEST 2008
Tue Apr  1 18:56:17 CEST 2008
xfssyncd(3426): WRITE block 682946489 on sda3
Tue Apr  1 18:56:22 CEST 2008
Tue Apr  1 18:56:27 CEST 2008
Tue Apr  1 18:56:32 CEST 2008
Tue Apr  1 18:56:37 CEST 2008
Tue Apr  1 18:56:42 CEST 2008
Tue Apr  1 18:56:47 CEST 2008
Tue Apr  1 18:56:52 CEST 2008
xfssyncd(3426): WRITE block 682946491 on sda3
Tue Apr  1 18:56:57 CEST 2008
Tue Apr  1 18:57:02 CEST 2008
Tue Apr  1 18:57:07 CEST 2008
Tue Apr  1 18:57:12 CEST 2008
Tue Apr  1 18:57:17 CEST 2008
Tue Apr  1 18:57:22 CEST 2008
Tue Apr  1 18:57:27 CEST 2008
xfssyncd(3426): WRITE block 682946493 on sda3
Tue Apr  1 18:57:32 CEST 2008
Tue Apr  1 18:57:37 CEST 2008
Tue Apr  1 18:57:42 CEST 2008
Tue Apr  1 18:57:47 CEST 2008
Tue Apr  1 18:57:52 CEST 2008
Tue Apr  1 18:57:57 CEST 2008
Tue Apr  1 18:58:02 CEST 2008
xfssyncd(3426): WRITE block 682946495 on sda3
Tue Apr  1 18:58:07 CEST 2008
Tue Apr  1 18:58:12 CEST 2008
Tue Apr  1 18:58:17 CEST 2008
Tue Apr  1 18:58:22 CEST 2008
