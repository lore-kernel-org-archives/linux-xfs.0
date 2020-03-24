Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0358DC4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39DB206F9
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgCXATd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:19:33 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52073 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727478AbgCXATd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 20:19:33 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 574573A2405
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 11:19:31 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-00057O-LH
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-0004h1-Ab
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfsprogs: miscellenaous patches
Date:   Tue, 24 Mar 2020 11:19:23 +1100
Message-Id: <20200324001928.17894-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=SS2py6AdgQ4A:10 a=_uUgevOlRHgqkLT73fwA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These are some patches I've had sitting around for a while - all of
them sent previously at various times, I think. Time to try to clear
the stack. :)

They are all pretty straight forward, except the xfs_io change to
provide non-zero exit codes on failure. It's fairly big, but the
changes are easy to understand - any failure that terminates the
command needs to have the exitcode set to non-zero.

Built on 5.6.0-rc0, runs through fstests cleanly.

Cheers,

Dave.

