Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3739 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751235AbdJPAIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 20:08:11 -0400
Date: Mon, 16 Oct 2017 11:08:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/30] xfs: create an ioctl to scrub AG metadata
Message-ID: <20171016000808.GJ3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777248179.1724.7466281196965640831.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777248179.1724.7466281196965640831.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an ioctl that can be used to scrub internal filesystem metadata.
> The new ioctl takes the metadata type, an (optional) AG number, an
> (optional) inode number and generation, and a flags argument.  This will
> be used by the upcoming XFS online scrub tool.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
