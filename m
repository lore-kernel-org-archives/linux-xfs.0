Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5263D7F3F
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 18:30:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3124E304053
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 16:30:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4Vu4bXrIEyz7648N for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 16:30:16 -0700 (PDT)
Date: Tue, 24 Sep 2013 09:30:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
Message-ID: <20130923233012.GV9901@dastard>
References: <20130917192538.230164044@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130917192538.230164044@sgi.com>
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

On Tue, Sep 17, 2013 at 02:25:23PM -0500, Mark Tinguely wrote:
> This tests triggers an assert in the XFS directory unbalance code.
> This test originally written by Brian Foster and suggestions
> from Micheal Semon.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 

A recent comment about the _cleanup funtion being removed made me
look at this again....

Where's the trap function to catch a ctrl-c and clean up the test
when that happens?

i.e. at minimum, the trap and cleanup function is used to ensure the
test is marked as failed if it is interrupted, and in this case it
probably needs to kill all the fsstress processes and wait for them
to complete, as well as remove

>  put into auto group and "long" group so people can opt out:
>   this test almost an hour on my test box.

The group for this is called "stress" - there's no need to introduce
a new group for the same test criteria.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
