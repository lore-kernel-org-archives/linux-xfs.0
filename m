Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E7C77F3F
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 11:05:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 74B468F8050
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 09:05:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id zqH2bQEh6MEtcGTP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 09:05:16 -0700 (PDT)
Date: Mon, 17 Jun 2013 09:05:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/27] xfs: reshuffle dir2 definitions around for userspace
Message-ID: <20130617160515.GC26043@infradead.org>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371032567-21772-16-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 12, 2013 at 08:22:35PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Many of the definitions within xfs_dir2_priv.h are needed in
> userspace outside libxfs. Definitions within xfs_dir2_priv.h are
> wholly contained within libxfs, so we need to shuffle some of the
> definitions around to keep consistency across files shared between
> user and kernel space.

I created the xfs_dir2_format.h header so that it would be self
contained.  Despite not mentioning it in the description this patch
also moves typedefs out of xfs_dir2_format.h which is something I'd
rather avoid.  Where in userspace would we need these defintions but
can't include xfs_dir2_format.h?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
