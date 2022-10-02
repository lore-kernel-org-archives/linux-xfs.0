Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C18C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJBSX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJBSX5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:23:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4572528C
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12EA60EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EEBC433C1;
        Sun,  2 Oct 2022 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735036;
        bh=4JkpfM9Cc0V0u3cbXoA5BjaKwo+n15v1/awWCXT/xBk=;
        h=Subject:From:To:Cc:Date:From;
        b=brGlwFo3QznHfzXt3ojz+q2peRGxA3zjTFhDwQtJ8mGEcsGQp4q0ABoeiWEAMbLQp
         94+JbzAq1+MC9htgvfOUzWEw8t36i4u8EF24/siBy/o8BU+q98pWPEVop4At1ddq+X
         n7YuzJdVtOQbONLzXzduQojc2wwRqEP7AEoA65x9jfmUexNHOZe6KAzybpCWcYslLJ
         cGmy53GtPqP9HXCvRv6y5PNGzJ1T4HTTJGufrsvc5xuyTAL31fm5A4SO1VaIEF+Unx
         rZ/n20twIo2mvipH+1RY47ZOVA+nea2O/NKOKzvnleehMSp46pwHIs2JsOJBQvdrUz
         HZTUPCPDUwOPA==
Subject: [PATCHSET v23.1 0/2] xfs: enhance fs summary counter scrubber
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:05 -0700
Message-ID: <166473480544.1083794.8963547317476704789.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series makes two changes to the fs summary counter scrubber: first,
we should mark the scrub incomplete when we can't read the AG headers.
Second, it fixes a functionality gap where we don't actually check the
free rt extent count.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fscounters-enhancements
---
 fs/xfs/scrub/fscounters.c |  107 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/scrub.h      |    8 ---
 2 files changed, 104 insertions(+), 11 deletions(-)

