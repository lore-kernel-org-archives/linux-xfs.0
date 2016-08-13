Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BDB97CA2
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 02:38:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F59B304043
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 00:38:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MTXRECtbqQCXadqe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 00:38:41 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 84A734E335
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 07:38:40 +0000 (UTC)
Received: from localhost (dhcp-13-153.nay.redhat.com [10.66.13.153])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7D7cd6E031311
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 03:38:40 -0400
Date: Sat, 13 Aug 2016 15:38:39 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: generic/224 triggers infinite "page discard on page xxx" on 512
	block size XFS with 4.8-rc1 kernel
Message-ID: <20160813073839.GY27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi all,

I've hit generic/224 flooding dmesg on 512 block size XFS, 4.8-rc1
kernel, with the following message:

...
[   98.146091] XFS (sda6): page discard on page ffffea0002f7e780, inode 0xe3a87, offset 1085214720.
[   98.147431] XFS (sda6): page discard on page ffffea00023c3800, inode 0xe3a87, offset 1085218816.
[   98.148743] XFS (sda6): page discard on page ffffea0002247700, inode 0xe3a87, offset 1085222912.
[   98.150136] XFS (sda6): page discard on page ffffea0002f8d000, inode 0xe3a87, offset 1085227008.
[   98.151496] XFS (sda6): page discard on page ffffea0002c58840, inode 0xe3a87, offset 1085231104.
[   98.152794] XFS (sda6): page discard on page ffffea0002e65340, inode 0xe3a87, offset 1085235200.
...

The inode number is always the same, only the page address and offset
are changing.

This is triggered by this dd command in generic/224:

dd if=/dev/zero of=$SCRATCH_MNT/testfile.$i bs=4k conv=notrunc

and it won't return until you kill it.

With 4.7 kernel I can see similar messages in dmesg, but only a few
lines are printed on different inodes, I don't see this infinite loop on
same inode.

And I bisected to this commit:

commit 68a9f5e7007c1afa2cf6830b690a90d0187c0684
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jun 21 09:53:44 2016 +1000

    xfs: implement iomap based buffered write path

    Convert XFS to use the new iomap based multipage write path. This involves
    implementing the ->iomap_begin and ->iomap_end methods, and switching the
    buffered file write, page_mkwrite and xfs_iozero paths to the new iomap
    helpers.

    With this change __xfs_get_blocks will never be used for buffered writes,
    and the code handling them can be removed.

    Based on earlier code from Dave Chinner.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Bob Peterson <rpeterso@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

I was testing on x86_64 kvm guest with 8G memory and 4vcpus. If more
information is needed please let me know.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
