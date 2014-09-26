Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE0D97FF3
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 04:45:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B9C930405F
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 02:45:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id D2t6AM7txRkXDhNr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 02:45:51 -0700 (PDT)
Date: Fri, 26 Sep 2014 02:45:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: remove bitfield based superblock updates
Message-ID: <20140926094550.GB10692@infradead.org>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411647632-28240-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This breaks generic/230 for me on an x86-64 VM:

--- tests/generic/230.out	2013-11-11 10:38:59.000000000 +0000
+++ /root/xfstests/results//generic/230.out.bad	2014-09-26 09:47:37.000000000 +0000
@@ -23,11 +23,8 @@
 Write 900k...
 Rewrite 1001k...
 Write 1000k...
-pwrite64: Disk quota exceeded
 Write 4096...
-pwrite64: Disk quota exceeded
 Touch 3+4
 Touch 5+6
 touch: cannot touch 'SCRATCH_MNT/file6': Disk quota exceeded
 Touch 5
-touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
