Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F240F7F90
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:14:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB53D304043
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:14:37 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id c77keA3HlSgiatah (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 03:14:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WO2en-00082U-8G
	for xfs@oss.sgi.com; Thu, 13 Mar 2014 10:14:33 +0000
Message-Id: <20140313101302.996355155@bombadil.infradead.org>
Date: Thu, 13 Mar 2014 03:13:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] O_TMPFILE tests, v2
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
To: xfs@oss.sgi.com

Now has proper feature support checking for xfs_io and the kernel, addressed
Dave's various minor comments for the second test.  I've left the repair
output as-is for the move of the zero link count files to lost+found.  While
I plan to fix that it's something that is generic for all zero link count
files and shouldn't cause the O_TMPFILE test to fail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
