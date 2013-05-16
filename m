Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 12A187F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 18:32:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A50C5AC003
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 16:31:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	34IahHtN6l3fsCLs for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 16:31:56 -0700 (PDT)
Date: Fri, 17 May 2013 09:31:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test data integrity under disk failure
Message-ID: <20130516233153.GI24635@dastard>
References: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 16, 2013 at 04:07:32PM +0400, Dmitry Monakhov wrote:
> Parallels team have old good tool called hwflush-check which is server/client
> application for testing data integrity under system/disk failure conditions.
> Usually we run hwflush-check on two different hosts and use PMU to trigger real
> power failure of the client as a whole unit. This tests may be used for
> SSD checking (some of them are known to have probelms with hwflush).
> I hope it will be good to share it with community.
> 
> This tests simulate just one disk failure while client system should
> survive this failure. This test extend idea of shared/305.
> 1) Run hwflush-check server and client on same host as usual
> 2) Simulare disk failure via blkdev failt injection API aka 'make-it-fail'
> 3) Umount failed device
> 4) Makes disk operatable again
> 5) Mount filesystem
> 3) Check data integrity

So, for local disk failure, why do we need a client/server network
architecture? That just complicates the code, and AFAICT

all the client does is send report report packets to server which
contain an id number that is kept in memory. If on restart of the
client after failure the ID in the report packet doesn't match what
the server wants, then it fails the test.

So, why is the server needed here? Just dump the IDs the client
writes to the file on a device not being tested, and either diff
them against a golden image or run a check to see all the IDs are
monotonically increasing. That removes all the networking code from
the test, the need for a client/server architecture, etc, and makes
the test far easier to review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
