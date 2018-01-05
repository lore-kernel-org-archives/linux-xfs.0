Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:28486 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751166AbeAECL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 21:11:59 -0500
Date: Fri, 5 Jan 2018 13:11:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] xfs: fix a few erroneous process_error calls in
 the scrubbers
Message-ID: <20180105021157.GZ30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398984007.18741.3912365431444339300.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398984007.18741.3912365431444339300.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:44:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There are a few places where we make a libxfs api call on behalf of some
> object other than the one we're scrubbing but inadvertently call the
> regular process_error function.  When this happens we mark the object
> corrupt even though it was corruption in /some other/ object that
> actually produced the -EFSCORRUPTED code.  The correct output flag for
> these situations is SCRUB_OFLAG_XFAIL, not SCRUB_OFLAG_CORRUPT, so fix
> this now that we also have a helper to set these.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
