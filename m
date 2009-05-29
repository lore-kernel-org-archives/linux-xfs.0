Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TElT51061865 for <xfs@oss.sgi.com>; Fri, 29 May 2009 09:47:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3700B1D37E38
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 07:47:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TDoFArgAIVyEr1Na for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 07:47:45 -0700 (PDT)
Date: Fri, 29 May 2009 10:47:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfsprogs: add xfs_loggen
Message-ID: <20090529144744.GB4882@infradead.org>
References: <20090528154338.GA20712@infradead.org>
	<4A1F0691.7060302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1F0691.7060302@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, May 28, 2009 at 04:48:01PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > The loggen utility in xfstests is the only remaining reason why
> > something outside libxfs would need libxfs, libxlog and their headers.
> > 
> > So just move it to xfsprogs but only install it with a special
> > make install-qa-tools so that it does not get installed by default.
> > Still easier to provide an xfsprogs-qa subpackage for those that want
> > to run xfsqa.
> 
> Ok, and the xfsqa tests can then skip loggen tests if it's not found.

Yeah.

> TBH I'd be pretty unlikely to bother with an xfsprogs-qa package for
> Fedora, consisting of exactly one binary... hardly seems worth it.
> 
> But I guess I don't see a better way :)  At least this way we can build
> it w/o the cross-package deps.

It would be really great to have it packaged..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
