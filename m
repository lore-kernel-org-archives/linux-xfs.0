Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8BDE7F5A
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:50:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CFC8AC001
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 05:50:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EH3FPRiYkdEKsTQh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 05:50:29 -0800 (PST)
Date: Tue, 3 Nov 2015 08:50:27 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: On-disk data for XFS_DINNODE_FMT_EXTENTS
Message-ID: <20151103135026.GB24445@bfoster.bfoster>
References: <436040866.262250269.1446544069841.JavaMail.root@zimbra84-e15.priv.proxad.net>
	<752500470.262252528.1446544133651.JavaMail.root@zimbra84-e15.priv.proxad.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <752500470.262252528.1446544133651.JavaMail.root@zimbra84-e15.priv.proxad.net>
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
To: hoper@free.fr
Cc: xfs@oss.sgi.com

On Tue, Nov 03, 2015 at 10:48:53AM +0100, hoper@free.fr wrote:
> Hi,
> 
> I'm trying to understand how xfs is storing informations,
> but I guess that my documentation "XFS Filesystem Structure
> 2nd Edition Revision 2" is quite outdated :(
> 
> I made an XFS filesystem, then made 60 files in /.
> 
> # xfs_db -f /root/small 
> xfs_db> inode 128
> xfs_db> addr
> current
> 	byte offset 32768, length 256
> 	buffer block 64 (fsbno 8), 8 bbs
> 	inode 128, dir inode 128, type inode
> xfs_db> p
> core.magic = 0x494e
> core.mode = 040755
> core.version = 2
> core.format = 2 (extents)
> [...]
> next_unlinked = null
> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,12,1,0]
> 
> I made a small script in python which retrieve all theases information from disk,
> except the "12" (location of the X2DB block = 12*4096). From the manuel, and my 
> understanding, this information, 12, should be found just next the di_unlinked.
> (page 43 on the manuel). But from an hex editor, from addr 32768, I got this :
> 
> 49 4E 41 ED 02 02 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 01
> 56 37 5D 71 2D 26 3D 0B 56 37 5D 6C 02 78 F1 EC 56 37 5D 6C 02 78 F1 EC 00 00 00 00 00 00 10 00
> 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00
> FF FF FF FF 00 00 00 00 00 00 00 00 00 00 00 00 01 80 00 01 00 00 00 00 00 00 00 00 00 00 00 00
> 
> First, 49 4E (IN) that's the begining of the inode core (96 bytes). All informations are here,
> and match the output of xfs_db. But after next_unlinked (FF FF FF FF here), and until next IN, 
> I can't find any 12 :( Where is it ?
> 

The extent information is encoded in a format that's not easily
interpreted from a raw hex dump. See xfs_iformat_extents() to start:

                dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
                xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
                for (i = 0; i < nex; i++, dp++) { 
                        xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
                        ep->l0 = get_unaligned_be64(&dp->l0);
                        ep->l1 = get_unaligned_be64(&dp->l1);
                }

So we start after di_next_unlinked and read in two 64-bit, big endian
fields. That data in your dump above is:

l0: 0x0000000000000000
l1: 0x0000000001800001

Then, these 64-bit fields have a special encoding themselves to map to
actual extent data. From xfs_format.h:

/*
 * Bmap btree record and extent descriptor.
 *  l0:63 is an extent flag (value 1 indicates non-normal).
 *  l0:9-62 are startoff.
 *  l0:0-8 and l1:21-63 are startblock.
 *  l1:0-20 are blockcount.
 */

We see that l0 is completely zeroed, so we can infer that this is a
normal extent and startoff is zero. The block count is l1:0-20, which is
00001b or 1. The start block is (((l0 & 0x1FF) << 43) | (l1 >> 21)),
which is:

	((0x0 & 0x1FF) << 43) | (0x1800001 >> 21)
	 0x0		      |  0xC
		= 0xC == 12

See __xfs_bmbt_get_all() for the code that implements this decoding.

Brian

> Lot's of thanks to anyone that could give me help on this subject.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
