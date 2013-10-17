Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE5A57F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 15:03:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA22E304059
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 13:03:19 -0700 (PDT)
Date: Thu, 17 Oct 2013 13:03:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: remove the unused XFS_ATTR_NONBLOCK flag
Message-ID: <20131017200315.GA26616@infradead.org>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.115410017@bombadil.infradead.org>
	<20131014045152.GG4446@dastard> <20131017200109.GI1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131017200109.GI1935@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Oct 17, 2013 at 03:01:09PM -0500, Ben Myers wrote:
> An xfs ioctl user who requests nonblocking behavior will no longer get it.
> This seems to constitute API breakage.  How can we verify that this is unused
> since anyone can open with O_NONBLOCK?

The flag isn't checked anywhere, which means it doesn't have any effect,
and doesn't as far as I can look back.  I also don't know how the
prealloc ioctls could behave non-blocking in any sane way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
