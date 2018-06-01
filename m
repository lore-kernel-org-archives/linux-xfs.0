Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:35417 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750715AbeFABjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 21:39:16 -0400
Date: Fri, 1 Jun 2018 11:26:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180601012657.GQ10363@dastard>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531191332.GB7825@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Dave Jiang <dave.jiang@intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 12:13:32PM -0700, Darrick J. Wong wrote:
> On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
> > On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> > > > From: Dave Jiang <dave.jiang@intel.com>
> > > > 
> > > > The function return values are confusing with the way the function is
> > > > named. We expect a true or false return value but it actually returns
> > > > 0/-errno.  This makes the code very confusing. Changing the return values
> > > > to return a bool where if DAX is supported then return true and no DAX
> > > > support returns false.
> > > > 
> > > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > 
> > > Looks ok, do you want me to pull the first two patches through the xfs
> > > tree?
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Thanks for the review.
> > 
> > I'm not sure what's best.  If you do that then Mike will need to have a DM
> > branch for the rest of the series based on your stable commits, yea?
> > 
> > Mike what would you prefer?
> 
> I /was/ about to say that I would pull in the first two patches, but now
> I can't get xfs to mount with pmem at all, and have no way of testing
> this...?

I have similar problems, too, but:

$ ndctl list
[
  {
    "dev":"namespace1.0",
    "mode":"raw",
    "size":8589934592,
    "sector_size":512,
    "blockdev":"pmem1"
  },
  {
    "dev":"namespace0.0",
    "mode":"raw",
    "size":8589934592,
    "sector_size":512,
    "blockdev":"pmem0"
  }
]
$ sudo ndctl create-namespace -f -e namespace0.0 --mode=fsdax
  Error: operation failed, region0 fsdax mode not available

failed to reconfigure namespace: Invalid argument
$

I can't make head or tail of what is going wrong here - how am I
supposed to debug this and get it working again?

FWIW, XFS+DAX used to just work on this setup (I hadn't even
installed ndctl until this morning!) but after changing the kernel
it no longer works. That would make it a regression, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
