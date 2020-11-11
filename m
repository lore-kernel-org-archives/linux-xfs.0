Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8665EC55ABD
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B66721D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qKKqR1E4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbgKKAn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:43:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55176 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKAnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:43:25 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0Xrr2040621;
        Wed, 11 Nov 2020 00:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HU4YD3virhhB4KWCTgXqdQzjB92zkoRForXhRqWUoHU=;
 b=qKKqR1E4b945YxBDml+ANixkyvdFzgXL9DJkQ250tGKf/R11zu3gO3GK4cUXIgWPJaEx
 nGRNVxyROUfAUZtXKX2Iyn1DKg6Y+uSJgz51whFuXmKI/mlcdsA7Nyi/0xvV34kGYdIQ
 U9S4jbq8P7amuJyQjLJCnOm5Yr6jFo0bmspu72ynIAeKtGKzCTNxXluWbIMr7UFm10Po
 BJ3Vvlpy20X2gxppC1H+waX3F/kvdH5cVQePln9FktMj3B63buQlNbQF1qeT9d5A6MfX
 csyebcEIjWH/G1IYe/uLiJKz3ISfHuqQneObI07fklXkpfiCHiHNXJwF/4RMsM0MjaIX hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3axw1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:43:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0V6Za027505;
        Wed, 11 Nov 2020 00:43:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34qgp7kqes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0hM7B000494;
        Wed, 11 Nov 2020 00:43:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:17 -0800
Subject: [PATCH 2/6] check: run tests in a systemd scope for mandatory test
 cleanup
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:43:16 -0800
Message-ID: <160505539618.1388647.12413009405934961273.stgit@magnolia>
In-Reply-To: <160505537312.1388647.14788379902518687395.stgit@magnolia>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

TLDR: If systemd is available, run each test in its own temporary
systemd scope.  This enables the test harness to forcibly clean up all
of the test's child processes (if it does not do so itself) so that we
can move into the post-test unmount and check cleanly.

I frequently run fstests in "low" memory situations (2GB!) to force the
kernel to do interesting things.  There are a few tests like generic/224
and generic/561 that put processes in the background and occasionally
trigger the OOM killer.  Most of the time the OOM killer correctly
shoots down fsstress or duperemove, but once in a while it's stupid
enough to shoot down the test control process (i.e. tests/generic/224)
instead.  fsstress is still running in the background, and the one
process that knew about that is dead.

When the control process dies, ./check moves on to the post-test fsck,
which fails because fsstress is still running and we can't unmount.
After fsck fails, ./check moves on to the next test, which fails because
fsstress is /still/ writing to the filesystem and we can't unmount or
format.

The end result is that that one OOM kill causes cascading test failures,
and I have to re-start fstests to see if I get a clean(er) run.

So, the solution I present in this patch is to teach ./check to try to
run the test script in a systemd scope.  If that succeeds, ./check will
tell systemd to kill the scope when the test script exits and returns
control to ./check.  Concretely, this means that systemd creates a new
cgroup, stuffs the processes in that cgroup, and when we kill the scope,
systemd kills all the processes in that cgroup and deletes the cgroup.

The end result is that fstests now has an easy way to ensure that /all/
child processes of a test are dead before we try to unmount the test and
scratch devices.  I've designed this to be optional, because not
everyone does or wants or likes to run systemd, but it makes QA easier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 check |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)


diff --git a/check b/check
index 5072dd82..83f6fc8b 100755
--- a/check
+++ b/check
@@ -521,6 +521,12 @@ _expunge_test()
 	return 0
 }
 
+# Can we run systemd scopes?
+HAVE_SYSTEMD_SCOPES=
+systemctl reset-failed "fstests-check" &>/dev/null
+systemd-run --quiet --unit "fstests-check" --scope bash -c "exit 77" &> /dev/null
+test $? -eq 77 && HAVE_SYSTEMD_SCOPES=yes
+
 # Make the check script unattractive to the OOM killer...
 OOM_SCORE_ADJ="/proc/self/oom_score_adj"
 test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
@@ -528,8 +534,26 @@ test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
 # ...and make the tests themselves somewhat more attractive to it, so that if
 # the system runs out of memory it'll be the test that gets killed and not the
 # test framework.
+#
+# If systemd is available, run the entire test script in a scope so that we can
+# kill all subprocesses of the test if it fails to clean up after itself.  This
+# is essential for ensuring that the post-test unmount succeeds.  Note that
+# systemd doesn't automatically remove transient scopes that fail to terminate
+# when systemd tells them to terminate (e.g. programs stuck in D state when
+# systemd sends SIGKILL), so we use reset-failed to tear down the scope.
 _run_seq() {
-	bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq"
+	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq")
+
+	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
+		local unit="$(systemd-escape "fs$seq").scope"
+		systemctl reset-failed "${unit}" &> /dev/null
+		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"
+		res=$?
+		systemctl stop "${unit}" &> /dev/null
+		return "${res}"
+	else
+		"${cmd[@]}"
+	fi
 }
 
 _detect_kmemleak

