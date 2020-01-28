Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F250C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 15:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C6321739
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 15:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cUEZK4XW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgA1P6y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 10:58:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgA1P6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 10:58:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SFrUZl191012;
        Tue, 28 Jan 2020 15:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kgbbU7HvCQ+tvQrxBqKvQFDKm9fXl+i7pBdyH/568T8=;
 b=cUEZK4XW82Frq1ePkCunB5PY5l9f03NHZhRHazQxC1rvSR/69bTxiyErJ0T5YmpJx5I8
 46CeKNLqhY2X0XVoxsHJWMWX5RfotG5Jdd0F9VFXRlvDBkslfXhjNK0F5AxZVU80KN97
 e9AT1yd5tbsyn+h7qmgvKgH4roFTtEZ9BVFxGaN6W8eop6Se9GPZy5+YAHRTifGkV7tY
 HUQxEdps4S79rDi8v9rv9nuM2PMoHz/OQFT9R+PUU4I9Mm0qmN+cMSd+Q9K/92B0Blry
 rJDzxboTnFj2rY5U+xcUjdsOVlf6/nF9V6RCRQKmtD6O+ALeXHFFuME0aN12z2SMWATt /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xrear747g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 15:58:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SFsfa2008128;
        Tue, 28 Jan 2020 15:56:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xtmr2q2t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 15:56:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00SFuntm007157;
        Tue, 28 Jan 2020 15:56:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jan 2020 07:56:49 -0800
Date:   Tue, 28 Jan 2020 07:56:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 9/8] xfs_io: fix integer over/underflow handling in
 timespec_from_string
Message-ID: <20200128155648.GN3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're filling out the struct timespec, make sure we detect when the
string value cannot be represented by a (potentially 32-bit) seconds
field in struct timespec.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxcmd/input.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/libxcmd/input.c b/libxcmd/input.c
index d232d4f3..137856e3 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -183,19 +183,30 @@ timestr(
 
 int
 timespec_from_string(
-	const char	* secs,
-	const char	* nsecs,
-	struct timespec	* ts)
+	const char		*secs,
+	const char		*nsecs,
+	struct timespec		*ts)
 {
-	char* p;
+	char			*p;
+	unsigned long long int	ll;
+
 	if (!secs || !nsecs || !ts)
 		return 1;
-	ts->tv_sec = strtoull(secs, &p, 0);
+
+	ll = strtoull(secs, &p, 0);
 	if (*p)
 		return 1;
-	ts->tv_nsec = strtoull(nsecs, &p, 0);
+	ts->tv_sec = ll;
+	if ((unsigned long long int)ts->tv_sec != ll)
+		return 1;
+
+	ll = strtoull(nsecs, &p, 0);
 	if (*p)
 		return 1;
+	ts->tv_nsec = ll;
+	if ((unsigned long long int)ts->tv_nsec != ll)
+		return 1;
+
 	return 0;
 }
 
