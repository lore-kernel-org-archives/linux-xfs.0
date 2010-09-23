Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NIveZ6142278 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 13:57:40 -0500
Subject: Re: [PATCH] xfs: force background CIL push under sustained load
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285208863-31489-1-git-send-email-david@fromorbit.com>
References: <1285208863-31489-1-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 13:58:32 -0500
Message-ID: <1285268312.1973.114.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-09-23 at 12:27 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I have been seeing relatively frequent pauses in transaction throughput up to
> 30s long under heavy parallel workloads. The only thing that seemed strange
> about them was that the xfsaild was active during the pauses, but making no
> progress. It was running exactly 20 times a second (on the 50ms no-progress
> backoff), and the number of pushbuf events was constant across this time as
> well.  IOWs, the xfsaild appeared to be stuck on buffers that it could not push
> out.

. . .

If you like I can take this patch directly (i.e., not wait for you to
send a separate pull request).  It fixes a real bug but since delayed
logging still an experimental feature I am not inclined to send it to
Linus at this point in the cycle.  Let me know if you disagree.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
