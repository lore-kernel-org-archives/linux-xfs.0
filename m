Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 477707F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:51:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F9718F8039
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 07:51:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id cxzhreZr1cO5HhZN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 07:51:57 -0800 (PST)
Date: Tue, 4 Feb 2014 07:51:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: return -E2BIG if hit the maximum size limits of ACLs
Message-ID: <20140204155156.GA3810@infradead.org>
References: <52EBB032.8070306@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52EBB032.8070306@oracle.com>
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

On Fri, Jan 31, 2014 at 10:16:18PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> We should return -E2BIG rather than -EINVAL if hit the maximum size
> limits of ACLS, as the former is consistent with VFS xattr syscalls.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

You were already working on tests for this area, right?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
