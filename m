Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:58558 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932184AbeBGBdu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Feb 2018 20:33:50 -0500
Date: Wed, 7 Feb 2018 12:34:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: support a basic extent swap command
Message-ID: <20180207013441.fwxtfm7nbtsjwidp@destitution>
References: <20180206130247.61882-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206130247.61882-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 06, 2018 at 08:02:47AM -0500, Brian Foster wrote:
> Extent swap is a low level mechanism exported by XFS to facilitate
> filesystem defragmentation. It is typically invoked by xfs_fsr under
> conditions that will atomically adjust inode extent state without
> loss of file data.
> 
> xfs_fsr does not provide the necessary controls for low-level
> testing of the extent swap command, however. For example, xfs_fsr
> implements policies that dictate when to perform an extent swap and
> offers no control over the donor file characteristics.

Hmmmm. I'm confused - we already use xfs_fsr for low level testing
of swapext functionality with carefully constructed donor file
characteristics in xfs/227.

What am I missing here?

I don't see any problem with adding a specific command to run
more controlled swapext tests, i just want to make sure I understand
what xfs_fsr is not providing you with.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
