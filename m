Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMMGjV3003245 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 16:16:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7783D41012
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 14:16:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id alsUgyt2gUzgMatt for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 14:16:44 -0800 (PST)
Date: Mon, 22 Dec 2008 17:16:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
Message-ID: <20081222221613.GA7128@infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
	<494FF9B3.9030103@sgi.com> <20081222204956.GA23453@infradead.org>
	<495010A2.2030903@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495010A2.2030903@sgi.com>
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
Cc: xfs@oss.sgi.com

On Tue, Dec 23, 2008 at 09:11:46AM +1100, Mark Goodwin wrote:
> I unsure, but don't think a group writable repository would work too well.
> Nathan doesn't push directly into the official pcp git tree (which is at
> git://oss/pcp/pcp.git) but rather pushes to his own git tree (which is
> at git://oss/nathans/pcp.git). SGI review and pull those commits and push
> them into the official tree (via an internal staging tree using a hook
> for the ptools back-end, but that's transparent to oss users). Nathan also
> reviews patches from others and pulls their patches into his tree, and
> regularly re-syncs with the official tree. git works it all out just fine.
>
> This is fairly new, but seems to work rather well since it supports
> effective collaboration for trusted contributors without SGI becoming
> a patch acceptance bottleneck - sort of a multiple maintainership.

I've set up a kernel.org hierachy where can have group commits.  We can
try for a while to have sgi pull from it.

>> One thing we were discussing is if it's really a good idea to have all
>> these together.
>
> It would certainly help SGI if the directory structure for the proposed
> xfs-cmds tree remained the same as it is in ptools at the moment. I
> guess we could consider splitting each xfs-cmds directory into separate
> repositories, but then building it all togetheer would be a pain. It could
> certainly make sense to split off xfstests into it's own tree since it's
> not part of the xfs-cmds build.

Ok, sounds fair to keep it like that for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
