Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FE0C3A5A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462D8233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfH2KrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 06:47:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58528 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbfH2KrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 06:47:19 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DE65243DDB1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 20:47:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HxQ-00032Q-F4
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 20:47:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HxQ-0007Nz-As
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 20:47:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/5] xfs: speed up large directory modifications
Date:   Thu, 29 Aug 2019 20:47:05 +1000
Message-Id: <20190829104710.28239-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=FmdZ9Uzk2mMA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=YkzX2WVXDbioeT2Ps38A:9 a=uLDcBiFPLnYA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Same patchset as here:

https://lore.kernel.org/linux-xfs/20190829063042.22902-1-david@fromorbit.com/T/#t

Now with all of Christoph's review changes added in.

-Dave.

