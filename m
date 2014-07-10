Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 543D77F51
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 20:52:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34B85304043
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 18:52:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RiCOglGMOVjUObb4 for <xfs@oss.sgi.com>;
	Wed, 09 Jul 2014 18:52:19 -0700 (PDT)
Message-ID: <53BDF1D2.6000204@sandeen.net>
Date: Wed, 09 Jul 2014 20:52:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: Check fs consistency on TEST_DEV only when
	needed
References: <1403617014-17870-1-git-send-email-lczerner@redhat.com>	<1403617014-17870-2-git-send-email-lczerner@redhat.com>
	<20140710010711.GJ4453@dastard>
In-Reply-To: <20140710010711.GJ4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Lukas Czerner <lczerner@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On 7/9/14, 8:07 PM, Dave Chinner wrote:
> Reducing runtime of the test harness is a good idea, but we should
> not do that if the cost is that it reduces the reliability of error
> detection.

Still, this could have a really big impact, especially on filesystems
with slow fsck.

It'd be great to find a way to make this reliable.

It's kind of a historical accident that "test" is always mounted, but
"scratch" must be _required.  What if we added _require_test if we're 
going to write to test, and doing so triggers the check?

I'm sure there are other ways around it.  Spending tons of time in fsck
for a filesystem we didn't touch isn't time well spent, IMHO.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
