Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0QIVn6I242939 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 12:31:49 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F306B24FC
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 10:31:06 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id BrHWwTV8XThGwrc6 for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2009 10:31:06 -0800 (PST)
Message-ID: <497E0163.8010207@sandeen.net>
Date: Mon, 26 Jan 2009 12:30:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair refuse to repair my corrupted xfs partition
References: <6efe08af0901252337m22844fc2yee3cef2a8ed8ac6@mail.gmail.com>
In-Reply-To: <6efe08af0901252337m22844fc2yee3cef2a8ed8ac6@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
Cc: xfs@oss.sgi.com

Vitaly V. Ch wrote:
> Hi All!

...

> #xfs_repai /dev/loop0
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> entry "" in shortform directory 128 references invalid inode 0
> zero length entry in shortform dir 128, junking 3 entries
> corrected entry count in directory 128, was 3, now 0
> corrected directory 128 size, was 69, now 6
> bogus .. inode number (0) in directory inode 128, clearing inode number
> xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino !=
> mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino
> && (ino == *parent || need_root_dotdot == 1))' failed.
> 
> 
> What I can do for repair my data? There was no hardware failure

you haven't said what version of xfs_repair you're using; if you are not
using the latest (2.10.2) please try that first.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
