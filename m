Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CE7B29DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 11:47:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8BFA5AC003
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 09:47:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KjyalzGxLGTFrWPX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 09:47:55 -0700 (PDT)
Date: Mon, 28 Apr 2014 09:47:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
Message-ID: <20140428164754.GA17472@infradead.org>
References: <535E8344.2070209@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535E8344.2070209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 28, 2014 at 11:35:16AM -0500, Eric Sandeen wrote:
> Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
> to test for a shut down fs,

It probably should.

> lest we go down paths we'll
> never be able to complete; Boris reported that during some
> stress tests he had threads stuck in xlog_cil_force_lsn
> via xfs_dir_fsync().

But this could still happen if we get a shutdown coming in after that
test.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
