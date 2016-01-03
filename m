Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAFF37F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:18:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A883AC002
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:18:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id f5X7FpIVXZfUUBd6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:18:33 -0800 (PST)
Date: Sun, 3 Jan 2016 04:18:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 35/76] libxfs: refactor short btree block verification
Message-ID: <20160103121832.GD28429@infradead.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090014.12713.75657.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219090014.12713.75657.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

> +/**
> + * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
> + *				      btree block
> + *
> + * @bp: buffer containing the btree block
> + * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
> + * @pag_max_level: pointer to the per-ag max level field
> + */

We're so far avoided using kerneldoc comments and they silly super
verbosity in XFS.  It might be good to tone this down to the normal
XFS level (same for some other patches).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
