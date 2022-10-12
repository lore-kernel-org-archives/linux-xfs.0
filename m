Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357FFC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJLBpW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLBpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738DF5788E;
        Tue, 11 Oct 2022 18:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B40B61343;
        Wed, 12 Oct 2022 01:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AECAC433D7;
        Wed, 12 Oct 2022 01:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539119;
        bh=BYmatKmuHlODgBxusZDJMX5TlgYoqR+YySoOIErGnWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UGI2MBkRWfI46EIizmg9o1fxnpfMwV98p1ZrB96aA7wQajTZicaDZxpqYXHEtbL7s
         hH1iMlmodASEDWeyKMg8HEeoA/DlhG88RFhAIk/D+kKx2XMNY1d62Umhn2GnCxYVWe
         EVjUXEecZxnQTqcPkEeECaSXDm0S5Kpbn2L0x6c1OZ78enY1kdF76giDWmVjjXnhv0
         XzDF8e/F1RS9dZC15PvWrOevj9Qm8gwTCDffFeLe6hmEwG8pVuIBcVXVRD1+5HPRzq
         CMZGnvXJZyXU1yZ8iH9QjNhxrt7/e3EW6J1nXfjlxaOP+IQ/QZ09VjQCdjwdGWSUZN
         B0Ftd9aRXNIew==
Subject: [PATCH 2/2] check: optionally compress core dumps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:18 -0700
Message-ID: <166553911893.422356.7143540040827489080.stgit@magnolia>
In-Reply-To: <166553910766.422356.8069826206437666467.stgit@magnolia>
References: <166553910766.422356.8069826206437666467.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new option, COREDUMP_COMPRESSOR, that will be used to compress
core dumps collected during a fstests run.  The program specified must
accept the -f -9 arguments that gzip has.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README    |    4 ++++
 common/rc |   14 +++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/README b/README
index 80d148be82..4c4f22f853 100644
--- a/README
+++ b/README
@@ -212,6 +212,10 @@ Tools specification:
     - Set FSSTRESS_AVOID and/or FSX_AVOID, which contain options added to
       the end of fsstresss and fsx invocations, respectively, in case you wish
       to exclude certain operational modes from these tests.
+ - core dumps:
+    - Set COREDUMP_COMPRESSOR to a compression program to compress crash dumps.
+      This program must accept '-f' and the name of a file to compress.  In
+      other words, it must emulate gzip.
 
 Kernel/Modules related configuration:
  - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload it between
diff --git a/common/rc b/common/rc
index 152b8bb414..c68869b7dc 100644
--- a/common/rc
+++ b/common/rc
@@ -4956,13 +4956,17 @@ _save_coredump()
 	local core_hash="$(_md5_checksum "$path")"
 	local out_file="$RESULT_BASE/$seqnum.core.$core_hash"
 
-	if [ -s "$out_file" ]; then
-		rm -f "$path"
-		return
-	fi
-	rm -f "$out_file"
+	for dump in "$out_file"*; do
+		if [ -s "$dump" ]; then
+			rm -f "$path"
+			return 0
+		fi
+	done
 
 	mv "$path" "$out_file"
+	test -z "$COREDUMP_COMPRESSOR" && return 0
+
+	$COREDUMP_COMPRESSOR -f "$out_file"
 }
 
 init_rc

