Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84G6BkG120614 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 11:06:11 -0500
Date: Tue, 4 Sep 2012 11:07:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/5] Use libtool to install apps and remove relative
	lib paths
Message-ID: <20120904160706.GJ3274@sgi.com>
References: <20120828172605.607853317@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120828172605.607853317@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

Hey Rich,

On Tue, Aug 28, 2012 at 12:26:05PM -0500, Rich Johnston wrote:
> This 5 part patchset (for xfstests, dmapi and xfsdump):
> 
> 1. Uses libtool to install the binary from the proper location and display a
>    warning if any shared library dependancies are not properly installed.
> 2. Ensures that a libtool wrapper shell script is not installed in place of
>    the application when libtool wrappers are being used.
> 3. Removes the undocumented feature which allowed xfs developers to build and
>    run xfstests without having to install the libraries.  This can lead to
>    touble if you expect that xfstests is using the versions of the libraries
>    installed on the system.

This patchset looks great to me.

Although Dave has mentioned that the first patch probably isn't strictly
necessary... I think that it's worth pulling in.  Since we build with libtool
we should also install with libtool.

Dave also asked about dmapi.  I took a brief look at the dmapi Makefiles.  It
appears the library is already installed using INSTALL_LTLIB.

Looks good!

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
