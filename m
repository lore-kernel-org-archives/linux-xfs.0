Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39905 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932540AbeEWKqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 06:46:35 -0400
Date: Wed, 23 May 2018 18:46:29 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs: pass extra params to _scratch_mkfs_xfs_opts in
 _scratch_mkfs_xfs
Message-ID: <20180523104629.GU29080@desktop.hz.ali.com>
References: <20180511030559.26502-1-guaneryu@gmail.com>
 <20180521223252.GQ23861@dastard>
 <20180523020129.GT29080@desktop.hz.ali.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523020129.GT29080@desktop.hz.ali.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, May 23, 2018 at 10:01:29AM +0800, Eryu Guan wrote:
> On Tue, May 22, 2018 at 08:32:52AM +1000, Dave Chinner wrote:
> > On Fri, May 11, 2018 at 11:05:59AM +0800, Eryu Guan wrote:
> > > One of _scratch_mkfs_xfs_opts()'s job is to remove any metadata
> > > related mkfs options if mkfs.xfs binary doesn't support them, so
> > > that tests that pass metadata mkfs options to _scratch_mkfs, e.g.
> > > "_scratch_mkfs -m crc=0" won't break with old mkfs.xfs.
> > > 
> > > But commit 596a068bf130 ("fstests: teach _scratch_mkfs to handle
> > > mkfs option conflicts") broke this, because it didn't pass any mkfs
> > > options to _scratch_mkfs_xfs_opts(). So fix it.
> > > 
> > > Also declare a variable as 'local' and fix a typo.
> > > 
> > > Reported-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> > 
> > Looks fine.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > (sorry for missing this when you opsted it first time)
> 
> Thanks for the review!
> 
> Eryu

This turns out to be broken when specifying "-m crc=0/1" in MKFS_OPTIONS
explicitly and test has its own extra "-m crc=0/1" option (e.g. xfs/001,
mkfs fails and test uses SCRATCH_DEV created from previous test), as we
have "-m" option specified multiple times, and _scratch_do_mkfs() won't
try mkfs for a second time because $extra_mkfs_options is empty, which
is because I didn't pass "extra_mkfs_options" as extra options but
"mkfs_cmd".

I wrote a v2 patch and will send it out soon.

Thanks,
Eryu
