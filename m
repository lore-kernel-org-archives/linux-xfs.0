Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E49BC05027
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjBOBqi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjBOBqh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C724B3344E;
        Tue, 14 Feb 2023 17:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62C7C6196F;
        Wed, 15 Feb 2023 01:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48C4C433EF;
        Wed, 15 Feb 2023 01:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425595;
        bh=RiD9GhkALst5gh+pM8o1R7jQftIUnOhJS1DqyE/m0/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jpsebc+vDRRrNK/9kUDeD9+5ApOnZeCNACOA3/TBI3W5qXU3aFKoTtorFepziOr9P
         suorv5PGv3wvJKssdLbGNnaRqrhvaMYAoYy1x/DcUuZmrUVfpIr1OSmZrTEB62Fs9b
         o2bgScpa57JpabWMKOeSI5sbGIAWypJv5k1v8++14MK/YSEMOCNf+20NTEZGjymTcy
         A6jQxnoSzfhwtsrkrzyj4QG2vEngykcUMC+6JB+kWuCFrBy7VK9iJ5dgtt9WhYDw1Z
         +ELSeAelTURFW9dR5Il3Qk5dl3/0x0XemjXVL3yobouWoRYkfV3LaHYCnxMbeudLhd
         0DStYWcjTEodw==
Subject: [PATCH 10/14] report: encode xml entities in property values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:35 -0800
Message-ID: <167642559529.2118945.3777372837490960741.stgit@magnolia>
In-Reply-To: <167642553879.2118945.15448815976865210889.stgit@magnolia>
References: <167642553879.2118945.15448815976865210889.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Avoid trouble with the properties reported in the xml reports by
translating xml-tricky characters in the property values into their xml
entity equivalents.

IOWs, if someone sets a property "NAME" to the value 'BOBBY"; DROP TABLES;',
the xml will be formatted:

	<property name="NAME" value="BOBBY&quot;; DROP TABLES;"/>

Thus avoiding XML problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/report b/common/report
index 2ab83928db..946ee4887c 100644
--- a/common/report
+++ b/common/report
@@ -33,7 +33,10 @@ _xunit_add_property()
 
 	test -z "$value" && return
 
-	echo -e "\t\t<property name=\"$name\" value=\"$value\"/>"
+	local xname="$(echo "$name" | encode_xml)"
+	local xvalue="$(echo "$value" | encode_xml)"
+
+	echo -e "\t\t<property name=\"$xname\" value=\"$xvalue\"/>"
 }
 
 _xunit_make_section_report()

