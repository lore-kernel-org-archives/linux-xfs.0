Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750990AbdISPdp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:33:45 -0400
Date: Tue, 19 Sep 2017 17:33:41 +0200
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Message-ID: <20170919153341.rghkmn2lyh5uyfr5@rh_laptop>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918204838.GW6540@magnolia>
 <7B6B7C4C-7FEB-401F-B4EE-6E11E95FB246@dilger.ca>
 <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919145520.c4y4w32lmsnqhhxp@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 10:55:20AM -0400, Theodore Ts'o wrote:
> On Mon, Sep 18, 2017 at 03:55:40PM -0600, Andreas Dilger wrote:
> > > And like hch said, why not {f,}pathconf?
> > 
> > The problem with pathconf() is that this is just made up by GlibC, and
> > doesn't actually communicate with the kernel or the filesystem at all.
> > For example, _PC_LINK_MAX does not return different values for ext2/ext4
> > filesystems based on feature flags, only what is hard-coded into GlibC
> > based on the filesystem magic.  This is not going to work as a per-file
> > source of information.
> > 
> > For example, even though EXT4_LINK_MAX has been 65000 for many years,
> > GlibC reports 32000 for an ext4 filesystem since it only uses the magic:
> 
> Maybe the right answer is we should define a new pathconfat(2) system
> call which can be used as part of a C library's implementation of
> pathconf() and fpathconf()?  glibc probably won't use it for years, of
> course.  But we can at least provide the information via an interface
> which we can control, and which is capable of returning correct
> results?
> 
> 						- Ted

Right, *I think* this is what Christoph suggested in his recent reply.
It sounds fair enough to me and this is much more usefull beyond just
fallocate, so I can look into it.

-Lukas

