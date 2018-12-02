Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4879 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725778AbeLBUxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 15:53:55 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gTYkM-0002gA-AA
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 07:53:46 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gTYkM-0001s7-5P
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 07:53:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs_io: additions for testing copy_range
Date: Mon,  3 Dec 2018 07:53:41 +1100
Message-Id: <20181202205343.7104-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

In trying to exercise copy_file_range() error conditions, I needed
to be able to pass pipes to copy_range and to have writeable file
descriptors open over read only files. These two patches allow these
things to be done by preventing pipes blocking on opening and
allowing xfs_io to change read/write permissions on open files.

Cheers,

Dave.
