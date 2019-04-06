Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49749 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726184AbfDGCN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Apr 2019 22:13:57 -0400
Date: Sat, 6 Apr 2019 19:27:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190406232717.GH18897@mit.edu>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402045519.GK1173@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
> 
> When Ted is done laughing, I really would like to consider something
> like this to solve the problem of grub-style bootloaders requiring a
> lease on the blocks underneath a file with a term exceeding that of the
> running kernel.
> 
> We can probably skip the harsh synchronous writes in favor of fsync on
> close, but we would need to keep the critical component of checkpointing
> the journal on fsync and syncfs.

At least for ext4, we don't need to add anything new, since FIFREEZE
force a journal checkpoint.  So we could try to get a patch into grub
which causes update_grub to open each kernel that it finds, and calls
fsync(2) on it, and then for all file systems where it finds a kernel,
it can call FIFREEZE and FITHAW on it, and that would be that.

That's not guaranteed to work for all file systems, of course.  So the
right answer may be to define a new IOCTL which causes all file system
to do whatever log truncation is needed so that grub will do the right
thing.

					- Ted
