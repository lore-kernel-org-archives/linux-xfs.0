Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4617 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752137AbeEOE6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 00:58:45 -0400
Date: Tue, 15 May 2018 14:58:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS 2038 rollover?
Message-ID: <20180515045842.GH23861@dastard>
References: <7BDFF86A-062B-4731-97E8-33E920CF7E7D@deer-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7BDFF86A-062B-4731-97E8-33E920CF7E7D@deer-run.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hal Pomeranz <hal@deer-run.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 15, 2018 at 12:33:01AM -0400, Hal Pomeranz wrote:
> I was curious about the roadmap for solving the 32-bit signed
> rollover issue for XFS (aka the “Y2K38” issue). You could
> cheat in a similar fashion to EXT4 and use the upper two bits of
> the nsec values to extend the seconds field to 34 bits. Or will
> the inode core be expanding to allow full 64-bit seconds values?
> Or is there some other plan?
> 
> I’ve checked the FAQ and haven’t been able to find
> anything via Google. 

Something along these lines:

https://lkml.org/lkml/2014/6/1/240

However, the VFS infrastructure I was asking for back in 2014 for
clamping timestamp ranges to the valid on-disk supported filesystem
range hasn't appeared yet, so there's a lot more work than just the
preliminary on-disk extended range support to be done....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
