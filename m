Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:48533 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751729AbdELXHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2017 19:07:14 -0400
Date: Sat, 13 May 2017 09:06:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic/285: Add more SEEK_HOLE tests
Message-ID: <20170512230657.GP12369@dastard>
References: <20170511164809.29739-1-jack@suse.cz>
 <20170512080443.GN7250@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512080443.GN7250@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Jan Kara <jack@suse.cz>, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 12, 2017 at 04:04:43PM +0800, Eryu Guan wrote:
> On Thu, May 11, 2017 at 06:48:09PM +0200, Jan Kara wrote:
> > Add tests for bugs found in ext4 & xfs SEEK_HOLE implementations
> > fixed by following patches:
> > 
> > xfs: Fix missed holes in SEEK_HOLE implementation
> > ext4: Fix SEEK_HOLE
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This will cause ext4 and xfs start to fail with current linus tree and
> appear as a new regression. So we usually don't add new tests to
> existing cases.
> 
> But seek_sanity_test.c deals with different SEEK_DATA/HOLE implentations
> nicely, which would be a bit tricky to do in a new test by shell, and it
> has all the infrastructures for new tests like this. So I think I'd
> prefer merging this patch as is, and document the false regression alert
> in release announce email.

Make the new tests optional (i.e. on a cli switch) and add a new
xfstest that runs them? Old test remains unchanged, doesn't fail,
new test covers the new tests, will fail on old kernels (which is ok
for new tests).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
