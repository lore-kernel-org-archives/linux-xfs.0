Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KHYgnR098936 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 12:34:42 -0500
Subject: Re: [PATCH 1/4] xfstests: fix _require_acl
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101015222852.GA3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222852.GA3781@infradead.org>
Date: Wed, 20 Oct 2010 12:35:51 -0500
Message-ID: <1287596151.2284.90.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2010-10-15 at 18:28 -0400, Christoph Hellwig wrote:
> Skip ACL tests if we get EOPNOTUPP back from the acl calls.  This is
> the error code we get on a kernel that does support the xattr system
> calls, but does not support the attributes used to handle Posix ACLs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
