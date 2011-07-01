Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k3b2055975 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C58216748B7
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dDe4apfgKn4GPDWQ for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIU-0001pH-4I
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:02 +0000
Message-Id: <20110701094321.936534538@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/27] patch queue for Linux 3.1, V2
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

This is my current patch queue for Linux 3.1.  Compared to the last
posting all review comments were incorporated and two additional trivial
patches were added.  The ->writepages implementation was dropped for now,
given the bad situation of kswap-originating writeback, but I'll repost
the fixed version separately to get feedback on the updated version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
