Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BDED7F58
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 19:11:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DF04304032
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 17:11:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sYIOJYKP5BcCGsBZ for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 17:10:59 -0700 (PDT)
Date: Mon, 31 Mar 2014 11:10:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix bad hash ordering
Message-ID: <20140331001055.GD16336@dastard>
References: <20140328173430.622616177@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140328173430.622616177@sgi.com>
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
Cc: Linux Stable <stable@vger.kernel.org>, XFS Mailing List <xfs@oss.sgi.com>

On Fri, Mar 28, 2014 at 12:33:34PM -0500, Mark Tinguely wrote:
> Fix the fix directory "bad hash ordering" bug introduced in
> commit f5ea1100.

The patch looks like it fixes a hashing issue, but I really can't
tell what hashing issue it fixes from the commit message.

I don't know if you've identified the right commit just by looking
at it - to confirm you've quoted the correct hash I have to find it,
parse it, read the diff and try and work out whether it could have
introduced some bug that you haven't described....

.... introduced in commit f5ea110 ("xfs: add CRCs to dir2/da node
blocks") ....

is far more informative, even for the causal reader....

Secondly, reading that commit subject and message in isolation,
it didn't even occur to me that this is a fix for a filesystem
corruption bug. Any distro maintainer reading the commit logs won't
have any idea that they need to pick this up, either.

IOWs, it is extremely important that the commit message for a
filesystem corruption bug fix to be clearly marked as fixing a
corruption bug, explain what the bug is, what they user visible
symptoms are, what the impact of the corruption is, how likely users
are going to be impacted by it, whether is causes permanent loss
of data or not, etc. This doesn't belong in a throw-away comment to
your fix...

> ---
> A C program that generates this problem can be found at:
>  http://oss.sgi.com/archives/xfs/2014-03/msg00373.html
> 
> A xfstest for this bug is coming from Hannes Frederic Sowa.

Can you convert this program to an xfstest yourself so that I can
commit the regression test at the same time I commit an updated
fix?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
