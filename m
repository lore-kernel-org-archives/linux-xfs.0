Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 15:55:14 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QMt7fB014517
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 15:55:09 -0700
Subject: Re: Unexpected XFS SB number 0x00000000
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200704262146.59921.martin.eisenhardt@wiai.uni-bamberg.de>
References: <200704262146.59921.martin.eisenhardt@wiai.uni-bamberg.de>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 08:57:19 +1000
Message-Id: <1177628239.6273.374.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Eisenhardt <martin.eisenhardt@wiai.uni-bamberg.de>
Cc: xfs@oss.sgi.com

On Thu, 2007-04-26 at 21:46 +0200, Martin Eisenhardt wrote:
> Hello list(s),
> 
> I run XFS on a software raid on Linux 2.6.19. When I invoke xfs_db in 
> read-only mode, I get:
> 
> # xfs_db -r /dev/md0
> xfs_db: unexpected XFS SB magic number 0x00000000
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> Segmentation fault

I think this segfault is fixed in recent xfs_db versions.

> The system is still running, the filesystem seems to be fine (except for the 
> above): files are created, written, and deleted without any problem.
> 
> So, I have two questions:
> 
> * Is there a real problem, or might a quick reboot solve this?

It looks like a real problem to me - something has written zeroes to
the start of your partition, where the primary XFS superblock should
be.  If the filesystem is still mounted(?), I'd
a/ make a backup copy of anything/everything precious there
b/ try to get the incore copy of the XFS superblock flushed out (this
assumes still mounted) - creater a file & use sync(1) - you might get
lucky.

> * If there is a real problem with the file system: What steps do you recommend 
> to overcome this problem?
> * How safe is it to run xfs_check and xfs_repair?

If you really have zeroes over your primary superblock, xfs_repair
is your only option to fix that really (after unmounting).  You
wont get much joy from xfs_check, as its just a shell script wrapper
around the xfs_db "check" command.

> P.S.: Sorry for cross-posting, I just figure that maybe the XFS users on 
> non-linux systems might have a hint or two for me ... ;-)

Theres only one list (both addresses point to the same place).

cheers.

-- 
Nathan
