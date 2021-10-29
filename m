Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF0AC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 08:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B2261075
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 08:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhJ2IxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 04:53:22 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.5]:55646 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231510AbhJ2IxN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Oct 2021 04:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1635497444; i=@fujitsu.com;
        bh=/fUUkCG4KILcfjVVsjJFd1CZYv5+RELEJvg3ij0heRI=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Ib3mvwEBBVYkZ+PhwaIxwgxYxv3jMYt0HBPvMVM1lcheXpFQidQjAkJIKQYSFwrI6
         YoxXcCTwCMjse/0iZi3z7VWjLKv+CfXHu7lZHqi76tRXzrH37/NTV9tRxgxU46LE+q
         e76diqYTyCPVJgg3lh20YUkjxJYAMZtpPXKyfgle1qW1DXpYnn0cZESNcUqY9dowJN
         pVzOCg1d/5pt3JTvSYRjAo+ReriJtSXZtVOVrH/RddlymHDZfvMDYU0j4HIYOBfcQY
         ml9lJ9Nzln3HaRQoMUEvPeN8/iROFZEqNAOieNnEJVh52w8jAJHyHqgPxkys1hUse0
         LCS5X2iVRocYg==
Received: from [100.112.192.69] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.eu-west-1.aws.symcld.net id D9/A9-17094-4E5BB716; Fri, 29 Oct 2021 08:50:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRWlGSWpSXmKPExsViZ8MxRffJ1up
  Eg2fMFpef8FmcbtnLbrHrzw52B2aPTas62Tw+b5ILYIpizcxLyq9IYM24tvIPW8FH1orNNz4w
  NjA2sXYxcnEICbxmlLi44x2Qwwnk7GGUmH9ACcRmE9CUeNa5gBnEFhEQl3i86BYTiM0skCGxo
  esSWL2wgJFE36n/LF2MHBwsAqoStyangoR5BTwkzrx/AlYuIaAgMeXhe2aIuKDEyZlPWCDGSE
  gcfPGCGaJGUeJSxzdGCLtCYtasNqYJjLyzkLTMQtKygJFpFaNFUlFmekZJbmJmjq6hgYGuoaG
  RrqGlsa6RsYleYpVuol5qqW55anGJrqFeYnmxXnFlbnJOil5easkmRmDQpRQcfLWDceWbD3qH
  GCU5mJREeX+urU4U4kvKT6nMSCzOiC8qzUktPsQow8GhJMG7eAtQTrAoNT21Ii0zBxgBMGkJD
  h4lEd6cDUBp3uKCxNzizHSI1ClGXY7L1+ctYhZiycvPS5US570OMkMApCijNA9uBCwaLzHKSg
  nzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5uXdDDSFJzOvBG7TK6AjmICOYFaqADmiJBEhJdXAdHz
  TxvyG4BDvbxe/dZXz7/smblZ9/djs4+IzQpiCPas+652L2nWx+YfkkcwN4d9iVRcY2+2eIl8Y
  8+ZGRJxYa9vFptYAhrDElMaELB6fohcmLTrHDH+mRzRwfjQNyv/4ee01+1lnH/mby4S80bD9m
  cfclLDd+l7cFn9d4861ccknd2/Jmsz8rvJNWLCYlf1zu/wrwUrLHs5zWz3L+bGgUN0K8y0bJz
  gpLX/01CHu/J2pPxPXnnu08sXFV8lJc4N2Vj9MuHBzWnfHh5tKrKGLp00KlOoz/O4b2/7HYRH
  z/srQqC2rly0wtqw6YDBLcy7nrQ8xDI2PucptXl15+S/2D89Lxh7XR/db03X//CzzVWIpzkg0
  1GIuKk4EAJLUhc1BAwAA
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-7.tower-271.messagelabs.com!1635497443!2753!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 32690 invoked from network); 29 Oct 2021 08:50:43 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-7.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 29 Oct 2021 08:50:43 -0000
Received: from R01UKEXCASM126.r01.fujitsu.local ([10.183.43.178])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 19T8oTI9015371
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 29 Oct 2021 09:50:36 +0100
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.24; Fri, 29 Oct 2021 09:50:27 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <djwong@kernel.org>
CC:     <fstests@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH] xfs/126: Add a getxattr opeartion
Date:   Fri, 29 Oct 2021 16:50:24 +0800
Message-ID: <1635497424-8095-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It is design to reproduce a deadlock on upstream kernel. It is introduced
by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").

Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 tests/xfs/126 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/126 b/tests/xfs/126
index c3a74b1c..9a77a60e 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -69,7 +69,7 @@ done
 
 echo "+ mount image && modify xattr"
 if _try_scratch_mount >> $seqres.full 2>&1; then
-
+	getfattr "${SCRATCH_MNT}/attrfile" -n "user.x00000000" 2> /dev/null || _fail "modified corrupt xattr"
 	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
 	umount "${SCRATCH_MNT}"
 fi
-- 
2.23.0

