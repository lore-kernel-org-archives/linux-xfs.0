Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RKAE7i017562 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 14:10:15 -0600
Date: Thu, 27 Jan 2011 12:11:54 -0800 (PST)
From: david@lang.hm
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <4D41CA16.8070001@hardwarefreak.com>
Message-ID: <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
MIME-Version: 1.0
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Mark Lord <kernel@teksavvy.com>

On Thu, 27 Jan 2011, Stan Hoeppner wrote:

>> Rather than hundreds or thousands of "tiny" MB sized extents.
>> I wonder what the best mkfs.xfs parameters might be to encourage that?
>
> You need to use the mkfs.xfs defaults for any single drive filesystem, and trust
> the allocator to do the right thing.  XFS uses variable size extents and the
> size is chosen dynamically--you don't have direct or indirect control of the
> extent size chosen for a given file or set of files AFAIK.
>
> As Dave Chinner is fond of pointing out, it's those who don't know enough about
> XFS and choose custom settings that most often get themselves into trouble (as
> you've already done once).  :)
>
> The defaults exist for a reason, and they weren't chosen willy nilly.  The vast
> bulk of XFS' configurability exists for tuning maximum performance on large to
> very large RAID arrays.  There isn't much, if any, additional performance to be
> gained with parameter tweaks on a single drive XFS filesystem.

how do I understand how to setup things on multi-disk systems? the 
documentation I've found online is not that helpful, and in some ways 
contradictory.

If there really are good rules for how to do this, it would be very 
helpful if you could just give mkfs.xfs the information about your system 
(this partition is on a 16 drive raid6 array) and have it do the right 
thing.

David Lang


> A brief explanation of agcount:  the filesystem is divided into agcount regions
> called allocation groups, or AGs.  The allocator writes to all AGs in parallel
> to increase performance.  With extremely fast storage (SSD, large high RPM RAID)
> this increases throughput as the storage can often sink writes faster than a
> serial writer can push data.  In your case, you have a single slow spindle with
> over 7,000 AGs.  Thus, the allocator is writing to over 7,000 locations on that
> single disk simultaneously, or, at least, it's trying to.  Thus, the poor head
> on that drive is being whipped all over the place without actually getting much
> writing done.  To add insults to injury, this is one of these low RPM low head
> performance "green" drives correct?
>
> Trust the defaults.  If they give you problems (unlikely) then we can't talk. ;)
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
