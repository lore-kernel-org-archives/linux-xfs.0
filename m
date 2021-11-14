Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE81C433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7D360E94
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 22:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhKNXCL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 18:02:11 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21808 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhKNXCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Nov 2021 18:02:08 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1636929828; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=kcgm1J/FE9QigP/qTcXlctjgOrRq4ZxDjlM9qcuG3/E0L5gE7eYgD7MdYzpdmMqRB+0Tr7cE5NS4dSisJ6Bm2WflKCb+uPaZTR5GWRHtkha5dW9YxvQxSngyglTRtGbkRodB6knLxacbMl3VIRGhE/vYc4NC0EewIoKw9b57T0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1636929828; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=FeTaBvqjdkMTXJkHBvsaxVZhLjUtaDJRRxbRu/2fqt8=; 
        b=lDQavFENljDMTJrm35zEIfSJ4mzyfGnATWF+rMajLaGrZgYQQx3nvxgwkFVOSheh6CMLuDuyMmSphr1+bmzHOt4alLRiSlIxfNokzPiRf5sNcdtoj85C33THz4PAXRk3M5IgejU3kqRuZOJf0puBT0FZtyNkFTZE1N6m4JKFnrY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from thinkbage.fritz.box (pd9544ed8.dip0.t-ipconnect.de [217.84.78.216]) by mx.zoho.eu
        with SMTPS id 1636929825971297.74720821417645; Sun, 14 Nov 2021 23:43:45 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Message-ID: <20211114224339.20246-1-bage@debian.org>
Subject: [PATCH v2 0/4] xfsprogs debian updates
Date:   Sun, 14 Nov 2021 23:43:35 +0100
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

As my Debian package changes were not included with the rc1,
I resend them with modifications and a new patch by Boian Bonev
that fixes the current RC build issue in Debian.

I ask you to apply them asap so that I can upload a fixed version.

Thanks,
Bastian

Changelog:
 v2: - Collect Review tags
     - Rebase 1st patch on the liburcu-dev addition
     - Drop debian/changelog changes from 2nd patch
     - Drop Multi-Arch patch (did not receive feedback in 1.5 months)
     - Add FTBFS fixing patch by Boian Bonev
     - Add patch with changelog entry

Bastian Germann (3):
  debian: Update Uploaders list
  debian: Pass --build and --host to configure
  debian: Add changelog entry for 5.14.0-rc1-1

Boian Bonev (1):
  debian: Fix FTBFS

 debian/changelog | 15 +++++++++++++++
 debian/control   |  2 +-
 debian/rules     | 10 ++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.33.1


