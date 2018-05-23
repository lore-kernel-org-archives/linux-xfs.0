Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:41375 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753819AbeEWCBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 22:01:33 -0400
Date: Wed, 23 May 2018 10:01:29 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfs: pass extra params to _scratch_mkfs_xfs_opts in
 _scratch_mkfs_xfs
Message-ID: <20180523020129.GT29080@desktop.hz.ali.com>
References: <20180511030559.26502-1-guaneryu@gmail.com>
 <20180521223252.GQ23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521223252.GQ23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, May 22, 2018 at 08:32:52AM +1000, Dave Chinner wrote:
> On Fri, May 11, 2018 at 11:05:59AM +0800, Eryu Guan wrote:
> > One of _scratch_mkfs_xfs_opts()'s job is to remove any metadata
> > related mkfs options if mkfs.xfs binary doesn't support them, so
> > that tests that pass metadata mkfs options to _scratch_mkfs, e.g.
> > "_scratch_mkfs -m crc=0" won't break with old mkfs.xfs.
> > 
> > But commit 596a068bf130 ("fstests: teach _scratch_mkfs to handle
> > mkfs option conflicts") broke this, because it didn't pass any mkfs
> > options to _scratch_mkfs_xfs_opts(). So fix it.
> > 
> > Also declare a variable as 'local' and fix a typo.
> > 
> > Reported-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> 
> Looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> (sorry for missing this when you opsted it first time)

Thanks for the review!

Eryu
