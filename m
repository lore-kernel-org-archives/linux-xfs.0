Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 869E97CA2
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 08:17:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45DFD8F8039
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:17:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YoMyKNKBQAjTNA1S (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 06:16:59 -0800 (PST)
Date: Thu, 10 Mar 2016 06:16:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/16] xfs: rmap btree add more reserved blocks
Message-ID: <20160310141659.GB29058@infradead.org>
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

> +	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);

We only use the m_ag_prealloc_blocks member in xfs_growfs_data_private.
I think a local variable would do it as well, as growfs isn't exactly
a frequent fast path operation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
