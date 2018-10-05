Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35708 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbeJFCqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 22:46:54 -0400
Date: Fri, 5 Oct 2018 12:46:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] writeback: fix range_cyclic writeback vs writepages
 deadlock
Message-Id: <20181005124640.3de2ba9dec8c713ee8cf286b@linux-foundation.org>
In-Reply-To: <20181005054526.21507-1-david@fromorbit.com>
References: <20181005054526.21507-1-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri,  5 Oct 2018 15:45:26 +1000 Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> We've recently seen a workload on XFS filesystems with a repeatable
> deadlock between background writeback and a multi-process
> application doing concurrent writes and fsyncs to a small range of a
> file.
> 
> ...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.de>

Not a serious enough problem for a -stable backport?
