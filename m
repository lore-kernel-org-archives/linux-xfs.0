Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33595 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755065AbdGXRiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 13:38:19 -0400
Date: Mon, 24 Jul 2017 10:38:15 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2 00/15] xfstests: remove IRIX support
Message-ID: <20170724173815.GB143373@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
 <20170724044308.GB9167@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724044308.GB9167@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 12:43:08PM +0800, Eryu Guan wrote:
> On Thu, Jul 20, 2017 at 09:38:38PM -0700, Eric Biggers wrote:
> > Hello,
> > 
> > This is v2 of the patchset to remove IRIX support from xfstests.  For
> > some time xfstests has de facto not supported IRIX anymore.  The final
> > release of IRIX was over 10 years ago and it seems no one has been
> > running the latest xfstests releases on any IRIX system, as at the very
> > least xfstests now assumes the existence of some util-linux binaries.
> > There are very likely other examples of this bitrot as well.  Also,
> > xfsprogs has already dropped IRIX support.
> > 
> > Therefore, this patchset simplifies things by removing IRIX support from
> > the xfstests tests, build system, and documentation.  It also ports the
> > useful IRIX-specific tests to Linux.  Of course, people will still find
> > more cruft later to remove, but this should be a good start.
> > 
> > To get around the mailing list message size limit, the series is
> > formatted with --irreversible-delete.  Therefore it can't be applied
> > directly.  It can be retrieved from git here:
> > https://github.com/ebiggers/xfstests.git, branch remove_irix_support_v2.
> 
> Great work! Thank you so much for doing this! I pulled & merged your
> branch into a test branch and am running some tests now, overall it
> looks good to me.
> 
> Though, as you mentioned, there're some places that could do further
> cleanups (e.g. I'm wondering if we can kill _supported_os completely and
> remove it from 'new' template, and some $HOSTOS and $PKG_PLATFORM checks
> could be cleaned up too), I agree this is a great start. Thanks again!
> 

We shouldn't make it too hard to port xfstests to other platforms in the future,
but yes I think at least _supported_os and $HOSTOS should probably go, since
they're subject to bitrot and checking the OS isn't usually what is really
wanted anyway.  Really we should check for the presence of some feature,
program, quirk, etc. instead, instead of being lazy and checking for "Linux".

Eric
