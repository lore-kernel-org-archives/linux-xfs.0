Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2D2YLa129706 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 08:02:34 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BmCYB73fGB6WdDpV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 06:04:27 -0700 (PDT)
Date: Fri, 2 Nov 2012 09:04:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs_logprint: Handle continued inode transactions
Message-ID: <20121102130425.GB12578@infradead.org>
References: <5092A1DE.10609@redhat.com>
 <5092A430.8080109@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5092A430.8080109@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 01, 2012 at 11:32:48AM -0500, Eric Sandeen wrote:
> 
> Tested by running xfs_logprint of TEST_DEV in xfsprogs
> after sequential tests; without this change it gets off
> in the weeds eventually; with this fix, it lasts longer,
> until it hits some other yet-unfixed logprint bug...

Add this testcase to xfstests, please.

>  int
> -xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
> +xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops, int continued)

Shouldn't this be a bool?

>  	xlog_print_op_header(op_head, i, &ptr);
> +	continued = (XLOG_SET(op_head->oh_flags, XLOG_WAS_CONT_TRANS) ||
> +		     XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS));

I'd also really love to see another cleanup patch to kill the
XLOG_SET macro.  The XLOG_ flags are true flags so they can be replaced
by a simple op_head->oh_flags & XLOG_FLAG.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
