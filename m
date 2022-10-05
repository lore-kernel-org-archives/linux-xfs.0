Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A18C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 22:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJEWbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiJEWbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:31:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1FD844E9;
        Wed,  5 Oct 2022 15:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38BA5617DC;
        Wed,  5 Oct 2022 22:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EAFC433B5;
        Wed,  5 Oct 2022 22:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009081;
        bh=IUPQRUwd9hQ1q2fKK6odedYbtKf8b7x2caILxzfcadU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iJQH34xpi83CP6Pvi/6HwMYTHY/sZVNLgvKCsoAcPLpxAVrSd06zpEBWsuTyqn9+4
         ss8gQxwJtg1FPn7NGGQcNuGKESjP3ZlBfk5xvY70yRvYyvH5BWpry1b7ubt1X8KMXd
         s707vlkUeS3vGPQicTC5OVvcxaDCDSNZovDxZqrtM+PqYNe9GDN3fzJYz5pByhtXR3
         FyzmP4oI/+uXQy8vUmv7vb4SKHIRVPF9tv7aIxZQyrOgTSomj1MQlc43dMY5ZXrMMI
         fN/TRdSBTkZeiFYGbxqrY5YyY/4HT3ENLvpjYGxgVI4CIUVWbtWMEd6+VYKr7Foz84
         iswdhwrVGC05A==
Subject: [PATCH 2/2] check: optionally compress core dumps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:31:21 -0700
Message-ID: <166500908117.887104.12652015559068296578.stgit@magnolia>
In-Reply-To: <166500906990.887104.14293889638885406232.stgit@magnolia>
References: <166500906990.887104.14293889638885406232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Compress coredumps whenever desired to save space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README    |    1 +
 common/rc |   13 +++++++++++++
 2 files changed, 14 insertions(+)


diff --git a/README b/README
index 80d148be82..ec923ca564 100644
--- a/README
+++ b/README
@@ -241,6 +241,7 @@ Misc:
    this option is supported for all filesystems currently only -overlay is
    expected to run without issues. For other filesystems additional patches
    and fixes to the test suite might be needed.
+ - Set COMPRESS_COREDUMPS=1 to compress core dumps with gzip -9.
 
 ______________________
 USING THE FSQA SUITE
diff --git a/common/rc b/common/rc
index 9750d06a9a..d3af4e07b2 100644
--- a/common/rc
+++ b/common/rc
@@ -4955,12 +4955,25 @@ _save_coredump()
 	local core_hash="$(_md5_checksum "$path")"
 	local out_file="$RESULT_BASE/$seqnum.core.$core_hash"
 
+	if [ "$COMPRESS_COREDUMPS" = "1" ]; then
+		out_file="${out_file}.gz"
+	fi
+
 	if [ -s "$out_file" ]; then
 		rm -f "$path"
 		return
 	fi
 	rm -f "$out_file"
 
+	if [ "$COMPRESS_COREDUMPS" = "1" ]; then
+		if gzip -9 < "$path" > "$out_file"; then
+			rm -f "$path"
+		else
+			rm -f "$out_file"
+		fi
+		return
+	fi
+
 	mv "$path" "$out_file"
 }
 

