Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4BGSinX002279 for <xfs@oss.sgi.com>; Mon, 11 May 2009 11:28:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D35D61252CB4
	for <xfs@oss.sgi.com>; Mon, 11 May 2009 09:33:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TVAyZGy5I4Oz0Kiv for
	<xfs@oss.sgi.com>; Mon, 11 May 2009 09:33:19 -0700 (PDT)
Date: Mon, 11 May 2009 12:28:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: update max log size
Message-ID: <20090511162849.GA1430@infradead.org>
References: <20090511160609.GA18278@infradead.org>
	<4A085173.5040208@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A085173.5040208@sandeen.net>
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

On Mon, May 11, 2009 at 11:25:23AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > Commit a6634fba3dec4a92f0a2c4e30c80b634c0576ad5 in xfsprogs increased the
> > maximum log size supported by mkfs.  Merged back the changes to xfs_fs.h
> > so the growfs enforced the same limit and the headers are in sync.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Ok, looks like kernelspace only cares about this during
> xfs_growfs_log_private(), and that's not actually implemented yet,
> right?  So no worries about kernel<->userspace version correlation I think.

Indeed, I just did a quick grep what's actually using it.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
