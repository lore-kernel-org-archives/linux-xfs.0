Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33274 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730915AbeKTHbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:31:02 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj6-0000XM-UV
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj6-0002Fo-R2
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfs: various fixes for 4.20
Date: Tue, 20 Nov 2018 08:04:52 +1100
Message-Id: <20181119210459.8506-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This series is an aggregation of fixes I've been building up over
the past few weeks. They are a result of bug reports, problems
analysing extremely large metadump image files, trying to add 64k
block size support to x86-64, and adding dedup/clone/copy_file_range
support to fsx.

I've posted a couple of these before, these versions contain the
updates made as a result of review comments that were made.

THere are no new regressions from these patches in fstests, and they
fix some of the new fsx failures that we are seeing with it's new
functionality.

Cheers,

Dave.
