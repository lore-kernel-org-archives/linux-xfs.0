Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D7B497CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 21:55:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C1EA8F804C
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 19:55:13 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	Z0C7RCiWuvdbKHh1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 19:55:10 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id g203so83295622iof.2
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 19:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
	<56E8AA22.7080301@sandeen.net>
	<CAJCQCtQYMitUvPN1ORyEHvDhddJ09Hp_xK_CBc0e1Cu972S3_w@mail.gmail.com>
	<CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
Date: Wed, 16 Mar 2016 20:55:09 -0600
Message-ID: <CAJCQCtT0j5Z6gL7N7z4kT-mj2vq6dh_FaMX8mc1WsvUik6S-pw@mail.gmail.com>
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
From: Chris Murphy <lists@colorremedies.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 16, 2016 at 8:39 PM, Chris Murphy <lists@colorremedies.com> wrote:

> # xfs_repair -n /dev/VG/testxfs

It's amateur hour... yes I did unmount before running xfs_repair or it
fails. And I also did the test on conventional LV, not thinp.

If I do the same test on a thinp LV, I consistently get more errors
(than conventional LV) when I run xfs_repair, probably because there
are 4x the AG's on thinp LV's for some reason.

# xfs_repair -n /dev/VG/testxfs
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
Metadata corruption detected at xfs_agf block 0x72ff488/0x1000
Metadata corruption detected at xfs_agf block 0x90ff188/0x1000Metadata
corruption detected at xfs_agf block 0x8bff208/0x1000

Metadata corruption detected at xfs_agf block 0x86ff288/0x1000
Metadata corruption detected at xfs_agf block 0x81ff308/0x1000
Metadata corruption detected at xfs_agf block 0x77ff408/0x1000
Metadata corruption detected at xfs_agf block 0x7cff388/0x1000
fllast 1014 in agf 23 too large (max = 1014)
Metadata corruption detected at xfs_agf block 0x6dff508/0x1000
Metadata corruption detected at xfs_agf block 0x68ff588/0x1000Metadata
corruption detected at xfs_agf block 0x63ff608/0x1000

Metadata corruption detected at xfs_agf block 0x5eff688/0x1000
Metadata corruption detected at xfs_agf block 0x54ff788/0x1000
Metadata corruption detected at xfs_agf block 0x59ff708/0x1000
Metadata corruption detected at xfs_agf block 0x4fff808/0x1000
fllast 1014 in agf 28 too large (max = 1014)
fllast 1014 in agf 27 too large (max = 1014)
fllast 1014 in agf 26 too large (max = 1014)
fllast 1014 in agf 29 too large (max = 1014)
fllast 1014 in agf 25 too large (max = 1014)
fllast 1014 in agf 24 too large (max = 1014)
fllast 1014 in agf 22 too large (max = 1014)
fllast 1014 in agf 21 too large (max = 1014)
fllast 1014 in agf 19 too large (max = 1014)
fllast 1014 in agf 20 too large (max = 1014)
fllast 1014 in agf 17 too large (max = 1014)
fllast 1014 in agf 18 too large (max = 1014)
fllast 1014 in agf 16 too large (max = 1014)
Metadata corruption detected at xfs_agf block 0x9fff008/0x1000
Metadata corruption detected at xfs_agf block 0x95ff108/0x1000
fllast 1014 in agf 32 too large (max = 1014)
fllast 1014 in agf 30 too large (max = 1014)
Metadata corruption detected at xfs_agf block 0x9aff088/0x1000
fllast 1014 in agf 31 too large (max = 1014)
        - 20:51:37: scanning filesystem freespace - 33 of 33
allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 20:51:37: scanning agi unlinked lists - 33 of 33 allocation
groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 30
        - agno = 15
        - agno = 1
        - agno = 31
        - agno = 16
        - agno = 2
        - agno = 3
        - agno = 17
        - agno = 32
        - agno = 4
        - agno = 18
        - agno = 19
        - agno = 5
        - agno = 20
        - agno = 6
        - agno = 21
        - agno = 7
        - agno = 22
        - agno = 8
        - agno = 23
        - agno = 9
        - agno = 24
        - agno = 10
        - agno = 25
        - agno = 11
        - agno = 26
        - agno = 12
        - agno = 27
        - agno = 13
        - agno = 28
        - agno = 14
        - agno = 29
        - 20:51:37: process known inodes and inode discovery - 64 of
64 inodes done
        - process newly discovered inodes...
        - 20:51:37: process newly discovered inodes - 33 of 33
allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 20:51:37: setting up duplicate extent list - 33 of 33
allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 2
        - agno = 3
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
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 4
        - agno = 0
        - agno = 5
        - 20:51:37: check for inodes claiming duplicate blocks - 64 of
64 inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.



-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
