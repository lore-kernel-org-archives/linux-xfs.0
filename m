Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753164AbeGCWWs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 18:22:48 -0400
Date: Tue, 3 Jul 2018 15:22:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: fuzz every field of every structure and test
 kernel crashes
Message-ID: <20180703222243.GE5724@magnolia>
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
 <152960597579.26479.1694478608504574104.stgit@magnolia>
 <20180628031027.GR2780@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628031027.GR2780@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 28, 2018 at 11:10:27AM +0800, Eryu Guan wrote:
> On Thu, Jun 21, 2018 at 11:32:55AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fuzz every field of every structure and then try to write the
> > filesystem, to see how many of these writes can crash the kernel.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Almost all the tests here are failing in similar ways with v4.18-rc1
> kernel and latest xfsprogs from for-next branch, e.g. xfs/1423 fails as
> 
>     +re-repair failed (1) with diskdq.magic = zeroes.
>     +re-repair failed (1) with diskdq.magic = ones.
>     +re-repair failed (1) with diskdq.magic = firstbit.
>     +re-repair failed (1) with diskdq.magic = middlebit.
> 
> Seems like we should skip re-repair in the "none" repair mode too in
> __scratch_xfs_fuzz_field_test?

Makes sense, will fix & resubmit.

--D

> 
> Thanks,
> Eryu
