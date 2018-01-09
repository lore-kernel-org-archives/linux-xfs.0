Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41715 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753389AbeAIW7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 17:59:38 -0500
Date: Wed, 10 Jan 2018 09:59:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: change 0x%p -> %p in print messages
Message-ID: <20180109225935.GN16421@dastard>
References: <151553075309.16288.5030700495895866371.stgit@magnolia>
 <151553075925.16288.12486014729801230618.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151553075925.16288.12486014729801230618.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 12:45:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since %p prepends "0x" to the outputted string, we can drop the prefix.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Nice little cleanup. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

(Next up - consistently printing offsets and inode numbers in hex :P)

-- 
Dave Chinner
david@fromorbit.com
