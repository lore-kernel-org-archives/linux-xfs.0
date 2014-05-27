Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 504A77F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 17:52:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E170E304043
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 15:52:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8zi6p4aV2A6XimEG for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 15:52:34 -0700 (PDT)
Date: Wed, 28 May 2014 08:51:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Message-ID: <20140527225138.GD8554@dastard>
References: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
	<53850F92.7010401@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53850F92.7010401@sgi.com>
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

On Tue, May 27, 2014 at 05:20:02PM -0500, Mark Tinguely wrote:
> On 09/02/13 09:29, Namjae Jeon wrote:
> >From: Namjae Jeon<namjae.jeon@samsung.com>
> >
> >Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.
> >
> >Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> >Signed-off-by: Ashish Sangwan<a.sangwan@samsung.com>
> >---
> 
> >+		/* Check if we can merge 2 adjacent extents */
> >+		if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
> >+		    left.br_startoff + left.br_blockcount == startoff &&
> >+		    left.br_startblock + left.br_blockcount ==
> >+		    xfs_bmbt_get_startblock(gotp) &&
> >+		    xfs_bmbt_get_state(gotp) == left.br_state &&
> >+		    left.br_blockcount + xfs_bmbt_get_blockcount(gotp) <=
> >+		    MAXEXTLEN) {
> >+			blockcount =
> >+			left.br_blockcount + xfs_bmbt_get_blockcount(gotp);
> >+			state |= BMAP_LEFT_CONTIG;
> >+			xfs_iext_remove(ip, *current_ext, 1, 0);
> >+			XFS_IFORK_NEXT_SET(ip, whichfork,
> >+				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> >+			gotp = xfs_iext_get_ext(ifp, --*current_ext);
> >+		}
> >+
> >+		if (cur) {
> >+			error = xfs_bmbt_lookup_eq(cur,
> >+					xfs_bmbt_get_startoff(gotp),
> >+					xfs_bmbt_get_startblock(gotp),
> >+					xfs_bmbt_get_blockcount(gotp),
> >+					&i);
> >+			if (error)
> >+				goto del_cursor;
> >+			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> 
> I can reliably trigger this XFS_WANT_CORRUPTED_GOTO() with a
> fsstress that fills the filesystem:
> 
> xfstests > ltp/fsstress -d /mnt/scratch -s 1370236858 -p 512 -n 8192 &

Hasn't reproduced after 10 minutes of running at ENOSPC here - how
long does it take to reproduce? What storage hardware are you
testing on? How many CPUs? RAM? ....

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
