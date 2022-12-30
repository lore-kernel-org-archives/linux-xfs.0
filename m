Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA1FC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiLaBDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiLaBDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:03:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D242E1DDF0;
        Fri, 30 Dec 2022 17:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A7A61D70;
        Sat, 31 Dec 2022 01:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD1CC433EF;
        Sat, 31 Dec 2022 01:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448630;
        bh=05tc+KJzVDyb3CpqvDzgpcLSp4Fj7KEs605HX+imy/4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LdVLWZ1GTg+ERhwA18JNexWquvruTTnXz4jBEOgDBdeI1Z3gAViws1Pbe2evY4nEu
         LmV56MMANctXPgQind2gJfnfsCNy4pCw9o7JkKuJRrsSyOk0QrO8c4ZaYrXVueGr4U
         1E/2wOClZ8KyiTIfbZIhIq5xJLEpjC8TSkxqd4HBZeFFTY2twwY8Lq8h9QGqoJrbW7
         4K9RIUpKDXuY71wC36dlZdceLVgm0iHr2xhpUp+lnsibanvmEmviRQ/zpLkUqOHnr5
         AC28NIQbZgn1p6p1XCP408fTQAXo1rnqSxZRe8udmazYg8LgbE7fEpJMcVBc6KQCxx
         UpGYUZYMYmhNw==
Subject: [PATCHSET v1.0 0/4] fstests: support metadump to external devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:36 -0800
Message-ID: <167243883613.738384.6883268151338937809.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series modifies fstests to take advantage of the fact that
xfs_metadump and xfs_mdrestore now support capturing the contents of an
external log in a metadump, and restoring it on the other end.  The
first part of this series refactors and cleans up the common code a bit,
and the rest add the actual support.  Once this is merged, we'll be able
to cache metadumps of populated filesystems with external log devices,
which will enable faster fuzz testing.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadump-external-devices

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadump-external-devices
---
 common/ext4     |   17 ++++++++++++-
 common/fuzzy    |    7 +++++
 common/populate |   72 ++++++++++++++++++++++++++++---------------------------
 common/xfs      |   39 ++++++++++++++++++++++++++++--
 4 files changed, 95 insertions(+), 40 deletions(-)

