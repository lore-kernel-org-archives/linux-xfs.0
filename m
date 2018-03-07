Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45924 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933970AbeCGPwn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 10:52:43 -0500
Subject: Re: [PATCH] xfs: fix transaction allocation deadlock in IO path
References: <20180305041120.4224-1-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2e82feb4-918b-dc12-1148-078779e9b4b2@sandeen.net>
Date: Wed, 7 Mar 2018 09:52:42 -0600
MIME-Version: 1.0
In-Reply-To: <20180305041120.4224-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 3/4/18 10:11 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans_alloc() does GFP_KERNEL allocation, and we can call it
> while holding pages locked for writeback in the ->writepages path.
> The memory allocation is allowed to wait on pages under writeback,
> and so can wait on pages that are held locked in writeback by the
> caller.
> 
> This affects both pre-IO submission and post-IO submission paths.
> Hence xfs_setsize_trans_alloc(), xfs_reflink_end_cow(),
> xfs_iomap_write_unwritten() and xfs_reflink_cancel_cow_range().
> xfs_iomap_write_unwritten() already does the right thing, but the
> others don't. Fix them.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

