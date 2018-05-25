Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:65454 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965570AbeEYPma (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 May 2018 11:42:30 -0400
Date: Fri, 25 May 2018 09:42:29 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180525154229.GA11044@linux.intel.com>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
 <20180525025518.11405-2-ross.zwisler@linux.intel.com>
 <20180525050218.GF4507@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525050218.GF4507@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs <linux-xfs@vger.kernel.org>

On Thu, May 24, 2018 at 10:02:18PM -0700, Darrick J. Wong wrote:
> On Thu, May 24, 2018 at 08:55:12PM -0600, Ross Zwisler wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > Remove __bdev_dax_supported and change to bdev_dax_supported that takes a
> > bdev parameter.  This enables multi-device filesystems like xfs to check
> > that a dax device can work for the particular filesystem.  Once that's
> > in place, actually fix all the parts of XFS where we need to be able to
> > distinguish between datadev and rtdev.
> > 
> > This patch fixes the problem where we screw up the dax support checking
> > in xfs if the datadev and rtdev have different dax capabilities.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Reviewed-by: Darr...oh, I'm not allowed to do that, am I?
> 
> Would you mind (re)sending this to the xfs list so that someone else can
> review it?
> 
> --D

Thanks for the review, Darrick.

I think at one point Dave said that if you touch more than 1 filesystem with a
series you should just CC linux-fsdevel and omit the individual filesystems?
I realize that this series only touches ext2 and ext4 a little, but that's
what I opted for.

Is that sufficient to get to the rest of the XFS developers, or would you like
a resend adding linux-xfs?
