Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1E027F6B
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:18:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98D638F804B
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:18:25 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id A4eESQNgxetY5H8V (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 08:18:24 -0800 (PST)
Date: Wed, 13 Nov 2013 08:18:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/11] xfs: reserve v5 superblock read-only compat.
	feature bit for finobt
Message-ID: <20131113161824.GC14300@infradead.org>
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
	<1384353427-36205-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384353427-36205-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&

no need for the bracing here.

Otherwise looks fine.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
