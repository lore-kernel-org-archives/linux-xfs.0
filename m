Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD1E07F62
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 19:15:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 990078F8035
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 17:15:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xabKOM9SVjhBKpTk for <xfs@oss.sgi.com>;
	Tue, 05 Feb 2013 17:15:50 -0800 (PST)
Date: Wed, 6 Feb 2013 12:15:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
Message-ID: <20130206011547.GT2667@dastard>
References: <50F44B2E.9050408@sgi.com>
 <20130201190930.GX27055@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130201190930.GX27055@sgi.com>
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
Cc: nathans@debian.org, xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>

On Fri, Feb 01, 2013 at 01:09:30PM -0600, Ben Myers wrote:
> On Mon, Jan 14, 2013 at 12:15:10PM -0600, Andrew Dahl wrote:
> > The following four patches fix an issue seen during the last user space
> > release where not all source files were included in xfsprogs.  They each
> > change xfsprogs, xfstests, xfsdump, and dmapi to all use git archive for
> > source tarball generation and add 'make realclean' in the release
> > scripts to ensure the configure and m4/autotools temp files are refreshed.
> 
> Applied this series.

It breaks the 'make deb' command for all the trees.

The debian package build creates a link tree so that it builds
outside the main source tree (e.g. in ./xfsprogs-3.1.10) and as part
of the build it runs 'make dist' to build a tarball from that link
tree. That now fails with:

fatal: current working directory is untracked

coming from the git archive command that is now used to build the
tarball.

Nathan, can the debian package build use git-archive? I'm under the
impression that you have to be able to build debian packages from a
source tarball or a source package, and so the build can't rely on
being inside a VCS controlled tree. That rules out using git archive
for tarball creation...

Also, given that the previous tarball creation used the same link
tree build as the debian package build (i.e. make source-link), that
implies the debian pacakges are going to be missing files using this
technique. Doesn't that mean we have to fix the file list being fed
into the source-link target regardless of whether we use git archive
to build the tarball?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
