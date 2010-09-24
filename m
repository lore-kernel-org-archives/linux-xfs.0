Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O2EISt158654 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 21:14:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63E2FE5E35E
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 19:27:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	8oZUQjVq6A6hkwd4 for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 19:27:49 -0700 (PDT)
Date: Fri, 24 Sep 2010 12:15:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: force background CIL push under sustained load
Message-ID: <20100924021509.GS2614@dastard>
References: <1285208863-31489-1-git-send-email-david@fromorbit.com>
	<1285268312.1973.114.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285268312.1973.114.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 23, 2010 at 01:58:32PM -0500, Alex Elder wrote:
> On Thu, 2010-09-23 at 12:27 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > I have been seeing relatively frequent pauses in transaction throughput up to
> > 30s long under heavy parallel workloads. The only thing that seemed strange
> > about them was that the xfsaild was active during the pauses, but making no
> > progress. It was running exactly 20 times a second (on the 50ms no-progress
> > backoff), and the number of pushbuf events was constant across this time as
> > well.  IOWs, the xfsaild appeared to be stuck on buffers that it could not push
> > out.
> 
> . . .
> 
> If you like I can take this patch directly (i.e., not wait for you to
> send a separate pull request).  It fixes a real bug but since delayed
> logging still an experimental feature I am not inclined to send it to
> Linus at this point in the cycle.  Let me know if you disagree.

I think it needs to go to linus as well back to 2.6.35.y as it can
result in recovery silently corrupting the filesystem if a
checkpoint larger than half the log is present in the log during
recovery.  I don' tthink the experimental status of the code makes
any difference, especially as we've already pushed checkpoint/
recovery corruption fixes into this release....

I'm adding it to the start of the metadata scale patchset branch
right now, which I'll probably being sending a pull request out for
later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
