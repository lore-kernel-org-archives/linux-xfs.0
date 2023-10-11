Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF92CDB472
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 17:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjJKR5Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjJKR5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 13:57:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4D59D
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 10:57:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C556C433C7;
        Wed, 11 Oct 2023 17:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047032;
        bh=sJRosifceCoVVK72uERCsE6wh15qXgi+F15obSgPsUI=;
        h=Date:From:To:Subject:From;
        b=StrUoLrMqKFeo7rsANHpS/7sRa/IrrSB84otj4tQCjpQcYS45+t/y1QG/aqM1AhoN
         QdT+JP9ZPxbR2rVGwxEnyOpYZSm2V21HfsKJiBGewfSPcKEXr9ySh7onJBeVW8S1bS
         LPxCMZOCwDWku/hUlAIBEnnjCixSh8aHlbFkUK73YqgUVWH8+VZ1Ovfc+n9v6cYsFX
         0AEd6TT8pU+CPR9eGBW3zfU+uVh4+lJl+q5/H62c2oHV1cN5L0+29g5WqJAZtFXruJ
         2YCmB5cAgSVuOIKTStFmQACvfCzPIdybWYixw1C888DpmtThyxeJID/a9rliHvbJKF
         R6iVnh2IOfcxA==
Date:   Wed, 11 Oct 2023 10:57:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     osandov@osandov.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCHBOMB RFC]: xfs: realtime units cleanups
Message-ID: <20231011175711.GM21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Christoph asked if I could resend the realtime space units cleanups that
I mentioned earlier in [1].  The realtime modernization project is stuck
deep in my dev branch behind the online repair series.  For my own
sanity I'm leaving them coupled together in djwong-dev instead of
splitting them and trying to keep the two branches in sync.

Anyway, here's an RFC of the rt cleanups; if this somehow gets merged
before online repair, I'll separate the fs/xfs/scrub/ diffs.

(Please please let's all help dchinner and cem have time and brainpower
to review the online repair patchsets.)

--D

[1] https://lore.kernel.org/linux-xfs/20230918153848.GA348018@frogsfrogsfrogs/
