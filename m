Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUHIv1P023510 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 11:18:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD6D61797E29
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 09:18:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H3TmoDLquI1wb6zU for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 09:18:57 -0800 (PST)
Date: Tue, 30 Dec 2008 12:18:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
Message-ID: <20081230171825.GA31624@infradead.org>
References: <49594CD9.3010402@sandeen.net>
	<20081230115224.GA24210@infradead.org>
	<20081230124936.GA26322@infradead.org>
	<200812300907.31459.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200812300907.31459.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 30, 2008 at 09:07:30AM -0500, Mike Frysinger wrote:
> acl-2.2.47 built fine for me with `./configure && make` and this patch ...

Works now after a make distclean for me.

> that said, if the only purpose of this is to make sure there are symlinks in 
> include/, why not do it at the tail end of configure ?  then there will be no 
> weird parallel magic to worry about, and everything will always be available 
> once configure has finished.

I'll leave that to Eric or anyone else who wants to play a build system
expert on TV :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
