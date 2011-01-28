Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SEUdTv160595 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 08:30:39 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73F808E4A19
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 06:33:04 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	DZHDgqHckmR3vXFl for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 06:33:04 -0800 (PST)
Message-ID: <4D42D39E.4080304@teksavvy.com>
Date: Fri, 28 Jan 2011 09:33:02 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard>
	<4D421A68.9000607@teksavvy.com> <20110128073119.GV21311@dastard>
In-Reply-To: <20110128073119.GV21311@dastard>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

On 11-01-28 02:31 AM, Dave Chinner wrote:
>
> A simple google search turns up discussions like this:
> 
> http://oss.sgi.com/archives/xfs/2009-01/msg01161.html

"in the long term we still expect fragmentation to degrade the performance of
XFS file systems"
Other than that, no hints there about how changing agcount affects things.


> Configuring XFS filesystems for optimal performance has always been
> a black art because it requires you to understand your storage, your
> application workload(s) and XFS from the ground up.  Most people
> can't even tick one of those boxes, let alone all three....

Well, I've got 2/3 of those down just fine, thanks.
But it's the "XFS" part that is still the "black art" part,
because so little is written about *how* it works
(as opposed to how it is laid out on disk).

Again, that's only a minor complaint -- XFS is way better documented
than the alternatives, and also works way better than the others I've
tried here on this workload.

>>> Why 8 AGs and not the default?
>>
>> How AGs are used is not really explained anywhere I've looked,
>> so I am guessing at what they do and how the system might respond
>> to different values there (that documentation thing again).
> 
> Section 5.1 of this 1996 whitepaper tells you what allocation groups
> are and the general allocation strategy around them:
> 
> http://oss.sgi.com/projects/xfs/papers/xfs_usenix/index.html

Looks a bit dated:  "Allocation groups are typically 0.5 to 4 gigabytes in size."
But it does suggest that "processes running concurrently can allocate space
in the file system concurrently without interfering with each other".

Dunno if that's still true today, but it sounds pretty close to what I was
theorizing about how it might work.

> start to see what I mean about tuning XFS really being a "black art"?

No, I've seen that "black" (aka. undefined, undocumented) part from the start.  :)
Thanks for chipping in here, though -- it's been really useful.

Cheers!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
