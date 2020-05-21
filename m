Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF23C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4807120756
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgEUCfs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:48 -0400
Received: from sandeen.net ([63.231.237.45]:41440 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgEUCfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:48 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 879BB1F1E; Wed, 20 May 2020 21:35:19 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7 V3] xfs: quota fixes and enhancements
Date:   Wed, 20 May 2020 21:35:11 -0500
Message-Id: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Once more with feeling, this rolls up the kernel patches sent in the
prior 0/SEVERAL series, with the fixes Darrick pointed out.  sorry this
has been such a mess.

