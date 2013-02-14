Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D0E77FE6
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 20:14:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 03D508F8052
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 18:14:50 -0800 (PST)
Date: Wed, 13 Feb 2013 21:14:37 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
In-Reply-To: <20130214010853.GD22182@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
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

Hi Ben,

----- Original Message -----
> On Wed, Feb 06, 2013 at 12:15:47PM +1100, Dave Chinner wrote:
> > ...
> > It breaks the 'make deb' command for all the trees.
> 
> xfsprogs: update 'make deb' to use tarball
> 
> This patch changes the build process so that 'make deb' uses the same
> process of creating a source tree as the release script.
> 
> * Add a list of files which go in the release tarball in .git_census
>   This is needed so that you can create a tarball in a bare release
>   tree, when .git is not available.
> 

I think you'll need .git_census in .gitignore (ala configure).
Possibly remove the underscore for naming consistency - *shrug*.

> 
> * 'make deb' now creates unsigned packages by default, 'make debsign'
>   creates signed packages.
> 

Ehrm - why?  Everything else in your patch worked, but this part broke
(which suggests a larger problem, in that this build path is no longer
checked on every build) ...

debsign: Can't find or can't read changes file !

> +debsign: deb
> +	debsign
> +

(That's not valid usage, FWIW).

I would recommend just removing that change in behaviour, "make deb"
was fine as it was (for me anyway, and evidently for Dave too).  Best
to go secure-by-default and not change this.

thanks!

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
