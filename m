Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE9AC07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA6B61CB3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhGGAXo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhGGAXo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4121261CAD;
        Wed,  7 Jul 2021 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617265;
        bh=2szKknxxEC5rmqegyJNRpjgy4ys28x/b5XxSHgf3cpU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NJIg3G90rFo929lNT4YX7ijffzBqVm+sKLdXkuj0CCAbdlBxuRBDfTIG3CP1j4bDd
         lENeHnslXftVQUEneFBfOfehGMSNlLtMdBf6eT/iUc980AFxAEjC97QyLUI5/8SJ7i
         i6Ce8mcIzIFCspOlmcFz+YrEFhs35E57Svtav/MBKogPRdrkFkHoxzTbcJx5rV+YPc
         ZGeQUs+Kh7wAa44W7eoPgdtfEZku5IlPFmFkWYMJCKZUAH6yFG/jFduOAg2C5IbiB1
         lcFeS+Fs35ubF6294AeXzs0OoHIM/o/0aR/bA2Dn/1hR1XtiaxRcvQy32aRzGpG+GP
         KftjqjCUtuyQQ==
Subject: [PATCH 1/1] new: allow users to specify a new test id
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:04 -0700
Message-ID: <162561726493.543346.17291318180978776290.stgit@locust>
In-Reply-To: <162561725931.543346.16210906692072836195.stgit@locust>
References: <162561725931.543346.16210906692072836195.stgit@locust>
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
 new |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/new b/new
index 07144399..51111f08 100755
--- a/new
+++ b/new
@@ -26,7 +26,18 @@ usage()
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
 

