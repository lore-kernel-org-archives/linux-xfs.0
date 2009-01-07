Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07EhDSw008704 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 08:43:13 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8B451B34BAD
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 06:43:12 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 5JwdkwfNOTUXvajA for
	<xfs@oss.sgi.com>; Wed, 07 Jan 2009 06:43:12 -0800 (PST)
Message-ID: <4964BF7E.6060906@sandeen.net>
Date: Wed, 07 Jan 2009 08:43:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db problem
References: <4964BD79.20806@poczta.onet.pl>
In-Reply-To: <4964BD79.20806@poczta.onet.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: aluno <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

aluno wrote:
> Hello,
> 
> Recently we've noticed that xfs_admin (xfs_db ver. 2.10.2) causes
> segfault or FP traps while trying
> to use following command on FAT partition:
> 
> # xfs_admin -u /dev/sda1
> xfs_admin: unexpected XFS SB magic number 0xeb58906d
> Floating point exception
> 
> and then makes error in dmesg:
> 
> xfs_db[10385] trap divide error ip:80b32b0 sp:fffbd900 error:0 in
> xfs_db[8048000+7f000]
> 
> We know that xfs_admin is dedicated tool for XFS only not for FAT or
> other filesystems,
> but we would like to have xfs_db which will be able to cope with non-xfs
> filesystems also.
> 
> After some investigations we've found some place and put there exit(1) -
> in xfsprogs-2.10.2/db/init.c
> 
> in init() procedure:
> 
>     (...)
>         sbp = &xmount.m_sb;
>         if (sbp->sb_magicnum != XFS_SB_MAGIC) {
>                 fprintf(stderr, _("%s: unexpected XFS SB magic number
> 0x%08x\n"),
>                         progname, sbp->sb_magicnum);
>                 exit(1);
>         }
>     (...)
> 
> 
> 
> Is it the right way to fix this problem?

The thing is, xfs_db could in theory be used to *fix* the bad magic
number, so refusing to continue might be a problem.  But perhaps when
invoked as xfs_admin, it should just bail out.  It would be interesting
to find where the actual failure is, though...

FWIW, I see a slightly different failure on a 128M vfat fs:

[root@host tmp]# file fsfile
fsfile: x86 boot sector, mkdosfs boot message display
[root@host tmp]# xfs_admin -u fsfile
xfs_admin: unexpected XFS SB magic number 0xeb3c906d
xfs_admin: size check failed
xfs_admin: failed to alloc 20875030464 bytes: Cannot allocate memory

It probably depends on the details of the (non-xfs) filesystem it's
pointed at.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
