Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49001 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751720AbdJPPMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 11:12:43 -0400
Date: Mon, 16 Oct 2017 17:12:40 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/19 v3] dax, ext4, xfs: Synchronous page faults
Message-ID: <20171016151240.GH9762@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <CAPcyv4g6tjyUy_zxVVze+C+xZiT89qa1GiSoVjhH3G-6r3eXDA@mail.gmail.com>
 <20171011224331.GB3666@dastard>
 <20171013225304.GF29081@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013225304.GF29081@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri 13-10-17 16:53:04, Ross Zwisler wrote:
> On Thu, Oct 12, 2017 at 09:43:31AM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2017 at 02:18:06PM -0700, Dan Williams wrote:
> > > On Wed, Oct 11, 2017 at 1:05 PM, Jan Kara <jack@suse.cz> wrote:
> > > > Anyway, here are the patches and AFAICT the series is pretty much complete
> > > > so we can start thinking how to merge this. Changes to ext4 / XFS are pretty
> > > > minimal so either tree is fine I guess. Comments are welcome.
> > > 
> > > I'd like to propose taking this through the nvdimm tree. Some of these
> > > changes make the MAP_DIRECT support for ext4 easier, so I'd like to
> > > rebase that support on top and carry both.
> > 
> > This functionality needs to be exercised and stressed by fstests
> > in some way before it gets merged.
> 
> I can work on making an fstest for this set, unless someone else has already
> started.

I haven't started yet so feel free to have a look. Otherwise I'll try to
find some time later this week.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
