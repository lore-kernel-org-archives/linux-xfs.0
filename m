Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10388 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750778AbdDAXFb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 19:05:31 -0400
Date: Sun, 2 Apr 2017 09:05:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170401230526.GW23007@dastard>
References: <20170321134500.GA1318@infradead.org>
 <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com>
 <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170330161231.GA9824@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Mar 30, 2017 at 12:12:31PM -0400, J. Bruce Fields wrote:
> On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
> > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
> > > Because if above is acceptable we could make reported i_version to be a sum
> > > of "superblock crash counter" and "inode i_version". We increment
> > > "superblock crash counter" whenever we detect unclean filesystem shutdown.
> > > That way after a crash we are guaranteed each inode will report new
> > > i_version (the sum would probably have to look like "superblock crash
> > > counter" * 65536 + "inode i_version" so that we avoid reusing possible
> > > i_version numbers we gave away but did not write to disk but still...).
> > > Thoughts?
> 
> How hard is this for filesystems to support?  Do they need an on-disk
> format change to keep track of the crash counter?

Yes. We'll need version counter in the superblock, and we'll need to
know what the increment semantics are. 

The big question is how do we know there was a crash? The only thing
a journalling filesystem knows at mount time is whether it is clean
or requires recovery. Filesystems can require recovery for many
reasons that don't involve a crash (e.g. root fs is never unmounted
cleanly, so always requires recovery). Further, some filesystems may
not even know there was a crash at mount time because their
architecture always leaves a consistent filesystem on disk (e.g. COW
filesystems)....

> I wonder if repeated crashes can lead to any odd corner cases.

WIthout defined, locked down behavour of the superblock counter, the
almost certainly corner cases will exist...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
