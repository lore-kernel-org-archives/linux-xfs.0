Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CABC54E8D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF2BF20757
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgELC76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 22:59:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53313 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728110AbgELC76 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 22:59:58 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CDCE4820966
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 12:59:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYL97-000239-6c
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 12:59:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYL96-007aCY-Tz
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 12:59:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: fix a couple of performance issues
Date:   Tue, 12 May 2020 12:59:47 +1000
Message-Id: <20200512025949.1807131-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=g7MSC_FphxsJ-jSkoP4A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I was comparing profiles between two machines and realised there was
a big discrepancy between them on an unlink workload that was kinda
weird. I pulled the string, and realised the problem was cacheline
bouncing interfering with cache residency of read-only variables.
Hence the first patch.

The second patch came about from working out what variable was
causing the cacheline bouncing that wasn't showing up in the CPU
usage profiles as overhead in the code paths that were contending on
it. And for larger machines, converting the atomic variable to a
per-cpu counter provides a major performance win.

Thoughts, comments, etc all welcome.

-Dave.


