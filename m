Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB98C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 02:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiBBCsF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 21:48:05 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38089 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243898AbiBBCod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 21:44:33 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9D7AB10C4B50;
        Wed,  2 Feb 2022 13:44:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nF5dG-00725S-36; Wed, 02 Feb 2022 13:44:30 +1100
Date:   Wed, 2 Feb 2022 13:44:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS disaster recovery
Message-ID: <20220202024430.GZ59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f9f00f
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=8Hbsrl3-e2EDxQ4PCEUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 08:20:45PM -0500, Sean Caron wrote:
> Thank you for the detailed response, Dave! I downloaded and built the
> latest xfsprogs (5.14.2) and tried to run a metadump with the
> parameters:
> 
> xfs_metadump -g -o -w /dev/md4 /exports/home/work/md4.metadump
> 
> It says:
> 
> Metadata CRC error detected at 0x56384b41796e, xfs_agf block 0x4d7fffd948/0x1000
> xfs_metadump: cannot init perag data (74). Continuing anyway.
> 
> It starts counting up inodes and gets to "Copied 418624 of 83032768
> inodes (1 of 350 AGs)"
> 
> The it stops with an error:
> 
> xfs_metadump: inode 2216156864 has unexpected extents

Not promising - that's a device inode (blk, chr, fifo or sock) that
appears to have extents in the data fork. That's indicative of the
inode cluster containing garbage, but unfortunately the error
propagation from a bad inode appears to abort the rest of the
metadump.

That looks like a bug in metadump to me.

Let me confirm this and work out how it should behave and I'll
send you a patch to avoid this issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
