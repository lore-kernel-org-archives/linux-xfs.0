Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OMNQxU169408 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 16:23:27 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CAB3199A52D
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:22:55 -0800 (PST)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id DGutbVOIbJOO5RPR for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2009 14:22:55 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 23:22:48 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<200902241037.50534.vapier@gentoo.org>
	<20090224184624.GC28007@infradead.org>
In-Reply-To: <20090224184624.GC28007@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902242322.48314.agruen@suse.de>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Tuesday, 24 February 2009 19:46:24 Christoph Hellwig wrote:
> On Tue, Feb 24, 2009 at 10:37:49AM -0500, Mike Frysinger wrote:
> > but acl/attr have not.  distros care about those packages as well.
>
> Andreas who has done most of the maintaince already is taking these over
> formally, so they won't be released with the xfs tools anymore.  I've
> put him on Cc so he can say when he expects to clear the backlog.

I think I have caught up with the backlog by now in my current trees:

  http://git.kernel.org/?p=linux/kernel/git/agruen/attr.git
  http://git.kernel.org/?p=linux/kernel/git/agruen/acl.git

The repos are based on Christoph's initial git import, with all additional 
fixes added that I'm aware of. Please let me know if anything is missing.

I expect that those repositories will move from where they are right now to 
their permanent new location soon, so please stay tuned ;-)

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
