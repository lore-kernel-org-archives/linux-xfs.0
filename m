Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92NCdDN102814 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 18:12:39 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Qwk36SurJGACaZCU for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 16:14:02 -0700 (PDT)
Date: Wed, 3 Oct 2012 09:14:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
	(+attachment)
Message-ID: <20121002231359.GV23520@dastard>
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
	<506B5DE1.4020000@tlinx.org> <20121002215253.GT23520@dastard>
	<506B7018.7040000@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506B7018.7040000@tlinx.org>
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

On Tue, Oct 02, 2012 at 03:52:08PM -0700, Linda Walsh wrote:
> Dave Chinner wrote:
> >Patches welcome.
> >
> >Cheers,
> >
> >Dave.
> ---
> Gee, that's a hard one... (build and tested that it was included)...

Actually, it's a lot more than just changing the default. If the
build system doesn't have libreadline/libedit/libtermcap installed,
the build will fail.

You need to add detection of the libraries' presence on the build
system, and then the "--enable-*" options can go away entirely.
See, for example, the way libuuid is detected in
m4/package_uuiddev.m4....

Also, libedit is only supposed to be used as a fallback option if
libreadline is not available.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
