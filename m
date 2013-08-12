Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D1A467F52
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 11:51:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFA9C8F8037
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 09:51:28 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id AMPerlV1RzJXmogC for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 09:51:23 -0700 (PDT)
Message-ID: <5209126F.5020204@allmail.net>
Date: Mon, 12 Aug 2013 18:50:55 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
In-Reply-To: <5207D9C4.7020102@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> On 8/11/13 2:11 AM, Michael Maier wrote:
>> Hello!
>>
>> I think I'm facing the same problem as already described here:
>> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428
> 
> Maybe you can try the tracing Dave suggested in that thread?

I sent you a trace.




Meanwhile, I faced another problem on another xfs-file system with linux
3.10.5 which I never saw before. During writing a few bytes to disc, I
got "disc full" and the writing failed.

At the same time, df reported 69G of free space! I ran xfs_repair -n and
got:


xfs_repair -n /dev/mapper/raid0-daten2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
sb_ifree 591, counted 492
^^^^^^^^^^^^^^^^^^^^^^^^^
What does this mean? How can I get rid of it w/o loosing data? This file
system was created a few days ago and never resized.


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
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 5
        - agno = 1
        - agno = 4
        - agno = 2
        - agno = 7
        - agno = 3
        - agno = 6
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...



        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


Thanks,
regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
