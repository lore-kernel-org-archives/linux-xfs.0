Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBT8g0Ht016953 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 02:42:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DC5917923C9
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 00:42:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DGqZcI2aAWvHvOXn for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 00:42:00 -0800 (PST)
Date: Mon, 29 Dec 2008 03:41:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
Message-ID: <20081229084128.GA397@infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
	<494FF9B3.9030103@sgi.com> <20081222204956.GA23453@infradead.org>
	<495010A2.2030903@sgi.com> <20081222221613.GA7128@infradead.org>
	<1229986947.4662.13.camel@verge.scott.net.au>
	<49585F70.5090709@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49585F70.5090709@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 04:26:08PM +1100, Mark Goodwin wrote:
> If we split it, we only loose the top level GNUmakefile, but gain the
> potential for separate maintainership (or even group write if needed)
> for each of the sub-projects. SGI can manage git/ptools for this easily
> enough internally.
> 
> So the proposal would be to set up:
> git://oss.sgi.com/xfs/{acl,attr,xfstests,xfsprogs,xfsdump,dmapi,xfsmisc}.git
> as bare repositories, each with a 'master' and 'stable' branch (initially
> identical) and merge from master to stable whenever we want to release
> (and also grab tarballs to preserve Barry's previous release process until
> such time as the distros catch on).
> 
> Before I go and do this, note we already have Russell's ptools/cvs
> mirror at git://oss.sgi.com/xfs-cmds which has the advantage of some
> history. Would we want to keep any of that history? Since this already
> mirrors t-o-t ptools, I could just as easily take a clone of that as
> git://oss.sgi.com/xfs/xfs-cmds.git and be done with it. Opinions?

I've setup a few experimental trees:

	http://git.kernel.org/?p=fs/xfs/acl.git;a=summary
	http://git.kernel.org/?p=fs/xfs/attr.git;a=summary
	http://git.kernel.org/?p=fs/xfs/dmapi.git;a=summary
	http://git.kernel.org/?p=fs/xfs/nfs4acl.git;a=summary
	http://git.kernel.org/?p=fs/xfs/xfsdump.git;a=summary
	http://git.kernel.org/?p=fs/xfs/xfsprogs.git;a=summary
	http://git.kernel.org/?p=fs/xfs/xfstests.git;a=summary

which do import all the history from the public CVS tree.  Unlike the
git tree on oss.sgi.com it does this in a nicer way by hacking cvsps to
actually detect ptool changest properly insted of splitting them into
multiple git commits due to the different per-file comments, having a
mapping from sgi login IDs to proper real names and having a single
import instead of multiple import and their merges.

The only real problem with these is that the CVS tree hasn't been
updated since October (and I've missed a few names on my first round of
imports).

I think these should be used as a model for the future trees, we can
have these kernel.org trees for the community (current Eric, Dave and me
could commit to those about, and we should add Nathan and Andreas soon),
and then sgi can pull them into their trees for official releases or
product trees.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
