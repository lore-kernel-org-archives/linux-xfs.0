Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:38758 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbeC1BUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 21:20:43 -0400
Date: Wed, 28 Mar 2018 09:20:35 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3] xfs: test agfl reset on bad list wrapping
Message-ID: <20180328012035.GD30836@localhost.localdomain>
References: <20180321165716.GB4818@magnolia>
 <20180323052540.GZ30836@localhost.localdomain>
 <20180323160817.GJ4818@magnolia>
 <20180326012253.GC30836@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326012253.GC30836@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, fstests <fstests@vger.kernel.org>

On Mon, Mar 26, 2018 at 09:22:53AM +0800, Eryu Guan wrote:
> On Fri, Mar 23, 2018 at 09:08:17AM -0700, Darrick J. Wong wrote:
> > > > +
> > > > +	# Format filesystem
> > > > +	echo "TEST $cmd" | tee /dev/ttyprintk
> > > 
> > > What's the purpose of writing to /dev/ttyprintk? I don't see how it's
> > > used in the test.
> > 
> > It makes it easy to tell which kernel messages came from which runtest()
> > invocation so that we can tell if a particular agfl mutation test
> > actually triggered the fixup.
> 
> This could fail the test if /dev/ttyprintk doesn't exist. It seems

Correction, it doesn't fail the test, but creates a new /dev/ttyprintk
file.. but still, I think this should be addressed.

Rather than that, the test runs good for me, it fails with 4.16-rc7
kernel and passes with the mentioned patch applied.

Brian, would you please help review the new version of this patch in
patchset "[PATCH 0/4] misc. fstests changes" (patch 3/4) as well? I
really like a Reviewed-by tag from someone who knows all the details of
the test and the fix :) Thanks a lot!

Eryu

> writing to /dev/kmsg works could tell us the same information, and we've
> already made sure /dev/kmsg is writable by _require_check_dmesg. IMHO
> /dev/kmsg might be a better choice here.
> 
> Thanks,
> Eryu
