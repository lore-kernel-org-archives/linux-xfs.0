Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ACAB57CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 11:31:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38E79AC003
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 09:31:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rzYoL7dqysFkISMm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 09:31:19 -0700 (PDT)
Date: Tue, 31 May 2016 09:31:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
Message-ID: <20160531163118.GA7016@infradead.org>
References: <1458128681-10869-1-git-send-email-hch@lst.de>
	<1458128681-10869-4-git-send-email-hch@lst.de>
	<b8d49db2-131d-0735-c803-adec326f43bb@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b8d49db2-131d-0735-c803-adec326f43bb@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, May 31, 2016 at 10:35:01AM -0500, Eric Sandeen wrote:
> Coverity thinks this is problematic, calling it a
> "Free of address-of expression (BAD_FREE)"
> 
> CID 1362192
> 
> The issue is that if bio still == io_inline_bio, we are freeing
> memory which was not allocated.

No, we free the ioend into which the bio is embedded.  Take a look
at the allocation side in xfs_alloc_ioend:

	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, xfs_ioend_bioset);

	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);


> Maybe this needs a:
> 
> if (bio != &ioend->io_inline_bio)
> 	bio_put(bio);

That would leak every ioend used.

> or is there a better way?

We just need to shut up the checker..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
