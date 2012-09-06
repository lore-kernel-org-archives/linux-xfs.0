Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86Igebo143287 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 13:42:40 -0500
Received: from xmail.sgi.com (pv-excas1-dc21.corp.sgi.com [137.38.102.116])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 526A0AC00D
	for <xfs@oss.sgi.com>; Thu,  6 Sep 2012 11:43:37 -0700 (PDT)
Message-ID: <5048EEB4.3030505@sgi.com>
Date: Thu, 6 Sep 2012 13:43:00 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] Use libtool to install apps and remove relative lib
	paths
References: <20120828172605.607853317@sgi.com> <20120904160706.GJ3274@sgi.com>
In-Reply-To: <20120904160706.GJ3274@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


On Tue, Aug 28, 2012 at 12:26:05PM -0500, Rich Johnston wrote:
> This 5 part patchset (for xfstests, dmapi and xfsdump):
>
> 1. Uses libtool to install the binary from the proper location and display a
>     warning if any shared library dependancies are not properly installed.
> 2. Ensures that a libtool wrapper shell script is not installed in place of
>     the application when libtool wrappers are being used.
> 3. Removes the undocumented feature which allowed xfs developers to build and
>     run xfstests without having to install the libraries.  This can lead to
>     touble if you expect that xfstests is using the versions of the libraries
>     installed on the system.
>

PATCH 1/5 of this series was determined to be unnecessary and was not 
checked in.  PATCHES 2-5 have been checked into the oss.sgi.com 
repositories.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
