Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 839CD29DF5
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2015 12:14:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72C85304059
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2015 10:14:55 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WsqRlqqOsTwaYS8Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 21 Nov 2015 10:14:53 -0800 (PST)
Date: Sat, 21 Nov 2015 10:14:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
	output
Message-ID: <20151121181451.GA17570@infradead.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
	<20151121005014.20398.22316.stgit@birch.djwong.org>
	<20151121180644.GA23916@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151121180644.GA23916@infradead.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

> Shouldn't these be Invalid argument just like the
> to a device case above or the clone case?

E.g. something like this on top of your patch:


diff --git a/tests/generic/158.out b/tests/generic/158.out
index 1210429..dff3692 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -16,9 +16,9 @@ XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe to a dir
 TEST_DIR/test-158/dir1: Is a directory
 Try to dedupe to a device
-dedupe: Operation not supported
+dedupe: Invalid argument
 Try to dedupe to a fifo
-dedupe: Operation not supported
+dedupe: Invalid argument
 Try to dedupe an append-only file
 Dedupe two files
 Check scratch fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
