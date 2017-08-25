Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54864 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934326AbdHYQ2l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 12:28:41 -0400
Date: Fri, 25 Aug 2017 12:28:37 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170825162837.urica6l4eamu356w@thunk.org>
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
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

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

Sorry, I was suggested XFS withdrawing support for the pre-file dax
flag.  I thought part of the argument for why ext4 should accept this
patch is that XFS already has the per-file DAX flag?

      	      	  	      	  	   - Ted
