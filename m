Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:55516 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751410AbdJPAjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 20:39:15 -0400
Date: Mon, 16 Oct 2017 11:39:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/30] xfs: probe the scrub ioctl
Message-ID: <20171016003912.GL3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777249786.1724.13451740442676439052.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777249786.1724.13451740442676439052.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a probe scrubber with id 0.  This will be used by xfs_scrub to
> probe the kernel's abilities to scrub (and repair) the metadata.

This no longer returns anything to userspace it indicate
capabilities. I can see that the previous patch checks for
valid/invalid input flags, so we have unknown feature
checking in place, just not obviously through the probe function
implementation. Can you expand this comment a little to explain
where the supported feature checks occur and so all that is required
here is a stub that does nothing?

Otherwise, consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
