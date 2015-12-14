Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B5DF7F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 14:26:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E698D304032
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 12:26:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5HPHVhHaHUsXrcbN for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2015 12:26:20 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0A05F65EBB81
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 14:26:20 -0600 (CST)
Subject: Re: [PATCH 1/2] metadump: bounds check btree block regions being
	zeroed
References: <1450054866-32720-1-git-send-email-david@fromorbit.com>
	<1450054866-32720-2-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <566F25EB.5040605@sandeen.net>
Date: Mon, 14 Dec 2015 14:26:19 -0600
MIME-Version: 1.0
In-Reply-To: <1450054866-32720-2-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On 12/13/15 7:01 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Arkadiusz Miskiewicz reported that metadump was crashing on one of
> his corrupted filesystems, and the trace indicated that it was
> zeroing unused regions in inode btree blocks when it failed. The
> btree block had a corrupt nrecs field, which was resulting in an out
> of bounds memset() occurring.

Doh.

Time to run fuzzers+valgrind w/ metadump I guess...
/me looks at djwong ...
 
> Ensure that the region being generated for zeroing is within bounds
> before executing the zeroing. While there, abstract the repeated
> boiler plate code so that it is simpler to maintain and extend the
> zeroing code to new types of btrees in future.

yeah, thanks, not sure why I didn't do that originally.  Much better.

Might be nice to split the bugfix & the cleanup into 2 patches, though...

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
