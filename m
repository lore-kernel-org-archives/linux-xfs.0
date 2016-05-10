Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF07C7CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 01:11:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A4C518F8049
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 23:10:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	RZIevUKEGeMG4gn9 for <xfs@oss.sgi.com>;
	Mon, 09 May 2016 23:10:56 -0700 (PDT)
Date: Tue, 10 May 2016 16:10:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/19 v2] mkfs cleaning
Message-ID: <20160510061054.GI26977@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 21, 2016 at 11:39:34AM +0200, Jan Tulak wrote:
> Updated version. Most notable changes are dropping of
> "xfsprogs: disable truncating of files", reverting 
> "don't treat files as though they are block devices"
> back to Dave's version, and adding a new patch
> "mkfs: conflicting values with disabled crc should fail."

Looking at xfstests runs, new failures are:

generic/054 - 
generic/055 - both fail with:

+*** mkfs failed: -l version=2,su=4096 ***

and the .full file has this specific error:

Illegal value 4096 for -l su option. value is too small

indicating that we should be allowing (2^N * block size) log
stripe units to be set. This will be a limit configuration issue,
most likely needing fixing in mkfs.

xfs/096 6s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad)
    --- tests/xfs/096.out       2016-04-05 11:11:36.814382107 +1000
    +++ /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad        2016-05-10 12:54:25.956199714 +1000
    @@ -2,18 +2,62 @@
     
     # su too big but must be a multiple of fs block size too
     --- mkfs=-l version=2,su=262656 ---
    -log stripe unit (262656) must be a multiple of the block size (4096)
    +Illegal value 262656 for -l su option. value is too large
    +Usage: mkfs.xfs
    +/* blocksize */            [-b log=n|size=num]
    ...
    (Run 'diff -u tests/xfs/096.out /home/dave/src/xfstests-dev/results//xfs/xfs/096.out.bad'  to see the entire diff)

This test is explicitly testing an invalid value, checking that it
falls back to a sane default. This patchset has changed the
behaviour, so the xfstest will need some rework to handle both old
and new mkfs behaviour.

Can you send patches to fix all these up?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
