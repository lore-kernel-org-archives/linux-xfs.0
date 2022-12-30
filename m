Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07623C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiL3XP4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiL3XPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4BC95B0;
        Fri, 30 Dec 2022 15:15:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39CFAB81DAD;
        Fri, 30 Dec 2022 23:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40C6C433EF;
        Fri, 30 Dec 2022 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442152;
        bh=w6OT9NItbEMTituV3yQduA7eDFXx1H0a+fDSiIAYfXM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MRNx48uk2dFF9kPi7RnCWV2tGfZvr3wHbtzqfdkktUHcEkWLwmerarkYTYBoCM2Ac
         fWylLsFtXe5TP3OWNPBCGvqswVO11GzuGroWLKIIUVAkiEdlRXg0X03O1VQoG1G4CU
         x7HBI0hurkQEMk2l1qIfVgQemBWENHeexikSeJ/nrt7bviTeucXn4VD+Wx75HrT5Pd
         H1ShPRnDQuUN0aeFrqIy8LFL09LZxZ8DLaOEUvpNxriGz1OsRNMB1PPyQOWdUjV5ym
         /1XX2gZqyrI1RSZut73SasiL47lD0PlDW41ZtSODnmFRKuUHKvun2tENnou9RGMKd+
         bDv35kCXnkpmA==
Subject: [PATCHSET v24.0 0/1] xfs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:09 -0800
Message-ID: <167243874952.722591.1496636246267309523.stgit@magnolia>
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

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
---
 common/fuzzy |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

