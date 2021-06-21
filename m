Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E438C48BC2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E3A61164
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFUXM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhFUXM1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C03860FDB;
        Mon, 21 Jun 2021 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317012;
        bh=JkyMfuGYugV8FYDP9sVGe6EZ99S16jZUqZgys3jToTE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PqWl+xdCyY3YHqmQRwPEa2b5+EBiEYDJ6M+QSMQUr60SA54NPWTxBVecSrKOaE4gG
         5ofUfhYbC0S0Y4+eENDZ/M+s7+BMCpiEsXP5WI7PA6w0x790KU6OrCxtzeLd1+uxSL
         1+QaEcLeA8AqMB8WV5GZkBUi9XIY+IV7cGnoGMwC6RCpJONEFMYukZTJN0a8nQATkc
         BjqE1ARZJ+gE/OSf7nzCvk+Sh6tyL86ZHdMwBJZz2z63Q8kOOeTb+Q29WEJ76edJKf
         ZbBipcbgN5Ci/cseQ/3e/JPht4sr6mLhr2Y6Y235cwzds4Ks01dhGeUGeAuXv33qbF
         O4AUCumnpQGow==
Subject: [PATCH 01/13] fstests: fix group check in new script
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:10:12 -0700
Message-ID: <162431701217.4090790.3582211048806383763.stgit@locust>
In-Reply-To: <162431700639.4090790.11684371602638166127.stgit@locust>
References: <162431700639.4090790.11684371602638166127.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the tests/*/group files, group names are found in the Nth columns of
the file, where N > 1.  The grep expression to warn about unknown groups
is not correct (since it currently checks column 1), so fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 new |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/new b/new
index bb427f0d..357983d9 100755
--- a/new
+++ b/new
@@ -243,10 +243,7 @@ else
     #
     for g in $*
     do
-	if grep "^$g[ 	]" $tdir/group >/dev/null
-	then
-	    :
-	else
+	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
 	    echo "Warning: group \"$g\" not defined in $tdir/group"
 	fi
     done

