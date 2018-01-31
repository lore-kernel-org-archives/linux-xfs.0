Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:13487 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753463AbeAaXrx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 18:47:53 -0500
Date: Thu, 1 Feb 2018 10:48:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reverse mapping
Message-ID: <20180131234846.x7jvyrtf3ypfulnh@destitution>
References: <20180131174913.GE4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131174913.GE4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, Jan 31, 2018 at 09:49:13AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reverse mapping has had a while to soak, so remove the experimental tag.
> Now that we've landed space metadata cross-referencing in scrub, the
> feature actually has a purpose.
> 
> Reject rmap filesystems with an rt device until the code to support it
> is actually implemented.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I've been using it for as long as I've been using reflink, and rmap
has posed less problems than reflink. So I think this is the right
time to remove the experimental flag.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
