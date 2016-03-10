Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A57447CA2
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 08:22:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30BC2AC009
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:22:10 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FKy91dABvuTPc5y3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:22:08 -0800 (PST)
Date: Thu, 10 Mar 2016 06:22:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/16] xfs: rmap btree add more reserved blocks
Message-ID: <20160310142207.GD29058@infradead.org>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<1457410578-30233-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457410578-30233-4-git-send-email-david@fromorbit.com>
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

Sorry for the second reply to the same mail - I expect this defintion to
be in patch 7, where it logically belongs..

> +#define	XFS_RMAP_BLOCK(mp) \
>  	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
>  	 XFS_FIBT_BLOCK(mp) + 1 : \
>  	 XFS_IBT_BLOCK(mp) + 1)

Is there any good reason for the variable offset for the rmap block.
Yes, it saves one otherwise unused block per AG, but fixed offsets
for metadata make a format much easier to understand.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
