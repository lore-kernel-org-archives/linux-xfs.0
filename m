Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E07E67F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:46:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8FC3CAC003
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 03:46:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id pvEuFfA043Tr0QFB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 03:46:39 -0700 (PDT)
Date: Tue, 27 May 2014 03:46:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/16] xfs: move directory block translatiosn to
	xfs_da_btree.h
Message-ID: <20140527104638.GE1440@infradead.org>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-3-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 10:03:38AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because they aren't actually part of the on-disk format, and so
> shouldn't be in xfs_da_format.h.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Maybe it's time to rename the functions and types from xfs_dir2_* to
xfs_da_* as we already do for some?  If not this should stay in dir2
headers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
