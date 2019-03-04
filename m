Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:2734 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbfCDXpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 18:45:15 -0500
Date: Tue, 5 Mar 2019 10:45:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Add xfs_only flag to fs_table_initialise_mounts()
 function
Message-ID: <20190304234512.GZ23020@dastard>
References: <20190304213124.552-1-tgill@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304213124.552-1-tgill@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: tgill@redhat.com
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 04, 2019 at 04:31:24PM -0500, tgill@redhat.com wrote:
> From: Todd Gill <tgill@redhat.com>
> 
> The xfs_only flag will allow the caller to request only XFS filesystems are
> added to the fs table.
> 
> For commands that are XFS specific (xfs_fsr, xfs_growfs, xfs_scrub) - pass
> the flag as 1.
> 
> The change avoids a hang when remote filesystem (like NFS) are non
> responsive.

I have the nagging feeling that this has been proposed, discussed
and rejected previously. However, my search skills are sadly lacking
today, because I can't find it in my local archive. Probably worth
doing some more searching rather than repeating the discussion over
again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
