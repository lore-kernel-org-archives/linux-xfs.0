Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4604FC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Feb 2022 02:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiBZCxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 21:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBZCxE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 21:53:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFAF3206F
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 18:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 388E6B83408
        for <linux-xfs@vger.kernel.org>; Sat, 26 Feb 2022 02:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5FEC340E7;
        Sat, 26 Feb 2022 02:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645843947;
        bh=aCCdGoJctqCyMEnJi2FCgsd6L18vEbHN3mbIwQ5z9D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ltRGj5kny1PNhzQCwii9iWe2s39YziFWMqYkeZuL3II762sr3gHQ/fIuQUdabxADp
         UDSuTWmch2u/RGdOrKngaXlhwh5HFk4JMGHepO+8wxyrZEBi2L27tbjF9ANEa81HR4
         HIKQwlST/aJuIPfMJOjCfNrkd1sC58l+LTeZ/WWIuMC2u1PMivSh863FGsyabRzHwF
         c7955wS1HRnBjuBP8xzqSw3eT/fX4FZHNLHW6JcS6gMtTiNAqVZNm+hPI3hLaNu6Or
         xuunl3dLHC5bOOhamVjxfvD0lp79xrNI5pwloaa7PKdm5uzQcaMJxwOE8IS8h1DPw2
         J529E+ukcADcg==
Date:   Fri, 25 Feb 2022 18:52:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: [PATCH v2 16/17] mkfs: add a config file for x86_64 pmem filesystems
Message-ID: <20220226025227.GW8313@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263818283.863810.4750810429299999067.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263818283.863810.4750810429299999067.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We have a handful of users who continually ping the maintainer with
questions about why pmem and dax don't work quite the way they want
(which is to say 2MB extents and PMD mappings) because they copy-pasted
some garbage from Google that's wrong.  Encode the correct defaults into
a mkfs config file and ship that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: s/sunit/su/
---
 mkfs/Makefile        |    1 +
 mkfs/dax_x86_64.conf |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 mkfs/dax_x86_64.conf

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 0aaf9d06..55d9362f 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -10,6 +10,7 @@ LTCOMMAND = mkfs.xfs
 HFILES =
 CFILES = proto.c xfs_mkfs.c
 CFGFILES = \
+	dax_x86_64.conf \
 	lts_4.19.conf \
 	lts_5.4.conf \
 	lts_5.10.conf \
diff --git a/mkfs/dax_x86_64.conf b/mkfs/dax_x86_64.conf
new file mode 100644
index 00000000..3a6ae988
--- /dev/null
+++ b/mkfs/dax_x86_64.conf
@@ -0,0 +1,19 @@
+# mkfs.xfs configuration file for persistent memory on x86_64.
+# Block size must match page size (4K) and we require V5 for the DAX inode
+# flag.  Set extent size hints and stripe units to encourage the filesystem to
+# allocate PMD sized (2MB) blocks.
+
+[block]
+size=4096
+
+[metadata]
+crc=1
+
+[data]
+su=2m
+sw=1
+extszinherit=512
+daxinherit=1
+
+[realtime]
+extsize=2097152
