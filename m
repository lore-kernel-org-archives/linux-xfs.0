Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA822BY8085178 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:02:11 -0600
Message-ID: <1320717726.3186.88.camel@doink>
Subject: Re: [PATCH v2 2/8] xfsdump: remove multi-stream synchronous dir dump
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:02:06 -0600
In-Reply-To: <1320699511-12281-3-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-3-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-11-07 at 14:58 -0600, Bill Kendall wrote:
> When doing multi-stream dumps, the directories are dumped by each
> stream in lock-step fashion. A stream backs up a given directory,
> then waits for all others to finish that directory, then they all
> move on to the next one. During restore a single stream is chosen to
> apply the directory dump.
> 
> This patch changes xfsdump so that only one stream dumps the
> directories. The other streams begin dumping files immediately.
> This results in a faster backup, which is presumably why multiple
> streams are being used in the first place.
> 
> It also removes the barrier routines in qlock.c as they were only
> used by the "SYNCDIR" code.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Nice change.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
