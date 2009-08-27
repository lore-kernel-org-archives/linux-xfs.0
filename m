Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RNF6jq116159 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 18:15:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B57C74064CA
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id he3TEHHWj86BfHmn for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MgoCD-0000Zy-J7
	for xfs@oss.sgi.com; Thu, 27 Aug 2009 23:15:57 +0000
Message-Id: <20090827231536.646792672@bombadil.infradead.org>
Date: Thu, 27 Aug 2009 19:15:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] sync improvements
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

Revisit Dave's prototype to make sync equivalent to freeze, that is make
sure not only we have all data on disk, but also the metadata in the right
place and not requite a log recovery.  That fixes test 182 and should also
help with the frequent grub complaints.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
