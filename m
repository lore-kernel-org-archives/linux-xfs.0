Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F19087F59
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 03:49:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C185AC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 01:49:00 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id XBmoA1FrGIBjmBXY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 01:48:55 -0800 (PST)
Received: from zimbra84-e15.priv.proxad.net (unknown [172.20.243.135])
	by smtp3-g21.free.fr (Postfix) with ESMTP id E2737A6694
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 10:48:53 +0100 (CET)
Date: Tue, 3 Nov 2015 10:48:53 +0100 (CET)
From: hoper@free.fr
Message-ID: <752500470.262252528.1446544133651.JavaMail.root@zimbra84-e15.priv.proxad.net>
In-Reply-To: <436040866.262250269.1446544069841.JavaMail.root@zimbra84-e15.priv.proxad.net>
Subject: On-disk data for XFS_DINNODE_FMT_EXTENTS
MIME-Version: 1.0
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

Hi,

I'm trying to understand how xfs is storing informations,
but I guess that my documentation "XFS Filesystem Structure
2nd Edition Revision 2" is quite outdated :(

I made an XFS filesystem, then made 60 files in /.

# xfs_db -f /root/small 
xfs_db> inode 128
xfs_db> addr
current
	byte offset 32768, length 256
	buffer block 64 (fsbno 8), 8 bbs
	inode 128, dir inode 128, type inode
xfs_db> p
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 2 (extents)
[...]
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12,1,0]

I made a small script in python which retrieve all theases information from disk,
except the "12" (location of the X2DB block = 12*4096). From the manuel, and my 
understanding, this information, 12, should be found just next the di_unlinked.
(page 43 on the manuel). But from an hex editor, from addr 32768, I got this :

49 4E 41 ED 02 02 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01
56 37 5D 71 2D 26 3D 0B 56 37 5D 6C 02 78 F1 EC 56 37 5D 6C 02 78 F1 EC 00 00 00 00 00 00 10 00
00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00
FF FF FF FF 00 00 00 00 00 00 00 00 00 00 00 00 01 80 00 01 00 00 00 00 00 00 00 00 00 00 00 00

First, 49 4E (IN) that's the begining of the inode core (96 bytes). All informations are here,
and match the output of xfs_db. But after next_unlinked (FF FF FF FF here), and until next IN, 
I can't find any 12 :( Where is it ?

Lot's of thanks to anyone that could give me help on this subject.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
