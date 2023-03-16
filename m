Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CEBC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCPT1q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPT1p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364F22E0D9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4AB7620EB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BBBC433D2;
        Thu, 16 Mar 2023 19:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994864;
        bh=LlwwJUKG4Kjf76h58g2uNo30ACo51TmhB6fO2Ckq6U8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=p1rWtOOe9O0t66xhWCqtyniUSaGOH7uBaZcODjTntsyBsf1xJAW1IS0P4F7OEt3/t
         e2O9LzmtrcJeDXTSNRkzAH8h28qO4/UpPDn4llXJ8NNDXNcmWtcC3Ml2aReI9JPzJw
         kDdkbBz8nzMwgEY8mYdECdU5rfLwjCnHb6FMcK0bb7hZ8aXjq/E62X+uTXN5ONPKYo
         k1k4dnjMVtUCOowagGXFuVAZhci+MXPnF7APw8Z5ORK8qtJRJjZOoLdcP7JesYJR7j
         8s3sy/4z4K81EC8zntmSa3HQEl6lYniHsw+fpQxpdlGsXacjeXnUxixhxkK2SUevpY
         v2cEnIgKhpgtQ==
Date:   Thu, 16 Mar 2023 12:27:43 -0700
Subject: [PATCH 7/9] xfs_io: print path in path_print
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415468.16278.3065032307974617782.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
References: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
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
index a6f3fa0ca..b18e02c4b 100644
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
 

