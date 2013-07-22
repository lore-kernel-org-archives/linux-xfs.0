Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD1057F53
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 18:37:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38BB6AC006
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 16:37:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RA7cXGN0t5kGuD0y for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 16:37:56 -0700 (PDT)
Date: Tue, 23 Jul 2013 09:37:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 38/49] xfs: refactor xfs_trans_reserve() interface
Message-ID: <20130722233752.GD19986@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-39-git-send-email-david@fromorbit.com>
	<51ED3351.5010304@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51ED3351.5010304@sgi.com>
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

On Mon, Jul 22, 2013 at 08:27:45AM -0500, Mark Tinguely wrote:
> On 07/19/13 01:25, Dave Chinner wrote:
> >From: Jie Liu<jeff.liu@oracle.com>
> >
> >With the new xfs_trans_res structure has been introduced, the log
> >reservation size, log count as well as log flags are pre-initialized
> >at mount time.  So it's time to refine xfs_trans_reserve() interface
> >to be more neat.
> >
> >Also, introduce a new helper M_RES() to return a pointer to the
> >mp->m_resv structure to simplify the input.
> >
> >Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> 
> >+/* shorthand way of accessing reservation structure */
> >+#define M_RES(mp)	(&(mp)->m_resv)
> 
> Not a fan of this define- it does not buy much savings in text and clarity.
> 
> Beside my anti-shouty rant, the patch looks good.

It's designed to be similar to XFS_I, VFS_I and XFS_M. i.e. short,
unique, obviously correct and easy to type. I can change it
if you want - I couldn't really think up a better name...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
