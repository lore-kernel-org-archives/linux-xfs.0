Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DA567F47
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 17:55:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8920B304032
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 15:55:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	StmSIjpOBFGXKCE7 for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 15:55:44 -0700 (PDT)
Date: Mon, 14 Jul 2014 08:55:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: consequences of XFS_IOC_FSSETXATTR on non-empty file?
Message-ID: <20140713225532.GD22339@dastard>
References: <CA+4uBUYg+81G2=sj3qXO4GGgA7pyjgVrGDCN+UQ32jnWgSbG5w@mail.gmail.com>
	<20140713012624.GS4453@dastard>
	<CA+4uBUZwuh5t28jU5jfQb3ApdUKx8t88hg6m8CXS+0ztpi6OTw@mail.gmail.com>
	<CALFYKtC7J1ZvW40wsSWmVpNS5T3tmAOmY9CP=nsh4r=iUjeznA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALFYKtC7J1ZvW40wsSWmVpNS5T3tmAOmY9CP=nsh4r=iUjeznA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>, Samuel Just <sam.just@inktank.com>, xfs@oss.sgi.com

On Sun, Jul 13, 2014 at 09:01:13PM +0400, Ilya Dryomov wrote:
> On Sun, Jul 13, 2014 at 5:48 AM, Samuel Just <sam.just@inktank.com> wrote:
> > Actually, on this ubuntu kernel (3.13.0-24-generic), it doesn't seem
> > to give an error.  I'll attach my test case for that.  We don't yet
> > have a way of reproducing the corruption -- the ext_size change in the
> > osd simply seemed like a promising lead.
> > -Sam
> >
> > On Sat, Jul 12, 2014 at 6:26 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> On Sat, Jul 12, 2014 at 06:16:54PM -0700, Samuel Just wrote:
> >>> Hi,
> >>>
> >>> We are seeing reports of ceph-osd stores on xfs of files with some
> >>> garbage data (possibly misplaced from data elsewhere in the
> >>> filesystem).  There was a bug for a while where the ceph-osd process
> >>> would set a value for fsx_extsize on a non-empty (possibly sparse)
> >>> file using XFS_IOC_FSSETXATTR.  Could that plausibly result in a file
> >>> with garbage data?
> >>
> >> No, setting an extent size on a non-empty file will simply fail
> >> with EINVAL.
> 
> AFAIR it checks whether or not any extents are actually allocated, not
> whether the file is empty or not.

FWIW, that's an implementation detail, not the definition of the
intended behaviour of the ioctl.  Indeed, the man page says:

"The fsx_xflags realtime file bit and the file's extent size may be
changed only when the file is empty, ..."

For most people, "[non-]empty file" is much more easily understood
than "a file without real extents, but might have been written to
and so have dirty, in-memory delayed allocation data whose
asynchronous flushing may or may not affect the behaviour of a call
to XFS_IOC_FSSETXATTR".

i.e. the intended application behaviour is that they should only be
able to change the extent size hint *before* any data is written to
the file.

> I think if you call fsync() or even
> fdatasync() before close(fd), it will fail as expected.

Only if you are trying to change the extent size immediately after
the first write you do to an empty file. Which is, as per the above,
not the recommended or intended use of the ioctl.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
