Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DCBC433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Oct 2021 21:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABD960F22
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Oct 2021 21:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhJaVcs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Oct 2021 17:32:48 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:39458 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhJaVcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Oct 2021 17:32:47 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 19VLTIZF090177;
        Sun, 31 Oct 2021 14:29:20 -0700
Message-ID: <617F0A6D.6060506@tlinx.org>
Date:   Sun, 31 Oct 2021 14:28:13 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Dave Chinner <david@fromorbit.com>
CC:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfsrestore'ing from file backups don't restore...why not?
References: <617721E0.5000009@tlinx.org> <20211026004814.GA5111@dread.disaster.area>
In-Reply-To: <20211026004814.GA5111@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When looking at a dump of /home (but not on other partitions 
that I've noticed, I see (stopping listing on problem line)

XFSDUMP_OPTIONS=-J #(set externally , not usually)

>./dump1fs#160(Xfsdump)> xfsdump -b 268435456 -l 8 -L home -J - /home
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.8 (dump format 3.0)
xfsdump: level 8 incremental dump of Ishtar:/home based on level 6 dump begun Fri Oct 29 04:30:13 2021
xfsdump: dump date: Sun Oct 31 14:20:37 2021
xfsdump: session id: 249233a0-a642-42a0-ae02-ed53012f3fa4
xfsdump: session label: "home"
xfsdump: NOTE: root ino 192 differs from mount dir ino 256, bind mount?

Of note, most things were placed in orphanage under
256.0

df shows:
df /home
Filesystem        Size  Used Avail Use% Mounted on
/dev/Space/Home2  2.0T  1.5T  570G  73% /home

(Became months ago as I made new partition of 2T to replace
old partition of 1.5T, after which I did another 
level-0 backup.



