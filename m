Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p72EDs1N105288 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 09:13:54 -0500
Message-ID: <4E38061E.1070206@sgi.com>
Date: Tue, 02 Aug 2011 09:13:50 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfsdump: remove SIGCHLD handling
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-4-git-send-email-wkendall@sgi.com>
	<20110802102245.GA22979@infradead.org>
In-Reply-To: <20110802102245.GA22979@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Jul 29, 2011 at 03:40:10PM -0500, Bill Kendall wrote:
>> The multi-stream version of xfsdump for IRIX used sprocs for
>> threading. When a "thread" exits with sprocs, a SIGCHLD is sent to
>> the main thread just as if a regular child process exited. A future
>> multi-stream version of xfsdump would use pthreads, so the SIGCHLD
>> code is no longer needed. So:
>>
>> - No longer register for or handle SIGCHLD (SIGCLD).
>> - Remove signal handling code for child processes.
>> - Remove cldmgr_killall() as there are no children.
>>
>> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> does this mean you're actively working on multi-threaded dump for Linux?

Indeed...I didn't want to come right out and say it, in case I get side
tracked. :) But hoping to have patches up for review in the next week or
two.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
