Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45388 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731342AbfBOFjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 00:39:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id y4so4248615pgc.12
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 21:39:52 -0800 (PST)
Date: Thu, 14 Feb 2019 21:39:50 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190215053950.GF9819@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <1190dcc0-7054-72b4-2a88-33d0b97e332c@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190dcc0-7054-72b4-2a88-33d0b97e332c@mendix.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "kernel-team@fb.com" <kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Feb 15, 2019 at 01:57:39AM +0000, Hans van Kranenburg wrote:
> Hi,
> 
> On 2/14/19 11:00 AM, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Since statx was added in 4.11, userspace has had an interface for
> > reading btime (file creation time), but no way to set it. This RFC patch
> > series adds support for changing btime with utimensat(). Patch 1 adds
> > the VFS infrastructure, patch 2 adds the support to utimensat() with a
> > new flag, and the rest of the patches add filesystem support; I excluded
> > CIFS for now because I don't have a CIFS setup to test it on.
> > 
> > Updating btime is useful for at least a couple of use cases:
> > 
> > - Backup/restore programs (my motivation for this feature is btrfs send)
> 
> Can you give an example of such usefulness? What's the thing you run
> into that you can't do without having this?

That boils down to what's useful about having the file creation time,
and it's really just another tidbit of information which you may or may
not care about. Maybe you have a document that you've been editing for
awhile, and you want to know when you started working on it. Or, you
want to know when a user created some directory that they keep adding
files to.

If the file creation time is useful to you, then you likely want it
preserved if you have to restore from backups. If I had to restore from
backups yesterday and I'm trying to figure out when I started that
document, I don't care that I restored that file yesterday, I want the
real creation date.

If you've never wondered when a file was created, then I'm sure you
won't care whether btrfs send/receive preserves it :)
