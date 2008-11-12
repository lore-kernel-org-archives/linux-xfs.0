Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:44:23 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9iFsR032695
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:44:15 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF04E154ABD5
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:44:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id FiJwNrFD2f2ru8uR for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:44:15 -0800 (PST)
Date: Wed, 12 Nov 2008 04:44:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] move inode allocation out xfs_iread
Message-ID: <20081112094415.GC9944@infradead.org>
References: <20081027134130.GG3183@infradead.org> <20081103015058.GR19509@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103015058.GR19509@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 03, 2008 at 12:50:58PM +1100, Dave Chinner wrote:
> Hmmmm - what happened to the patch I sent that moved this till
> after ip->i_mount() was initialised? Hmmm - looks like it
> went missing. Ah - christoph's fix for the security inode
> leak was taken, so the patch I had that included this change
> was dropped. Looks like we still need that part of my patch.
> 
> I'll have to resend it, and it needs to go in ASAP as
> inode_init_always() can call ->destroy_inode, so the above is a
> double free or a panic in xfs_ireclaim(). This patch will then need
> to be rediffed on top of it.

Still a little confused about which patch you mean.  Care to resend it
ASAP?
