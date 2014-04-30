Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1748929DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 10:11:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B39A3AC012
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 08:10:56 -0700 (PDT)
Date: Wed, 30 Apr 2014 08:10:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: remove unused argument in trans_iput
Message-ID: <20140430151055.GB15162@infradead.org>
References: <20140430134844.924376330@sgi.com>
	<20140430135319.660238697@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140430135319.660238697@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 30, 2014 at 08:48:45AM -0500, Mark Tinguely wrote:
> Remove the unused second argument to xfs_iput() and
> xfs_trans_iput().
> 
> Introduce the define "IRELE()" and use in place of xfs_iput().
>  
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
