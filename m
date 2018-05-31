Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755628AbeEaQjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 12:39:54 -0400
Date: Thu, 31 May 2018 09:39:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: convert to SPDX license tags
Message-ID: <20180531163950.GA837@magnolia>
References: <20180531042621.11786-1-david@fromorbit.com>
 <20180531044145.GL10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531044145.GL10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 02:41:45PM +1000, Dave Chinner wrote:
> On Thu, May 31, 2018 at 02:26:21PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Remove the verbose license text from XFS files and replace them
> > with SPDX tags. This does not change the license of any of the code,
> > merely refers to the common, up-to-date license files in LICENSES/
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> This was mostly scripted. The awk script below did the majority
> of the work, but I manually modified fs/xfs/Makefile (different
> comment format) and fs/xfs/libxfs/xfs_fs.h (LGPL 2.1 license,
> not GPL 2.0).

Hmm... if nobody objects to spdx conversion I think I'll apply this on
fs/xfs/ at the tail end of xfs-4.18-merge.  Dave's patch I think doesn't
quite capture all the files added to -merge, but it's not hard to rerun
it now that we have the awk script.

Also, I think I'd like to record the awk script and other details in the
commit message.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Awk script:
> 
> $ cat hdr.awk
> BEGIN {
> 	print "// SPDX-License-Identifier: GPL-2.0"
> 	hdr = 1.0;
> }
> 
> /^ \* This program is free software/ {
> 	hdr = 2.0;
> 	next
> }
> 
> /^ \*\// {
> 	print $0
> 	hdr = 0.0
> 	next
> }
> 
> /^ \* / {
> 	if (hdr > 1.0)
> 		next
> 	print $0
> 	next
> }
> 
> /^ \*/ {
> 	if (hdr > 0.0)
> 		next
> 	print $0
> 	next
> }
> 
> // {
> 	print $0
> }
> 
> END { }
> $
> 
> 
> Script was run like so:
> 
> for f in `git grep -l "GNU General" fs/xfs/` ; do \
> 	echo $f ; \
> 	cat $f | awk -f hdr.awk > $f.new; \
> 	mv -f $f.new $f; \
> done
> 
> And then I fixed up the remaining files.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
