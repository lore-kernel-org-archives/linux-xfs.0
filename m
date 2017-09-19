Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58876 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751697AbdISO5g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 10:57:36 -0400
Date: Tue, 19 Sep 2017 10:55:20 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Message-ID: <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 03:55:40PM -0600, Andreas Dilger wrote:
> > And like hch said, why not {f,}pathconf?
> 
> The problem with pathconf() is that this is just made up by GlibC, and
> doesn't actually communicate with the kernel or the filesystem at all.
> For example, _PC_LINK_MAX does not return different values for ext2/ext4
> filesystems based on feature flags, only what is hard-coded into GlibC
> based on the filesystem magic.  This is not going to work as a per-file
> source of information.
> 
> For example, even though EXT4_LINK_MAX has been 65000 for many years,
> GlibC reports 32000 for an ext4 filesystem since it only uses the magic:

Maybe the right answer is we should define a new pathconfat(2) system
call which can be used as part of a C library's implementation of
pathconf() and fpathconf()?  glibc probably won't use it for years, of
course.  But we can at least provide the information via an interface
which we can control, and which is capable of returning correct
results?

						- Ted
