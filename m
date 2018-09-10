Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727871AbeIJQpL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Sep 2018 12:45:11 -0400
Date: Mon, 10 Sep 2018 13:51:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RFC] writeback: fix range_cyclic writeback vs
 writepages deadlock
Message-ID: <20180910115127.GA29088@quack2.suse.cz>
References: <20180622030941.25544-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180622030941.25544-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri 22-06-18 13:09:41, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We've recently seen a workload on XFS filesystems with a repeatable
> deadlock between background writeback and a multi-process
> application doing concurrent writes and fsyncs to a small range of a
> file.

Going through some old email and this didn't seem to be merged yet?
FWIW I agree with your solution and the patch looks good to me. Feel free
to add:

Reviewed-by: Jan Kara <jack@suse.cz>

and then send it to AKPM for inclusion.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
