Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6F007F93
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 05:12:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96461304053
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 03:12:14 -0700 (PDT)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com
	[209.85.192.172]) by cuda.sgi.com with ESMTP id
	LnIIugEbC8Xkequ7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 03:12:13 -0700 (PDT)
Received: by mail-pd0-f172.google.com with SMTP id ft15so3084264pdb.3
	for <xfs@oss.sgi.com>; Wed, 06 Aug 2014 03:12:12 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Aug 2014 12:12:12 +0200
Message-ID: <CACyNnZM8D4ZdOAvbXNoiRUAGh1uZF8=9Gy34qS2XH7QUVjiGsQ@mail.gmail.com>
Subject: xfs_bmbt_rec_64 leading to wrong blocks
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
To: xfs@oss.sgi.com

Hello,

I am writing a software which reads xfs partitions and it is working
well so far, but, at in a particular folder with 10k files, only 7k
files appear, the other ones don't.

I read an inode which has di_core.di_format = XFS_DINODE_FMT_BTREE

No problem here, the btree is trivial, it has only 1 element inside
it, which leads to a list of 82 extends.

Extends 0..52 aprox. are all great, and work fine.

Extent 53 (and other ones after that) point to very wierd memory areas
which don't match the pattern that I saw previously =(

Here is the hex data of the extents, the selected extent in nr 53:

http://magnifier.sourceforge.net/temp/xfs/extent_with_xfs_bmbt_rec_64.png

And here is debug information showing which values I extracted from this table:

i=0 FLocalExtent.StartOff=0 FLocalExtent.StartBlock=66748
FLocalExtent.BlockCount=1 lStartBlock=65212
i=1 FLocalExtent.StartOff=1 FLocalExtent.StartBlock=66758
FLocalExtent.BlockCount=2 lStartBlock=65222
i=2 FLocalExtent.StartOff=3 FLocalExtent.StartBlock=66772
FLocalExtent.BlockCount=1 lStartBlock=65236
....

i=51 FLocalExtent.StartOff=77 FLocalExtent.StartBlock=67468
FLocalExtent.BlockCount=1 lStartBlock=65932
i=52 FLocalExtent.StartOff=78 FLocalExtent.StartBlock=67479
FLocalExtent.BlockCount=1 lStartBlock=65943
i=53 FLocalExtent.StartOff=8388608 FLocalExtent.StartBlock=66749
FLocalExtent.BlockCount=1 lStartBlock=65213
i=54 FLocalExtent.StartOff=8388609 FLocalExtent.StartBlock=66783
FLocalExtent.BlockCount=2 lStartBlock=65247
...

Note how StartOff is suddenly so big! But I manually checked the bits
comparing to xfs_bmbt_rec_64 and the value written is that one. But
what sense does it make for StartOff to jump like that?

And why are the blocks pointing to a non-XD2D block?

Here is the block to which one of the valid extents point to:

http://magnifier.sourceforge.net/temp/xfs/correct_block_xd2d.png

And here is a block to which one of the extents that I cannot
interpretate point to:

http://magnifier.sourceforge.net/temp/xfs/wierd_block_xd2d.png
and another one:
http://magnifier.sourceforge.net/temp/xfs/wierd_xfs_dir2_data_entry.png

Any ideas???

I already worked so much on this, but I cannot figure out =(

thanks,
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
