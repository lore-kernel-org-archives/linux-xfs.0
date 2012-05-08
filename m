Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48EV72T184875 for <xfs@oss.sgi.com>; Tue, 8 May 2012 09:31:09 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rf5hBCnbLCdNXCF3 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 07:31:06 -0700 (PDT)
Date: Tue, 8 May 2012 10:31:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix delalloc quota accounting on failure
Message-ID: <20120508143104.GA15308@infradead.org>
References: <1336474133-27732-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1336474133-27732-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 08, 2012 at 08:48:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfstest 270 was causing quota reservations way beyond what was sane
> (ten to hundreds of TB) for a 4GB filesystem. There's a sign problem
> in the error handling path of xfs_bmapi_reserve_delalloc() because
> xfs_trans_unreserve_quota_nblks() simple negates the value passed -
> which doesn't work for an unsigned variable. This causes
> reservations of close to 2^32 block instead of removing a
> reservation of a handful of blocks.
> 
> Fix the same problem in the other xfs_trans_unreserve_quota_nblks()
> callers where unsigned integer variables are used, too.

eww.  Wouldn't it be better to make handle that inside
xfs_trans_unreserve_quota_nblks?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
