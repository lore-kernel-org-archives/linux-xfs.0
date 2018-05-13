Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbeEMSQy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 May 2018 14:16:54 -0400
Date: Sun, 13 May 2018 18:16:53 +0000
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180513181653.GD27915@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-2-mfasheh@suse.de>
 <20180512024920.i7duhoi3lnkha4yl@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180512024920.i7duhoi3lnkha4yl@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Hey Adam,

On Sat, May 12, 2018 at 04:49:20AM +0200, Adam Borowski wrote:
> On Fri, May 11, 2018 at 12:26:50PM -0700, Mark Fasheh wrote:
> > The permission check in vfs_dedupe_file_range() is too coarse - We
> > only allow dedupe of the destination file if the user is root, or
> > they have the file open for write.
> > 
> > This effectively limits a non-root user from deduping their own
> > read-only files. As file data during a dedupe does not change,
> > this is unexpected behavior and this has caused a number of issue
> > reports. For an example, see:
> > 
> > https://github.com/markfasheh/duperemove/issues/129
> > 
> > So change the check so we allow dedupe on the target if:
> > 
> > - the root or admin is asking for it
> > - the owner of the file is asking for the dedupe
> > - the process has write access
> 
> I submitted a similar patch in May 2016, yet it has never been applied
> despite multiple pings, with no NAK.  My version allowed dedupe if:
> - the root or admin is asking for it
> - the file has w permission (on the inode -- ie, could have been opened rw)

Ahh, yes I see that now. I did wind up acking it too :)

> There was a request to include in xfstests a test case for the ETXTBSY race
> this patch fixes, but there's no reasonable way to make such a test case:
> the race condition is not a bug, it's write-xor-exec working as designed.
> 
> Another idea discussed was about possibly just allowing everyone who can
> open the file to deduplicate it, as the file contents are not modified in
> any way.  Zygo Blaxell expressed a concern that it could be used by an
> unprivileged user who can trigger a crash to abuse writeout bugs.
> 
> I like this new version better than mine: "root or owner or w" is more
> Unixy than "could have been opened w".

I agree, IMHO the behavior in this patch is intuitive. What we had before
would surprise users.

Yeah we've been careful about not letting a user dedupe some other users
file. Data-wise it technically might be ok but I can imagine several
scenarios where you might not want some other user deduping your files.

Thanks for the review,
	--Mark
