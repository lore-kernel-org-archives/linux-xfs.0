Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbeIDOJ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Sep 2018 10:09:26 -0400
Date: Tue, 4 Sep 2018 10:45:05 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180904094505.GW27120@redhat.com>
References: <20180903224919.GA16358@redhat.com>
 <20180904004940.GR5631@dastard>
 <20180904082600.GB16358@redhat.com>
 <20180904091112.GT5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904091112.GT5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 04, 2018 at 07:11:12PM +1000, Dave Chinner wrote:
> On Tue, Sep 04, 2018 at 09:26:00AM +0100, Richard W.M. Jones wrote:
> > Yes I think I was far too hasty declaring this a problem with mkfs.xfs
> > last night.  It turns out that NBD on the wire can only describe a few
> > different errors and maps any other error to -EINVAL, which is likely
> 
> Urk. It should map them to -EIO, because then we know it's come from
> the IO layer and isn't a problem related to userspace passing the
> kernel invalid parameters.

Actually EIO is one of the errors that NBD does understand :-)

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
