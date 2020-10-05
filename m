Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DB7C46466
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9A8220853
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NejL55e0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgJESXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:23:37 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45962 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:23:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IADs7148617;
        Mon, 5 Oct 2020 18:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BVTlH+rsGP5VA9RZD33Z5U0LNKwDfKcy+bsHSKqwGIo=;
 b=NejL55e0pYspEAahdURMVHbxujU8+PmjZ8UI7tLWisN+iexsJ60D5aksyElOwW6hKm2j
 NZWdvxttS+6mC+mubNGS81ENbz7b9L3oJgjkoxkPjMgU9GhV98YwsUYVHtmrrvk5OcNC
 htCoR4bjRgLESP2IgPt4nze9cSsEanadsOLMF1Rb9EgC+qfvUMSnRYQcs/UdQUXG1m4p
 2jqRx3udVcUDfLu/4t8ZBF36K+byKW7NP0DrLHQrqLr8hRz3rKAhwoAYwBESWnWvMv7e
 eMZOpuKzLPuzJ/a7ZQfPYTjEpNpwGWkplgNSqQeuj+FUOtIITOMdyLxgkfh6YnQP7Xhp PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetaq75t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:21:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IBRkZ073800;
        Mon, 5 Oct 2020 18:21:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vkugvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:21:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095ILVlV019448;
        Mon, 5 Oct 2020 18:21:31 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:21:31 -0700
Subject: [PATCH 1/2] xfs: limit entries returned when counting fsmap records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, chandanrlinux@gmail.com
Date:   Mon, 05 Oct 2020 11:21:30 -0700
Message-ID: <160192209042.2569942.5823795765306349583.stgit@magnolia>
In-Reply-To: <160192208358.2569942.13189278742183856412.stgit@magnolia>
References: <160192208358.2569942.13189278742183856412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If userspace asked fsmap to count the number of entries, we cannot
return more than UINT_MAX entries because fmh_entries is u32.
Therefore, stop counting if we hit this limit or else we will waste time
to return truncated results.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_fsmap.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 4eebcec4aae6..aa36e7daf82c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -256,6 +256,9 @@ xfs_getfsmap_helper(
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
+		if (info->head->fmh_entries == UINT_MAX)
+			return -ECANCELED;
+
 		if (rec_daddr > info->next_daddr)
 			info->head->fmh_entries++;
 

