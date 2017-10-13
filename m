Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:1305 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751339AbdJMWxG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 18:53:06 -0400
Date: Fri, 13 Oct 2017 16:53:04 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/19 v3] dax, ext4, xfs: Synchronous page faults
Message-ID: <20171013225304.GF29081@linux.intel.com>
References: <20171011200603.27442-1-jack@suse.cz>
 <CAPcyv4g6tjyUy_zxVVze+C+xZiT89qa1GiSoVjhH3G-6r3eXDA@mail.gmail.com>
 <20171011224331.GB3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011224331.GB3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Oct 12, 2017 at 09:43:31AM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 02:18:06PM -0700, Dan Williams wrote:
> > On Wed, Oct 11, 2017 at 1:05 PM, Jan Kara <jack@suse.cz> wrote:
> > > Anyway, here are the patches and AFAICT the series is pretty much complete
> > > so we can start thinking how to merge this. Changes to ext4 / XFS are pretty
> > > minimal so either tree is fine I guess. Comments are welcome.
> > 
> > I'd like to propose taking this through the nvdimm tree. Some of these
> > changes make the MAP_DIRECT support for ext4 easier, so I'd like to
> > rebase that support on top and carry both.
> 
> This functionality needs to be exercised and stressed by fstests
> in some way before it gets merged.

I can work on making an fstest for this set, unless someone else has already
started.
