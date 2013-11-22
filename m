Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D9277F52
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 03:18:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0F87AC008
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 01:18:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id H44vz9etj7r55eTw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 01:18:28 -0800 (PST)
Date: Fri, 22 Nov 2013 01:18:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: make quota metadata truncation behavior consistent
	to user space
Message-ID: <20131122091827.GC32568@infradead.org>
References: <528EF3D0.70102@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528EF3D0.70102@oracle.com>
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

On Fri, Nov 22, 2013 at 02:04:00PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> In xfs_qm_scall_trunc_qfiles(), we ignore the error if failed to remove
> the users quota metadata and proceed to remove groups and projects if
> they are being there.  However, in user space, the remove operation will
> break and return if failed to remove any kind of quota.
> Also for v5 super block, we can enabled both group and project quota at
> the same time, in this case the current error handling will cover the
> group error with projects but they might failed due to different reasons.
> 
> It seems we'd better the error handling consistent to the user space and
> don't trying to remove another kind of quota metadata if the previous
> operation is failed.

Looks good.  Just curious, did you manage to reproduce an error
truncating the quota files?

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
