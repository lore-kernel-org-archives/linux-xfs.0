Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C66177F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 06:48:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8CAE30405F
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 04:48:18 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GRaSNlBCke5Se9Hs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 04:48:17 -0700 (PDT)
Date: Sat, 3 May 2014 04:48:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140503114816.GA31191@infradead.org>
References: <535580A1.20806@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535580A1.20806@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Can I assumes that xfs/007 failing with:

--- tests/xfs/007.out	2014-05-03 08:58:08.000000000 +0000
+++ /root/xfstests/results//xfs/007.out.bad	2014-05-03
11:48:05.000000000 +0000
@@ -7,4 +7,4 @@
 *** umount
 *** Usage after quotarm ***
 core.nblocks = 0
-core.nblocks = 0
+core.nblocks = 1

is because this patch didn't get picked up yet?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
