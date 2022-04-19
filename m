Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2AAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352885AbiDSRes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350190AbiDSRer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:34:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433137BE0;
        Tue, 19 Apr 2022 10:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C915B81920;
        Tue, 19 Apr 2022 17:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398A8C385A7;
        Tue, 19 Apr 2022 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650389521;
        bh=tps1+sWgLKwoNkHgkgrdlVpGGaQd7uHTSCEGzBQo8Gc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bqMkA4G9+Hbm5cyRTBEtBVLS0YtDs9IoJZqBD+VKPq6oMDkj3RjGKRob++/wV109d
         ANE+2jUQaf0H9rSkZdHPWQAT498xWBNUZXxAN6+OPGVwusZgCweilnLrrq7kq0Suax
         NGMdm2Pk76RUEfigKrURhuNv83Q0Ps7ZoxiQ8IlOj/KExFJcDEfJ0vLqgn/bNVukVE
         u4OjEzH0H1IWliLrFJQu5jjFcJBeOpB0bmjuUPX+2aCHRNOQZ+wTmxr5Eogig8zKlh
         RHr5elctwpAxqkipFoqSNr47kg7cOBjYCFJoZNp0MJbEnwNDd5nXlfPZW1MClzyQ6m
         nnfEkUp6IJ07g==
Subject: [PATCH 1/2] xfs/019: fix golden output for files created in setgid
 dir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 19 Apr 2022 10:32:00 -0700
Message-ID: <165038952072.1677615.13209407698123810165.stgit@magnolia>
In-Reply-To: <165038951495.1677615.10687913612774985228.stgit@magnolia>
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A recent change to xfs/019 exposed a long-standing bug in mkfs where
it would always set the gid of a new child created in a setgid directory
to match the gid parent directory instead of what's in the protofile.

Ignoring the user's directions is not the correct behavior, so update
this test to reflect that.  Also don't erase the $seqres.full file,
because that makes forensic analysis pointlessly difficult.

Cc: Catherine Hoang <catherine.hoang@oracle.com>
Fixes: 7834a740 ("xfs/019: extend protofile test")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/019     |    3 +--
 tests/xfs/019.out |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/019 b/tests/xfs/019
index 535b7af1..790a6821 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -10,6 +10,7 @@
 _begin_fstest mkfs auto quick
 
 seqfull="$seqres.full"
+rm -f $seqfull
 # Import common functions.
 . ./common/filter
 
@@ -97,7 +98,6 @@ _verify_fs()
 	echo "*** create FS version $1"
 	VERSION="-n version=$1"
 
-	rm -f $seqfull
 	_scratch_unmount >/dev/null 2>&1
 
 	_full "mkfs"
@@ -131,6 +131,5 @@ _verify_fs()
 _verify_fs 2
 
 echo "*** done"
-rm $seqfull
 status=0
 exit
diff --git a/tests/xfs/019.out b/tests/xfs/019.out
index 8584f593..9db157f9 100644
--- a/tests/xfs/019.out
+++ b/tests/xfs/019.out
@@ -61,7 +61,7 @@ Device: <DEVICE> Inode: <INODE> Links: 2
 
  File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
  Size: 5 Filetype: Regular File
- Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
 Device: <DEVICE> Inode: <INODE> Links: 1 
 
  File: "./pipe"

