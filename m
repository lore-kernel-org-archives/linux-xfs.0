Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:55564 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbeJLIws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 04:52:48 -0400
Date: Fri, 12 Oct 2018 12:22:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/25] xfs: remove redundant remap partial EOF block
 checks
Message-ID: <20181012012243.GU6311@dastard>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923132645.5546.97372209609060021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923132645.5546.97372209609060021.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 09:15:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've moved the partial EOF block checks to the VFS helpers, we
> can remove the redundantn functionality from XFS.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
