Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729A2C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiL3XBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:00:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF90DCF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:00:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C4C261C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5FAC433EF;
        Fri, 30 Dec 2022 23:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441257;
        bh=b30DElFBuSkolIlIU69+vXNeQY0owOym05z2HIrQW3I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s2pxKL63qwkpHoe9RuMCgFLfZl2a+XwTXdNitWMPjezWxYs9Dv1CcFJJBnMsuCVhQ
         KEkjzXB5L0vFnmNF6CQ4jcpnmGbIre6syuSnu7+xJT8Dae6fHiRJW9JsdEx+Y9CyM/
         sluLZ5i3zkADN/AM2Q+iOsWpuUTa2ZdOLoSwxqs29g4dXjEJ+mggvZ2IdCPnOdZgTu
         FzzN9VzgakZ9jH2p5HdRZkno5p6z6qw6ypEJW84VZ+ctFesaWZP6J68/wcoW4EqlSI
         qBCum8+XqHBgrGQ0XmPGp7dWvEC+AA6ryetW3QdkbSQq8N70VfOeLU8t+rKHIOqHdk
         BklRZ1zmIpPAQ==
Subject: [PATCHSET v24.0 0/2] xfs: miscellaneous repair tweaks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:42 -0800
Message-ID: <167243836213.692856.10814391065284832600.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Before we start adding online repair functionality, there's a few tweaks
that I'd like to make to the common repair code.  First is a fix to the
integration between repair and the health status code that was
interfering with repair re-evaluations.  Second is a minor tweak to the
sole existing repair functions to make one last check that the user
hasn't terminated the calling process before we start writing to the
filesystem.  This is a pattern that will repeat throughout the rest of
the repair functions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tweaks
---
 fs/xfs/scrub/agheader_repair.c |   16 ++++++++++++++++
 fs/xfs/scrub/health.c          |   10 ++++++++++
 2 files changed, 26 insertions(+)

