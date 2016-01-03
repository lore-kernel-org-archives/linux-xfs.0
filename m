Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADEE37F47
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:09:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3EA59AC005
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:09:39 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id e4t8MBBEmU0DfEIx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:09:36 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: reflink fixes
Date: Sun,  3 Jan 2016 13:07:50 +0100
Message-Id: <1451822873-12969-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Hi Darrick,

below are three patches I need to xfstests to pass reliably for the
reflink code.  I actually still see a lot of issues when testing
NFS clones on XFS due to extents hanging on the COW for too long,
but that's a separate issue I still need to investigate.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
