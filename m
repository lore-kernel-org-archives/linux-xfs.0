Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S2883r076429 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 20:08:08 -0600
Date: Thu, 27 Jan 2011 18:09:58 -0800 (PST)
From: david@lang.hm
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <4D42056E.2050505@hardwarefreak.com>
Message-ID: <alpine.DEB.2.00.1101271730030.17579@asgard.lang.hm>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
	<4D42056E.2050505@hardwarefreak.com>
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

> david@lang.hm put forth on 1/27/2011 2:11 PM:
>
>> how do I understand how to setup things on multi-disk systems? the documentation
>> I've found online is not that helpful, and in some ways contradictory.
>
> Visit http://xfs.org  There you will find:
>
> Users guide:
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html
>
> File system structure:
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html
>
> Training labs:
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Labs/tmp/en-US/html/index.html

thanks for the pointers.

>> If there really are good rules for how to do this, it would be very helpful if
>> you could just give mkfs.xfs the information about your system (this partition
>> is on a 16 drive raid6 array) and have it do the right thing.
>
> If your disk array is built upon Linux mdraid, recent versions of mkfs.xfs will
> read the parameters and automatically make the filesystem accordingly, properly.
>
> mxfs.fxs will not do this for PCIe/x hardware RAID arrays or external FC/iSCSI
> based SAN arrays as there is no standard place to acquire the RAID configuration
> information for such systems.  For these you will need to configure mkfs.xfs
> manually.
>
> At minimum you will want to specify stripe width (sw) which needs to match the
> hardware stripe width.  For RAID0 sw=[#of_disks].  For RAID 10, sw=[#disks/2].
> For RAID5 sw=[#disks-1].  For RAID6 sw=[#disks-2].
>
> You'll want at minimum agcount=16 for striped hardware arrays.  Depending on the
> number and spindle speed of the disks, the total size of the array, the
> characteristics of the RAID controller (big or small cache), you may want to
> increase agcount.  Experimentation may be required to find the optimum
> parameters for a given hardware RAID array.  Typically all other parameters may
> be left at defaults.

does this value change depending on the number of disks in the array?

> Picking the perfect mkfs.xfs parameters for a hardware RAID array can be
> somewhat of a black art, mainly because no two vendor arrays act or perform
> identically.

if mkfs.xfs can figure out how to do the 'right thing' for md raid arrays, 
can there be a mode where it asks the users for the same information that 
it gets from the kernel?

> Systems of a caliber requiring XFS should be thoroughly tested before going into
> production.  Testing _with your workload_ of multiple parameters should be
> performed to identify those yielding best performance.

<rant>
the problem with this is that for large arrays, formatting the array and 
loading it with data can take a day or more, even before you start running 
the test. This is made even worse if you are scaling up an existing system 
a couple orders of magnatude, because you may not have the full workload 
available to you. Saying that you should test out every option before 
going into production is a cop-out. The better you can test it, the better 
off you are, but without knowing what the knobs do, just doing a test and 
twiddling the knobs to do another test isn't very useful. If there is a 
way to set the knobs in the general ballpark, then you can test and see if 
the performance seems adaquate, if not you can try teaking one of the 
knobs a little bit and see if it helps or hurts. but if the knobs aren't 
even in the ballpark when you start, this doesn't help much.
</rant>

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
