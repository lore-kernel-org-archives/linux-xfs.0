Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABFBC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 04:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9036064DD9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 04:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhA1Emk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:42:40 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:40574 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231163AbhA1Emj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 23:42:39 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 821249BC8
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 15:41:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l4z80-003F5E-Du
        for linux-xfs@vger.kernel.org; Thu, 28 Jan 2021 15:41:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1l4z80-003Nu5-3x
        for linux-xfs@vger.kernel.org; Thu, 28 Jan 2021 15:41:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfs: various log stuff...
Date:   Thu, 28 Jan 2021 15:41:49 +1100
Message-Id: <20210128044154.806715-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=EmqxpYm9HcoA:10 a=ihYwfvNihA3IHkiOysoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Quick patch dump for y'all. A couple of minor cleanups to the
log behaviour, a fix for the CIL throttle hang and a couple of
patches to rework the cache flushing that journal IO does to reduce
the number of cache flushes by a couple of orders of magnitude.

All passes fstests with no regressions, no performance regressions
from fsmark, dbench and various fio workloads, some big gains even
on fast storage.

Cheers,

Dave.

