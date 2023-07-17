Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC114C0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jul 2023 16:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjGQQRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jul 2023 12:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjGQQRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jul 2023 12:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F92FDD
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 09:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EF0761159
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2023 16:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E03C433C7;
        Mon, 17 Jul 2023 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689610635;
        bh=/f3vWLuuHnedUQ/yUU0Bn9Bbr2CE2cMLToS7HAdsfF4=;
        h=Date:From:To:Cc:Subject:From;
        b=r/REbl5pdEhcYX4H7Le4vIU/8W4RggGpCicGz3YB96luC0bl9I4nc9SVkUE0W8tJx
         8s4QzZTRByjSzF8N4nschp0BqPKHKm2mUiox5cfREl3BBmacCzqaGP4ZAqjG6RPR5N
         NieDcnkEjY+50hyMMlRjqGhyJBMELNYqbHTB06iD+7HYbyTY2CVd6P99xPwrsgAlbg
         wKTpZpAD3C6bj1cOCTrIR5v3TaBvpHgjTqYYDsATPf9OWFVEm6l5qyiVOsc1I4cC+p
         GHdQhWo0AVZfQVwbJFT9jrHcX0b+G3szuJvs24aQJjiAErp9xKavfuUrx0PksIfteW
         ae+QPE/gd8W5A==
Date:   Mon, 17 Jul 2023 09:17:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, hch@lst.de, keescook@chromium.org,
        linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to f6250e205691
Message-ID: <168961060284.394583.9141765514597482376.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f6250e205691 xfs: convert flex-array declarations in xfs attr shortform objects

3 new commits:

Darrick J. Wong (3):
[371baf5c9750] xfs: convert flex-array declarations in struct xfs_attrlist*
[a49bbce58ea9] xfs: convert flex-array declarations in xfs attr leaf blocks
[f6250e205691] xfs: convert flex-array declarations in xfs attr shortform objects

Code Diffstat:

fs/xfs/libxfs/xfs_da_format.h | 75 +++++++++++++++++++++++++++++++++++++------
fs/xfs/libxfs/xfs_fs.h        |  4 +--
fs/xfs/xfs_ondisk.h           |  5 +--
3 files changed, 71 insertions(+), 13 deletions(-)
