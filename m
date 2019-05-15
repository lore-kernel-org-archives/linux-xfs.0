Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40926 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725921AbfEOFxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 01:53:34 -0400
Date: Wed, 15 May 2019 15:53:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] libxfs: remove xfs_inode_log_item ili_flags
Message-ID: <20190515055331.GV29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-3-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:21PM -0500, Eric Sandeen wrote:
> ili_flags is only set to zero and asserted to be zero; it serves
> no purpose, so remove it.
> 
> (it was renamed to ili_lock_flags in the kernel in commit 898621d5,
> for some reason userspace had both, with ili_flags ~unused)

Probably something that wasn't properly cleaned up in a big merge.
Good to get rid of it, thought.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
