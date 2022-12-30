Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC84DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiLaApa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiLaAp1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:45:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ECE1D0C8;
        Fri, 30 Dec 2022 16:45:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3815A61D60;
        Sat, 31 Dec 2022 00:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9600AC433EF;
        Sat, 31 Dec 2022 00:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447525;
        bh=3x3XEDRXMs+IWlpWKgflc3vUvWTqgKOotEG36aBKnGM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m9H4wZznkdSBgIMT8Y9lkCArvg4jW3ziaMfwaNQ9QeJ8kF0dWEqVUJhOauSsjrfS/
         5AKvn4KqbHdy+clTvoa4OePYDXyn1nqvKiETwy9sUA5iZu/H+nRT2azs+BypqWjRuA
         miRVJagG8QWnsNtrCjH67Gem2XPTifUQ5U5CEO47K0w4iUK+pxQjO1blkT5s5LJtEb
         qtVXg7ClMzPlraCOafHSmjU9AVd9R7Bx5YmcMvovypuicN2v3+mE+q+Y5UR3DL2AqS
         lxA7hIj+lUX8gYHGC/VjTyUH7c3NZNTPpaJPqFH2GC+fAGTJxNXb2Yl3L7MsJPwbGi
         Jh+NbdgRJPXQA==
Subject: [PATCH 05/24] fuzzy: don't fuzz inode generation numbers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877973.730387.11174533211065383401.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The inode generation number is a randomly selected 32-bit integer that
isn't itself validated anywhere.  No need to fuzz that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index d183052a14..0d7e60a011 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -83,7 +83,8 @@ __filter_unvalidated_xfs_db_fields() {
 	    -e '/\.lsn/d' \
 	    -e '/^core.flushiter/d' \
 	    -e '/^core.dmevmask/d' \
-	    -e '/^core.dmstate/d'
+	    -e '/^core.dmstate/d' \
+	    -e '/^core.gen/d'
 }
 
 # Filter the xfs_db print command's field debug information

