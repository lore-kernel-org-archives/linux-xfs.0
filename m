Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF01BC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B68B720CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S6zb60Qf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgBYTYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:24:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgBYTYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:24:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJNYVC038101;
        Tue, 25 Feb 2020 19:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Xsm2LlftUFDJFiBMuEwKYkj3C61ZXGg9UzwNSYaqbDo=;
 b=S6zb60QfIonC1pgzqOUQ09n3J3TEpWZlmCX46oPwCWw+swk1jBIIvpsHG8YYw0PPHv36
 3GbSpCP/bVRqLQTsNRnCcSOaTOxcFdHBfCYMXpltbySNwMj4O+pAYBtM5rib//9Ov1en
 rPgRrHlvOFuMfr6gOzXcNeu3GNVoL5b55eTT0CUeKRvBNb1F7nswFlAAppIEVw3yuRpI
 a3xusmAJXPSOsjeFGnyYgiMTnIeL3LtE3RD5S63psF2OVVJnyPovekzvR2T1aiPcKa5z
 ZSnzxwHBLkNSg+ftSofdysu94D5I1Vl1ldMTnk0P15nLButDS9rzbEpDBo/q8pmgPIBv 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yd0njkk2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:24:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJMArY105849;
        Tue, 25 Feb 2020 19:24:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yd09bapp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:24:35 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PJOYME014498;
        Tue, 25 Feb 2020 19:24:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 11:24:33 -0800
Date:   Tue, 25 Feb 2020 11:24:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 6/7] xfs_repair: check that metadata updates have been
 committed
Message-ID: <20200225192432.GS6740@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258946575.451075.126426300036283442.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258946575.451075.126426300036283442.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that any metadata that we repaired or regenerated has been
written to disk.  If that fails, exit with 1 to signal that there are
still errors in the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v2: use the usual error reporting to log and exit
---
 repair/xfs_repair.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index eb1ce546..2ebf6a5b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -703,6 +703,7 @@ main(int argc, char **argv)
 	struct xfs_sb	psb;
 	int		rval;
 	struct xfs_ino_geometry	*igeo;
+	int		error;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -1104,7 +1105,13 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	 */
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
-	libxfs_umount(mp);
+
+	/* Report failure if anything failed to get written to our fs. */
+	error = -libxfs_umount(mp);
+	if (error)
+		do_error(
+	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair."),
+				error);
 
 	if (x.rtdev)
 		libxfs_device_close(x.rtdev);
