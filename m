Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EA5C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbjEZA35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbjEZA3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:29:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C05A18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 264F5615D4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE25C433EF;
        Fri, 26 May 2023 00:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685060967;
        bh=b30DElFBuSkolIlIU69+vXNeQY0owOym05z2HIrQW3I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=T0nUZhLSABVW0QWuj87utWD3GmANYF0tgqmwb8jMFQvLqBZ0cQ+eipu6q6m8c5Vyd
         EYpAlc6T1pR0Iy6MggD/oezNCXQrL4RfKB8iCw0wJdphREQbPDqAGo9rz1lLvtYf1r
         f+hlrg9GZJjMQo3stqsNSUr74fw2M/zRceY9cPOdD/sGLgYeRl6h7WCZ/r9VvZwlqn
         CO8QqJQQxiydW+kyQzZsm1J+aq9yercnOGqeK9VY4MwhDgOlUT0WXo8yRjNWkcn6se
         pQZifp9GfBOwoD42/eKGGPKPBFjm8wuqHyVvtozFajUiQg/Jx+UPGY9Xc5p5Bg37NW
         RPSRINY0cQJtA==
Date:   Thu, 25 May 2023 17:29:27 -0700
Subject: [PATCHSET v25.0 0/2] xfs: miscellaneous repair tweaks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
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

