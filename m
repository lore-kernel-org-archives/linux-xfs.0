Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 545A67F53
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:43:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 296298F8065
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:43:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id xFwtHacXOwlSVuDY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:43:36 -0800 (PST)
Date: Thu, 28 Nov 2013 02:43:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
Message-ID: <20131128104336.GE26927@infradead.org>
References: <5294A469.1060000@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5294A469.1060000@oracle.com>
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

On Tue, Nov 26, 2013 at 09:38:49PM +0800, Jeff Liu wrote:
> +	if (flags & XFS_QMOPT_UQUOTA)
> +		return xfs_qm_dqpurge(dqp, NULL);

To me it doesn't make any sense to overload this function for the user
quotas that don't have hints.

I'd suggest dropping this hunk and keeping a separate walk for
releasing the uquots. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
