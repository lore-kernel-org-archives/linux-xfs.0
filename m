Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47739 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932538AbcJYU7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 16:59:33 -0400
Date: Wed, 26 Oct 2016 07:59:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: task pool:2509 blocked for more than 120 seconds
Message-ID: <20161025205926.GC23194@dastard>
References: <CABXGCsNtOfYRX_exLiBjA9WQDTui33XX7zdb8kwshneMUaS8iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsNtOfYRX_exLiBjA9WQDTui33XX7zdb8kwshneMUaS8iQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 12:46:54AM +0500, Михаил
Гаврилов wrote:
> Hello guy's!  Can anybody look at my problem?  Every time after
> boot and launching google chrome the messages with text "task
> pool:2509 blocked for more than 120 seconds" added to kernel log.
> And in call trace I see many references to xfs code.  It likely
> XFS or VFS issue. Can you tell anything about it?

XFs is stalled waiting for IO completion. Seems to me that there's
a DMA-API debugging OOM message almost exactly 120s before the
hung task timeouts fire. Problem with the debugging code, perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
