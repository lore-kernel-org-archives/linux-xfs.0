Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F18EB64DA
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 12:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjFZMHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 08:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjFZMHn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 08:07:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F14DE5A
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 05:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BEE660DDD
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 12:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA8AC433C0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 12:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687781261;
        bh=RPsBVaNHv7bESxzbJKWA65yu16suxOztbfSjGkjeXng=;
        h=Date:From:To:Subject:From;
        b=BRj2rqJr5hQXRG2KluZdSMdvbX2HDkvykHJ4A2r5J/Pp8fYVU4yYPsONlmfBvkaOT
         fYQI258+sniJxIjsg5BrvvfWrGm0l46VeCzKchd3Y7jdYk9Tzk5REF5Xvrc17paqgc
         HuoH+Gk7NjtvlcNXymkYPn3dfL4Shq8JMn57tI/WPSZw4WDhRJLvbE7t+sm1PUy570
         B5KZ1AQwHnHPtWIsWEXRqW8Rs/R8p0zOhB/8TkjjIpk1ZnvZh5wBnWu7A9PClYtAgB
         dLe62nfEc4F6Ux30hZe/mZX5rJBEqNDFXe/HA7ne90u9J6AGpyFzUm+xAJ5LEYM7H1
         lhB92uiX8ScxA==
Date:   Mon, 26 Jun 2023 14:07:36 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to b894e1b9a
Message-ID: <20230626120736.4bccaypfhqbgsoqc@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

b894e1b9a567338f62eefb6d6ea0290d0b37060d

4 new commits:

David Seifert (1):
      [987373623] po: Fix invalid .de translation format string

Donald Douwsma (1):
      [248754271] xfstests: add test for xfs_repair progress reporting

Pavel Reichl (1):
      [b894e1b9a] mkfs: fix man's default value for sparse option

Weifeng Su (1):
      [8813e12cc] libxcmd: add return value check for dynamic memory function

Code Diffstat:

 libxcmd/command.c      |  4 +++
 man/man8/mkfs.xfs.8.in |  2 +-
 po/de.po               |  2 +-
 tests/xfs/999          | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out      | 15 ++++++++++++
 5 files changed, 87 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

-- 
Carlos
