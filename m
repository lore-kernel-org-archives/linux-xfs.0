Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C377C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EFD3613C7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348958AbhDNBFR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348955AbhDNBFR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76BCC613B6;
        Wed, 14 Apr 2021 01:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362296;
        bh=pbYuwrUWXL3AUu2acpNZ4vhttw1ifQap+9ZkRWLPkiQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mZYLuLo95AUsETGAp2LkaRduHdAfW6vTmxRGlMwAB9qN09S4a5iKuWK7CMUp5fxvf
         CNo13e6JgLjkfeDzRB8MZSFssZDv8Yt0ovgLoOMAn12bHGpIN5xWpflyubrPwMDKZP
         lFX+ctgLq4J/YL7ms6UK1orfT21QilWoMrC8gXCOhZKaw0t1s+N6o+jWArWB3Ibzh8
         RZydVhGllLlWtFQnxAA5RsA0aGwzbSKKLT4ZH7wezlCbg5Le6J4wc4M6dxodMCSHZB
         2sAXOhs/BlMI7x47qt1+9rF5jNSumacGJyDW+Fl0GnCA6sp94ETenN1pCoPcdG7Vq/
         LblzyzuSEQY0g==
Subject: [PATCH 4/9] common/dump: filter out xfs_restore messages about
 fallocate failures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:04:54 -0700
Message-ID: <161836229453.2754991.3539097521630217821.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

fallocate is not supported on XFS filesystems that are running in
"always COW" mode.  This leads to false test regressions because
xfs_restore complains about EOPNOTSUPP in the golden output.  The
preallocation isn't required for correct xfs_restore operation, so
filter out the EOPNOTSUPP messages.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dump |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/dump b/common/dump
index 2b8e0893..3c4029ff 100644
--- a/common/dump
+++ b/common/dump
@@ -866,6 +866,7 @@ _dump_filter_main()
       -e 's/id:[[:space:]]*[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}/ID: ID/'						\
       -e 's/\[y\/n\][- ]----------------------*/\[y\/n\]/'		\
       -e '/skip attribute set/d'				\
+      -e '/xfsrestore: NOTE: attempt to reserve [0-9]* bytes for.*Operation not supported/d' \
   | perl -ne '
 	# filter out all the output between the lines "Dump Summary:"
 	# and "Dump Status:"

