Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([54.37.238.230]:43838 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfBQRzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 12:55:11 -0500
Date: Sun, 17 Feb 2019 18:54:50 +0100
From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190217175450.psaesabv3vlzvjv4@angband.pl>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Boaz Harrosh <openosd@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Sun, Feb 17, 2019 at 06:35:25PM +0200, Boaz Harrosh wrote:
> On 15/02/19 00:06, Dave Chinner wrote:
> > So you're adding an interface that allows users to change the create
> > time of files without needing any privileges?

> > Inode create time is forensic metadata in XFS  - information we use
> > for sequence of event and inode lifetime analysis during examination
> > of broken filesystem images and systems that have been broken into.

> I think the difference in opinion here is that there are two totally
> different BTIme out in the world. For two somewhat opposite motivations
> and it seems they both try to be crammed into the same on disk space.
> 
> One - Author creation time
> Two - Local creation time

> So it looks like both sides are correct trying to preserve their own guy?

I'd say that [2] is too easily gameable to be worth the effort.  You can
just change it on the disk.  That right now it'd take some skill to find the
right place to edit doesn't matter -- a tool to update the btime against
your wishes would need to be written just once.  Unlike btrfs, XFS doesn't
even have a chain of checksums all the way to the root.

On the other hand, [1] has a lot of uses.  It can also be preserved in
backups and version control (svnt and git-restore-mtime could be easily
extended).

I'd thus go with [2] -- any uses for [1] are better delegated to filesystem
specific tools.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Have you accepted Khorne as your lord and saviour?
⠈⠳⣄⠀⠀⠀⠀
