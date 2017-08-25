Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbdHYHyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 03:54:16 -0400
Date: Fri, 25 Aug 2017 00:54:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170825075415.GA748@infradead.org>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
 <20170811100147.GB7064@infradead.org>
 <20170811121132.bj5y77scrvkgy7uo@rh_laptop>
 <20170811125849.GA15300@infradead.org>
 <20170811134130.o46y5jpekrpj5qvw@rh_laptop>
 <20170824182057.amdirlrbugezrahy@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824182057.amdirlrbugezrahy@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Aug 24, 2017 at 02:20:57PM -0400, Theodore Ts'o wrote:
> The counter-argument is that system administrators do need to have a
> way to signal that they would like the file system to "do something
> different" on a per-file basis, and no one else has come up with
> another way of doing things.  Furthermore, it would be highly
> desirable if the system adminisator can provide this per-file system
> hint with requiring changes to the application.  (For example, by
> adding madvise/fadvise hints.)

We can always add some sort of inode or subtree advice.  It's just
the binary flag that encodes a specific implementation that is
very bad in the long run.

> Is that a fair summary of the argument?

Otherwise yet.

> I have two additional questions I'd like to ask at this point.
> 
> 1)  Has there been any other difficulty that XFS has had due to the
> fact that they have this DAX flag added?  e.g., are there any
> operational, or practical code maintainability issues at stake here?
> Or is this mostly an design philosophy debate?

It hasn't yet.  It will create really annoying problems once we
use raw DAX access for metadata, which I had prototype a while ago
and plan to finnally get in in the next months.

> 2) Are there any users using the DAX flag with XFS such that, if XFS
> were to remove the DAX flag support, those users would complain
> bitterly?

I don't know of anyone that actually uses the flag.  If someone did
that would probably run into problems like changing that changing it
on a file that's currently mmaped would crash an burn badly.
