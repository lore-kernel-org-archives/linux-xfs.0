Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36093 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933035AbdHYXeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 19:34:01 -0400
Date: Sat, 26 Aug 2017 09:33:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170825233358.GC17782@dastard>
References: <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
 <20170824182057.amdirlrbugezrahy@thunk.org>
 <20170825075415.GA748@infradead.org>
 <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825154032.GA1827@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 08:40:32AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 25, 2017 at 11:14:45AM -0400, Theodore Ts'o wrote:
> > > I don't know of anyone that actually uses the flag.  If someone did
> > > that would probably run into problems like changing that changing it
> > > on a file that's currently mmaped would crash an burn badly.
> > 
> > Crash and burn meaning the *kernel* will crash and burn?  Or will data
> > be damaged?
> > 
> > Given that, maybe XFS should withdraw support for the DAX and hope no
> > one is actually using it?
> 
> Nah, -o dax works very well.  It's just the flag instead of the -o dax
> option or rather switching it on a mapped file will probably be very dangerous.

In what way is it dangerous, Christoph?

Changing to/form DAX is simply a case of syncing the data and then
invalidating the existing mappings and letting the new faults go
direct or through the page cache. The mapping invalidation
requirements are no different to what we need to do to punch a hole
in a mapped file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
