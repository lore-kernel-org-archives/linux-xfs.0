Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15B0C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDB72063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:30:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RiuyQ/6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgEIQaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:30:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:30:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRVLL196448;
        Sat, 9 May 2020 16:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DyqNSYDZ1JSnuUr1b0wnR+zVBqN1cxVp3ocfAR6K3L8=;
 b=RiuyQ/6wAmPrQ6qMJ2yt5yaSAvAX0Syty76g61/4cHbFiNs2y/3AfUvzXujY6fGe7XAE
 GWbTYske5WwD6hKAagldCW86+9fR+jsCO5mUyLDDJWneNh80HL4LBkoq3841ODakc8yC
 h3TiK4FM/6Ofqy0FRNGR5x649w+llj+4p4RRGbKs/w0BAot10iMKZPlL/2II1mVOHRCj
 D0DQOR56ljg5pT+haUetEOysSgp7gbw6QqE2Ln1bAPFqaLoGD3qt0d/EF6Q5XZYHiUyp
 9s5yH0LxjWp/gmhgGovGz0/Cdr45dwOJhvbWg3R2DiAlMfeJ8funM7kEMSeqkVaPCazA bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30wmfm14yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GTIJW097759;
        Sat, 9 May 2020 16:30:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30wx1857fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:30:05 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GU5X0020315;
        Sat, 9 May 2020 16:30:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:04 -0700
Subject: [PATCH 02/16] xfs_repair: warn when we would have rebuilt a directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:05 -0700
Message-ID: <158904180502.982941.12047148158523698696.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=977
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

longform_dir2_entry_check should warn the user when we would have
rebuilt a directory had -n not been given on the command line.  The
missing warning results in repair returning 0 (all clean) when in fact
there were things that it would have fixed.

Found by running xfs/496 against lents[0].hashval = middlebit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index a938e802..75e273c8 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2426,6 +2426,9 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		*num_illegal = 0;
 		*need_dot = 0;
 	} else {
+		if (fixit || dotdot_update)
+			do_warn(
+	_("would rebuild directory inode %" PRIu64 "\n"), ino);
 		for (i = 0; i < num_bps; i++)
 			if (bplist[i])
 				libxfs_buf_relse(bplist[i]);

