Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5DFC388F3
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 06:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEEE521A4A
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 06:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfI3GDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 02:03:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35690 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729640AbfI3GDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 02:03:50 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F21F443D870
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2019 16:03:46 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iEomg-00053l-3J
        for linux-xfs@vger.kernel.org; Mon, 30 Sep 2019 16:03:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1iEomf-0003pl-Vc
        for linux-xfs@vger.kernel.org; Mon, 30 Sep 2019 16:03:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: limit CIL push sizes
Date:   Mon, 30 Sep 2019 16:03:42 +1000
Message-Id: <20190930060344.14561-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=J70Eh1EUuV4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=yaflm1dJKSMLNCn4xi0A:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI Folks,

Version 2 of the CIL push size limiting patches. The main changes in
this version are updates to comments describing behaviour, making it
clear this isn't a hard limit but a method of providing schedule
points that will allow the CIL push to proceed rather than being
held off indefinitely by ongoing work.

The original patchset was here:

https://lore.kernel.org/linux-xfs/20190909015159.19662-1-david@fromorbit.com/

Cheers,

Dave.


