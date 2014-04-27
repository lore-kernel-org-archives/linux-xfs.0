Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A95C27F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 10:53:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 863B68F804B
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 08:53:39 -0700 (PDT)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
	[209.85.192.173]) by cuda.sgi.com with ESMTP id
	nEkqlKCX57tUFK6r (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 08:53:38 -0700 (PDT)
Received: by mail-pd0-f173.google.com with SMTP id p10so4498977pdj.32
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 08:53:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACyNnZPzJGCQf5FYm+Oqkw5U3Ggm8wQd5LKC5Jnwiyksa-K1OA@mail.gmail.com>
References: <CACyNnZMtP87y6VHum+J4xKEZqaYp2YERVnt3YuaCmeiZBmMTzQ@mail.gmail.com>
	<5359912A.70603@sandeen.net>
	<CACyNnZPV89C87DggE4fiJX+_r3zh1hKhcX3ExmXRzpLLhWJ6CQ@mail.gmail.com>
	<535AE19D.8@sandeen.net>
	<CACyNnZPzJGCQf5FYm+Oqkw5U3Ggm8wQd5LKC5Jnwiyksa-K1OA@mail.gmail.com>
Date: Sun, 27 Apr 2014 12:53:36 -0300
Message-ID: <CACyNnZMgSYdC+-=M6hYarAAUEZexc=HwD4Tn2AnO2DP=vGN6Hw@mail.gmail.com>
Subject: Re: How to find the inodes in XFS
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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

Oh, well, ...now my code works great for low inode numbers, but it
doesn't work at all for high inode numbers. =)

If inode is the root one 0x80 or similar small numbers which as 0x83
it will map correctly to the block 8, which means position 0x8000 +
internal offset inside the block

But in high inodes, for example 0x204B87 and 0x204B80 it will split
the inode number like this:
AG=2
Block inside AG Nr=0x4B8

And since XFS_INO_TO_FSB just recombines back together the parts:

#define XFS_INO_TO_FSB(mp,i) \
XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))

#define XFS_AGB_TO_FSB(mp,agno,agbno) \
(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))

I get as the result from XFS_INO_TO_FSB 0x204B8, which would mean
position 0x204B8000, but this is a wrong position =(

I opened the partition with a hex viewer and the correct position is
block 0x1521A which means position 0x1521A000 + offset inside block

My superblock has these values:

XFS_INO_AGINO_BITS = mp^.m_agino_log = 20
XFS_INO_OFFSET_BITS= m_sb^.sb_inopblog = 4
XFS_INO_AGBNO_BITS = m_sb^.sb_agblklog = 16
XFS_INO_MASK = FFFF
sb_agcount = 4

Any ideas?

Maybe my flaw is that to get the disk position I simply multiply the
block number by the size of a block ... I tryed to use
XFS_FSB_TO_DADDR instead but it gives 64 for block nr 8, which doesn't
make much sense, I'd expect 0x8000

thanks!
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
