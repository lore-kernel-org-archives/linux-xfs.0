Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423532AbeBOQjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 11:39:25 -0500
Date: Thu, 15 Feb 2018 08:39:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/015: enlarge the initial fs size
Message-ID: <20180215163917.GA14582@magnolia>
References: <20180104054626.14458-1-eguan@redhat.com>
 <20180214152401.GO18267@eguan.usersys.redhat.com>
 <20180214164532.GH5217@magnolia>
 <20180215083317.GQ18267@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180215083317.GQ18267@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Feb 15, 2018 at 04:33:17PM +0800, Eryu Guan wrote:
> On Wed, Feb 14, 2018 at 08:45:32AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 14, 2018 at 11:24:01PM +0800, Eryu Guan wrote:
> > > On Thu, Jan 04, 2018 at 01:46:26PM +0800, Eryu Guan wrote:
> > > > Kernel commit f59cf5c29919 ("xfs: remove "no-allocation"
> > > > reservations for file creations") is known to cause earlier ENOSPC
> > > > conditions, and xfs/015 is affected in the way that no new file/dir
> > > > can be created in a newly created 16M XFS with both reflink and
> > > > rmapbt enabled, thus xfs/015 fails due to the missing test dirs.
> > > > 
> > > > So enlarge the initial fs size to 32M that we're able to create new
> > 
> > 32M?  I thought this was a 64M -> 128M expansion?
> 
> The final fs size (after growfs) is expanded from 64M to 128M, but we
> need the initial fs size (prior to growfs) to be 32M instead of 16M.

Ahh, ok.  The initial size is doubled (and the test still grows the fs
4x), so we need to double the _require_space.

> 
> > 
> > > > dir/file before growing the filesystem size.
> > > > 
> > > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > 
> > I don't think this hurts anything, but otoh I couldn't reproduce the
> > failure you're seeing on my setup.
> 
> You need "both reflink and rmapbt enabled", I can still reproduce it
> with v4.16-rc1 kernel with MKFS_OPTIONS="-m reflink=1,rmapbt=1".
> 
> Thanks for reviewing!

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
