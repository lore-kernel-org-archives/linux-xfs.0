Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f41.google.com ([209.85.160.41]:37484 "EHLO
        mail-pl0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeCZBXA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Mar 2018 21:23:00 -0400
Date: Mon, 26 Mar 2018 09:22:53 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3] xfs: test agfl reset on bad list wrapping
Message-ID: <20180326012253.GC30836@localhost.localdomain>
References: <20180321165716.GB4818@magnolia>
 <20180323052540.GZ30836@localhost.localdomain>
 <20180323160817.GJ4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323160817.GJ4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, fstests <fstests@vger.kernel.org>

On Fri, Mar 23, 2018 at 09:08:17AM -0700, Darrick J. Wong wrote:
> > > +
> > > +	# Format filesystem
> > > +	echo "TEST $cmd" | tee /dev/ttyprintk
> > 
> > What's the purpose of writing to /dev/ttyprintk? I don't see how it's
> > used in the test.
> 
> It makes it easy to tell which kernel messages came from which runtest()
> invocation so that we can tell if a particular agfl mutation test
> actually triggered the fixup.

This could fail the test if /dev/ttyprintk doesn't exist. It seems
writing to /dev/kmsg works could tell us the same information, and we've
already made sure /dev/kmsg is writable by _require_check_dmesg. IMHO
/dev/kmsg might be a better choice here.

Thanks,
Eryu
