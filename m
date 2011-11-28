Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS7sx2R224323 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 01:55:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9B3816E1D5C
	for <xfs@oss.sgi.com>; Sun, 27 Nov 2011 23:54:57 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XZ9lJ5EjsSGCmFdE for <xfs@oss.sgi.com>;
	Sun, 27 Nov 2011 23:54:57 -0800 (PST)
Date: Mon, 28 Nov 2011 02:54:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
Message-ID: <20111128075451.GA6000@infradead.org>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ED2C233.8010104@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Sun, Nov 27, 2011 at 05:05:23PM -0600, Eric Sandeen wrote:
> > i.e. do we have any guarantee at all that a PBS sized IO will either
> > wholly complete or wholly fail when PBS != sector size? And if not,
> > why is this a change we should make given it appears to me to
> > violate a fundamental assumption of the filesystem design?
> 
> I had the expectation that physical block size WAS the fundamental/atomic
> IO size for the disk, and anything smaller required read/modify/write.
> So I made this suggestion (and I think hch concurred) so that we weren't
> doing log IOs which required RMW & translation.

Yes, that is how it is defined. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
