Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DA2C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZAk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZAk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB74EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388FD615B8
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6B4C433D2;
        Fri, 26 May 2023 00:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061654;
        bh=5YRQGpkEnIO05OBwi17JLmLiFUZfbk73on+vsykG9C0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oXYig2k0vYQW0+7iTuVrR5VoqSVjwyjl4dfJcIuNdHnsSrWYBDLWFguXLrGc+nPtP
         HfZhF2NGeUbvcYgDf166LwMv2oQPvdUzFBdRc0Cs09sRVN/dVQ7uKYdPWMnJ7ac5N9
         bOQ7F0Lyrrn9EwmOpvcMcJ8B4fAOvbeB3RE/5xWWXBw/DtGbpNTzlyXawgWoD96j9r
         rDoF/L4oaoUbpARYPNNJ7SR1VPAasNRWNBP8rj99lBT1qPqzMIggXk96cHKdlQkAFW
         k2vF5VlqkDnnzms9Rt+zGTn6eeAl1k+1kzBp8RVzAU1+9U8CEqcOVTJnJ3/OjXw3Hu
         rPOfq+rIJbk/Q==
Date:   Thu, 25 May 2023 17:40:54 -0700
Subject: [PATCHSET v25.0 0/5] xfs_scrub_all: improve systemd handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
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



If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-all-improve-systemd-handling
---
 debian/control         |    2 
 scrub/xfs_scrub_all.in |  279 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 209 insertions(+), 72 deletions(-)

