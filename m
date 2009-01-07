Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07EYdns007981 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 08:34:42 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FC3217B745F
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 06:34:38 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	nQNBERDwhpsaMFZF for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 06:34:38 -0800 (PST)
Message-ID: <4964BD79.20806@poczta.onet.pl>
Date: Wed, 07 Jan 2009 15:34:33 +0100
From: aluno <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: xfs_db problem
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
To: xfs@oss.sgi.com


Hello,

Recently we've noticed that xfs_admin (xfs_db ver. 2.10.2) causes
segfault or FP traps while trying
to use following command on FAT partition:

# xfs_admin -u /dev/sda1
xfs_admin: unexpected XFS SB magic number 0xeb58906d
Floating point exception

and then makes error in dmesg:

xfs_db[10385] trap divide error ip:80b32b0 sp:fffbd900 error:0 in
xfs_db[8048000+7f000]

We know that xfs_admin is dedicated tool for XFS only not for FAT or
other filesystems,
but we would like to have xfs_db which will be able to cope with non-xfs
filesystems also.

After some investigations we've found some place and put there exit(1) -
in xfsprogs-2.10.2/db/init.c

in init() procedure:

    (...)
        sbp = &xmount.m_sb;
        if (sbp->sb_magicnum != XFS_SB_MAGIC) {
                fprintf(stderr, _("%s: unexpected XFS SB magic number
0x%08x\n"),
                        progname, sbp->sb_magicnum);
                exit(1);
        }
    (...)



Is it the right way to fix this problem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
