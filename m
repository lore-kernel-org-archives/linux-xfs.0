Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:34365 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbdCILIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2017 06:08:18 -0500
Received: by mail-ot0-f171.google.com with SMTP id o24so53835622otb.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2017 03:08:18 -0800 (PST)
MIME-Version: 1.0
From: fuser ct1 <fuserct1@gmail.com>
Date: Thu, 9 Mar 2017 11:08:17 +0000
Message-ID: <CAL8yqiigz_ShyH=YE5GqxP+V5jRiMJLPSQpWbcsAiCzzQfsP_A@mail.gmail.com>
Subject: pquota + xfs_fsr cron
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello list,

Many of the posts here are DLEVEL, so I hope this won't seem too pedestrian.

My questions are:


1) do project quota's noticeably slow xfs down?

That might sound silly, but I'm planning to use them quite
extensively. Sure, initializing the quota can take a while (I don't
want to limit the depth), but aside from this can't find any ill
effects in the lab.


2) is it moronic to do a nightly xfs_fsr?

It seems reasonable that my system defrag XFS volumes automatically.

The problem is I often don't have access my machines (no SSH), so
would like to leave this simple option in place.

Sure I can write a little script to check the defrag % then act
accordingly, but xfs_fsr seems like it would already work.


3) Finally, according to the docs, unless instructed otherwise xfs_fsr
should check all XFS volumes present in mtab. My lab box only has one
volume, but supposing there were two (or more) should I expect it to
divide the 2 hours time it spends nightly between all mounted XFS
volumes?


Thanks in advance!

fUSER
