Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8160DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 22:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347774AbiBBWGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Feb 2022 17:06:04 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33594 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235073AbiBBWGD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Feb 2022 17:06:03 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AEB0710C4FD7;
        Thu,  3 Feb 2022 09:06:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nFNlH-007LtB-Ks; Thu, 03 Feb 2022 09:05:59 +1100
Date:   Thu, 3 Feb 2022 09:05:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: handle corruption errors without aborting
Message-ID: <20220202220559.GB59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area>
 <20220202074242.GA59729@dread.disaster.area>
 <CAA43vkXxyHmQdu-GqVukmeOqEh8g-xJDCDD6sx7t4f-MVn+BBA@mail.gmail.com>
 <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
 <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61fb004a
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=sK7nPfoSTDcSBi5Y1_IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 02, 2022 at 03:18:34PM -0500, Sean Caron wrote:
> Hi Dave,
> 
> It counted up to inode 13555712 and then crashed with the error:
> 
> malloc_consolidate(): invalid chunk size

That sounds like heap corruption or something similar - that's a
much more difficult problem to track down.

Can you either run gdb on the core file it left and grab a stack
trace of where it crashed, or run metadump again from gdb so that it
can capture the crash and get a stack trace that way?

> Immediately before that, it printed:
> 
> xfs_metadump: invalid block number 4358190/50414336 (1169892770398976)
> in bmap extent 0 in symlink ino 98799839421

I don't think that would cause any problems - it just aborts
processing the extent records in that block and moves on to the next
valid one that is found.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
