Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50245 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727932AbfBLVQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Feb 2019 16:16:36 -0500
Date: Wed, 13 Feb 2019 08:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix error message when xfs handle library not found
Message-ID: <20190212211526.GK20493@dastard>
References: <20190212181840.7093-1-fdmanana@kernel.org>
 <93a04478-db84-95f2-9957-5588dc0a54ed@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a04478-db84-95f2-9957-5588dc0a54ed@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fdmanana@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

[cc linux-xfs@vger.kernel.org]

On Tue, Feb 12, 2019 at 12:59:02PM -0600, Eric Sandeen wrote:
> On 2/12/19 12:18 PM, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > The error message mentions a "make install-lib" target from xfsprogs,
> > however that target does not exists in xfsprogs, what exists is a
> > target named "install-dev". So fix that and replace "install-lib" with
> > "install-dev".
> > 
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  m4/package_xfslibs.m4 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
> > index 9be56e11..ad019518 100644
> > --- a/m4/package_xfslibs.m4
> > +++ b/m4/package_xfslibs.m4
> > @@ -83,7 +83,7 @@ AC_DEFUN([AC_PACKAGE_NEED_ATTRLIST_LIBHANDLE],
> >          echo
> >          echo 'FATAL ERROR: could not find a current XFS handle library.'
> >          echo 'Install or upgrade the XFS library package.'
> 
> To fix things up a bit more, I'd probably not refer to the "XFS library package"
> because I'm not sure that exists anywhere either, does it?
> 
> In fedora/rhel land, it's in xfsprogs & xfsprogs-devel for development.
> 
> Not sure about suse or debian or ...?

Debian:

$ apt-file search libhandle
....
xfslibs-dev: /lib/libhandle.a
xfslibs-dev: /lib/libhandle.so
xfslibs-dev: /usr/lib/libhandle.a
xfslibs-dev: /usr/lib/libhandle.la
xfsprogs: /lib/libhandle.so.1
xfsprogs: /lib/libhandle.so.1.0.3
$

So the libhandle library DSO is shipped in xfsprogs. The /static/
library is shipped in xfslibs-dev.

So what is fstests requiring here - the DSO or the static library?
If it's the static library, then why does it need that and why can't
it use the DSO shipped as part of the main xfsprogs package?

> Not a huge deal but if nobody ships xfsprogs-libs (or similar) then maybe best
> to fix that line as well.
> 
> > -        echo 'Alternatively, run "make install-lib" from the xfsprogs source.'
> > +        echo 'Alternatively, run "make install-dev" from the xfsprogs source.'
> 
> and yeah, this part makes sense.

Only if it requires the static libhandle.a library.

But that said, we should probably get rid of the static library and
just ship the DSO - I can't think of a good reason for shipping a
static version of a DSO in a "dev" package these days.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
