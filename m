Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 444767F8A
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:50:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D6DB304066
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 14:50:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TimX3d8vlFiDjoqE for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 14:50:47 -0800 (PST)
Date: Fri, 15 Feb 2013 09:50:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: update 'make deb' to use tarball
Message-ID: <20130214225046.GP26694@dastard>
References: <20130214010853.GD22182@sgi.com>
	<1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
	<20130214162454.GH30652@sgi.com> <20130214165409.GE22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130214165409.GE22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>

On Thu, Feb 14, 2013 at 10:54:09AM -0600, Ben Myers wrote:
> This patch changes the build process so that 'make deb' uses the same
> process of creating a source tree as the release script.
> 
> * Add a list of files which go in the release tarball in .gitcensus
>   This is needed so that you can create a tarball in a bare release
>   tree, when .git is not available.
> 
> * Modify the SRCTAR target to include files from .git_census and use tar
>   instead of git archive.
> 
> * Modify the SRCTARINC files to include .git_census, and include 
>   .git_census in the 'make realclean' target.
> 
> * remove the 'make source-link' target.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Works fine here.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
