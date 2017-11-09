Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59694 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751241AbdKICNO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:13:14 -0500
Date: Thu, 9 Nov 2017 13:13:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: pass inode number to xfs_scrub_ino_set_{preen,
 warning}
Message-ID: <20171109021311.GM4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001662000.26786.4013509197578072250.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001662000.26786.4013509197578072250.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

On Mon, Nov 06, 2017 at 05:03:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There are two ways to scrub an inode -- calling xfs_iget and checking
> the raw inode core, or by loading the inode cluster buffer and checking
> the on-disk contents directly.  The second method is only useful if
> _iget fails the verifiers; when this is the case, sc->ip is NULL and
> calling the tracepoint will cause a system crash.
> 
> Therefore, pass the raw inode number directly into the _preen and
> _warning functions.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Simple enough. Looks ok

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
