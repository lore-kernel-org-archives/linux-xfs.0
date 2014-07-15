Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 067907F9C
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:25:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0670304051
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:25:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gkrDOFLIjjTRZ0pj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 03:25:20 -0700 (PDT)
Date: Tue, 15 Jul 2014 03:25:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix uflags detection at xfs_fs_rm_xquota
Message-ID: <20140715102520.GH30363@infradead.org>
References: <53C4F5DB.2060108@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53C4F5DB.2060108@oracle.com>
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

On Tue, Jul 15, 2014 at 05:35:23PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> We are intended to check up uflags against FS_PROJ_QUOTA rather than 
> FS_USER_UQUOTA once more, it looks to me like a typo, but might cause
> the project quota metadata space can not be removed.

This code was introduced by commit
9da93f9b7cdf8ab28da6b364cdc1fafc8670b4dc which attempts to fix the
broken quotarm code.  Seems like we need a testcase for this
functionality or just remove it.  Physically removing the quota file
never seems that useful to me to start with..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
