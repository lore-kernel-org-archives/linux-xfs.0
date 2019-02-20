Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfBTS7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 13:59:05 -0500
Date: Wed, 20 Feb 2019 10:58:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/3] generic: posix acl extended attribute memory
 corruption test
Message-ID: <20190220185847.GP32253@magnolia>
References: <154993784038.1948.7502664832930298472.stgit@magnolia>
 <20190213204814.GB6477@magnolia>
 <20190220132952.GW9874@twin.jikos.cz>
 <alpine.LNX.2.21.9999.1902201501470.8769@tux.applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.21.9999.1902201501470.8769@tux.applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: David Sterba <dsterba@suse.cz>, guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Feb 20, 2019 at 03:09:32PM +0100, Holger Hoffstätte wrote:
> 
> On Wed, 20 Feb 2019, David Sterba wrote:
> 
> > On Wed, Feb 13, 2019 at 12:48:14PM -0800, Darrick J. Wong wrote:
> > > +#include <attr/xattr.h>
> > 
> > This does not compile on some systems, sys/xattr.h works (it's provided
> > by glibc) and is also used by other fstests' sources. I'm not sure where
> > does attr/xattr.h come from, my devel package for libattr provides only
> > attr/libattr.h.
> 
> This was removed from attr back in 2015 [1] but apparently caused
> many aplications to no longer compile, so some packagers added attr/xattr.h
> back, completing the cycle of confusion.
> I just randomly remembered because Gentoo fell into the same sinkhole
> and is still climbing out [2].
> 
> AFAIK sys/xattr.h is the preferred thing now unless you are building on an
> ancient distro.

...an ancient distro like Debian Testing or Ubuntu 18.04, which still
ships libattr 2.4.47, which has manpages telling you to use
attr/xattr.h.

OTOH xfsprogs has been using sys/xattr.h since 2009, so patch coming
soon.

--D

> cheers
> Holger
> 
> [1] http://git.savannah.nongnu.org/cgit/attr.git/commit/?id=7921157890d07858d092f4003ca4c6bae9fd2c38
> [2] https://bugs.gentoo.org/648864
