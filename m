Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E391E7F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:16:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C3A318F804C
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 01:16:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BZbIFCiyOR0q1eqS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 01:16:26 -0700 (PDT)
Date: Mon, 2 Sep 2013 01:16:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: set remote symlink buffer type for recovery
Message-ID: <20130902081625.GA11210@infradead.org>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
	<1378081921-18570-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378081921-18570-2-git-send-email-david@fromorbit.com>
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

On Mon, Sep 02, 2013 at 10:32:00AM +1000, Dave Chinner wrote:
> errors, and subsequent reads of the symlink failing CRC
> verification. Found via fsstress + godown.

Can you make sure xfstests triggers this case, please?

> +			xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
>  			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
>  							(char *)bp->b_addr);

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
