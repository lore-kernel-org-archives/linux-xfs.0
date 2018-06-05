Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:39215 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbeFEA4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 20:56:51 -0400
Date: Tue, 5 Jun 2018 10:56:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use xfs_trans_getsb in xfs_sync_sb_buf
Message-ID: <20180605005647.GX10363@dastard>
References: <bd3ee55c-30a4-4e45-10fc-3458c7b93a1d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3ee55c-30a4-4e45-10fc-3458c7b93a1d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 04, 2018 at 06:50:05PM -0500, Eric Sandeen wrote:
> Use xfs_trans_getsb rather than reaching right in for
> mp->m_sb_bp; I think this is more correct, and it facilitates
> building this libxfs code in userspace as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This passes the online label test ... tbh I'm not quite
> sure if I'm unwinding/unlocking/putting the bp properly
> here, though, so ... eyes & advice appreciated?

I think it's ok - the transaction context is gone with the commit,
so xfs_trans_brelse() would just call xfs_buf_relse() anyway.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
