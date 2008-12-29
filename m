Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBT5QJ4S030479 for <xfs@oss.sgi.com>; Sun, 28 Dec 2008 23:26:19 -0600
Message-ID: <49585F70.5090709@sgi.com>
Date: Mon, 29 Dec 2008 16:26:08 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
References: <20081222163831.755809000@bombadil.infradead.org>	
	<494FF9B3.9030103@sgi.com> <20081222204956.GA23453@infradead.org>	
	<495010A2.2030903@sgi.com> <20081222221613.GA7128@infradead.org>
	<1229986947.4662.13.camel@verge.scott.net.au>
In-Reply-To: <1229986947.4662.13.camel@verge.scott.net.au>
Reply-To: markgw@sgi.com
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
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



Nathan Scott wrote:
> On Mon, 2008-12-22 at 17:16 -0500, Christoph Hellwig wrote:
>> On Tue, Dec 23, 2008 at 09:11:46AM +1100, Mark Goodwin wrote:
>>>> One thing we were discussing is if it's really a good idea to have all
>>>> these together.
>>> It would certainly help SGI if the directory structure for the proposed
>>> xfs-cmds tree remained the same as it is in ptools at the moment. I
>>> guess we could consider splitting each xfs-cmds directory into separate
>>> repositories, but then building it all togetheer would be a pain. It could
>>> certainly make sense to split off xfstests into it's own tree since it's
>>> not part of the xfs-cmds build.
>> Ok, sounds fair to keep it like that for now.
>
> Now seems like a good time to split it.  The distributions have to deal
> with it this way, and for the most part developers don't need to go and
> update acl/attr from the version shipped with their distro.  And now in
> xfsprogs-3.0 the exported headers are sorted out, the interface between
> the packages is much better defined ... if we don't break the link now,
> we probably never will - so I'd vote for separate trees for each self-
> contained package, personally.  Be good to allow agruen to directly be
> able to commit to acl/attr for example, as Christoph said.

If we split it, we only loose the top level GNUmakefile, but gain the
potential for separate maintainership (or even group write if needed)
for each of the sub-projects. SGI can manage git/ptools for this easily
enough internally.

So the proposal would be to set up:
git://oss.sgi.com/xfs/{acl,attr,xfstests,xfsprogs,xfsdump,dmapi,xfsmisc}.git
as bare repositories, each with a 'master' and 'stable' branch (initially
identical) and merge from master to stable whenever we want to release
(and also grab tarballs to preserve Barry's previous release process until
such time as the distros catch on).

Before I go and do this, note we already have Russell's ptools/cvs
mirror at git://oss.sgi.com/xfs-cmds which has the advantage of some
history. Would we want to keep any of that history? Since this already
mirrors t-o-t ptools, I could just as easily take a clone of that as
git://oss.sgi.com/xfs/xfs-cmds.git and be done with it. Opinions?

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
