Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1S8rFX0126784 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 02:53:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D30BA302282
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 00:56:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VgMRA2hPJVSG7OP2 for
	<xfs@oss.sgi.com>; Mon, 28 Feb 2011 00:56:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Ptytf-0001aV-5f
	for xfs@oss.sgi.com; Mon, 28 Feb 2011 08:56:03 +0000
Date: Mon, 28 Feb 2011 03:56:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [gf435@gmx.net: [regression]2.6.38-rc6 with XFS still does consume
	all free space]
Message-ID: <20110228085603.GB27227@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

----- Forwarded message from Otto Meier <gf435@gmx.net> -----

Date: Tue, 22 Feb 2011 13:19:51 +0100
From: Otto Meier <gf435@gmx.net>
Subject: [regression]2.6.38-rc6 with XFS still does consume all free space
To: linux-kernel@vger.kernel.org

Hello,
on my System a "make modules_install" with kernel 2.6.38-rc6 has eaten up
all free Space on a XFS partition.

The free Space is

/dev/sda6             56472984  43613692  12859292  78% /

after make modules_install i get

/dev/sda6             56472984  56472964        20 100% /

with kernel 2.6.37.1 everything runs fine and df shows

/dev/sda6             56472984  43262256  13210728  77% /

any idea what is going on here?

bye Otto


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
