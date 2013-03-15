Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45F607FB9
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 00:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 315E38F8040
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 22:13:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fCN22AIZ8EUwLn4b for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 22:13:41 -0700 (PDT)
Date: Fri, 15 Mar 2013 16:13:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/18] xfstests: Redo option parsing
Message-ID: <20130315051338.GB2559@dastard>
References: <20130314130611.6A23953C7F62@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.6A23953C7F62@polaris-admin.engr.sgi.com>
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
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 06:06:11AM -0700, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> The option parise in a messy loop of option parsing and actions on
> secondary arguments. Turn it into something much neater and esay to
> understand rather than a mess of temporary variables and tortured
> logic...
> -----------------
> 
> This required some deviation owing to the decision made in patch #2 of this
> series.

If all the check specific option parsing is moved to check (like my
series did), then there isn't any code left in the common file.

All i see here is a reflection of SGI's obstinate refusal to remove
bitrotted code. If we are removing all the users of this code except
one, it is no longer shared code and, as such, abstractions for
sharing shoul dbe removed.

If some new script comes along that uses the *same option parsing*
as check, then we can consider it shared code again. However, i
can't see this ever happening, so the code should be moved the check
script where it can be more fully integrated and simplified.

So, really, all is see from trying to retain the common file like
this is an obstinate refusal to let go of bitrotted code and to
re-abstract and re-implement it properly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
