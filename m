Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGbuHx173499 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:37:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4124030205F
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:40:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 97nUVaTZngEga0SP for
	<xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:40:03 -0700 (PDT)
Date: Fri, 30 Apr 2010 12:40:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: be more explicit if RT mount fails due to config
Message-ID: <20100430164002.GC14107@infradead.org>
References: <4BDA54A4.3040204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BDA54A4.3040204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

> +	if (mp->m_sb.sb_rblocks == 0)
> +		return 0;
> +	else {
> +		cmn_err(CE_WARN, "XFS: Not built with CONFIG_XFS_RT");
> +		return ENOSYS;
> +	}

No need for the else if you return anyway.

Looks good either way,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
