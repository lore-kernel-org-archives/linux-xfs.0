Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 147D87CA4
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 20:41:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D87308F8037
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 18:41:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	or8xjhhfKL3TXHn8 for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 18:41:13 -0700 (PDT)
Date: Tue, 21 Jun 2016 11:40:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 008/119] xfs: separate freelist fixing into a separate
	helper
Message-ID: <20160621014037.GA27480@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632363.12839.15504324533944246285.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612632363.12839.15504324533944246285.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:18:43PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <david@fromorbit.com>
> 
> Break up xfs_free_extent() into a helper that fixes the freelist.
> This helper will be used subsequently to ensure the freelist during
> deferred rmap processing.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Just noticed - should be from/sob dchinner@redhat.com. I'll fix this
up, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
