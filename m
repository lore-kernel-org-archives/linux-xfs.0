Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13FqQIm072663 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 09:52:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 154841C01DD6
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 07:51:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CYHO6skMDHKIa7g7 for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 07:51:47 -0800 (PST)
Date: Tue, 3 Feb 2009 10:51:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090203155147.GB21278@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090201161458.GA5930@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090201161458.GA5930@infradead.org>
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
To: xfs@oss.sgi.com, Nick Piggin <nickpiggin@yahoo.com.au>

On Sun, Feb 01, 2009 at 11:14:58AM -0500, Christoph Hellwig wrote:
> On Sun, Feb 01, 2009 at 03:12:24AM -0500, Christoph Hellwig wrote:
> > When running xfsqa on the current xfs development tree (sometimes two
> > runs are needed to trigger it) I get the following oops.  This seems to
> > have been introduced by the last mainling merge (with
> > 5ee810072175042775e39bdd3eaaa68884c27805), but I'd need to bisect it to
> > make sure my gut feeling is right.
> 
> Still happens with a commit before that mainline merge.  Looking for
> a good candiate for bisection now.

I bisected it down to commit 0087167c9d5b1273e7e6bbe39a9ab13bdb9a39bb
"[XFS] use scalable vmap API".

Nick, any idea what this could be?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
