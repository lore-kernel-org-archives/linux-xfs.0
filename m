Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8269DC12002
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB7260FF3
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhGTAat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378034AbhGTA1n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:27:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 611406108B;
        Tue, 20 Jul 2021 01:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743302;
        bh=BXPjE561FDFtSFdZ/uwoutkkgt/V2CSQ1ewQnMQ/jRM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kqXEQ9TvDkiQMN8fOQo4ExhurpLzpOEXqFrCALvfqrVHTVMR6YDgIa3qGNUtc9Lyu
         O3nAwxEC+ubaInz1yPC4QkaH73iJqGoTtB0rikeX50IjD7DG8VBj+rkM17ID15tjk5
         8i1wxrff1Nq3uhjDp0b4tEtF++Eu0WNuV+eymL0iVYtzyKQsMUEOXCLAYj5+3qSHyO
         wOjbOPZzQWFCttZYNw5QGLuZ/7xHFbU7YWH0H+Cl9rhpXeSbWxrNwicJWTj9JH3niT
         K6lpqCwf+XwrO1bd5kXR2vHSBSezmzhFvpSy7XfSMbs47JlL9JkBfAvcf5KGbtU8dZ
         c1Wk7NnoqAf5g==
Subject: [PATCH 1/1] new: allow users to specify a new test id
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:22 -0700
Message-ID: <162674330211.2650678.4087092414669814557.stgit@magnolia>
In-Reply-To: <162674329655.2650678.3298345419686024312.stgit@magnolia>
References: <162674329655.2650678.3298345419686024312.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Alter the ./new script so that one can set the test id explicitly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 new |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/new b/new
index 07144399..2097a883 100755
--- a/new
+++ b/new
@@ -20,13 +20,24 @@ _cleanup()
 SRC_GROUPS=`find tests -not -path tests -type d -printf "%f "`
 usage()
 {
-    echo "Usage $0 test_dir"
+    echo "Usage $0 test_dir|test_dir_and_name"
     echo "Available dirs are: $SRC_GROUPS"
     exit
 }
 
 [ $# -eq 0 ] && usage
-tdir=tests/$1
+
+if echo "$1" | grep -q '/'; then
+	if [ -e "tests/$1" ]; then
+		echo "$1: test already exists."
+		exit 1
+	fi
+	tdir="tests/$(echo "$1" | cut -d '/' -f 1)"
+	id="$(echo "$1" | cut -d '/' -f 2)"
+else
+	tdir=tests/$1
+	id="$(basename "$(./tools/nextid "$1")")"
+fi
 
 i=0
 line=0
@@ -36,7 +47,6 @@ eof=1
 export AWK_PROG="$(type -P awk)"
 [ "$AWK_PROG" = "" ] && { echo "awk not found"; exit; }
 
-id="$(basename "$(./tools/nextid "$1")")"
 echo "Next test id is $id"
 shift
 

