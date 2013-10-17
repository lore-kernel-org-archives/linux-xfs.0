Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18A4F7F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 16:17:44 -0500 (CDT)
Date: Thu, 17 Oct 2013 16:17:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/5] xfs: remove the unused XFS_ATTR_NONBLOCK flag
Message-ID: <20131017211740.GK1935@sgi.com>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.115410017@bombadil.infradead.org>
	<20131014045152.GG4446@dastard> <20131017200109.GI1935@sgi.com>
	<20131017200315.GA26616@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131017200315.GA26616@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Thu, Oct 17, 2013 at 01:03:15PM -0700, Christoph Hellwig wrote:
> On Thu, Oct 17, 2013 at 03:01:09PM -0500, Ben Myers wrote:
> > An xfs ioctl user who requests nonblocking behavior will no longer get it.
> > This seems to constitute API breakage.  How can we verify that this is unused
> > since anyone can open with O_NONBLOCK?
> 
> The flag isn't checked anywhere, which means it doesn't have any effect,
> and doesn't as far as I can look back.

Gah.  I was about to say that you just removed the last usage of it in patch 1!
But that patch is about NOLOCK, not NONBLOCK.  I should get my eyes checked. ;)

Anyway, XFS_ATTR_NONBLOCK is used by dmapi so that nfs threads don't block for
offline files.  Folks who care about that sort of thing will have to add it
back in.  That's fine.

FWIW, you can see that here:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=shortlog;h=refs/heads/v3.0-xfs_dmapi

> I also don't know how the
> prealloc ioctls could behave non-blocking in any sane way.

Right.  Nfsd doesn't use any of those ioctls, so I don't really see the point
either.

Looks like my concern was unfounded.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
