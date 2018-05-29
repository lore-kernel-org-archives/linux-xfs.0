Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:62286 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967368AbeE2WBP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 18:01:15 -0400
Date: Tue, 29 May 2018 16:01:14 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180529220114.GA13948@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529212510.GJ30110@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Dave Jiang <dave.jiang@intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> > From: Dave Jiang <dave.jiang@intel.com>
> > 
> > The function return values are confusing with the way the function is
> > named. We expect a true or false return value but it actually returns
> > 0/-errno.  This makes the code very confusing. Changing the return values
> > to return a bool where if DAX is supported then return true and no DAX
> > support returns false.
> > 
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Looks ok, do you want me to pull the first two patches through the xfs
> tree?
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for the review.

I'm not sure what's best.  If you do that then Mike will need to have a DM
branch for the rest of the series based on your stable commits, yea?

Mike what would you prefer?
