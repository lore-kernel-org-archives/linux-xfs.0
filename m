Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54528 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933536AbdHYPOw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 11:14:52 -0400
Date: Fri, 25 Aug 2017 11:14:45 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170825151445.ycf5xomoxvebgaez@thunk.org>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
 <20170824182057.amdirlrbugezrahy@thunk.org>
 <20170825075415.GA748@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825075415.GA748@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 12:54:15AM -0700, Christoph Hellwig wrote:
> > 1)  Has there been any other difficulty that XFS has had due to the
> > fact that they have this DAX flag added?  e.g., are there any
> > operational, or practical code maintainability issues at stake here?
> > Or is this mostly an design philosophy debate?
> 
> It hasn't yet.  It will create really annoying problems once we
> use raw DAX access for metadata, which I had prototype a while ago
> and plan to finnally get in in the next months.
> 
> > 2) Are there any users using the DAX flag with XFS such that, if XFS
> > were to remove the DAX flag support, those users would complain
> > bitterly?
> 
> I don't know of anyone that actually uses the flag.  If someone did
> that would probably run into problems like changing that changing it
> on a file that's currently mmaped would crash an burn badly.

Crash and burn meaning the *kernel* will crash and burn?  Or will data
be damaged?

Given that, maybe XFS should withdraw support for the DAX and hope no
one is actually using it?

					- Ted



