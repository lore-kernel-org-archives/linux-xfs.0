Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37088 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbeJVKbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Oct 2018 06:31:11 -0400
Date: Mon, 22 Oct 2018 13:14:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/28] xfs: support returning partial reflink results
Message-ID: <20181022021439.GT6311@dastard>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
 <154013867727.29026.14417615066515846065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154013867727.29026.14417615066515846065.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sun, Oct 21, 2018 at 09:17:57AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Back when the XFS reflink code only supported clone_file_range, we were
> only able to return zero or negative error codes to userspace.  However,
> now that copy_file_range (which returns bytes copied) can use XFS'
> clone_file_range, we have the opportunity to return partial results.
> For example, if userspace sends a 1GB clone request and we run out of
> space halfway through, we at least can tell userspace that we completed
> 512M of that request like a regular write.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok to me. remap_file_range() still returns the full length,
so there's no change of behaviour there.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
