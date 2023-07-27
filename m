Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EF5C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjG0WTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:19:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326CB187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A2561F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295F5C433C7;
        Thu, 27 Jul 2023 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496391;
        bh=b30DElFBuSkolIlIU69+vXNeQY0owOym05z2HIrQW3I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qBLe0J10xqNg3aRyRzhAO2REzaME+JMtIQcclD7b3QPFagawLP8jomolFOETTChrD
         TyF7cxddX1ccWgoXlmoK5HptqUlrCXap93PnP7bne9ayE4Y2e+MCoQDdya279OOt3D
         SyYeKjwYTi5ITa+T2Ca8FbpepvWiq3s+mmEyblquHxZ4WS5x80W1XtRllocuRKGMSK
         cFjab/RIQmoLlH5V5LyVDWFDXn/gw3pgfkHG2MeX+oB5MKkPSMNBE6hkCUEMMtzVb/
         YBlpM7OoFi1Uj7dny0oUMSfcm114vKZ7h9+abP+IJ9OHSVmXuDynef0ieo+KO9Q/md
         jgUgXzShP7NIQ==
Date:   Thu, 27 Jul 2023 15:19:50 -0700
Subject: [PATCHSET v26.0 0/2] xfs: miscellaneous repair tweaks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049624664.921955.12084246901012682213.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
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

