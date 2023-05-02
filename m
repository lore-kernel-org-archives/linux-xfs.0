Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB01FC77B78
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjEBUIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjEBUIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498861997;
        Tue,  2 May 2023 13:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A616231D;
        Tue,  2 May 2023 20:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405B2C433EF;
        Tue,  2 May 2023 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058092;
        bh=eyu26KMZnGh1HL4k2AjRl/yPU+tUlilpDF+9z5uJZIY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hd+EXCKe8xjtjJ7fVQt83qVwAR3YyC9Lagbc8Q2e9X5sTjDEGbRvlL2VztKar99ZP
         wx1XfX6hDO3Mil37grw5O3ejhKAVyEDyS6QToPJCzWOhr81bdhG5uLLoVuHhN7vXX/
         FPl9z1XYhkD2i5+5OOWuE0/0ZauhZ6sfbVGKPNxGv3ynuqpU5ArMSA3Oiqe6mPMKed
         VMOYEfKN10yjxkuT4rMBjE6wjTRNFnzskFwT0EwrnQDqDZNE10rATzyLpW55/yhuAg
         L3xjq0U5SmsBRSUDVNnkA00X54IOvc3Fip5qwCGwlPOCfpTg8eW5cT1jsIwfCR2Vvf
         OySeAKD4pXKNQ==
Subject: [PATCH 1/7] fsx: fix indenting of columns in bad buffers report
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:11 -0700
Message-ID: <168305809174.331137.660744527774559430.stgit@frogsfrogsfrogs>
In-Reply-To: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
References: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When file corruption is detected, make the columns of the report line
up correctly even in the diff output.  Although the .out.bad file
contains this (with spaces to demonstrate unequivocally what happens
when tabs are formatted as 8-column indent):

OFFSET  GOOD    BAD     RANGE
0x2c000 0x0000  0xd6c1  0x00000

diffing the good and bad golden output yields poorly formatted output:

+OFFSET GOOD    BAD     RANGE
+0x2c000        0x0000  0xd6c1  0x00000

Replace the tabs with columns indented with printf width specifiers so
that the test output gets this:

OFFSET      GOOD    BAD     RANGE
0x2c000     0x0000  0xd6c1  0x0

...which always lines up the columns regardless of the user's tab
display settings or diff inserting plus signs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index c76b06ca76..ffa64cfa00 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -669,17 +669,18 @@ check_buffers(char *buf, unsigned offset, unsigned size)
 	if (memcmp(good_buf + offset, buf, size) != 0) {
 		prt("READ BAD DATA: offset = 0x%x, size = 0x%x, fname = %s\n",
 		    offset, size, fname);
-		prt("OFFSET\tGOOD\tBAD\tRANGE\n");
+		prt("%-10s  %-6s  %-6s  %s\n", "OFFSET", "GOOD", "BAD", "RANGE");
 		while (size > 0) {
 			c = good_buf[offset];
 			t = buf[i];
 			if (c != t) {
 			        if (n < 16) {
 					bad = short_at(&buf[i]);
-				        prt("0x%05x\t0x%04x\t0x%04x", offset,
-				            short_at(&good_buf[offset]), bad);
+				        prt("0x%-8x  0x%04x  0x%04x  0x%x\n",
+					    offset,
+					    short_at(&good_buf[offset]), bad,
+					    n);
 					op = buf[offset & 1 ? i+1 : i];
-				        prt("\t0x%05x\n", n);
 					if (op)
 						prt("operation# (mod 256) for "
 						  "the bad data may be %u\n",

