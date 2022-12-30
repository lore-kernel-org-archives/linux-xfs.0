Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EEFC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbiLaAo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbiLaAo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:44:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845E81D0C8;
        Fri, 30 Dec 2022 16:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2423261D5E;
        Sat, 31 Dec 2022 00:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AADC433D2;
        Sat, 31 Dec 2022 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447494;
        bh=lg6Kci8gAYkjBnA4jWbeTc6udRQF7YkXDDDl0IBixn4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dxtddWgr78MINX3uZmdN2ku7yb0xAS6HSsI1Jp0uPA+ddod75YMepiVGGSvfXcFw8
         P9iiDZA2L4JmIZQ+58axvmm0cNFBJyyqTOBwNAFJkvElWxiloEd50w56MahGoYAMtj
         Ew8Ut6gNBebFxJQ0iPUmFIg6Wp3Tf5KYUBMxD/tQdLfw3/qILatdFZ92SgulJkARmO
         /VU0iDA/9Y5e3mBpT8sf9GnMqhfbvGN2mXU52jNNn3yJKUCDeIKoYzwxW/oH8AL2iq
         HkgcNY1Y1nHWxQbk4V6IfZ9TJnUc6gTzHvbbGjmG5/B/Nl2/a2RHDhSYpbIj+l7BRx
         89OZELs6m7kNA==
Subject: [PATCH 03/24] fuzzy: don't fuzz the log sequence number
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877946.730387.8683116177682310024.stgit@magnolia>
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

Don't bother filtering log sequence numbers since xfs_db doesn't have
the ability to tell us the range of LSNs that would actually cause
validation failures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 2798c257a0..677e655d68 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -78,7 +78,9 @@ __filter_xfs_db_keys() {
 # does no validation.
 __filter_unvalidated_xfs_db_fields() {
 	sed -e '/\.sec/d' \
-	    -e '/\.nsec/d'
+	    -e '/\.nsec/d' \
+	    -e '/^lsn$/d' \
+	    -e '/\.lsn/d'
 }
 
 # Filter the xfs_db print command's field debug information

