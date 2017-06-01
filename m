Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbdFAH3E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 03:29:04 -0400
Date: Thu, 1 Jun 2017 15:29:02 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/6] xfstests: remove most IRIX-specific code
Message-ID: <20170601072902.GY23805@eguan.usersys.redhat.com>
References: <20170531223655.130613-1-ebiggers3@gmail.com>
 <20170601031235.GV23805@eguan.usersys.redhat.com>
 <20170601032904.GA1083@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170601032904.GA1083@zzz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: fstests@vger.kernel.org, Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org

On Wed, May 31, 2017 at 08:29:04PM -0700, Eric Biggers wrote:
> On Thu, Jun 01, 2017 at 11:12:35AM +0800, Eryu Guan wrote:
> > On Wed, May 31, 2017 at 03:36:49PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > For some time xfstests has de facto not supported IRIX anymore.  The
> > > final release of IRIX was over 10 years ago and it seems no one has
> > > been running the latest xfstests releases on any IRIX system, as at
> > > the very least xfstests now assumes the existence of some util-linux
> > > binaries.  There are probably other examples of this bitrot too.
> > > 
> > > Therefore, this patchset simplifies things removing IRIX support from
> > > the xfstests tests, build system, and documentation.
> > > 
> > > It focuses on making larger, more obvious cleanups.  Of course,
> > > there's more to do if people want to spend more time going through
> > > some of the more intricate details, especially XFS-specific details.
> > > But this should be a good start.
> > 
> > Thanks a lot for doing this!! I didn't see patch #2 and #3 hit the list
> > (too big for the list?). Do you have a public git repo that I can pull
> > from?
> > 
> 
> Ick, I guess the size limit must be 100K.  I've pushed the series out to
> repository https://github.com/ebiggers/xfstests, branch "remove_irix_support".
> 
> Note that the two biggest patches can be more easily reviewed with
> 'git diff -D', since that abbreviates the file deletions.

Thanks!

I also cc'ed linux-xfs list for review, as IRIX support is mainly for
XFS.

Eryu
