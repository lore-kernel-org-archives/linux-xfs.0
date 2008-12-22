Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMNKgWl008556 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 17:20:42 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA6701777733
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 15:20:39 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id apH6GXsfs8eJmEII for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 15:20:39 -0800 (PST)
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <20081222221613.GA7128@infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
	<494FF9B3.9030103@sgi.com> <20081222204956.GA23453@infradead.org>
	<495010A2.2030903@sgi.com>  <20081222221613.GA7128@infradead.org>
Date: Tue, 23 Dec 2008 10:02:27 +1100
Message-Id: <1229986947.4662.13.camel@verge.scott.net.au>
Mime-Version: 1.0
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
To: Mark Goodwin <markgw@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 2008-12-22 at 17:16 -0500, Christoph Hellwig wrote:
> On Tue, Dec 23, 2008 at 09:11:46AM +1100, Mark Goodwin wrote:
> >> One thing we were discussing is if it's really a good idea to have all
> >> these together.
> >
> > It would certainly help SGI if the directory structure for the proposed
> > xfs-cmds tree remained the same as it is in ptools at the moment. I
> > guess we could consider splitting each xfs-cmds directory into separate
> > repositories, but then building it all togetheer would be a pain. It could
> > certainly make sense to split off xfstests into it's own tree since it's
> > not part of the xfs-cmds build.
> 
> Ok, sounds fair to keep it like that for now.

Now seems like a good time to split it.  The distributions have to deal
with it this way, and for the most part developers don't need to go and
update acl/attr from the version shipped with their distro.  And now in
xfsprogs-3.0 the exported headers are sorted out, the interface between
the packages is much better defined ... if we don't break the link now,
we probably never will - so I'd vote for separate trees for each self-
contained package, personally.  Be good to allow agruen to directly be
able to commit to acl/attr for example, as Christoph said.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
