Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8Sbbc225858 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:28:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFEE416E1BB1
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:28:36 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uFSlaT9iDYcOn1me for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:28:36 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwZo-0000st-76
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:28:36 +0000
Message-Id: <20111128082722.604873274@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:27:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/16] quota cleanups for Linux 3.3
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These quota updates are required to prepare for removing all non-transaction
metadata updates, implementing a proper quota shrinker and eventually
replacing the quota hashes with better scaling data structures.  They have
been posted two times before but not gotten a review yet.  I think it's
time to get them into the tree for Linux 3.3.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
