Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:26187 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750966AbdIGXec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 19:34:32 -0400
Date: Fri, 8 Sep 2017 09:34:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS mounted with 'discard' option - deleting fio test files slow
Message-ID: <20170907233401.GC17782@dastard>
References: <42228B9C-D2D3-4B9C-BFCF-BC9AED4A9678@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42228B9C-D2D3-4B9C-BFCF-BC9AED4A9678@amazon.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Lu, Qian" <luqia@amazon.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


[Your email is full of wacky symbols and needs line wrapping at 72
columns]

On Thu, Sep 07, 2017 at 06:22:22PM +0000, Lu, Qian wrote:
> Recently we received a bug report in the XFS filesystem with
> 'discard' option. I have been able to reproduce this issue. I used
> XFS filesystem to format NVMe SSD and mounted with 'discard'
> option. When I tried to delete the test fio files, the session
> took long time. This issue is based on Linux 4.9 stable tree. I
> have also repeated this test with Linux 4.13, 4.12, and we are
> facing the same issue. Tests were repeated several times and it
> was consistent.

.....
> 
> # fio --name fio_test_file --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=8 --group_reporting
> --> Interrupt with Ctrl+C
> # time rm -rf fio_test_file.*
> real 2m2.242s
> user 0m0.000s
> sys 0m25.524s

4k random write with direct IO. 5GB file. Probably got a million 4k
extents in it. Which means XFS has sent a million tiny 4k discards
to the device. Run 'xfs_bmap -vvp fio_test_file.*' to confirm.

Don't use "-o discard" if you care about performance.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
