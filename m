Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Apr 2007 00:42:46 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3R7gbfB031035
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 00:42:39 -0700
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.197])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3R7gZSt002420
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 16:42:35 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3R7gZf29503 for xfs@oss.sgi.com; Fri, 27 Apr 2007 16:42:35 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3R7gZL16455 for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 16:42:35 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070427.164234.75002200 for <xfs@oss.sgi.com>
	; Fri, 27 Apr 2007 16:42:35 +0900
Message-Id: <200704270742.AA05287@TNESG9305.tnes.nec.co.jp>
From: Utako Kusaka <utako@tnes.nec.co.jp>
Date: Fri, 27 Apr 2007 16:42:27 +0900
Subject: Re: [PATCH] Fix segmentation fault when using xfs_quota state
	command.
In-Reply-To: <1177646302.6273.386.camel@edge>
References: <1177646302.6273.386.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com

Thanks for your comment.
I thought processes after fopen_write_secure() is not necessary
when the path list is empty.
But is creating an empty file necessary when specifying -f option?
This option isn't written in man page:)

--
Utako

Fri, 27 Apr 2007 13:58:22 +1000 Nathan Scott wrote：
>On Fri, 2007-04-27 at 11:40 +0900, Utako Kusaka wrote:
>> +	if (!fs_count)
>> +		return 0;
>> +
>
>Is the segfault due to this line in state.c?
>237             else if (fs_path->fs_flags & FS_MOUNT_POINT)
>
>If so, a fix that is more clear to the reader might be:
>
>- else if (fs_path->fs_flags & FS_MOUNT_POINT)
>+ else if (fs_path && fs_path->fs_flags & FS_MOUNT_POINT)
>
>This keeps the fix alongside the problematic access to fs_path.
>
>cheers.
>
>-- 
>Nathan
