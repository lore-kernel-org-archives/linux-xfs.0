Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51907 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbeEQXBv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 19:01:51 -0400
Date: Fri, 18 May 2018 01:01:50 +0200
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180517230150.GA28045@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-2-mfasheh@suse.de>
 <20180512024920.i7duhoi3lnkha4yl@angband.pl>
 <20180513181653.GD27915@wotan.suse.de>
 <20180513205025.3kolgcnbpy4grqtv@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180513205025.3kolgcnbpy4grqtv@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, May 13, 2018 at 10:50:25PM +0200, Adam Borowski wrote:
> On Sun, May 13, 2018 at 06:16:53PM +0000, Mark Fasheh wrote:
> > On Sat, May 12, 2018 at 04:49:20AM +0200, Adam Borowski wrote:
> > > On Fri, May 11, 2018 at 12:26:50PM -0700, Mark Fasheh wrote:
> > > > The permission check in vfs_dedupe_file_range() is too coarse - We
> > > > only allow dedupe of the destination file if the user is root, or
> > > > they have the file open for write.
> > > > 
> > > > This effectively limits a non-root user from deduping their own
> > > > read-only files. As file data during a dedupe does not change,
> > > > this is unexpected behavior and this has caused a number of issue
> > > > reports.
> [...]
> > > > So change the check so we allow dedupe on the target if:
> > > > 
> > > > - the root or admin is asking for it
> > > > - the owner of the file is asking for the dedupe
> > > > - the process has write access
> > > 
> > > I submitted a similar patch in May 2016, yet it has never been applied
> > > despite multiple pings, with no NAK.  My version allowed dedupe if:
> > > - the root or admin is asking for it
> > > - the file has w permission (on the inode -- ie, could have been opened rw)
> > 
> > Ahh, yes I see that now. I did wind up acking it too :)
> > > 
> > > I like this new version better than mine: "root or owner or w" is more
> > > Unixy than "could have been opened w".
> > 
> > I agree, IMHO the behavior in this patch is intuitive. What we had before
> > would surprise users.
> 
> Actually, there's one reason to still consider "could have been opened w":
> with it, deduplication programs can simply open the file r and not care
> about ETXTBSY at all.  Otherwise, every program needs to stat() and have
> logic to pick the proper argument to the open() call (r if owner/root,
> rw or w if not).

That makes sense. The goal after all is to be able to just open r and not
worry about it. I hadn't considered the other possibilities that
inode_permission() covers. I'll make that change for my next series.

Thanks,
  --Mark
