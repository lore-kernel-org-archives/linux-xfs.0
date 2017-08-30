Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42518 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdH3BXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 21:23:34 -0400
Date: Tue, 29 Aug 2017 18:23:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170830012330.GG4757@magnolia>
References: <20170829235052.21050-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 09:50:10AM +1000, Dave Chinner wrote:
> Everyone who tries to modify mkfs quickly learns that it is a pile
> of spaghetti, the only difference in opinion is whether it is a
> steaming, cold or rotten pile. This patchset attempts to untangle
> the ball of pasta and turn it into a set of clear, obvious
> operations that lead to a filesystem being formatted correctly.
> 
> The patch series is really in three parts, splitting the code up
> into roughly three modules. The first part introduces a mkfs
> parameters structure and factors the on-disk formatting code to use
> only information in that structure. The second part introduces a
> command line input structure and factors the input parsing to use
> it. This requires a bunch of temporary code to keep the rest of
> the code working. The third part is factoring the input validation
> and geometry calculation code to use the input structure and put
> the output into the mkfs parameter structure and to remove all the
> temporary support code.
> 
> The result is three modules - input parsing, validation+calculations
> and formatting - with well defined data flow between them. This also
> paves the way to supporting config files to set defaults via a
> separate (new) module. The overall data flow now looks like this:
> 
> Build defaults --\
>                   ---> mkfs_default_params -> CLI -> mkfs_params
> config file -----/
> 
> It is not worth spending a lot of time reviewing the temporary code
> that is added - it gets removed before the end of the series. No
> attempt has been made to ensure that mkfs works 100% correctly after
> each patch is applied - the only guarantee is that it will build
> cleanly. It /should/ work if a bisect lands in the middle of the
> series, but trying to exhaustively test each patch is OK would take
> more effort than it is worth. As such, testing has only been
> performed on the whole series.
> 
> The new output from mkfs to indicate where it has sourced the
> defaults from causes xfstests to have conniptions. This requires
> some updates to the mkfs output filters that are already in place
> but it is a fairly trivial update. Test xfs/191 has a couple of new
> failures, but that is because the new code now correctly parses
> things like agsize so that block and sector size based
> specifications work with default mkfs values. This will require test
> updates.
> 
> Future work will be to split the xfs_mkfs.c file into a file per
> module (i.e. seperate files for CLI parsing, mkfs formating,
> validation+calculation and, finally, one for config file support),
> but otherwise the majority of the factoring work is now complete.
> 
> Comments, flames, etc all welcome.

A couple of questions right off the bat--

I've noticed that max_trans_res in mkfs.xfs constructs a fake xfs_mount
so that it can use libxfs_log_calc_minimum_size to calculate the minimum
log size.  We've had at least a couple of mkfs bug reports where mkfs
fails to model enough of the proposed filesystem to calculate the
correct transaction reservation sizes and therefore the minimum log
size.  I've not looked into all 42 patches, but is there a way to
eliminate the duplicate xfs_mount constructions (there's another one
around line 2690 in xfs_mkfs.c) because I keep screwing them up? :)

Second: is it possible to refactor the geometry printing code in mkfs
and xfs_info to use the same function?  They're awfully similar, but not
/quite/ the same.

(Ofc I can already see the objections -- "some script could be parsing
the output and will break!" <cough>xfstests<cough>...)

--D

> 
> -Dave.
> 
> Overall Diffstat:
>  include/libxfs.h |    2 
>  mkfs/xfs_mkfs.c  | 4615 ++++++++++++++++++++++++++++++-------------------------
>  2 files changed, 2578 insertions(+), 2039 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
