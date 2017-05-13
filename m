Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751519AbdEMR0X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 May 2017 13:26:23 -0400
Date: Sun, 14 May 2017 01:26:21 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic/285: Add more SEEK_HOLE tests
Message-ID: <20170513172620.GR7250@eguan.usersys.redhat.com>
References: <20170511164809.29739-1-jack@suse.cz>
 <20170512080443.GN7250@eguan.usersys.redhat.com>
 <20170512230657.GP12369@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512230657.GP12369@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, May 13, 2017 at 09:06:57AM +1000, Dave Chinner wrote:
> On Fri, May 12, 2017 at 04:04:43PM +0800, Eryu Guan wrote:
> > On Thu, May 11, 2017 at 06:48:09PM +0200, Jan Kara wrote:
> > > Add tests for bugs found in ext4 & xfs SEEK_HOLE implementations
> > > fixed by following patches:
> > > 
> > > xfs: Fix missed holes in SEEK_HOLE implementation
> > > ext4: Fix SEEK_HOLE
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > This will cause ext4 and xfs start to fail with current linus tree and
> > appear as a new regression. So we usually don't add new tests to
> > existing cases.
> > 
> > But seek_sanity_test.c deals with different SEEK_DATA/HOLE implentations
> > nicely, which would be a bit tricky to do in a new test by shell, and it
> > has all the infrastructures for new tests like this. So I think I'd
> > prefer merging this patch as is, and document the false regression alert
> > in release announce email.
> 
> Make the new tests optional (i.e. on a cli switch) and add a new
> xfstest that runs them? Old test remains unchanged, doesn't fail,
> new test covers the new tests, will fail on old kernels (which is ok
> for new tests).

Yeah, this should work and looks a better solution to me. This avoids
regressing generic/285 again when adding another new test in future,
future tests could just follow this path too. Thanks for the suggestion!

Jan, could you please update the patch and, as suggested by Dave, make
it a new test? I can do it too if you like.

Thanks,
Eryu
