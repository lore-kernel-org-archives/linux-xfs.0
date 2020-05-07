Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE5EC54E49
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 19:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF7C21BE5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588879358;
	bh=qrpmzCPpQ9HFwu20utBp+1OHeWSt1E7WeS45pMG/mJs=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=zmx3rNsIG1bqULb//Loe/7luYDOcVnuXQ/vGYn58+s8lu8n9dWx7mARE0XIA+iOp4
	 76hDJ867JhZr4RN6JXsDTWG05CFYpeDCGUkIKITwJMlMANY8dgllIDq/NaYKIzfb4N
	 qCnlvoaA3RJyyShTvcmdEzWZDME6JinvI5zS+OKg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEGTWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 15:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbgEGTWi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 15:22:38 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF22208D6;
        Thu,  7 May 2020 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588879357;
        bh=qrpmzCPpQ9HFwu20utBp+1OHeWSt1E7WeS45pMG/mJs=;
        h=Date:From:To:Cc:Subject:From;
        b=Fp/WP7t+5M1ymFQtuRe7hYifflClNVPTtZoQw9uQl4yIVRKjMOi+xt9rmlUxGLqZm
         tY/iHj0FIqT36g/Uaff0wYK2dT7kjDU39258TKc5vefvt7ujUgpKApzBg+cry/AfTC
         blajwso2+n7raYEqoC55p1i7IE4icUBvJZ0fwNsA=
Date:   Thu, 7 May 2020 14:27:03 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: Replace zero-length array with flexible-array
Message-ID: <20200507192703.GA16784@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 045556e78ee2..592f1c12ad36 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1681,7 +1681,7 @@ struct xfs_acl_entry {
 
 struct xfs_acl {
 	__be32			acl_cnt;
-	struct xfs_acl_entry	acl_entry[0];
+	struct xfs_acl_entry	acl_entry[];
 };
 
 /*

