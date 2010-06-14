Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EDZMa0042655 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 08:35:22 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FA88FB1D9F
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 06:41:25 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id FmuMDG26zAHCNQx3 for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 06:41:25 -0700 (PDT)
Message-ID: <4C16308E.1030305@oracle.com>
Date: Mon, 14 Jun 2010 21:37:18 +0800
From: Tao Ma <tao.ma@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
References: <1276308495-14267-1-git-send-email-tao.ma@oracle.com>
	<20100614002705.GA6590@dastard> <20100614122912.GD6590@dastard>
In-Reply-To: <20100614122912.GD6590@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

Dave Chinner wrote:
> On Mon, Jun 14, 2010 at 10:27:06AM +1000, Dave Chinner wrote:
>   
>> On Sat, Jun 12, 2010 at 10:08:15AM +0800, Tao Ma wrote:
>>     
>>> The reason is that in xfs_getbmap we will
>>> calculate holes and set it in 'out', while out is malloced by
>>> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
>>> worst case, if 'out' vector looks like
>>> [hole, extent, hole, extent, hole, ... hole, extent, hole],
>>> we will only return half of fi_extent_max extents.
>>>       
>> Right, it's not broken, we simply return less than fi_extent_mex
>> extents when there are holes. I don't see that as a problem as
>> applications have to handle that case anyway, and....
>>
>>     
>>> So in xfs_vn_fiemap, we should consider this worst case. If the
>>> user wants fi_extent_max extents, we need a 'out' with size of
>>> 2 *fi_extent_max + 2(one more the header).
>>>       
>> That's rather dangerous, I think. It relies on other code to catch
>> the buffer overrun that this sets up for fragmented, non-sparse
>> files. Personally I'd much prefer to return fewer extents for sparse
>> files than to add a landmine like this into the kernel code....
>>     
>
> I just had a thought - if you want to avoid holes being reported to
> fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
> holes in the mappin gloop when this flag is set. That will make
> fiemap fill in the full number of extents without hacking the
> extent count...
>   
yeah, that should work and I will try to generate a patch for it.
I am not quite familiar with xfs, so please be kind to me if I make some 
stupid mistake in the patch. ;)

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
