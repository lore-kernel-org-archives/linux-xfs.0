Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F07497F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 16:10:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF958304039
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 14:10:36 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id RN4i0BIZhLEPogE0 for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 14:10:34 -0800 (PST)
Date: Tue, 3 Mar 2015 17:10:33 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150303221033.GB19439@fieldses.org>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

I'm getting mysterious crashes on a server exporting an xfs filesystem.

Strangely, I've reproduced this on

	93aaa830fc17 "Merge tag 'xfs-pnfs-for-linus-3.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs

but haven't yet managed to reproduce on either of its parents
(24a52e412ef2 or 781355c6e5ae).  That might just be chance, I'll try
again.

I can also try a serial console or something, but for now I'm not
getting a lot of information about the crashes.

The filesystem in question isn't on a block device available to the
client, but I'm still seeing occasional GETLAYOUT and GETDEVICEINFO
calls; I suppose the client's getting that far, finding no devices it
can use, and giving up?

Sorry for the incomplete report, I'll pass along more when I have it.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
