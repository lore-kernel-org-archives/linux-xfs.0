Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C21D29DF5
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 09:01:08 -0500 (CDT)
Message-Id: <20150821193047.661578219@gulag1.americas.sgi.com>
From: rjohnston@sgi.com
Subject: [PATCH 0/2] xfsdump: fix problems in cb_add_inogrp
Date: Fri, 21 Aug 2015 09:01:04 -0500 (CDT)
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

The memset in cb_add_inogrp will segfault when the index oldsize
overflows. In cb_add_inogrp(), the temp variables used in
calculating the new i2gmap segment offset should be int64 instead
of intgen_t (int32).

A second bug also occurs because we already compensate for the
length of each item in oldsize so are 32bit wrap becomes a 40bit
wrap.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
