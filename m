Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56061 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758224AbdLRJML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 04:12:11 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0002sq-Lj
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0003qG-HO
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] mkfs: various cleanups
Date: Mon, 18 Dec 2017 20:11:51 +1100
Message-Id: <20171218091158.14537-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This patchset follows up the mkfs refactoring and cleans up some of
the loose ends in that patchset. The first patch makes all the
option parsing use option table poitners consistently. The second
patch gets rid of mkfs/maxtrres.c as we don't need to build a whole
new superblock from individual config state anymore. The third patch
fixes a double call to setup the protofile.

THe next three patches allow the option table to specify conflicts
with options ouside the immediate subsystem. This cleans up the
implicit index in teh subopt name arrays and fixes some suboptimal
error messages.

Finally, the last patch removes all the log-based size options for
different parameters. We don't use them anywhere in xfstests, and
very few people use them, so just remove all the redundant options
and clean up the code to consistently calculate the log based values
needed in the superblock.

Thoughts, comments, flames all welcome...

-Dave.
