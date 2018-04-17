Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:21512 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751206AbeDQG7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 02:59:45 -0400
Date: Tue, 17 Apr 2018 16:59:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump: too many -f arguments: maximum is 1 when running in
 miniroot
Message-ID: <20180417065943.GJ23861@dastard>
References: <1523934525.20129.96.camel@uvic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1523934525.20129.96.camel@uvic.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ryan Taylor <rptaylor@uvic.ca>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Apr 17, 2018 at 03:08:45AM +0000, Ryan Taylor wrote:
> 
> Hello,
> 
> I have a CentOS6 system with kernel 2.6.32-696.23.1.el6.x86_64 and xfsdump-3.0.4-4.el6_6.1.x86_64
> (the latest available versions).
> 
> When I try to xfsdump I get this error:
> 
> $ sudo xfsdump -d 2000 -l 0 -p 30 -L Dump -f /mnt/data2/l0/file0 -f /mnt/data2/l0/file1 /mnt/data1
> xfsdump: too many -f arguments: maximum is 1 when running in miniroot

Your xfsdump binary is so old it doesn't support multiple dump files
(or streams, as xfsdump calls them). That was introduced in v3.1.0,
IIRC, via commit:

commit 7ffdf9d1fbd65eb38171b8772ed4c31315cbbef6
Author: Bill Kendall <wkendall@sgi.com>
Date:   Mon Nov 7 14:58:31 2011 -0600

    xfsdump: enable multiple streams
    
    IRIX contained an environment referred to as "miniroot" where
    sproc threads were either not available, or at least not used
    in xfsdump. Throughout xfsdump there's a "miniroot" variable
    which indicates whether or not thread support is enabled. On
    Linux this variable has always been false in order to disable
    support for multiple streams.
    
    Now that the threading infracstructure has been converted over
    to pthreads, this patch removes the "miniroot" variable and
    enables the option of using multiple streams.
    
    Note that another feature in xfsdump, using a ring buffer for
    I/O to tapes, also depends on thread support. I'm leaving that
    disabled for now until more testing has been done.
    
    Reviewed-by: Alex Elder <aelder@sgi.com>
    Signed-off-by: Bill Kendall <wkendall@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

> (I need to produce multiple dump files in order to migrate some data under space constraints.
> I was planning to produce the dump files on an ext4 filesystem (since you can shrink that), and
> restore 1 dump file at a time. After restoring each dump file, I can delete it, shrink the ext4
> filesystem to reclaim space, and expand the destination XFS filesystem.)

I don't think multiple dump streams does what you want.

When you create multiple dump files with a current xfsdump, you also
need to supply xfsrestore with all those dump files, too, otherwise
the dump inventory cannot be validated. IOWs, I don't think you can
just restore a single dump file from a multi-stream dump as data
being restored may be spread across multiple dump files...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
