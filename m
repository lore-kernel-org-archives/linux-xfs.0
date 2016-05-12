Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 973F67CA3
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 06:58:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C231AC003
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 04:58:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id d99zAiyC60kFMdEk (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 04:58:11 -0700 (PDT)
Date: Thu, 12 May 2016 04:58:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove unused variable warning in
	xfs_finish_page_writeback
Message-ID: <20160512115811.GE32528@infradead.org>
References: <1462983266-15235-1-git-send-email-cmaiolino@redhat.com>
	<17ff69fb-360c-8c44-9431-564dcd54aef9@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <17ff69fb-360c-8c44-9431-564dcd54aef9@sandeen.net>
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

On Wed, May 11, 2016 at 11:33:21AM -0500, Eric Sandeen wrote:
> Oh, I see.  It's unused on non-debug builds because it's only used
> under ASSERT.
> 
> Ok, that's a good way to fix it, although there are some scanners
> out there (clang?  some gcc?  I don't recall) which will also flag
> write-only variables.  It'd be ugly but sometimes I wonder if an
> ASSERT_DECL() macro would make some sense.
> 
> Or a MASK() macro so we could just do:
> 
> #define MASK(nbits) ((1UL << (nbits)) - 1) /* mask with NBITS bits set */

aka xfs_mask32lo from xfs_bit.h? :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
