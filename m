Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24CwSjO165546 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 06:58:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6FFE1AF2B93
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 05:01:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8T7V5hwOvpLE66Dv for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 05:01:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PvUdD-0004nw-41
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 13:01:19 +0000
Message-Id: <20110304125953.650347660@bombadil.infradead.org>
Date: Fri, 04 Mar 2011 07:59:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] avoid busy extents during user data allocations
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

This patchset adds support to trim down extents

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
