Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266C3C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCOAxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCOAxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDFB44AC;
        Tue, 14 Mar 2023 17:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5EC7B81C37;
        Wed, 15 Mar 2023 00:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978E5C433D2;
        Wed, 15 Mar 2023 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841607;
        bh=RiD9GhkALst5gh+pM8o1R7jQftIUnOhJS1DqyE/m0/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HH2C9F/rSyCi926c3OgVeVJN2lrxHzUFK4kjUbm2wBbqLmXU0MQIK97xDdHJrAJap
         3gwNxgb8nmHeBa8wKMgG+pkS94i2c+038znHzFilu1TtvHWkSkEdbzihHxgMG7gIZ3
         31uBBIwA59vvOOFpOBJN4MxplGcmgjjZN5UQBANHQElKGJUpspFmK1ZCWEtZDQn6+1
         6Ffp9wNBnYwYJRiCZdzXKkjxqu20ijYrMcnTLilV4cQkxClOp/kDAFmjoPHJkpAB0R
         t+4rEVNrKae8PovcU82FUAs023eTVD06NegXAi3pjlk0SLseJwqLjnmKm+q1qiXwnT
         0ot+2k1vip8Mg==
Subject: [PATCH 10/15] report: encode xml entities in property values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:27 -0700
Message-ID: <167884160721.2482843.18113696253114083867.stgit@magnolia>
In-Reply-To: <167884155064.2482843.4310780034948240980.stgit@magnolia>
References: <167884155064.2482843.4310780034948240980.stgit@magnolia>
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

