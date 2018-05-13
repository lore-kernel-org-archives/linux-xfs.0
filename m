Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34040 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbeEMUu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 May 2018 16:50:29 -0400
Date: Sun, 13 May 2018 22:50:25 +0200
From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180513205025.3kolgcnbpy4grqtv@angband.pl>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-2-mfasheh@suse.de>
 <20180512024920.i7duhoi3lnkha4yl@angband.pl>
 <20180513181653.GD27915@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180513181653.GD27915@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, May 13, 2018 at 06:16:53PM +0000, Mark Fasheh wrote:
> On Sat, May 12, 2018 at 04:49:20AM +0200, Adam Borowski wrote:
> > On Fri, May 11, 2018 at 12:26:50PM -0700, Mark Fasheh wrote:
> > > The permission check in vfs_dedupe_file_range() is too coarse - We
> > > only allow dedupe of the destination file if the user is root, or
> > > they have the file open for write.
> > > 
> > > This effectively limits a non-root user from deduping their own
> > > read-only files. As file data during a dedupe does not change,
> > > this is unexpected behavior and this has caused a number of issue
> > > reports.
[...]
> > > So change the check so we allow dedupe on the target if:
> > > 
> > > - the root or admin is asking for it
> > > - the owner of the file is asking for the dedupe
> > > - the process has write access
> > 
> > I submitted a similar patch in May 2016, yet it has never been applied
> > despite multiple pings, with no NAK.  My version allowed dedupe if:
> > - the root or admin is asking for it
> > - the file has w permission (on the inode -- ie, could have been opened rw)
> 
> Ahh, yes I see that now. I did wind up acking it too :)
> > 
> > I like this new version better than mine: "root or owner or w" is more
> > Unixy than "could have been opened w".
> 
> I agree, IMHO the behavior in this patch is intuitive. What we had before
> would surprise users.

Actually, there's one reason to still consider "could have been opened w":
with it, deduplication programs can simply open the file r and not care
about ETXTBSY at all.  Otherwise, every program needs to stat() and have
logic to pick the proper argument to the open() call (r if owner/root,
rw or w if not).

I also have a sister patch: btrfs_ioctl_defrag wants the same change, for
the very same reason.  But, let's discuss dedupe first to avoid unnecessary
round trips.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 
⢿⡄⠘⠷⠚⠋⠀ Certified airhead; got the CT scan to prove that!
⠈⠳⣄⠀⠀⠀⠀ 
