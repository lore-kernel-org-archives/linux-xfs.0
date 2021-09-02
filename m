Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398C5C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2489F6109E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345591AbhIBXxu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhIBXxt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Sep 2021 19:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D93F86103A;
        Thu,  2 Sep 2021 23:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630626770;
        bh=nzD09Q/tAZ4eU7/GUDYfiWz1uRucqWOZNgFTCrx3700=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KtuWmZLXuqjuHqtajdsdHH9Q8BKBzb9N6QxWqzw2MrOl2cKzVsnvwJ4HsVQHgJJy0
         gPvYg2NIzYjd/jZZXWM8aoSP4nuuQcRDqWAqMvyJFJdcg2G6yfzUyGRWH38JWXEvpD
         sOY6HWy2NEkdqVFrUeQtAq97VbgzlJwlE7sQevSp6m2kQL1D2xV+gJDN03bp3B5ftz
         VFrUCydBS+DoErmE/gkEl6LwyepFQaFJNgE6GEYKgQ6GtY0n632Va01AXSTU3nVMma
         33jnZ/Ys4Viv49v4aglkZYu07W85L2BzTt4hRZ+dPooOTTVrRMfZlTavocNcSf65qz
         QsSvOKFFZ/Ozw==
Subject: [PATCH 5/8] generic/631: change this test to use the 'whiteout' group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 02 Sep 2021 16:52:50 -0700
Message-ID: <163062677061.1579659.11968268236095449158.stgit@magnolia>
In-Reply-To: <163062674313.1579659.11141504872576317846.stgit@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test isn't really an overlay test; it's a regression test for a bug
that someone found in xfs handling of whiteout files.  Since the
'overlay' group has one member, let's move it to 'whiteout'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/631 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/631 b/tests/generic/631
index a1acdedb..aae181dd 100755
--- a/tests/generic/631
+++ b/tests/generic/631
@@ -22,7 +22,7 @@
 # in xfs_rename").
 
 . ./common/preamble
-_begin_fstest auto rw overlay rename
+_begin_fstest auto rw whiteout rename
 
 # Override the default cleanup function.
 _cleanup()

