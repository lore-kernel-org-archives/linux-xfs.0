Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA4FoAkp101660 for <xfs@oss.sgi.com>; Fri, 4 Nov 2011 10:50:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A27D4101895A
	for <xfs@oss.sgi.com>; Fri,  4 Nov 2011 08:50:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id eEyrKebTv6XJ8bT3 for <xfs@oss.sgi.com>;
	Fri, 04 Nov 2011 08:50:09 -0700 (PDT)
Message-ID: <4EB409B0.4050302@sandeen.net>
Date: Fri, 04 Nov 2011 10:50:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsp_repair segfault (3.1.4 & 3.1.6)
References: <4EAAED63.9050804@otenet.gr>
In-Reply-To: <4EAAED63.9050804@otenet.gr>
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
To: nanashi <nanashi@otenet.gr>
Cc: xfs@oss.sgi.com

On 10/28/11 12:58 PM, nanashi wrote:
> Hi,
> 
> I have a corrupted RAID5 xfs filesystem from an intel SS-4000 NAS storage.
> I'm using slackware-current with 2.6.39.3-smp kernel (32bit & 64bit)
> When i try xfs_repair I get
> 
> xfs_repair: dir2.c:2133: process_dir2: Assertion `(ino
> !=mp->m_sb.sb_rootino && ino != *parent) || (ino ==
> mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
> 
> I try both x86 and x86_64, I build 3.1.4 and 3.1.6 with DEBUG=-DNDEBUG and both continue but gave me a segfault
> 
> [23978.718305] xfs_repair[25800]: segfault at 7fffa1d81ff0 ip 00007f15c1852049 sp 00007fffa257f048 error 6 in libc-2.13.so[7f15c1715000+19b000]
> 
> I try xfs_metadump and I get segfault too.
> 
> The partition is 2.2TB and I don't have enough space to dd it to an image.
> 
> I attach the xfs_repair output before the segfault.
> 
> any help is appreciated.
> 

A corefile + debug binary would be helpful too...

Argh, if metadump segfaults, that will make things tough.

At least with a core + binary we could see just where it blew up.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
