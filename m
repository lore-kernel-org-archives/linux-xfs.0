Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o97KNlpF221743 for <xfs@oss.sgi.com>; Thu, 7 Oct 2010 15:23:47 -0500
Subject: Re: [PATCH 6/7] xfs: remove xfs_cred.h
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101006184126.663057623@localhost.localdomain>
References: <20101006184111.634126439@localhost.localdomain>
	<20101006184126.663057623@localhost.localdomain>
Date: Thu, 07 Oct 2010 15:24:49 -0500
Message-ID: <1286483089.2670.372.camel@doink>
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

On Wed, 2010-10-06 at 14:41 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-remove-cred.h)
> We're not actually passing around credentials inside XFS for a while now,
> so remove all xfs_cred.h with it's cred_t typedef and all instances of it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Looks good.  I think I found one or two spots left where
"cred" was used in comments (maybe above xfs_ialloc()?).
But that's OK.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
