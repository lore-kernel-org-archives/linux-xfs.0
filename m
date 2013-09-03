Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E5267F55
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 02:34:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FAD78F8049
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 00:34:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id VbNvC9ei1vx8yplN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 00:34:51 -0700 (PDT)
Date: Tue, 3 Sep 2013 00:34:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfstests: Obey mkfs options for sized filesystems on
	XFS
Message-ID: <20130903073450.GC1422@infradead.org>
References: <1378167295-7566-1-git-send-email-david@fromorbit.com>
	<1378167295-7566-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378167295-7566-3-git-send-email-david@fromorbit.com>
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

On Tue, Sep 03, 2013 at 10:14:54AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The XFS implementation of _scratch_mkfs_sized ignores MKFS_OPTIONS
> when a custom block size is set and so isn't testing things like
> CRCs on such sized filesytsems. Fix this by ensuring we don't try to
> override the block size is it is set in MKFS_OPTIONS. xfs/204 shows
> this problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Maybe someone more familar with the other mkfs tools should cross-check
those as well.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
