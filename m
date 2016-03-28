Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F6497CA3
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 16:59:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3372D304032
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 14:59:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TWJ4rt9xJsBUCj9J for <xfs@oss.sgi.com>;
	Mon, 28 Mar 2016 14:59:26 -0700 (PDT)
Date: Tue, 29 Mar 2016 08:59:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Build regressions/improvements in v4.6-rc1
Message-ID: <20160328215923.GG11812@dastard>
References: <CAMuHMdXx80zs5VoA_aYc_wMn37O=fa6oXk-ovteHq0hGQYUUzg@mail.gmail.com>
	<CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>, Rich Felker <dalias@libc.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Cris <linux-cris-kernel@axis.com>, xfs@oss.sgi.com

On Sun, Mar 27, 2016 at 02:43:24PM +0200, Geert Uytterhoeven wrote:
> On Sun, Mar 27, 2016 at 2:39 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v4.6-rc1[1] compared to v4.5[2].
> >
> > Summarized:
> >   - build errors: +9/-6
> 
> > [1] http://kisskb.ellerman.id.au/kisskb/head/10114/ (all 262 configs)
> > [2] http://kisskb.ellerman.id.au/kisskb/head/10047/ (all 262 configs)
> 
> > 9 error regressions:
> >   + /home/kisskb/slave/src/fs/xfs/xfs_ondisk.h: error: call to
> > '__compiletime_assert_79' declared with attribute error: XFS:
> > sizeof(xfs_attr_shortform_t) is wrong, expected 8:  => 79:2
> 
> cris-allyesconfig, cris-allmodconfig

Yup, cris is the only platform that throws this error on this
structure. It's an on-disk structure and relying on the gcc
optimiser to do the same thing from release to release has become
such a crap-shoot these days. Hence as a stop-gap measure we added
build time checking of what they compiler is doing with those
structures, and to refuse to build XFS if the compiler/platform is
doing something obviously different.

Modernising the on-disk structure definitions is on the list of
things to do, but it's nowhere near the top of my list at the
moment...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
