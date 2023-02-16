Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80004C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBPU2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBPU2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:28:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C042196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EE6DB82992
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBEC433D2;
        Thu, 16 Feb 2023 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579295;
        bh=JrKGUEG445W7avQKMOKhc4/GTc5cibriAQ5UvDGitMs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NAniwHGRd5TR3ZSQooR+WGl7GeDNNzLHFQZDgLq7LI6iL9lV1NiEmLd2t27GMCP+2
         JrSQpSGf3wWWgxyNmXkExU36A4Iiew2JMIcnyjIdMBu2IeiGcTTGRCjAKjtX761JQR
         o6u6XuLgSKF+9x76/x2VBC8AEfAZEj8/WM3E2HDmHH5ReRWAxsbBkXdikBeHAZtseK
         U10gQkeR54O3Iinj+9s9Ym8G4mC6h0eZHqYW80eAwfcCFiT+pBa+iZvr8NlyR+HLqo
         dlaBjvvf7vbIk+sd+6uUQrI1QsvzVELPJF2yu1CFhmsXY8Ll56gCJyWQN5zDTSBj1N
         YoWLWAXCSbF9A==
Date:   Thu, 16 Feb 2023 12:28:14 -0800
Subject: [PATCHSET v9r2d1 0/2] xfs: online checking of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875530.3475324.17245553975507455352.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Update the existing online directory checker to confirm the parent
pointers that should also exist.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-check
---
 fs/xfs/scrub/dir.c   |  367 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h |    2 
 2 files changed, 368 insertions(+), 1 deletion(-)

