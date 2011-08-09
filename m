Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79MeB25130867 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 17:40:11 -0500
Subject: Re: [PATCH v2 2/7] xfsdump: process EPIPE instead of catching SIGPIPE
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312497011-24840-3-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-3-git-send-email-wkendall@sgi.com>
Date: Tue, 9 Aug 2011 17:40:10 -0500
Message-ID: <1312929610.9482.20.camel@doink>
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

On Thu, 2011-08-04 at 17:30 -0500, Bill Kendall wrote:
> Looking forward towards a multi-threaded xfsdump, it's simpler to
> handle pipe failures as a system call failure (EPIPE) rather than
> through a signal handler which may run in a separate thread. The
> existing error handling code handles EPIPE just fine, so the only
> required change is to ignore SIGPIPE. Some sections of code already
> temporarily ignore SIGPIPE -- they no longer need to do so since it
> will already be ignored.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I don't know the real structure of the code well enough
to verify your statement that it "handles EPIPE just fine."

I see that only _rmt_open() calls pipe(2), setting up a
pipeline between an rsh (child process) and the the code
in _rmt_command().  Thereafter, only _rmt_command() and
_rmt_write() write to the write side of that pipe, and
both of those abort the dump if a write doesn't result
in the expected number of bytes being written.

I see only restore_spec() opens a socket, but it closes
it again.  So I guess I don't see any place that I
expect would produce a EPIPE that doesn't handle it
appropriately.

In any case, I assume your statement is right, and
with that in mind I think the change looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

PS  I'm in the midst of reviewing patch 3 but I'm out
    of time and will have to pick it up again later.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
