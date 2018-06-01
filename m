Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53818 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeFAU7w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 16:59:52 -0400
Date: Fri, 1 Jun 2018 14:59:50 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [dm-devel] [PATCH v2 2/7] dax: change bdev_dax_supported() to
 support boolean returns
Message-ID: <20180601205950.GA12821@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia>
 <20180531205206.GA12681@redhat.com>
 <20180531222645.GA6086@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531222645.GA6086@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Toshi Kani <toshi.kani@hpe.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Thu, May 31, 2018 at 03:26:45PM -0700, Darrick J. Wong wrote:
> On Thu, May 31, 2018 at 04:52:06PM -0400, Mike Snitzer wrote:
> > On Thu, May 31 2018 at  3:13pm -0400,
> > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > > On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
> > > > On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> > > > > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> > > > > > From: Dave Jiang <dave.jiang@intel.com>
> > > > > > 
> > > > > > The function return values are confusing with the way the function is
> > > > > > named. We expect a true or false return value but it actually returns
> > > > > > 0/-errno.  This makes the code very confusing. Changing the return values
> > > > > > to return a bool where if DAX is supported then return true and no DAX
> > > > > > support returns false.
> > > > > > 
> > > > > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > > > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > > 
> > > > > Looks ok, do you want me to pull the first two patches through the xfs
> > > > > tree?
> > > > > 
> > > > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Thanks for the review.
> > > > 
> > > > I'm not sure what's best.  If you do that then Mike will need to have a DM
> > > > branch for the rest of the series based on your stable commits, yea?
> > > > 
> > > > Mike what would you prefer?
> > > 
> > > I /was/ about to say that I would pull in the first two patches, but now
> > > I can't get xfs to mount with pmem at all, and have no way of testing
> > > this...?
> > 
> > Once you get this sorted out, please feel free to pull in the first 2.
> 
> Sorted.  It'll be in Friday's for-next.  Ross helped me bang on the pmem
> devices w/ ndctl to enable fsdax mode and twist qemu until everything
> worked properly. ;)

For anyone else who would like to simulate persistent memory using QEMU, I've
added some hints here:

https://nvdimm.wiki.kernel.org/pmem_in_qemu
