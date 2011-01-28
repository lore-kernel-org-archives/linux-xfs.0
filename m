Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S1Y3Ix070510 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 19:34:03 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53542297CB6
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:36:27 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	4sjProDprcrHE9V7 for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 17:36:27 -0800 (PST)
Message-ID: <4D421D9A.50007@teksavvy.com>
Date: Thu, 27 Jan 2011 20:36:26 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard>
	<4D421A68.9000607@teksavvy.com>
In-Reply-To: <4D421A68.9000607@teksavvy.com>
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

On 11-01-27 08:22 PM, Mark Lord wrote:
> On 11-01-27 07:17 PM, Dave Chinner wrote:
>>
>> In my experience with XFS, most people who tweak mkfs parameters end
>> up with some kind of problem they can't explain and don't know how
>> to solve. And they are typically problems that would not have
>> occurred had they simply used the defaults in the first place. What
>> you've done is a perfect example of this.
> 
> Maybe.  But what I read from the paragraph above,
> is that the documentation could perhaps explain things better,
> and then people other than the coders might understand how
> best to tweak it.


By the way, the documentation is excellent, for a developer who
wants to work on the codebase.  It describes the data structures
and layouts etc.. better than perhaps any other Linux filesystem.

But it doesn't seem to describe the algorithms, such as how it
decides where to store a recording stream.

I'm not complaining, far from it.  XFS is simply wonderful,
and my DVR literally couldn't work without it.

But I am as technical as you are, and I like to experiment and
understand the technology I use.  That's partly why we both work
on the Linux kernel.

Cheers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
