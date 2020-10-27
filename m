Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8457AC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 276E1206F7
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r0qMllIr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444558AbgJ0TCZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410146AbgJ0TCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItFxp021979;
        Tue, 27 Oct 2020 19:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1uN6tgkxmEJ5UX6qSGjTRGy8/W3t2gP27dkRxZp6kZU=;
 b=r0qMllIr+nWq/+AldiCVV3+tDNG1aaJuOp6uZGvF0yjU9XnYtrW/J9w+O7OfNaw5jQvs
 UDZxT5r7APKI2lEPZDODtQfihZl6kilvPVYhqZuVw6zlDBpOB6zkVwyEukCZTsiHMm/5
 2aW1IjmOo/h+Rer+U7anzrDD6C6CUz7E3Nc68eJHyKBbtkqL9fuxbxeJrT4Jq+86Uppd
 smmsKuLxXYt1O+/NZbzwL5QSTrMGL3b+RtLth0RE4SRu+J9abaZ/de+uqCRZITFH8ldC
 RX6syflszVwP7hd3YhUh5ATCOZJpYrb1FKSRj+JhmrmQuIoGhaIavKFwojM/uehXdHIn 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sav05t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:02:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2Pg132992;
        Tue, 27 Oct 2020 19:02:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx5xg882-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:22 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ2M29006155;
        Tue, 27 Oct 2020 19:02:22 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:22 -0700
Subject: [PATCH 8/9] check: run tests in a systemd scope for mandatory test
 cleanup
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:21 -0700
Message-ID: <160382534122.1202316.7161591166906029132.stgit@magnolia>
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If systemd is available, run each test in its own temporary systemd
scope.  This enables the test harness to forcibly clean up all of the
test's child processes (if it does not do so itself) so that we can move
into the post-test unmount and check cleanly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)


diff --git a/check b/check
index 5072dd82..47c72fa2 100755
--- a/check
+++ b/check
@@ -521,6 +521,11 @@ _expunge_test()
 	return 0
 }
 
+# Can we run systemd scopes?
+HAVE_SYSTEMD_SCOPES=
+systemd-run --quiet --unit "fstests-check" --scope bash -c "exit 77" &> /dev/null
+test $? -eq 77 && HAVE_SYSTEMD_SCOPES=yes
+
 # Make the check script unattractive to the OOM killer...
 OOM_SCORE_ADJ="/proc/self/oom_score_adj"
 test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
@@ -528,8 +533,22 @@ test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
 # ...and make the tests themselves somewhat more attractive to it, so that if
 # the system runs out of memory it'll be the test that gets killed and not the
 # test framework.
+#
+# If systemd is available, run the entire test script in a scope so that we can
+# kill all subprocesses of the test if it fails to clean up after itself.  This
+# is essential for ensuring that the post-test unmount succeeds.
 _run_seq() {
-	bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq"
+	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq")
+
+	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
+		local unit="$(systemd-escape "fs$seq").scope"
+		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"
+		res=$?
+		systemctl stop "${unit}" &> /dev/null
+		return "${res}"
+	else
+		"${cmd[@]}"
+	fi
 }
 
 _detect_kmemleak

