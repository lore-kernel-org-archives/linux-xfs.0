Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B439C41513
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 19:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjHAT6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjHAT6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 15:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99106DB;
        Tue,  1 Aug 2023 12:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34D73616D7;
        Tue,  1 Aug 2023 19:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FED0C433C8;
        Tue,  1 Aug 2023 19:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690919896;
        bh=0rLOEj9lB+jzObAqxrHgGtwIwYUMJC354EkgMvvgg4Y=;
        h=Subject:From:To:Cc:Date:From;
        b=fvdkTtbW6H9HGOlGZnwPYf25tMgm2ocEPQz0C1NK/rT3iGypRtgbRnOCEQpblKxZY
         ih4Jw6ejIlx/8BFtJ6OqPXpn6Xu1Wi0la8xJeaL26/3ZZM4wBhUfDjg5FYJCHbYgJ0
         E2YjRGbO5rVBmVg29HyHMEA31UI+/kMFEtr3Jho4fJFnixTnmmhygJt2tmzY896EWa
         hJ3I1wOQurwGym8nGFzTt29zrGYO+4GzooRlTAwyFBn+35WQV9s8vQSl4YlOEhdBoN
         sMMoG8MYb+O6HmtoHQ4ASisytj2MpPQsbZhVLkmiKdEkKPbOTqDZxqILkd4LsaG1RA
         GAKNyQPv6UHVg==
Subject: [PATCHSET 0/3] xfs: maintainer transition for 6.6
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     corbet@lwn.net, Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, cem@kernel.org, sandeen@sandeen.net,
        chandan.babu@oracle.com, amir73il@gmail.com,
        leah.rumancik@gmail.com, zlang@kernel.org, fstests@vger.kernel.org,
        willy@infradead.org, shirley.ma@oracle.com, konrad.wilk@oracle.com
Date:   Tue, 01 Aug 2023 12:58:15 -0700
Message-ID: <169091989589.112530.11294854598557805230.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I do not choose to continue as maintainer.

My final act as maintainer is to write down every thing that I've been
doing as maintainer for the past six years.  There are too many demands
placed on the maintainer, and the only way to fix this is to delegate
the responsibilities.  I also wrote down my impressions of the unwritten
rules about how to contribute to XFS.

The patchset concludes with my nomination for a new release manager to
keep things running in the interim.  Testing and triage; community
management; and LTS maintenance are all open positions.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
 Documentation/filesystems/index.rst                |    1 
 .../filesystems/xfs-maintainer-entry-profile.rst   |  192 ++++++++++++++++++++
 .../maintainer/maintainer-entry-profile.rst        |    1 
 MAINTAINERS                                        |    4 
 4 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/filesystems/xfs-maintainer-entry-profile.rst

