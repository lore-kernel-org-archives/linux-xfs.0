Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9J40Rdr231407 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 23:00:28 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FHWvMFD5kUlukRXz for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 21:02:07 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9J4269N012065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 00:02:06 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q9J42518012386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 00:02:06 -0400
Message-ID: <5080D0BD.3000304@redhat.com>
Date: Thu, 18 Oct 2012 23:02:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsdump:fill in bs_forkoff
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Upstream, the structure containing bs_forkoff is actually zeroed
prior to these functions, but when pulling the patch back to an
older xfsdump, we got checksum errors due to an uninitialized
bs_forkoff not matching in dump vs. restore.

So even though forkoff won't be explicitly restored from
a dump, do explicitly set it in these routines to keep checksums
happy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Tested w/ ./check -g dump on a 3.6.0 kernel, no failures.

Setting to 0 would work too, if that would be better?
It just looked odd.



Index: xfsdump-3.0.4/common/arch_xlate.c
===================================================================
--- xfsdump-3.0.4.orig/common/arch_xlate.c
+++ xfsdump-3.0.4/common/arch_xlate.c
@@ -377,6 +377,7 @@ xlate_bstat(bstat_t *bs1, bstat_t *bs2, 
 	IXLATE(bs1, bs2, bs_extents);
 	IXLATE(bs1, bs2, bs_gen);
 	IXLATE(bs1, bs2, bs_projid_lo);
+	IXLATE(bs1, bs2, bs_forkoff);
 	IXLATE(bs1, bs2, bs_projid_hi);
 	IXLATE(bs1, bs2, bs_dmevmask);
 	IXLATE(bs1, bs2, bs_dmstate);
Index: xfsdump-3.0.4/dump/content.c
===================================================================
--- xfsdump-3.0.4.orig/dump/content.c
+++ xfsdump-3.0.4/dump/content.c
@@ -5072,6 +5072,7 @@ copy_xfs_bstat(bstat_t *dst, xfs_bstat_t
 	dst->bs_extents = src->bs_extents;
 	dst->bs_gen = src->bs_gen;
 	dst->bs_projid_lo = src->bs_projid_lo;
+	dst->bs_forkoff = src->bs_forkoff;
 	dst->bs_projid_hi = src->bs_projid_hi;
 	dst->bs_dmevmask = src->bs_dmevmask;
 	dst->bs_dmstate = src->bs_dmstate;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
