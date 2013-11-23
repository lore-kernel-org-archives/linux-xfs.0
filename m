Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 299D17F56
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 02:51:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5555AC001
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 00:51:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Jo5je4Lm3RKjzzAR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 00:51:26 -0800 (PST)
Date: Sat, 23 Nov 2013 00:51:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: integrate xfs_quota_priv header file to xfs_qm
Message-ID: <20131123085125.GB31055@infradead.org>
References: <528F832F.6050006@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528F832F.6050006@oracle.com>
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

On Sat, Nov 23, 2013 at 12:15:43AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> The xfs_quota_priv header file is only included by xfs_qm header and
> there is no much users for its contents, hence we can move those stuff
> to xfs_qm header file and kill it.
> 
> This patch also remove an unused macro DQFLAGTO_TYPESTR.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
