Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 643487F66
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 19:39:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FD838F8065
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 17:39:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dgJo9fgiQNfq7kJ8 for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 17:39:43 -0700 (PDT)
Date: Sat, 31 May 2014 10:39:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Message-ID: <20140531003918.GI14410@dastard>
References: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
	<53850F92.7010401@sgi.com> <20140527225138.GD8554@dastard>
	<53851836.2070301@sgi.com> <20140528002906.GH8554@dastard>
	<538743E0.70103@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538743E0.70103@sgi.com>
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

On Thu, May 29, 2014 at 09:27:44AM -0500, Mark Tinguely wrote:
> On 05/27/14 19:29, Dave Chinner wrote:
> >On Tue, May 27, 2014 at 05:56:54PM -0500, Mark Tinguely wrote:
> >>A 7-8 hours on spinning rust. This is my burn in test.
> >
> >Can you try to narrow the problem down? Otherwise it's going to be a
> >case of looking for a needle in a haystack....
> 
> Nod on the needle in a hay stack if it bmbt is really corrupt.
> 
> I am running fsstress from xfstests with the top commit 9b7f704, and
> I don't see any newer fsstress patches since then.
> 
> I moved the test to another box with a kdump that works on top of
> tree Linux and grabbed a vmcore. I grabbed a metadata dump of the
> filesystem after the ASSERT. That should give some idea of what
> inode/block it was looking up.
> 
> I sent email to Namjae when I first tripped over this problem in
> late April. No longer on the face of the earth and I can't look at
> this until the weekend.

No worries - it looks pretty hard to hit, so it's not something we
urgently need to track down. Any time you can spare to try to narrow
it down would be great!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
