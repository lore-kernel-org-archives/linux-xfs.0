Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ODNq6Y081570 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 08:23:53 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 028D51210037
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 06:32:44 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id h1uhlVwu5DOhAsFB for
	<xfs@oss.sgi.com>; Wed, 24 Jun 2009 06:32:44 -0700 (PDT)
Message-ID: <4A4228DE.6040104@sandeen.net>
Date: Wed, 24 Jun 2009 08:23:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
In-Reply-To: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
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
To: Nitin Arora <nitin.arora.del@gmail.com>
Cc: xfs@oss.sgi.com

Nitin Arora wrote:
> Hi,
> 
> I am using linux kernel 2.6.18 with XFS support.
> I have formatted USB hard drive with XFS. When I try to copy
> (i.e. cp 1.avi 2.avi) a big file (size : 1.3 GB) from one
> location to another on the same hard drive It corrupts the
> hard drive with the following back trace.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=71a8c87fb300b601eacf7a86cc6c6322fe827bfd

fixed a longstanding in-memory extent corruption, but that's my only
guess at this point.  As Michael said, 2.6.18 is getting very old, and
unless you have a vendor supporting it (in which case you should
probably ask them...) you will probably have trouble getting help with
problems in it, I'm afraid, because it is several years old.

(however, if this is mission critical we could point you to people who
can do contract work to help)

-Eric

> /XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1588 of file
> fs/xfs/xfs_alloc.c.  Caller 0xc0131a70
> [<c0024618>] (dump_stack+0x0/0x14) from [<c0158ae0>]
> (xfs_error_report+0x54/0x64)
> [<c0158a8c>] (xfs_error_report+0x0/0x64) from [<c012fcf0>]
> (xfs_free_ag_extent+0xec/0x768)
> [<c012fc04>] (xfs_free_ag_extent+0x0/0x768) from [<c0131a70>]
> (xfs_free_extent+0xa0/0xbc)
> [<c01319d0>] (xfs_free_extent+0x0/0xbc) from [<c0140dd0>]
> (xfs_bmap_finish+0xec/0x184)
> r7 = CBF826F8  r6 = 00000000  r5 = 000357B8  r4 = CB7CF708
> [<c0140ce4>] (xfs_bmap_finish+0x0/0x184) from [<c01633b8>]
> (xfs_itruncate_finish+0x1c8/0x2fc)
> [<c01631f0>] (xfs_itruncate_finish+0x0/0x2fc) from [<c01814b0>]
> (xfs_inactive+0x278/0x89c)/
> 
> I have searched on the internet about and found that many people are
> facing the same problem,
> But no solution is found.
> 
> Can you guide me Or answer the following questions.
> *
> 1. Is there any patch available which solves this problem.
> 2. If there is no patch available so far then can you give me
>   some pointers which will help in solving the problem.*
> 
> Thanks in advance
> 
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
