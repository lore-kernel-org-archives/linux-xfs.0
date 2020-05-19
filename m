Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9064C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56BB205CB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgESVsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 17:48:47 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33847 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgESVsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 17:48:47 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id EF5ADD793D2
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 07:48:43 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbA6M-0000C3-Tu
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 07:48:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbA6M-00AmfQ-Ir
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 07:48:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: fix unecessary percpu counter overhead
Date:   Wed, 20 May 2020 07:48:38 +1000
Message-Id: <20200519214840.2570159-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=6Pue7imYyI7EwQHIrAMA:9 a=2UcSWh3t_xF2qKFN:21 a=xPxJ3wGyvkyeCVS9:21
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a resend of a patch from months ago that can be found here:

https://lore.kernel.org/linux-xfs/20191121004437.9633-1-david@fromorbit.com/

I've split it into two patches and cleaned it up further and
retested it, and all is good now.

Essentially it solves the problem of production systems taking
percpu_counter_sum() overhead in a hot path when the sum is only
used for debug purposes and not actually compiled in to production
kernels. As a further cleanup of this code, the error handling
never returns errors at all to the caller, so it's only
for debug purposes. Given that the error handling logic is wrong and
we throw it away on debug kernels anyway, just get rid of all of it.

Cheers,

Dave.

