Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:54848 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbeIKESW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Sep 2018 00:18:22 -0400
Date: Tue, 11 Sep 2018 09:21:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] writeback: fix range_cyclic writeback vs
 writepages deadlock
Message-ID: <20180910232157.GC5631@dastard>
References: <20180622030941.25544-1-david@fromorbit.com>
 <20180910115127.GA29088@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180910115127.GA29088@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 10, 2018 at 01:51:27PM +0200, Jan Kara wrote:
> On Fri 22-06-18 13:09:41, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We've recently seen a workload on XFS filesystems with a repeatable
> > deadlock between background writeback and a multi-process
> > application doing concurrent writes and fsyncs to a small range of a
> > file.
> 
> Going through some old email and this didn't seem to be merged yet?
> FWIW I agree with your solution and the patch looks good to me. Feel free
> to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> and then send it to AKPM for inclusion.

Thanks, Jan. I'll resend it and get it moving.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
