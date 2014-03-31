Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE82C7F57
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 19:35:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 898E88F8033
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 17:35:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qV8SZLGHOFDgpw5s for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 17:35:46 -0700 (PDT)
Message-ID: <5338B863.9050106@sandeen.net>
Date: Sun, 30 Mar 2014 18:35:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix bad hash ordering
References: <20140328173430.622616177@sgi.com> <20140331001055.GD16336@dastard>
In-Reply-To: <20140331001055.GD16336@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Mark Tinguely <tinguely@sgi.com>
Cc: Linux Stable <stable@vger.kernel.org>, XFS Mailing List <xfs@oss.sgi.com>

On 3/30/14, 6:10 PM, Dave Chinner wrote:
> On Fri, Mar 28, 2014 at 12:33:34PM -0500, Mark Tinguely wrote:
>> Fix the fix directory "bad hash ordering" bug introduced in
>> commit f5ea1100.
> 
> The patch looks like it fixes a hashing issue, but I really can't
> tell what hashing issue it fixes from the commit message.
> 
> I don't know if you've identified the right commit just by looking
> at it - to confirm you've quoted the correct hash I have to find it,
> parse it, read the diff and try and work out whether it could have
> introduced some bug that you haven't described....
> 
> .... introduced in commit f5ea110 ("xfs: add CRCs to dir2/da node
> blocks") ....
> 
> is far more informative, even for the causal reader....
> 
> Secondly, reading that commit subject and message in isolation,
> it didn't even occur to me that this is a fix for a filesystem
> corruption bug. Any distro maintainer reading the commit logs won't
> have any idea that they need to pick this up, either.
> 
> IOWs, it is extremely important that the commit message for a
> filesystem corruption bug fix to be clearly marked as fixing a
> corruption bug, explain what the bug is, what they user visible
> symptoms are, what the impact of the corruption is, how likely users
> are going to be impacted by it, whether is causes permanent loss
> of data or not, etc. This doesn't belong in a throw-away comment to
> your fix...

But thanks a lot for jumping on the bug report & getting the fix out
on the list in short order.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
