Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SFZ240260824 for <xfs@oss.sgi.com>; Thu, 28 May 2009 10:35:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB7872B7AAC
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 08:35:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DOTFZhjeHwN3J0cd for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 08:35:17 -0700 (PDT)
Date: Thu, 28 May 2009 11:35:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] Make libxfs.h optional
Message-ID: <20090528153517.GA15293@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-3-git-send-email-sandeen@sandeen.net>
	<20090528095749.GB651@infradead.org> <4A1EA6E5.50805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1EA6E5.50805@sandeen.net>
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

On Thu, May 28, 2009 at 09:59:49AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Wed, May 27, 2009 at 01:53:26PM -0500, Eric Sandeen wrote:
> >> libxfs.h is really only needed for the loggen test;
> >> make it config-time optional.
> > 
> > Maybe we should just move loggen into xfsprogs?
> 
> Perhaps, though it has no use outside of qa ... even if we do that it'll
> take a while to trickle into people's xfsprogs, so any problem with
> putting this patch in for now, even if we move loggen?

I will send a patch to add loggen to xfsprogs ASAP.  After that we can
remove loggen and thus the requirement for libxfs.h from xfstests
completely.  The tests that use loggen would ismply check for a
xfs_loggen binary  in their PATH and not run, so far less drama then
the current situation.

> 
> Thanks,
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
