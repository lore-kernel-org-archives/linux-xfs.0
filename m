Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEE3A7F37
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:37:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE1258F8037
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 15:37:52 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LYea1SKEC10W9ugj for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 15:37:51 -0800 (PST)
Date: Mon, 25 Feb 2013 10:37:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix xfs_iomap_eof_prealloc_initial_size type
Message-ID: <20130224233748.GD5551@dastard>
References: <20130224190436.906161932@sgi.com>
	<20130224190441.937509860@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130224190441.937509860@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 24, 2013 at 01:04:37PM -0600, Mark Tinguely wrote:
> Fix the return type of xfs_iomap_eof_prealloc_initial_size() to
> xfs_fsblock_t to reflect the fact that the return value may be an
> unsigned 64 bits if XFS_BIG_BLKNOS is defined.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Good Find.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
