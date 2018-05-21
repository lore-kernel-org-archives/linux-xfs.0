Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59009 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751559AbeEUWd1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 18:33:27 -0400
Date: Tue, 22 May 2018 08:32:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: pass extra params to _scratch_mkfs_xfs_opts in
 _scratch_mkfs_xfs
Message-ID: <20180521223252.GQ23861@dastard>
References: <20180511030559.26502-1-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511030559.26502-1-guaneryu@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 11:05:59AM +0800, Eryu Guan wrote:
> One of _scratch_mkfs_xfs_opts()'s job is to remove any metadata
> related mkfs options if mkfs.xfs binary doesn't support them, so
> that tests that pass metadata mkfs options to _scratch_mkfs, e.g.
> "_scratch_mkfs -m crc=0" won't break with old mkfs.xfs.
> 
> But commit 596a068bf130 ("fstests: teach _scratch_mkfs to handle
> mkfs option conflicts") broke this, because it didn't pass any mkfs
> options to _scratch_mkfs_xfs_opts(). So fix it.
> 
> Also declare a variable as 'local' and fix a typo.
> 
> Reported-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

(sorry for missing this when you opsted it first time)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
