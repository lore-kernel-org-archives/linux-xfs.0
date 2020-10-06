Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9C2C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C393B208B8
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LU5iCSPz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgJFWGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:06:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:49754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJFWGp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 18:06:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602022003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dNrS/qfmb/Wf7ZBVNuoRowt6W3Ol6Tgx8pLLAbpvZs8=;
        b=LU5iCSPzHVkSVvkarr2x/WCqCknm6FWmJ5ZNmXI9WdrMK25oWqGHkQ4a3gwFLYVSDpX/UH
        wazDssYxN52pXOp8altse0NEKRUODHMBQBH0zUZb+f9ixzkhu6/utl32oHeL47Ybwg9HJc
        gJCUdDtgZ+yAfopaLtU7AK/ztVMCIsU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ABBE9AF49;
        Tue,  6 Oct 2020 22:06:43 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfsdump: obsolete file type handling cleanups
Date:   Wed,  7 Oct 2020 00:07:02 +0200
Message-Id: <20201006220704.31157-1-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just a couple of code and doc removals for file types that were never
supported in Linux (S_IFMNT, S_IFNAM).

Anthony Iliopoulos (2):
  xfsdump: remove obsolete code for handling mountpoint inodes
  xfsdump: remove obsolete code for handling xenix named pipes

 doc/files.obj     | 2 +-
 doc/xfsdump.html  | 6 ++----
 dump/content.c    | 6 ------
 dump/inomap.c     | 3 ---
 restore/content.c | 8 --------
 5 files changed, 3 insertions(+), 22 deletions(-)

-- 
2.28.0

