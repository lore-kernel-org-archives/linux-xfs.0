Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF56FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJLBpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLBpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD34E5A8B7;
        Tue, 11 Oct 2022 18:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99796B818B7;
        Wed, 12 Oct 2022 01:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52448C433D6;
        Wed, 12 Oct 2022 01:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539128;
        bh=mu+XQWULgwqOd8CE4Ws0V4Kvx564Sq55kRsjdB67D6c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RXIAbpOg0vfgmUAPHmTbgDLE+pW9cUE4znlkHeGhkepr/3Hfs0AHDiEL7dHwJ/THE
         8V44YxHG1/PWeeMCoFrqm7wgbs2kb/M8D5aVNwDaidO6Hu1pZb8k4pSFleTDhOQRem
         xu+YLhkhdy2z2ODMkuHKdLktqD3ucor1RotroBhLPGkixuC5PWQACMUbxIvJRuNCGS
         DJdlW1ypPOgLU6E7HsmRQKT1+fTawTe0lB8roOf5VtIEgxsV7E/74HmsDMwnTx5BZp
         VQqk5vi6bpEwf3pTnr3BdyifAEiGeaaWOA+z/1CgQCZ3OB9l3S3UHwLV/06sjwo51E
         AKohdcEU7i0WQ==
Subject: [PATCH 1/5] populate: export the metadump description name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:27 -0700
Message-ID: <166553912788.422450.6797363004980943410.stgit@magnolia>
In-Reply-To: <166553912229.422450.15473762183660906876.stgit@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Not sure why this hasn't been broken all along, but we should be
exporting this variable so that it shows up in subshells....

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/populate b/common/populate
index cfdaf766f0..b501c2fe45 100644
--- a/common/populate
+++ b/common/populate
@@ -868,9 +868,9 @@ _scratch_populate_cached() {
 	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
 	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
 
-	# These variables are shared outside this function
-	POPULATE_METADUMP="${metadump_stem}.metadump"
-	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
+	# This variable is shared outside this function
+	export POPULATE_METADUMP="${metadump_stem}.metadump"
+	local POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
 
 	# Don't keep metadata images cached for more 48 hours...
 	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"

