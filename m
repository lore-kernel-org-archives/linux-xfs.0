Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50DB47F93
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:27:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F771304075
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 14:27:29 -0800 (PST)
Date: Thu, 14 Feb 2013 17:27:27 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1098935015.3042606.1360880847661.JavaMail.root@redhat.com>
In-Reply-To: <20130214173120.GF22182@sgi.com>
Subject: Re: xfsdump: update 'make deb' to use tarball archive
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
Cc: xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>



----- Original Message -----
> This patch changes the build process so that 'make deb' uses the same
> process of creating a source tree as the release script.
> 
> * Add a list of files which go in the release tarball in .gitcensus
>   This is needed so that you can create a tarball in a bare release
>   tree, when .git is not available.
> 
> * Modify the SRCTAR target to include files from .gitcensus and use
> tar
>   instead of git archive.
> 
> * Modify the SRCTARINC files to include .gitcensus, and include
>   .gitcensus in the 'make realclean' target.
> 
> * remove the 'make source-link' target.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> 

Reviewed-by: Nathan Scott <nathans@debian.org>

thanks!

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
