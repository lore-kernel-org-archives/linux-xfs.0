Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15602 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753899AbeEaFE3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 01:04:29 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fOFPF-0002yq-4C
        for linux-xfs@vger.kernel.org; Thu, 31 May 2018 14:41:45 +1000
Date: Thu, 31 May 2018 14:41:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: convert to SPDX license tags
Message-ID: <20180531044145.GL10363@dastard>
References: <20180531042621.11786-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531042621.11786-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 02:26:21PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Remove the verbose license text from XFS files and replace them
> with SPDX tags. This does not change the license of any of the code,
> merely refers to the common, up-to-date license files in LICENSES/
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

This was mostly scripted. The awk script below did the majority
of the work, but I manually modified fs/xfs/Makefile (different
comment format) and fs/xfs/libxfs/xfs_fs.h (LGPL 2.1 license,
not GPL 2.0).

Awk script:

$ cat hdr.awk
BEGIN {
	print "// SPDX-License-Identifier: GPL-2.0"
	hdr = 1.0;
}

/^ \* This program is free software/ {
	hdr = 2.0;
	next
}

/^ \*\// {
	print $0
	hdr = 0.0
	next
}

/^ \* / {
	if (hdr > 1.0)
		next
	print $0
	next
}

/^ \*/ {
	if (hdr > 0.0)
		next
	print $0
	next
}

// {
	print $0
}

END { }
$


Script was run like so:

for f in `git grep -l "GNU General" fs/xfs/` ; do \
	echo $f ; \
	cat $f | awk -f hdr.awk > $f.new; \
	mv -f $f.new $f; \
done

And then I fixed up the remaining files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
