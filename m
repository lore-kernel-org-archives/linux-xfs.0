Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2188E7F5D
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 11:38:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 025BC8F8081
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 09:38:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ctqn1a5bw0yUPmwk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Apr 2015 09:38:25 -0700 (PDT)
Date: Wed, 1 Apr 2015 12:38:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs corruption issue
Message-ID: <20150401163822.GC4756@bfoster.bfoster>
References: <CAC=x_0iFLbJwbKCKEe7XTKexex29wvbVQDvuN=SO5j9gX=u4rw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC=x_0iFLbJwbKCKEe7XTKexex29wvbVQDvuN=SO5j9gX=u4rw@mail.gmail.com>
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
To: Danny Shavit <danny@zadarastorage.com>
Cc: Lev Vainblat <lev@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Wed, Apr 01, 2015 at 05:09:11PM +0300, Danny Shavit wrote:
> Hello Dave,
> My name is Danny Shavit and I am with Zadara storage.
> We will appreciate your feedback reagrding an xfs_corruption and xfs_reapir
> issue.
> 
> We found a corrupted xfs volume in one of our systems. It is around 1 TB
> size and about 12 M files.
> We run xfs_repair on the volume which succeeded after 42 minutes.
> We noticed that memory consumption raised to about 7.5 GB.
> Since some customers are using only 4GB (and sometimes even 2 GB) we tried
> running "xfs_repair -m 3200" on a 4GB RAM machine.
> However, this time an OOM event happened during handling of AG 26 during
> step 3.
> The log of xfs_repair is enclosed below.
> We will appreciate your feedback on the amount of memory needed for
> xfs_repair in general and when using "-m" option specifically.
> The xfs metadata dump (prior to xfs_repair) can be found here:
> https://zadarastorage-public.s3.amazonaws.com/xfs/xfsdump-prod-ebs_2015-03-30_23-00-38.tgz
> It is a 1.2 GB file (and 5.7 GB uncompressed).
> 
> We will appreciate your feedback on the corruption pattern as well.

Have you tried something smaller, perhaps -m 2048? I just ran repair on
the metadump on a 4g vm. It oom'd with default options and completed in
a few minutes with -m 2048, though rss still peaked at around 3.6G.
Using -P seems to help at the cost of time. That took me ~20m, but rss
peaked around 2.4GB.

FWIW, I'm also on a recent xfsprogs:

# xfs_repair -V
xfs_repair version 3.2.2

Brian

> -- 
> Thank you,
> Danny Shavit
> Zadarastorage
> 
> ---------- xfs_repair log  ----------------
> root@vsa-00000428-vc-1:/export/4xfsdump# date; xfs_repair -v /dev/dm-55;
> date
> Tue Mar 31 02:28:04 PDT 2015
> Phase 1 - find and verify superblock...
>         - block cache size set to 735288 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 1920 tail block 1920
>         - scan filesystem freespace and inode maps...
> agi_freecount 54, counted 55 in ag 7
> sb_ifree 947, counted 948
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>          - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
> bad . entry in directory inode 5691013154, was 5691013170: correcting
> bad . entry in directory inode 5691013156, was 5691013172: correcting
> bad . entry in directory inode 5691013157, was 5691013173: correcting
> bad . entry in directory inode 5691013163, was 5691013179: correcting
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26   (Danny: OOM occurred here with -m 3200)
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - agno = 32
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - agno = 32
> Phase 5 - rebuild AG headers and trees...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - agno = 32
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
> entry "SavedXML" in dir inode 2992927241 inconsistent with .. value
> (4324257659) in ino 5691013156
>         will clear entry "SavedXML"
> rebuilding directory inode 2992927241
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
> entry "Out" in dir inode 4324257659 inconsistent with .. value (2992927241)
> in ino 5691013172
>         will clear entry "Out"
> rebuilding directory inode 4324257659
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
> entry "tocs_file" in dir inode 5691012138 inconsistent with .. value
> (3520464676) in ino 5691013154
>         will clear entry "tocs_file"
> entry "trees.log" in dir inode 5691012138 inconsistent with .. value
> (3791956240) in ino 5691013155
>         will clear entry "trees.log"
> rebuilding directory inode 5691012138
> entry "filelist.xml" in directory inode 5691012139 not consistent with ..
> value (1909707067) in inode 5691013157,
> junking entry
> fixing i8count in inode 5691012139
> entry "image001.jpg" in directory inode 5691012140 not consistent with ..
> value (2450176033) in inode 5691013163,
> junking entry
> fixing i8count in inode 5691012140
> entry "OCR" in dir inode 5691013154 inconsistent with .. value (5691013170)
> in ino 1909707065
>         will clear entry "OCR"
> entry "Tmp" in dir inode 5691013154 inconsistent with .. value (5691013170)
> in ino 2179087403
>         will clear entry "Tmp"
> entry "images" in dir inode 5691013154 inconsistent with .. value
> (5691013170) in ino 2450176007
>         will clear entry "images"
> rebuilding directory inode 5691013154
> entry "286_Kellman_Hoffer_Master.pdf_files" in dir inode 5691013156
> inconsistent with .. value (5691013172) in ino 834535727
>         will clear entry "286_Kellman_Hoffer_Master.pdf_files"
> rebuilding directory inode 5691013156
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - agno = 25
>         - agno = 26
>         - agno = 27
>         - agno = 28
>         - agno = 29
>         - agno = 30
>         - agno = 31
>         - agno = 32
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected dir inode 834535727, moving to lost+found
> disconnected dir inode 1909707065, moving to lost+found
> disconnected dir inode 2179087403, moving to lost+found
> disconnected dir inode 2450176007, moving to lost+found
> disconnected dir inode 5691013154, moving to lost+found
> disconnected dir inode 5691013155, moving to lost+found
> disconnected dir inode 5691013156, moving to lost+found
> disconnected dir inode 5691013157, moving to lost+found
> disconnected dir inode 5691013163, moving to lost+found
> disconnected dir inode 5691013172, moving to lost+found
> Phase 7 - verify and correct link counts...
> resetting inode 81777983 nlinks from 2 to 12
> resetting inode 1909210410 nlinks from 1 to 2
> resetting inode 1909707067 nlinks from 3 to 2
> resetting inode 2450176033 nlinks from 18 to 17
> resetting inode 2992927241 nlinks from 13 to 12
> resetting inode 3520464676 nlinks from 13 to 12
> resetting inode 3791956240 nlinks from 13 to 12
> resetting inode 4324257659 nlinks from 13 to 12
> resetting inode 5691013154 nlinks from 5 to 2
> resetting inode 5691013156 nlinks from 3 to 2
> 
>         XFS_REPAIR Summary    Tue Mar 31 03:11:00 2015
> 
> Phase           Start           End             Duration
> Phase 1:        03/31 02:28:04  03/31 02:28:05  1 second
> Phase 2:        03/31 02:28:05  03/31 02:28:42  37 seconds
> Phase 3:        03/31 02:28:42  03/31 02:48:29  19 minutes, 47 seconds
> Phase 4:        03/31 02:48:29  03/31 02:55:40  7 minutes, 11 seconds
> Phase 5:        03/31 02:55:40  03/31 02:55:43  3 seconds
> Phase 6:        03/31 02:55:43  03/31 03:10:57  15 minutes, 14 seconds
> Phase 7:        03/31 03:10:57  03/31 03:10:57
> 
> Total run time: 42 minutes, 53 seconds
> done
> Tue Mar 31 03:11:01 PDT 2015

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
