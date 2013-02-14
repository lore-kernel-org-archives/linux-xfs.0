Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 426CF8067
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:51:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C2760AC005
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 14:51:13 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RC0vwiUW2S4hmjEj for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 14:51:12 -0800 (PST)
Date: Fri, 15 Feb 2013 09:51:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump: update 'make deb' to use tarball archive
Message-ID: <20130214225111.GQ26694@dastard>
References: <20130214010853.GD22182@sgi.com>
	<1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
	<20130214162454.GH30652@sgi.com> <20130214173120.GF22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130214173120.GF22182@sgi.com>
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

On Thu, Feb 14, 2013 at 11:31:20AM -0600, Ben Myers wrote:
> This patch changes the build process so that 'make deb' uses the same
> process of creating a source tree as the release script.
> 
> * Add a list of files which go in the release tarball in .gitcensus
>   This is needed so that you can create a tarball in a bare release
>   tree, when .git is not available.
> 
> * Modify the SRCTAR target to include files from .gitcensus and use tar
>   instead of git archive.
> 
> * Modify the SRCTARINC files to include .gitcensus, and include
>   .gitcensus in the 'make realclean' target.
> 
> * remove the 'make source-link' target.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Works fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
