Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5FEC7CAF
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:46:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D6768F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:46:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id q9OuJ3CtmXRFXnAr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 16:46:46 -0700 (PDT)
Date: Thu, 7 Apr 2016 16:46:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: mark reclaimed inodes invalid earlier
Message-ID: <20160407234636.GC26634@infradead.org>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
	<1460072271-23923-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460072271-23923-7-git-send-email-david@fromorbit.com>
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

> +	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags = XFS_IRECLAIM;
> +	ip->i_ino = 0;
> +	spin_unlock(&ip->i_flags_lock);

It's just a tiny sniplet, but still duplicated from xfs_inode_free().
Maybe add another helper for this?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
