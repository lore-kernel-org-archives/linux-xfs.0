Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RKLgbp019564 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 14:21:42 -0600
MIME-Version: 1.0
Message-ID: <19777.54393.645313.900155@quad.stoffel.home>
Date: Thu, 27 Jan 2011 15:24:25 -0500
From: "John Stoffel" <john@stoffel.org>
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <4D419765.4070805@teksavvy.com>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
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
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> On 11-01-27 10:40 AM, Justin Piszcz wrote:
>> 
>> 
>> On Thu, 27 Jan 2011, Mark Lord wrote:
Mark> ..
>>> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
>>> of this system?  Eg. Only a few thousand active inodes, and nearly all files are
>>> in the 600MB -> 20GB size range.  The usage pattern it must handle is up to
>>> six concurrent streaming writes at the same time as up to three streaming reads,
>>> with no significant delays permitted on the reads.
>>> 
>>> That's the kind of workload that I find XFS handles nicely,
>>> and EXT4 has given me trouble with in the past.
Mark> ..
>> I did a load of benchmarks a long time ago testing every mkfs.xfs option there
>> was, and I found that most of the time (if not all), the defaults were the best.
Mark> ..

Mark> I am concerned with fragmentation on the very special workload
Mark> in this case.  I'd really like the 20GB files, written over a
Mark> 1-2 hour period, to consist of a very few very large extents, as
Mark> much as possible.

Mark> Rather than hundreds or thousands of "tiny" MB sized extents.  I
Mark> wonder what the best mkfs.xfs parameters might be to encourage
Mark> that?

Hmmm, should the application be pre-allocating the disk space then, so
that the writes get into nice large extents automatically?  Isn't this
what the fallocate() system call is for?  Doesn't MythTV use this?

I don't use XFS, or MythTV, but I like keeping track of this stuff.

John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
