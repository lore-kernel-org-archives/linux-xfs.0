Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E5827F52
	for <linux-xfs@oss.sgi.com>; Wed,  6 Feb 2013 00:29:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0DB6AC001
	for <linux-xfs@oss.sgi.com>; Tue,  5 Feb 2013 22:29:51 -0800 (PST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id zqDXvSWP2mhjDUSk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 05 Feb 2013 22:29:50 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1U2yWD-00015M-4w
	for linux-xfs@oss.sgi.com; Wed, 06 Feb 2013 07:30:06 +0100
Received: from CPE-121-219-138-16.lnse2.lon.bigpond.net.au ([121.219.138.16])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 06 Feb 2013 07:30:05 +0100
Received: from nathans by CPE-121-219-138-16.lnse2.lon.bigpond.net.au with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 06 Feb 2013 07:30:05 +0100
From: Nathan Scott <nathans@debian.org>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using
	=?utf-8?b?Z2l0CWFyY2hpdmU=?=
Date: Wed, 6 Feb 2013 06:28:10 +0000 (UTC)
Message-ID: <loom.20130206T072310-821@post.gmane.org>
References: <50F44B2E.9050408@sgi.com> <20130201190930.GX27055@sgi.com>
	<20130206011547.GT2667@dastard>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Dave Chinner <david <at> fromorbit.com> writes:

> 
> It breaks the 'make deb' command for all the trees.
> 

(thanks for checking!)

> The debian package build creates a link tree so that it builds
> outside the main source tree (e.g. in ./xfsprogs-3.1.10) and as part
> of the build it runs 'make dist' to build a tarball from that link
> tree. That now fails with:
> 
> fatal: current working directory is untracked
> 
> coming from the git archive command that is now used to build the
> tarball.
> 
> Nathan, can the debian package build use git-archive? I'm under the
> impression that you have to be able to build debian packages from a
> source tarball or a source package, and so the build can't rely on
> being inside a VCS controlled tree. That rules out using git archive
> for tarball creation...
> 

IIRC, the requirement is to be building in a tree that had a basename
of for <package>-<version> - hence the link'd tree build previously.
If that can be maintained somehow, the build should be fine.  Symlinks
did not work very well (IIRC) - the build tools might've used basename
or realpath or something like that, but I do remember trying that.

> Also, given that the previous tarball creation used the same link
> tree build as the debian package build (i.e. make source-link), that
> implies the debian pacakges are going to be missing files using this
> technique. Doesn't that mean we have to fix the file list being fed
> into the source-link target regardless of whether we use git archive
> to build the tarball?

The source tarball definitely needs to have the package-version prefix
for all the files it contains - has a mechanism to acheive that been
found?

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
