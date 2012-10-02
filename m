Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92NnKKx109649 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 18:49:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7o2taF07GaHbObjO for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 16:50:44 -0700 (PDT)
Date: Wed, 3 Oct 2012 09:50:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
	(+attachment)
Message-ID: <20121002235042.GW23520@dastard>
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
	<506B5DE1.4020000@tlinx.org> <20121002215253.GT23520@dastard>
	<506B7018.7040000@tlinx.org> <20121002231359.GV23520@dastard>
	<506B7A1C.3000001@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506B7A1C.3000001@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 02, 2012 at 04:34:52PM -0700, Linda Walsh wrote:
> 
> 
> Dave Chinner wrote:
> >On Tue, Oct 02, 2012 at 03:52:08PM -0700, Linda Walsh wrote:
> >>Dave Chinner wrote:
> >>>Patches welcome.
> >>>
> >>>Cheers,
> >>>
> >>>Dave.
> >>---
> >>Gee, that's a hard one... (build and tested that it was included)...
> >
> >Actually, it's a lot more than just changing the default. If the
> >build system doesn't have libreadline/libedit/libtermcap installed,
> >the build will fail.
> >
> >You need to add detection of the libraries' presence on the build
> >system, and then the "--enable-*" options can go away entirely.
> >See, for example, the way libuuid is detected in
> >m4/package_uuiddev.m4...
> ----
> Hmmm...Oh...I thought configure did that detection.. Now I see that
> was never put it and it was basically a 'manual' on/off switch
> that was available.

Yup.

> Urk.
> 
> On top of matters, my local distrib had readline installed in a way that
> it wouldn't link had libreadline.so.x.y, libreadline.so.x => libreadline.so.x.y in
> /usr/lib64 but libreadline.so=>libreadline.so.x was in
> /usr/lib64/readline/libreadline.so.
> 
> ???
> Will have to figure out why that is and where it is supposed to be (I just
> moved the soft-link from /usr/lib64/readline/libreadline.so to one dir up -- same
> with libeditline...

Check what your /etc/ld.so.conf looks at - it might just be fine.

> >Also, libedit is only supposed to be used as a fallback option if
> >libreadline is not available.
> ---
> Oh... thought readline did the history part and edit did the edit part...
> Oi vey...

$ gl -n 1 d4b9ebd
commit d4b9ebda67cabf50ba9865880403a89e6b4bc3e7
Author: Nathan Scott <nathans@sgi.com>
Date:   Wed Apr 16 23:38:03 2003 +0000

    Add editline support in for cases where readline is unavailable.

> Sigh.  That I actually thought something might be simple... what an idiot!

TANSTAAFL. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
