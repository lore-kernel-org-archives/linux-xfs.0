Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8A0C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 08:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiEBIYK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 04:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383738AbiEBIXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 04:23:52 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9239862C1
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 01:20:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6760010E66CC
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 18:20:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-0073Tf-LP
        for linux-xfs@vger.kernel.org; Mon, 02 May 2022 18:20:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-004WM6-K0
        for linux-xfs@vger.kernel.org;
        Mon, 02 May 2022 18:20:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfs: fix random format verification issues
Date:   Mon,  2 May 2022 18:20:14 +1000
Message-Id: <20220502082018.1076561-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=626f9446
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=5_JkJofsVe_gMCoRqwsA:9
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This series contains a handful of fixes for the malicious format
verification attacks that were dumped into the kernel.org bugzilla
over the weekend.

I'm not going to give any credit to the reporter - they are not
disclosing these issues responsibly and so I'm not going to
encourage them by giving them any credit for causing me unnecessary
stress by forcing me to drop everything to investigate the reported
problems.

As I said back in my response to a similar malicious bug reporter
recently at https://bugzilla.kernel.org/show_bug.cgi?id=215783 :

	"If you are going to run some scripted tool to randomly
	corrupt the filesystem to find failures, then you have an
	ethical and moral responsibility to do some of the work to
	narrow down and identify the cause of the failure, not just
	throw them at someone to do all the work."

I'll add that *responsible disclosure* is also necessary. Giving us
a chance to determine the severity and impact of the format
verification/corruption problem before they are made public would
take a lot of the angst and stress out of this situation.

</rant>

Anyway, one of the bug fixes "breaks" xfs/348, which is actually
broken because it encodes observed (broken) behaviour as success
rather than encoding correct behaviour and then failing. This series
ensures that the data fork is in the correct form for symlinks,
directories and regular files and so the test now fails. Fixes for
that test will need to be done.

-Dave.


