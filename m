Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbfBVPBL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 10:01:11 -0500
Date: Fri, 22 Feb 2019 16:02:27 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190222150227.GF9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> Since statx was added in 4.11, userspace has had an interface for
> reading btime (file creation time), but no way to set it. This RFC patch
> series adds support for changing btime with utimensat(). Patch 1 adds
> the VFS infrastructure, patch 2 adds the support to utimensat() with a
> new flag, and the rest of the patches add filesystem support; I excluded
> CIFS for now because I don't have a CIFS setup to test it on.
> 
> Updating btime is useful for at least a couple of use cases:
> 
> - Backup/restore programs (my motivation for this feature is btrfs send)
> - File servers which interoperate with operating systems that allow
>   updating file creation time, including Mac OS [1] and Windows [2]

I don't have anything new to add to what has been said in the thread.
The creation time is property of the filesystem and if user wants to
track additional metadata, then as external attributes.
