Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1105CC3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiL3XRn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:17:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3778B1C134;
        Fri, 30 Dec 2022 15:17:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7B1B61C40;
        Fri, 30 Dec 2022 23:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB5BC433D2;
        Fri, 30 Dec 2022 23:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442261;
        bh=xkVk+uxaubicbFLaKpfkmVGO+v2HPw8pNy53BCslE8E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C+3q2ETRnBqUu7H7OHsgfReO+19XKypXYUysbaIQvCPY8RI0fjwplT6qk26lZzqlb
         SehSCzp+58vvgwL2HiwtrpZs7Y7aSSXgiTgMaq5KJYwp6zIW+rW5IipCEdDuMoyDVs
         R+omrzvqnwCiSKP/JhT2FzsgoTTR4WTXNg080f3KbgwWRF8Ehei+FJO1dz8m7u1wZK
         fh5hi6RiD4OHQUbvvis/4jv4Upw8FcMMhloVkpfHzc0ZgC+2+ngM/oqtABYwqVAbWt
         krrdnAZu1L6OaOH5H0LmR4zs6+mBSm8hReksETrSJdBEFPkdKnKhSdO9/V+Pd1skY3
         YRzJnUlO/amPQ==
Subject: [PATCHSET v24.0 0/2] fstests: online repair for fs summary counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:30 -0800
Message-ID: <167243877039.727863.13765266441029212988.stgit@magnolia>
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

A longstanding deficiency in the online fs summary counter scrubbing
code is that it hasn't any means to quiesce the incore percpu counters
while it's running.  There is no way to coordinate with other threads
are reserving or freeing free space simultaneously, which leads to false
error reports.  Right now, if the discrepancy is large, we just sort of
shrug and bail out with an incomplete flag, but this is lame.

For repair activity, we actually /do/ need to stabilize the counters to
get an accurate reading and install it in the percpu counter.  To
improve the former and enable the latter, allow the fscounters online
fsck code to perform an exclusive mini-freeze on the filesystem.  The
exclusivity prevents userspace from thawing while we're running, and the
mini-freeze means that we don't wait for the log to quiesce, which will
make both speedier.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-fscounters
---
 tests/xfs/713     |   36 ++++++++++++++++++++++++++++++++++++
 tests/xfs/713.out |    4 ++++
 tests/xfs/714     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/714.out |    2 ++
 tests/xfs/762     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/762.out |    2 ++
 6 files changed, 131 insertions(+)
 create mode 100755 tests/xfs/713
 create mode 100644 tests/xfs/713.out
 create mode 100755 tests/xfs/714
 create mode 100644 tests/xfs/714.out
 create mode 100755 tests/xfs/762
 create mode 100644 tests/xfs/762.out

