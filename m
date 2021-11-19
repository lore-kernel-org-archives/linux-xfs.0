Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A3DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F82F61A53
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhKSRQF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:16:05 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21885 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKSRQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:16:05 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637341979; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=UORyP16YybZ2utDbWWqNlHwDu6IYf9BQOAq8JXUEBKWUTuH6SSV75KG7PWtfDAsPPhKE5tZosZZ05DUMRsZocME989rB0DaYszYC4aYbjRJ0kHc5JJjZhDrq59C5X9jJ0ieYEMWj0dBO+70PPQUIrnLkHH0A6witzaGFJRa9r2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637341979; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=0Rn7nzChVjP36s0eeGjdfDDEmYHIljtRBGjDMVboyxo=; 
        b=IfsuBbnwj53sKQh1iQXL4Ae3MFOsm/9k62aF0kP/W+pkUsAmyFspxoOrkgd8o+M396Kc5oczvB1FhNc1hv+f6vTubqXL289rggP/E2NLVKx2ve/rgL2wLgXqguRHPdC6EgVoKePnEHLrWth6UgKo35OFYWxw4fVPgmMDE5L32T4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from adam.tec.linutronix.de (port-92-200-1-46.dynamic.as20676.net [92.200.1.46]) by mx.zoho.eu
        with SMTPS id 1637341977760983.504267146207; Fri, 19 Nov 2021 18:12:57 +0100 (CET)
From:   Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Message-ID: <20211119171241.102173-1-bage@debian.org>
Subject: [PATCH 0/2] debian: Fix xfsprogs FT(C)BFS
Date:   Fri, 19 Nov 2021 18:12:39 +0100
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I am going to include these two patches for the unstable Debian upload
of v5.14.0-1.

Thanks,
Bastian

Bastian Germann (2):
  debian: Generate .gitcensus instead of .census (Closes: #999743)
  debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)

 debian/rules | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.30.2


