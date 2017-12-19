Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25669 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759421AbdLSDuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 22:50:10 -0500
Date: Tue, 19 Dec 2017 14:50:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/13] xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3
 data verifiers
Message-ID: <20171219035006.GL4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320950500.30654.7534958032611175786.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320950500.30654.7534958032611175786.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:58:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since __xfs_dir3_data_check verifies on-disk metadata, we can't have it
> noisily blowing asserts and hanging the system on corrupt data coming in
> off the disk.  Instead, have it return a boolean like all the other
> checker functions, and only have it noisily fail if we fail in debug
> mode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine, though we do lose fine-grained debug information here.
I guess we get that back from the conversion to _this_address as
the return value, though...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
