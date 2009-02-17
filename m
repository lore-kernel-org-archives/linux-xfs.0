Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1H9dSFY215927 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 03:39:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BF6115A02BA
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 01:38:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vZk1z8NYT9Cx0UvB for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 01:38:55 -0800 (PST)
Date: Tue, 17 Feb 2009 04:38:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: fix system() error reporting
Message-ID: <20090217093824.GB15620@infradead.org>
References: <20090216102845.GA6835@infradead.org>
	<d38e348a0902161608r466a2582pfd5fd75e17a66f12@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d38e348a0902161608r466a2582pfd5fd75e17a66f12@mail.gmail.com>
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
To: Timothy Shimmin <timothy.shimmin@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Feb 17, 2009 at 11:08:33AM +1100, Timothy Shimmin wrote:
> Hi Christoph,
> 
> Looks reasonable.
> Though, in the case of returning -1, it might be more interesting
> to know the value of errno ? (I presume errno would be set in that case).

>From looking at the manpage and the glibc implementation it seem like
system does not actually set errno.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
