Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38947 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbeGFGI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 02:08:26 -0400
Date: Fri, 6 Jul 2018 14:08:20 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] xfs: fuzz every field of every structure and test
 kernel crashes
Message-ID: <20180706060820.GE2780@desktop>
References: <153067982461.28315.11621030236927888645.stgit@magnolia>
 <153067983717.28315.16483133462251633709.stgit@magnolia>
 <20180706043109.GC2780@desktop>
 <20180706050805.GT32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180706050805.GT32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jul 05, 2018 at 10:08:05PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 06, 2018 at 12:31:09PM +0800, Eryu Guan wrote:
> > On Tue, Jul 03, 2018 at 09:50:37PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Fuzz every field of every structure and then try to write the
> > > filesystem, to see how many of these writes can crash the kernel.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The "re-repair" failures are gone, but I still see some test failures
> > like (xfs/1398 for example)
> > 
> > +re-mount failed (32) with magic = zeroes.
> > +re-mount failed (32) with magic = ones.
> > ...
> > 
> > Looks like the re-mount is expected to fail as we skipped all the repair work.
> 
> Yeah, these tests are going to throw a /lot/ of errors as we try to see
> if we can get the kernel to blow up on deliberately garbage filesystems.
> They're not expected to pass ever, except in the sense that the kernel
> doesn't just crash. :)
> 
> > Also, there're _check_dmesg failures too (they were buried among other
> > failures so I didn't notice them in last review), like this "Internal
> > error" from xfs/1397
> 
> But yeah, I will add _check_dmesg to all of the tests before the next
> submission (unless you commit it before then).

I'll wait for re-submission :)

Thanks,
Eryu
