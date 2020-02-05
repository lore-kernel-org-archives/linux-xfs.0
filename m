Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A765C3524D
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 319C9217BA
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e1S8X6DY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBEACS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:02:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBEACS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:02:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwwSa076211;
        Wed, 5 Feb 2020 00:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aUaQI5DsgBUHSzEcazJpEHTPn5drJJunop3nh7Czhyo=;
 b=e1S8X6DY8BFfpl4HnGFnABqmU4IRASn5I3TSUIkdLrwXgblvNVdIvBmQEJHe+VzdpxqS
 GAUEX/PaggmvPOe4yUwxn6aNlKKUmtPrgpq+uBrkhJjP+dTIORNp+bTb7UT4S9EtLXk/
 tb69QmYBJbZ5z+0IL8XzCiLRvQtIHQ2PVeioH0luft/sLMXjA28Wl2ijHAtfbsMLS8V4
 8ZNaXBAlrtkYlBxCXzX9j++fVCATUB5vCrCwf3WFoWfQ6Gnjn7fXlViOxxBK46r7g0Hj
 nLIlwSMgm/9ugFOmgPbhBZXPvypr0RXzk9t/R6Y8OeKo2i79USaeeX8lfb8azjIcuHLy gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xyhkfg8ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NwrYj059198;
        Wed, 5 Feb 2020 00:02:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xyhmq3hyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:02:15 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01502E8a022711;
        Wed, 5 Feb 2020 00:02:14 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:02:14 -0800
Subject: [PATCH 5/5] fsx: support 64-bit operation counts
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:02:13 -0800
Message-ID: <158086093318.1989378.1186256375919220733.stgit@magnolia>
In-Reply-To: <158086090225.1989378.6869317139530865842.stgit@magnolia>
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Support 64-bit operation counts so that we can run long-soak tests for
more than 2 billion fsxops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |   54 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 26 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 120f4374..02403720 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -135,12 +135,12 @@ int	fd;				/* fd for our test file */
 blksize_t	block_size = 0;
 off_t		file_size = 0;
 off_t		biggest = 0;
-unsigned long	testcalls = 0;		/* calls to function "test" */
+long long	testcalls = 0;		/* calls to function "test" */
 
-unsigned long	simulatedopcount = 0;	/* -b flag */
+long long	simulatedopcount = 0;	/* -b flag */
 int	closeprob = 0;			/* -c flag */
 int	debug = 0;			/* -d flag */
-unsigned long	debugstart = 0;		/* -D flag */
+long long	debugstart = 0;		/* -D flag */
 char	filldata = 0;			/* -g flag */
 int	flush = 0;			/* -f flag */
 int	do_fsync = 0;			/* -y flag */
@@ -148,7 +148,7 @@ unsigned long	maxfilelen = 256 * 1024;	/* -l flag */
 int	sizechecks = 1;			/* -n flag disables them */
 int	maxoplen = 64 * 1024;		/* -o flag */
 int	quiet = 0;			/* -q flag */
-unsigned long progressinterval = 0;	/* -p flag */
+long long	progressinterval = 0;	/* -p flag */
 int	readbdy = 1;			/* -r flag */
 int	style = 0;			/* -s flag */
 int	prealloc = 0;			/* -x flag */
@@ -157,7 +157,7 @@ int	writebdy = 1;			/* -w flag */
 long	monitorstart = -1;		/* -m flag */
 long	monitorend = -1;		/* -m flag */
 int	lite = 0;			/* -L flag */
-long	numops = -1;			/* -N flag */
+long long numops = -1;			/* -N flag */
 int	randomoplen = 1;		/* -O flag disables it */
 int	seed = 1;			/* -S flag */
 int     mapped_writes = 1;              /* -W flag disables */
@@ -788,7 +788,7 @@ doread(unsigned offset, unsigned size)
 		       (monitorstart == -1 ||
 			(offset + size > monitorstart &&
 			(monitorend == -1 || offset <= monitorend))))))
-		prt("%lu read\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
+		prt("%lld read\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
 		    offset, offset + size - 1, size);
 	ret = lseek(fd, (off_t)offset, SEEK_SET);
 	if (ret == (off_t)-1) {
@@ -925,7 +925,7 @@ domapread(unsigned offset, unsigned size)
 		       (monitorstart == -1 ||
 			(offset + size > monitorstart &&
 			(monitorend == -1 || offset <= monitorend))))))
-		prt("%lu mapread\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
+		prt("%lld mapread\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
 		    offset, offset + size - 1, size);
 
 	pg_offset = offset & PAGE_MASK;
@@ -1003,7 +1003,7 @@ dowrite(unsigned offset, unsigned size)
 		       (monitorstart == -1 ||
 			(offset + size > monitorstart &&
 			(monitorend == -1 || offset <= monitorend))))))
-		prt("%lu write\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
+		prt("%lld write\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
 		    offset, offset + size - 1, size);
 	ret = lseek(fd, (off_t)offset, SEEK_SET);
 	if (ret == (off_t)-1) {
@@ -1070,7 +1070,7 @@ domapwrite(unsigned offset, unsigned size)
 		       (monitorstart == -1 ||
 			(offset + size > monitorstart &&
 			(monitorend == -1 || offset <= monitorend))))))
-		prt("%lu mapwrite\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
+		prt("%lld mapwrite\t0x%x thru\t0x%x\t(0x%x bytes)\n", testcalls,
 		    offset, offset + size - 1, size);
 
 	if (file_size > cur_filesize) {
@@ -1123,11 +1123,12 @@ dotruncate(unsigned size)
 
 	if (testcalls <= simulatedopcount)
 		return;
-	
+
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      size <= monitorend)))
-		prt("%lu trunc\tfrom 0x%x to 0x%x\n", testcalls, oldsize, size);
+		prt("%lld trunc\tfrom 0x%x to 0x%x\n", testcalls, oldsize,
+				size);
 	if (ftruncate(fd, (off_t)size) == -1) {
 	        prt("ftruncate1: %x\n", size);
 		prterr("dotruncate: ftruncate");
@@ -1168,7 +1169,7 @@ do_punch_hole(unsigned offset, unsigned length)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend))) {
-		prt("%lu punch\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+		prt("%lld punch\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
 			offset, offset+length, length);
 	}
 	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
@@ -1230,7 +1231,7 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend))) {
-		prt("%lu zero\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+		prt("%lld zero\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
 			offset, offset+length, length);
 	}
 	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
@@ -1280,8 +1281,8 @@ do_collapse_range(unsigned offset, unsigned length)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend))) {
-		prt("%lu collapse\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
-			offset, offset+length, length);
+		prt("%lld collapse\tfrom 0x%x to 0x%x, (0x%x bytes)\n",
+				testcalls, offset, offset+length, length);
 	}
 	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
 		prt("collapse range: 0x%x to 0x%x\n", offset, offset + length);
@@ -1332,7 +1333,7 @@ do_insert_range(unsigned offset, unsigned length)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend))) {
-		prt("%lu insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
+		prt("%lld insert\tfrom 0x%x to 0x%x, (0x%x bytes)\n", testcalls,
 			offset, offset+length, length);
 	}
 	if (fallocate(fd, mode, (loff_t)offset, (loff_t)length) == -1) {
@@ -1724,7 +1725,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend)))
-		prt("%lu falloc\tfrom 0x%x to 0x%x (0x%x bytes)\n", testcalls,
+		prt("%lld falloc\tfrom 0x%x to 0x%x (0x%x bytes)\n", testcalls,
 				offset, offset + length, length);
 	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
 	        prt("fallocate: 0x%x to 0x%x\n", offset, offset + length);
@@ -1773,7 +1774,7 @@ docloseopen(void)
 		return;
 
 	if (debug)
-		prt("%lu close/open\n", testcalls);
+		prt("%lld close/open\n", testcalls);
 	if (close(fd)) {
 		prterr("docloseopen: close");
 		report_failure(180);
@@ -1797,7 +1798,7 @@ dofsync(void)
 	if (testcalls <= simulatedopcount)
 		return;
 	if (debug)
-		prt("%lu fsync\n", testcalls);
+		prt("%lld fsync\n", testcalls);
 	log4(OP_FSYNC, 0, 0, 0);
 	ret = fsync(fd);
 	if (ret < 0) {
@@ -1834,7 +1835,7 @@ cleanup(int sig)
 {
 	if (sig)
 		prt("signal %d\n", sig);
-	prt("testcalls = %lu\n", testcalls);
+	prt("testcalls = %lld\n", testcalls);
 	exit(sig);
 }
 
@@ -1942,7 +1943,7 @@ test(void)
 		debug = 1;
 
 	if (!quiet && testcalls < simulatedopcount && testcalls % 100000 == 0)
-		prt("%lu...\n", testcalls);
+		prt("%lld...\n", testcalls);
 
 	if (replayopsf) {
 		struct log_entry log_entry;
@@ -2293,13 +2294,13 @@ usage(void)
 }
 
 
-int
+long long
 getnum(char *s, char **e)
 {
-	int ret;
+	long long ret;
 
 	*e = (char *) 0;
-	ret = strtol(s, e, 0);
+	ret = strtoll(s, e, 0);
 	if (*e)
 		switch (**e) {
 		case 'b':
@@ -2487,7 +2488,8 @@ main(int argc, char **argv)
 		case 'b':
 			simulatedopcount = getnum(optarg, &endp);
 			if (!quiet)
-				prt("Will begin at operation %ld\n", simulatedopcount);
+				prt("Will begin at operation %lld\n",
+						simulatedopcount);
 			if (simulatedopcount == 0)
 				usage();
 			simulatedopcount -= 1;
@@ -2854,7 +2856,7 @@ main(int argc, char **argv)
 		prterr("close");
 		report_failure(99);
 	}
-	prt("All %lu operations completed A-OK!\n", testcalls);
+	prt("All %lld operations completed A-OK!\n", testcalls);
 	if (recordops)
 		logdump();
 

