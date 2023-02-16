Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95F0C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjBPVDp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPVDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:03:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22232A16F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95A20B8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271CFC433EF;
        Thu, 16 Feb 2023 21:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581420;
        bh=ZQizVFdLDlCT9exkEmiE2JxrgLN23LNtWEBpmVX7HpY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KrnDVX6rdHmnrxhXjW1GII4TTrxNqIXEIvTy1/bvY/eXSo9tdfUXAl+VHjIydyeIQ
         7dx0/gpbSIuUhVW98IHJyK7f9R/ITu6pU1xLC3Ia/lqhAELW0NQWIB3xb7dNNSKZG2
         QLHVoeowZxOJVlJmM8rX7YlteF/8gkB2l6ei7dJ6uSmYNLh3mJfnM4VjvF77U4JCD6
         TP2XcKjhjr6gdG3RjPGRI+dPOzU/PAqTLn6Z1btuEaGxeGNagN4kake1g/EaaLHObM
         SpgN9/EIEqlYbblE/gYuWzl5lVLFJW7q7FQzGYRFpx3+ru7XmSHDJ8iiaeVVerbXZ9
         uZDJ4mwF8AAyA==
Date:   Thu, 16 Feb 2023 13:03:39 -0800
Subject: [PATCH 02/10] xfs_io: print path in path_print
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880284.3477097.17451710627088149390.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Actually print the path string once we've bothered to construct it into
a string buffer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/io/parent.c b/io/parent.c
index a6f3fa0c..b18e02c4 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -87,6 +87,8 @@ path_print(
 	ret = path_list_to_string(path, buf + ret, len - ret);
 	if (ret < 0)
 		return ret;
+
+	printf("%s\n", buf);
 	return 0;
 }
 

