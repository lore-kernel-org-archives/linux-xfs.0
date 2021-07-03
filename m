Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A4BC07E96
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0BB61416
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhGCDAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhGCDAa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D406613EB;
        Sat,  3 Jul 2021 02:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281077;
        bh=rkcDsL5Ecs4mNgKTu8iKm1vOaNpB2DEOYIRtydiEgUU=;
        h=Subject:From:To:Cc:Date:From;
        b=lShucG4/ARZwqKQHeUDQ9TLCGpZwPsCPxc64ptyeNETB7TCaz2bnbgEK2vH+VsYrM
         pFtX0sMv329mdzGW7IEHB/vhksV8j7vL93CERw6KjSURLrxks9bwdFNIfCv3gbbEq7
         CijfYTZCqagSV5bZnFQiBV0nQFyjL8OowY6kEN/lFRCdIlAwgtYB0xrqnna52jCPJf
         sl6t+pp3xIr95Psc+x9B3VtlOrYavwYiCZis0RfgpnvJwSrDSbLsfQeJM3js3lfKTO
         CTdI6qdwELOyuylyYhZusbMhGBnvURkt7qQtkWPOsKYuErRudp+i6jozQORpSjVPtm
         MrxU6gJcoFxjQ==
Subject: [PATCHSET 0/2] xfs_io: small fixes to funshare command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:57:57 -0700
Message-ID: <162528107717.36401.11135745343336506049.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of small fixes to the funshare command.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=funshare-fixes
---
 io/prealloc.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

