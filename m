Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1572BC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 06:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BDF233FF
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 06:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfH2Gau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 02:30:50 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54140 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbfH2Gau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 02:30:50 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0FD49360DB7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:30:48 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3DxG-0000xX-H4
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 16:30:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3DxG-0006BK-EH
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 16:30:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2 0/5] xfs: speed up large directory modifications
Date:   Thu, 29 Aug 2019 16:30:37 +1000
Message-Id: <20190829063042.22902-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=FmdZ9Uzk2mMA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=qDYnm9PS-GAC4vx6eUAA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

After a long time I've managed to get back to these directory
speedup patches, originally posted here:

https://lore.kernel.org/linux-xfs/20181024225716.19459-1-david@fromorbit.com/

I've addressed all of Christoph's original issues, incorporated his
suggestions, updated the benchmark results (same/slightly better
improvement) and done more testing on it. The series has been in my
test tree since I posted it ~9 months ago and has been in all my
benchmarking work over that time. I haven't seen any performance
regression as a result of the change of algorithm, but there are a
few that go a lot faster....

Comments welcome.

-Dave.


