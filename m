Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OCVMCd251073 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 07:31:22 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1jvA8oCK15cC9PJS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 05:33:06 -0700 (PDT)
Message-ID: <5087DFCC.30000@oracle.com>
Date: Wed, 24 Oct 2012 20:32:12 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
	<20121023123044.GG7341@infradead.org>
	<20121023215313.GQ4291@dastard> <20121024114711.GB11262@shiny>
In-Reply-To: <20121024114711.GB11262@shiny>
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
To: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 10/24/12 19:47, Chris Mason wrote:
> On Tue, Oct 23, 2012 at 03:53:13PM -0600, Dave Chinner wrote:
>> On Tue, Oct 23, 2012 at 08:30:44AM -0400, Christoph Hellwig wrote:
>>> On Thu, Oct 18, 2012 at 04:11:17PM +1100, Dave Chinner wrote:
>>>> So, I was bored a few days ago, and I was sick of having to run
>>>> xfs_db incorrectly report free space extents when the filesytem is
>>>> mounted, so I decided to extend fiemap to export freespace mappings
>>>> to userspace so I could get the information coherently through the
>>>> mounted filesystem.
>>>>
>>>> Yes, this could probably be considered interface abuse but, well, it
>>>> was simple to do because extent mapping is exactly what fiemap is
>>>> designed to do. Hence I didn't have to write new walkers/formatters
>>>> and I was using code I knew worked correctly.
>>> I think the right way to handle this is to introduce a new ioctl which
>>> uses the same structures.  That way we have a reasonable interface,
>>> without issue like which file does it need to be called on because the
>>> VFS glue can turn it into a superblock op.
>> A VFS level ioctl or an XFS ioctl?
>>
>> I thought about a new ioctl, but then what's the point of having an
>> extensible fiemap interface if we create new ioctls with an
>> identical interface for doing something that the existing ioctl is
>> perfectly capable of doing?  I'd still need special flags to control
>> the ioctl behaviour even though it uses struct fiemap and plumbing,
>> so it seemed pointless to introduce a new ioctl....
Hi Dave,

I am writing XFS shrinkfs feature, and I really need an approach to get
the free space of an XFS file system since
xfs_db can not fetch agf->agf_freeblks and agf_btreeblks against a
mounted partition to calculate it out for
online shrink operation that just as what's you have mentioned above.

So currently I add a new ioctl for this purpose, that's would be fine if
we can have a fiemap interface to do it so that
I can kill this new ioctl to avoid duplicate efforts.

Thanks,
-Jeff
> This brings us one step close to the norton disk doctor defrag display.
> I'm all for it in the main fiemap call, it makes much more sense for the
> users I think.
>
> -chris
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
