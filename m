Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0452C7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 07:45:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA5158F804B
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 05:45:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CDZnHPK2jngmpDAw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 05:44:57 -0700 (PDT)
Date: Mon, 21 Apr 2014 05:44:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 01/10] xfs: remove redundant stat assignment in
	xfs_bulkstat_one_int
Message-ID: <20140421124457.GA4017@infradead.org>
References: <535078A9.409@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078A9.409@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 18, 2014 at 08:58:17AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Remove the redundant BULKSTAT_RV_NOTHING assignment in case of call
> xfs_iget() failed at xfs_bulkstat_one_int().
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
