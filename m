Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E364C10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiLMTpQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiLMTpO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD2DFF6;
        Tue, 13 Dec 2022 11:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D7E29CE1784;
        Tue, 13 Dec 2022 19:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7F5C433D2;
        Tue, 13 Dec 2022 19:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960710;
        bh=hvq8LGyDN5pS8eNftlJ1dMtKC2RlI2/Giihf0icM7Uw=;
        h=Subject:From:To:Cc:Date:From;
        b=UcO1ImSWlcObD0HTGoGRefIR13iZF9mT6S10R9+t4zYd5PDgxJPLJ6EocNXHr96bv
         wJ1EehW+hf9Eby7qRJP0jOkp4aVaSlFBCmaLmT7u452xTKo+4Cmipf1MNdiJgEgVim
         4It3eBx4c/EhMB663Uuhl7cV+Aj+UWaHB/1bpdpPlPicOsOsIaI85+I4TpF47EgZf3
         fCjL3mqdODP6XFUtQtyd/m0wkHcNDCXVIgBovrOfTTxQ63jgpxqyQHaB9/ElqdFJn5
         xPnXzmK/mjtUU3swx/76hLY0AzXsOy7t/sufdCWLROirRV+gUDkmQealZVqev/cLwo
         Myga21Tm+tEEg==
Subject: [PATCHSET 0/4] fstests: fix broken fuzzing xfs_mdrestore calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:09 -0800
Message-ID: <167096070957.1750373.5715692265711468248.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Back in 2021, I amended the xfs create-a-filesystem helper code to
support the generation of compressed metadumps.  Unfortunately, I
neglected to submit the other half of that code which detects a
*compressed* metadump file and uses it, which means that the metadump
caching used by all the xfs fuzz tests have been broken ever since, but
only if DUMP_COMPRESSOR is set by the user.

Fast-forward to 2022, and I noticed that fuzz tests runs would
occasionally complain about POPULATE_METADUMP not pointing to a valid
file if DUMP_COMPRESSOR is set, and no dump file exists, compressed or
uncompressed.  After some curious looks from Zorro, I finally realized
that POPULATE_METADUMP points to the uncompressed file, so checking for
its existence is not correct.

Hence port all the code that fixed mdrestore of compressed metadumps
further down the patch stack, and fix the broken conditional to get
things running again.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
 common/ext4     |   21 +++++++++++++++++++++
 common/fuzzy    |    5 ++---
 common/populate |   15 ++-------------
 common/xfs      |   29 +++++++++++++++++++++++++++++
 tests/xfs/129   |    2 +-
 tests/xfs/234   |    2 +-
 tests/xfs/253   |    2 +-
 tests/xfs/284   |    2 +-
 tests/xfs/291   |    2 +-
 tests/xfs/336   |    2 +-
 tests/xfs/432   |    2 +-
 tests/xfs/503   |    8 ++++----
 12 files changed, 65 insertions(+), 27 deletions(-)

