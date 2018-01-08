Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3966 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758138AbeAHW5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 17:57:09 -0500
Date: Tue, 9 Jan 2018 09:57:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: clarify units in the failed metadata io message
Message-ID: <20180108225705.GE16421@dastard>
References: <20180108194015.GT5602@magnolia>
 <20180108223845.GZ5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108223845.GZ5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Mon, Jan 08, 2018 at 02:38:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a metadata IO error happens, we report the location of the failed IO
> request in units of daddrs.  However, the printk message misleads people
> into thinking that the units are fs blocks, so fix the reported units.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix only the units reporting, don't print the caller
> v2: fix more messages

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
