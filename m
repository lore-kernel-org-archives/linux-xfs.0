Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34319 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbeEBMcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 08:32:00 -0400
Received: by mail-wr0-f180.google.com with SMTP id p18-v6so13844733wrm.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 May 2018 05:32:00 -0700 (PDT)
Date: Wed, 2 May 2018 14:31:56 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/2] xfs: clean up xfs_file_iomap_begin()
Message-ID: <20180502123156.csrvt4wgdjw5lqhk@odin.usersys.redhat.com>
References: <20180502055144.28851-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502055144.28851-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 02, 2018 at 03:51:42PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> These patches follow up on recent changes to the locking and
> non-blocking behaviour of xfs_file_iomap_begin() to make it easier
> to follow and understand. The code is a bit of a tangle right now,
> and these two patches pull all of the locking and NOWAIT decisions
> into a single function and out of all the mapping code.
> 
> There are no functional changes here, just a code re-org.
> 
> Cheers,
> 
> Dave.

Both patches looks good:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
