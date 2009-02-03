Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13G5t4l073394 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 10:05:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C5861C0205B
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 08:05:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YE34sItoCsoAju1q for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 08:05:16 -0800 (PST)
Date: Tue, 3 Feb 2009 11:05:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090203160515.GA30986@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090201161458.GA5930@infradead.org>
	<20090203155147.GB21278@infradead.org>
	<200902040303.13933.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902040303.13933.nickpiggin@yahoo.com.au>
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
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 03:03:13AM +1100, Nick Piggin wrote:
> Hmm, seems similar to the other one Dave saw. I suppose it could
> be due to bad parameters being passed to vmap API, but quite
> likely it could be a bug in vmap as well.
> 
> Any chance you can print out va_start and va_end from va and tmp
> before going bug? (or if you like, I can try reproduce it with
> xfsqa if there is a URL for it -- a quick google didn't help me).

It's at http://git.kernel.org/?p=fs/xfs/xfstests-dev.git

Right now I'm doing two verification runs with the current codebase
and just that patch reverted as a second verification.  After that
I can do a patch with the debug printks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
