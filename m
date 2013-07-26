Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1F687F4E
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 06:37:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 791658F8033
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 04:37:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	n3aEDoeGLAI5dNIt for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 04:37:25 -0700 (PDT)
Date: Fri, 26 Jul 2013 21:37:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix an assertion failure
Message-ID: <20130726113717.GN13468@dastard>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
	<20130726020318.GD21982@dastard>
	<CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Fri, Jul 26, 2013 at 02:01:23PM +0800, Zhi Yong Wu wrote:
> No, it still raised the same assertion as below:
> 
> [  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
> XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940

How are you reproducing it?

Can you take an event trace with trace-cmd and attach the output of
the report?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
