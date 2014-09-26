Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F5938012
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 07:08:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26308AC004
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:08:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AT0tBNg39JAPY5jb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 05:08:34 -0700 (PDT)
Date: Fri, 26 Sep 2014 05:08:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: refactor recovery transaction start handling
Message-ID: <20140926120834.GD10574@infradead.org>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
	<1411697952-24741-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411697952-24741-6-git-send-email-david@fromorbit.com>
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

On Fri, Sep 26, 2014 at 12:19:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rework the transaction lookup and allocation code in
> xlog_recovery_process_ophdr() to remove fold two related call-once

s/remove //

> helper functions into a single helper. Then fold in all
> XLOG_START_TRANS logic to that helper to clean up the remaining
> logic in xlog_recovery_process_ophdr().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
