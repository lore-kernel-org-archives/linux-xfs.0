Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E104C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbjDDXRK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjDDXRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2F44200;
        Tue,  4 Apr 2023 16:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD92638ED;
        Tue,  4 Apr 2023 23:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13708C433EF;
        Tue,  4 Apr 2023 23:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680650227;
        bh=/nKlwZxCQrgiPCN8nqKQXsGE3xozZu0KoZoBHX5uLPA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sfnf4YXnEcdDoh12PvJQglKVflrbgVDMBI9HEQTiNcN/85YHNKs9rc760YOancy5o
         7eXJWZDqsFPMySBrDJCtftfSyLDuuRHiCWWVRljgmD1TrXbvo2JdUOG/GnABxDpsVi
         wcVulm92IwaHNWVmGaGslMSnk3nUT9U7SrRSS+KBbCZaiR5EpRZWYbxj62Jr1mqRLg
         PsDJrrkBqbvOMgB9IdFQACqBnBMHMhLmPa1fVTa8H/NirwwzREpkEEtbKml/Tu0YKr
         rcVRxsJIuetEVr/AOwVOZOiONKSGsbIuc+JRbq3brIx88s5XDbsUzaCURyJKEdv8fm
         rIaR8jO5/2Efw==
Subject: [PATCH 3/3] populate: create fewer holes in directories and xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 04 Apr 2023 16:17:06 -0700
Message-ID: <168065022660.494608.3347185703277760781.stgit@frogsfrogsfrogs>
In-Reply-To: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
References: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The same study of aging filesystem metadumps also showed that the rate
of file and xattr deletion is a lot lower than what this script does.
Decrease the deletion interval from every other file/name to every 19th
item to get us to a more reasonable 5% deletion rate, but with a prime
number. ;)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/populate b/common/populate
index 524e0c32cb..3d233073c9 100644
--- a/common/populate
+++ b/common/populate
@@ -89,7 +89,7 @@ __populate_create_dir() {
 	$here/src/popdir.pl --dir "${name}" --end "${nr}" "$@"
 
 	test -z "${missing}" && return
-	$here/src/popdir.pl --dir "${name}" --start 1 --incr 2 --end "${nr}" --remove "$@"
+	$here/src/popdir.pl --dir "${name}" --start 1 --incr 19 --end "${nr}" --remove "$@"
 }
 
 # Create a large directory and ensure that it's a btree format
@@ -123,7 +123,7 @@ __populate_xfs_create_btree_dir() {
 	done
 
 	test -z "${missing}" && return
-	$here/src/popdir.pl --dir "${name}" --start 1 --incr 2 --end "${nr}" --remove
+	$here/src/popdir.pl --dir "${name}" --start 1 --incr 19 --end "${nr}" --remove
 }
 
 # Add a bunch of attrs to a file
@@ -138,7 +138,7 @@ __populate_create_attr() {
 		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --end "${nr}"
 
 		test -z "${missing}" && return
-		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --start 1 --incr 2 --end "${nr}" --remove
+		${PYTHON3_PROG} $here/src/popattr.py --file "${name}" --start 1 --incr 19 --end "${nr}" --remove
 		return
 	fi
 

