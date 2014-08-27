Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 027C47F47
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 05:20:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D62968F8070
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 03:20:19 -0700 (PDT)
Received: from mail-pd0-f178.google.com (mail-pd0-f178.google.com
	[209.85.192.178]) by cuda.sgi.com with ESMTP id
	XSX57ekKuweoNixi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 03:20:18 -0700 (PDT)
Received: by mail-pd0-f178.google.com with SMTP id w10so24528751pde.9
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 03:20:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Aug 2014 12:20:14 +0200
Message-ID: <CACyNnZNUMdv=EUAaYmW69X+0yB7qmsVA3bC=ChJiKb_X4WCt-w@mail.gmail.com>
Subject: Ghost items in the end of a dir listing
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

I am writing a program that reads XFS partitions and I am having
trouble with some dir listings. In some directories in the block that
starts with XD2B there is first the list of all directory items, which
I read without problems, and then there is a free item, for example:

  xfs_dir2_data_unused
    freetag -> XFS_DIR2_DATA_FREE_TAG */
    length -> 9A0
    tag -> zero

But after this free item there is still room in the block, so my
program will try to read the next item. I cannot stop the reading
because it is possible to have valid items, then a free item and then
more valid items.

The next item start might be something like:

00 00 00 2E 00 00 00 02 16

So it is not a free item, as it doesn't start with FF = XFS_DIR2_DATA_FREE_TAG
But it isn't valid either, as its name is a bunch of trash =(

So my questions are:
1> What are those ghost items in the end of the block?
2> Which criteria should be utilized to differentiate them from valid
items? I tried some guesses but nothing really works so far...

Here are screenshots of the actual data involved, here showing the
item with XFS_DIR2_DATA_FREE_TAG:

http://magnifier.sourceforge.net/temp/xfs/xfs_dir_listing_XD2B_FREE_item.png

And here showing the area in the end of the block with wierd items:

http://magnifier.sourceforge.net/temp/xfs/xfs_dir_listing_XD2B_after_FREE.png

thanks for any tips =)
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
