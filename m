Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LFrpfq008453 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 10:53:51 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBA0317B1EDD
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 08:55:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uu8fhn3mFjU0fFCH for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2009 08:55:25 -0700 (PDT)
Message-ID: <4ADF2EE8.6010700@sandeen.net>
Date: Wed, 21 Oct 2009 10:55:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
In-Reply-To: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>, xfs@oss.sgi.com

Amit Sahrawat wrote:
> Dear Eric,
> 
> 
> I am facing an issue with file deletion in XFS. Every time, I perform a
> remove operation the kernel crashes with the following prints.
> 

Old kernel I'm afraid.  Which ABI are you using?

I'd have to remind what's gone in since then, but at least this:

commit ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Mon Jun 23 13:23:32 2008 +1000

    [XFS] Pack some shortform dir2 structures for the ARM old ABI
    architecture.

    This should fix the longstanding issues with xfs and old ABI arm boxes,
    which lead to various asserts and xfs shutdowns, and for which an
    (incorrect) patch has been floating around for years.

    I've verified this patch by comparing the on-disk structure layouts
using
    pahole from the dwarves package, as well as running through a bit of
xfsqa
    under qemu-arm, modified so that the check/repair phase after each test
    actually executes check/repair from the x86 host, on the filesystem
    populated by the arm emulator. Thus far it all looks good.

    There are 2 other structures with extra padding at the end, but they
don't
    seem to cause trouble. I suppose they could be packed as well:
    xfs_dir2_data_unused_t and xfs_dir2_sf_t.

    Note that userspace needs a similar treatment, and any filesystems which
    were running with the previous rogue "fix" will now see corruption
(either
    in the kernel, or during xfs_repair) with this fix properly in place; it
    may be worth teaching xfs_repair to identify and fix that specific
issue.

    SGI-PV: 982930

    SGI-Modid: xfs-linux-melb:xfs-kern:31280a

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

comes to mind.

But, do you always get an error on the same dir & block nr?  Does an
xfs_repair fix it?  Maybe it's just plain ol' corruption.

-Eric

> # rm -rf 1* 2* 3* 4*
> xfs_da_do_buf: bno 16777216
> dir: inode 128
> Filesystem "sda1": XFS internal error xfs_da_do_buf(1) at line 1992 of
> file fs/xfs/xfs_da_btree.c.  Caller 0xc011d2e4
> [<c0022618>] (dump_stack+0x0/0x14) from [<c0129b2c>]
> (xfs_error_report+0x54/0x64)
> [<c0129ad8>] (xfs_error_report+0x0/0x64) from [<c011cea0>]
> (xfs_da_do_buf+0x334/0x6ec)
> [<c011cb6c>] (xfs_da_do_buf+0x0/0x6ec) from [<c011d2e4>]
> (xfs_da_read_buf+0x34/0x3c)
> [<c011d2b0>] (xfs_da_read_buf+0x0/0x3c) from [<c0126030>]
> (xfs_dir2_node_removename+0x278/0x500)
> [<c0125db8>] (xfs_dir2_node_removename+0x0/0x500) from [<c0120760>]
> (xfs_dir_removename+0x100/0x10c)
> [<c0120660>] (xfs_dir_removename+0x0/0x10c) from [<c0151be0>]
> (xfs_remove+0x280/0x424)
>  r6 = 00000000  r5 = 00000000  r4 = 0000357C
> [<c0151960>] (xfs_remove+0x0/0x424) from [<c015c3a0>]
> (xfs_vn_unlink+0x30/0x60)
> [<c015c370>] (xfs_vn_unlink+0x0/0x60) from [<c0091c58>]
> (vfs_unlink+0x70/0xac)
>  r7 = C3E79000  r6 = C3E5AE58  r5 = C4122EB8  r4 = 00000000
> [<c0091be8>] (vfs_unlink+0x0/0xac) from [<c0093fbc>]
> (do_unlinkat+0xcc/0x14c)
>  r6 = C4123D78  r5 = C4122EB8  r4 = 00000000
> [<c0093ef0>] (do_unlinkat+0x0/0x14c) from [<c0094054>]
> (sys_unlink+0x18/0x1c)
>  r7 = 0000000A  r6 = 0000000C  r5 = 00000008  r4 = BECE6A2B
> [<c009403c>] (sys_unlink+0x0/0x1c) from [<c001de40>]
> (ret_fast_syscall+0x0/0x2c)
> 
> *I am using kernel version - 2.6.18.1
> Platform - ARM
> *
> I have searched a lot on this issue, but no solution is available. In
> the FAQS it is mentioned that it's been fixed 2.6.17.7 onwards.
> But, i keep getting this issue frequently almost every time I do this
> operation .
> 
> Please provide me any help to sort this issue.
> 
> Thanks & Regards,
> Amit Sahrawat
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
