Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CF6C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Dec 2021 00:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhLRAQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 19:16:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47192 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLRAQU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 19:16:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F51B82B2B
        for <linux-xfs@vger.kernel.org>; Sat, 18 Dec 2021 00:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1887C36AE2;
        Sat, 18 Dec 2021 00:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639786577;
        bh=mjF6FyWZxJ3JsTyYii173k7I75PmGrjRCzxMC0lPcGg=;
        h=Date:From:To:Cc:Subject:From;
        b=kVvRNw2SDZ4VIcICbO3hffxelPnqME5UlLdUuehdhut+sLoc3sYyo7BYIDzzepteQ
         7B3MzYy9QFx6wmICh+LiQARs9nPyQs0Oyd1cjaCkApUuhRqbOoUJ/SAYGZ2TaT8Nzc
         I/3V3O9QcVNUOV+i7R9rhMRQfUxsYaH5dunVTmavatGJ59BLl+9PvV+tocv2ljVhuH
         xk+BSZjiojEQD5mIY+3soWBlNzK5FXNxEmZkxRtiiFl+/n4XTABo8AhjR91kIuYzJi
         w9m/HSUcs+IYxi7BOCTl8iB7H1QIGTlUH/g80Hc2NadAn0r46/2FMmynQ+3r4Agam7
         3pwyEeas0oJ7A==
Date:   Fri, 17 Dec 2021 16:16:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHSET 5.14.3 0/3] xfsprogs: packaging fixes
Message-ID: <20211218001616.GB27676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

Here's a rollup of a few random fixes that <cough> might be <cough>
needed to produce a working 5.14.3 package for <cough> reasons.

--D
