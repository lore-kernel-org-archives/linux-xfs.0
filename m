Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0106CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 00:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiGMA5N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 20:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGMA5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:57:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C4FCEBBA;
        Tue, 12 Jul 2022 17:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A3FB81C98;
        Wed, 13 Jul 2022 00:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3F2C3411C;
        Wed, 13 Jul 2022 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673828;
        bh=cTR84NFgEJ2+zO1AerxNsExZ+iqP5oTd7ri/PS70vGI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dj/42Vkt78M7cLlBS9weZ8z9L2aMyO2FvpsrvRMPpC/u/nMEUeClHe+Q5tI0kxEZ8
         0qp8qcBCbi7g4oExgWf55WqxyKbZ3Coqsrexxftejtgp/w1lR0xAY4+PEk7YKRiOLV
         KUjPm/sCgF+dqaWMb4G9Cf7XWjBVz0OuquKbcU/xMWWy9WzH9jS3QK4bhrANkFcFMK
         o0aKUqVae3Al5M4v9qXI98OiGuCnfOZvsRpdlwg6XCNUDodB0s9T6IIpb078EGGlSE
         YwS0+U9FwpdmoEG+MyTMwNW6OFj7vRV15mu3glX4RUlkYXDb5wetasftatWxKIsRDX
         W5q92PTIjdA/w==
Subject: [PATCH 6/8] punch: skip fpunch tests when op length not congruent
 with file allocation unit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:57:07 -0700
Message-ID: <165767382771.869123.12118961152998727124.stgit@magnolia>
In-Reply-To: <165767379401.869123.10167117467658302048.stgit@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Skip the generic fpunch tests on a file when the file's allocation unit
size is not congruent with the proposed testing operations.

This can be the case when we're testing reflink and fallocate on the XFS
realtime device.  For those configurations, the file allocation unit is
a realtime extent, which can be any integer multiple of the block size.
If the request length isn't an exact multiple of the allocation unit
size, reflink and fallocate will fail due to alignment issues, so
there's no point in running these tests.

Assuming this edgecase configuration of an edgecase feature is
vanishingly rare, let's just _notrun the tests instead of rewriting a
ton of tests to do their integrity checking by hand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/punch |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/punch b/common/punch
index 4d16b898..7560edf8 100644
--- a/common/punch
+++ b/common/punch
@@ -250,6 +250,7 @@ _test_generic_punch()
 	_8k="$((multiple * 8))k"
 	_12k="$((multiple * 12))k"
 	_20k="$((multiple * 20))k"
+	_require_congruent_file_oplen $TEST_DIR $((multiple * 4096))
 
 	# initial test state must be defined, otherwise the first test can fail
 	# due ot stale file state left from previous tests.

