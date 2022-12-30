Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114B1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiL3XFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiL3XFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:05:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE5D1D0E9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAF44B81DA1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6302FC433D2;
        Fri, 30 Dec 2022 23:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441539;
        bh=tT8ODD3qYThvpOBEewZjxvanOcS8WBegLljrWGxTNks=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MzOLCMhcsDpLFeaqN3bmTFm58D7NG1siBh0+z+I3BfqE7txRCaCoNnuyLR0jvsZ/E
         hNKSnP0nb7wZIGsFWOeSU30vjZx5XjN5eI51X6UVWSNPG8AtOrVk5y1zKOs+Ne60tQ
         CA5kolG+21XSJoNHrcOHsAfDyzz4QfRxvb48P5V2iktNuhLSZJtvU+Lvhwjt+otlHw
         0fDwjjn7s4MhJ0qN2pRGsxL7N8GHjPpK0EgG4Wi7OYzB5xx5gXTmV7HzTcbzOWSTms
         ZqdhGPU/D2jfL/JiAewFA2N8AbeCmB3/tGCglwvI2N2ye6pMYEcwf0phwyxf3uXuGP
         VVj68BTAm6JeQ==
Subject: [PATCHSET v24.0 0/2] xfs: support attrfork and unwritten BUIs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:48 -0800
Message-ID: <167243842809.699248.13762919270503755284.stgit@magnolia>
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

In preparation for atomic extent swapping and the online repair
functionality that wants atomic extent swaps, enhance the BUI code so
that we can support deferred work on the extended attribute fork and on
unwritten extents.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=expand-bmap-intent-usage

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=expand-bmap-intent-usage
---
 fs/xfs/libxfs/xfs_bmap.c |   49 ++++++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_item.c   |    3 ++-
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_reflink.c     |    8 ++++----
 5 files changed, 33 insertions(+), 39 deletions(-)

