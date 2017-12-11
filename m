Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10670 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752066AbdLKXpp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Dec 2017 18:45:45 -0500
Date: Tue, 12 Dec 2017 10:38:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 72/73] xfs: Convert mru cache to XArray
Message-ID: <20171211233835.GV5858@dastard>
References: <fd7130d7-9066-524e-1053-a61eeb27cb36@lge.com>
 <Pine.LNX.4.44L0.1712081228430.1371-100000@iolanthe.rowland.org>
 <20171208223654.GP5858@dastard>
 <1512838818.26342.7.camel@perches.com>
 <20171211214300.GT5858@dastard>
 <1513030348.3036.5.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513030348.3036.5.camel@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Byungchul Park <byungchul.park@lge.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <willy@infradead.org>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com

On Mon, Dec 11, 2017 at 02:12:28PM -0800, Joe Perches wrote:
> On Tue, 2017-12-12 at 08:43 +1100, Dave Chinner wrote:
> > On Sat, Dec 09, 2017 at 09:00:18AM -0800, Joe Perches wrote:
> > > On Sat, 2017-12-09 at 09:36 +1100, Dave Chinner wrote:
> > > > 	1. Using lockdep_set_novalidate_class() for anything other
> > > > 	than device->mutex will throw checkpatch warnings. Nice. (*)
> > > []
> > > > (*) checkpatch.pl is considered mostly harmful round here, too,
> > > > but that's another rant....
> > > 
> > > How so?
> > 
> > Short story is that it barfs all over the slightly non-standard
> > coding style used in XFS.
> []
> > This sort of stuff is just lowest-common-denominator noise - great
> > for new code and/or inexperienced developers, but not for working
> > with large bodies of existing code with slightly non-standard
> > conventions.
> 
> Completely reasonable.  Thanks.
> 
> Do you get many checkpatch submitters for fs/xfs?

We used to. Not recently, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
