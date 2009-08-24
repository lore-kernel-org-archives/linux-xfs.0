Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OG3eaE134715 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 11:03:50 -0500
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B5253F2CE9
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 09:04:24 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id HqXFqVfXsZcZPfd5
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 09:04:24 -0700 (PDT)
Date: Mon, 24 Aug 2009 18:04:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xfs_check does not recognize fs truncation
In-Reply-To: <20090824144752.GA20898@infradead.org>
Message-ID: <alpine.LSU.2.00.0908241714410.17924@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0908241208520.1028@fbirervta.pbzchgretzou.qr>
	<20090824144752.GA20898@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Monday 2009-08-24 16:47, Christoph Hellwig wrote:
>On Mon, Aug 24, 2009 at 12:12:59PM +0200, Jan Engelhardt wrote:
>> 
>> This I see on xfsprogs-2.10.1 with kernel 2.6.29.6:
>
>What does xfs_repair -n say?

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


You can get the image at
http://dev.medozas.de/files/linux-hist.img.lzma [179MB->1782MB]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
