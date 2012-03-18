Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2II8cXp001466 for <xfs@oss.sgi.com>; Sun, 18 Mar 2012 13:08:38 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hJDNPBmIXUjJiGfS
	for <xfs@oss.sgi.com>; Sun, 18 Mar 2012 11:08:37 -0700 (PDT)
Message-ID: <4F6624A3.5010206@hardwarefreak.com>
Date: Sun, 18 Mar 2012 13:08:35 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com> <20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
In-Reply-To: <20325.50714.237894.328039@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
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
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

On 3/18/2012 6:25 AM, Peter Grandi wrote:

> So in my view 'delaylog' cannot be described boldly and barely
> described, especially in this thread, as an improvement in XFS
> performance, as it is an improvement in XFS's unsafety to obtain
> greater speed, similar to but not as extensive as 'nobarrier'.

You have recommended in various past posts on multiple lists that users
should max out logbsize and logbufs to increase metadata performance.
You made no mention in those posts about safety as you have here.
Logbufs are in-memory journal write buffers and are volatile.  Delaylog
uses in-memory structures that are volatile.  So, why do you consider
logbufs to be inherently safer than delaylog?  Following the logic
you've used in this thread, both should be considered equally unsafe.
Yet I don't recall you ever preaching against logbufs in the past.  Is
it because logbufs can 'only' potentially lose 2MB worth of metadata
transactions, and delaylog can potentially lose more than 2MB?

> In the same way that 'eatmydata':

Hardly.  From: http://packages.debian.org/sid/eatmydata

"This package ... transparently disable fsync ... two side-effects: ...
writes data ... quicker ... no longer crash safe ... useful if
particular software calls fsync(), sync() etc. frequently but *the data
it stores is not that valuable to you* and you may *afford losing it in
case of system crash*."

So you're comparing delaylog's volatile buffer architecture to software
that *intentionally and transparently disables fsync*?  So do you
believe a similar warning should be attached to the docs for delaylog?
And thus to the use of logbufs as well?  How about all write
buffers/caches in the Linux kernel?

Where exactly do you draw the line Peter, between unsafe/safe use of
in-memory write buffers?  Is there some magical demarcation point
between synchronous serial IO, and having gigabytes of inflight write
data in memory buffers?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
