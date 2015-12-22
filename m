Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D11EF7F56
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 07:51:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77338AC002
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4Pqm0Zj0uY3sXE4o (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:23 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 17AC8C0B7E14
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 13:51:23 +0000 (UTC)
Received: from schleppi.home.com (vpn1-6-147.ams2.redhat.com [10.36.6.147])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tBMDpH2J030386
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 08:51:21 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 2/6] fsx: Fix hex numbers in operation dump
Date: Tue, 22 Dec 2015 14:51:08 +0100
Message-Id: <1450792272-7402-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
References: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
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

Some hex numbers are prefixed with "0x" and right-aligned with spaces,
leading to output like "0x beef".  Make that "0x0beef" instead.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 ltp/fsx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 805fdfb..16d74c0 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -447,10 +447,10 @@ check_buffers(unsigned offset, unsigned size)
 			if (c != t) {
 			        if (n < 16) {
 					bad = short_at(&temp_buf[i]);
-				        prt("0x%5x\t0x%04x\t0x%04x", offset,
+				        prt("0x%05x\t0x%04x\t0x%04x", offset,
 				            short_at(&good_buf[offset]), bad);
 					op = temp_buf[offset & 1 ? i+1 : i];
-				        prt("\t0x%5x\n", n);
+				        prt("\t0x%05x\n", n);
 					if (op)
 						prt("operation# (mod 256) for "
 						  "the bad data may be %u\n",
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
